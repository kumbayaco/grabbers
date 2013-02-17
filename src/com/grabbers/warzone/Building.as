package com.grabbers.warzone
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.manager.host.ArmyManager;
	import com.grabbers.manager.host.TexPackManager;
	import com.grabbers.ui.AnimateObject;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.type.Anchor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Building extends DisplayObjectContainer
	{
		static public const UP_STATE:uint = 0;
		static public const HOVER_STATE:uint = 1;
		
		public static const BUILD_CITY:uint = 0;
		public static const BUILD_CASTLE:uint = 1;
		public static const BUILD_FORGE:uint = 2;
		public static const BUILD_STABLE:uint = 3;
		public static const BUILD_TOWER:uint = 4;
		
		static public const OWNER_PLAYER:uint = 1;
		
		public static const NAMES_BUILDING:Array = ["city","castle","forge","stable","tower"];
		
		public static const COMMAND_SELECT:String = "select";
		public static const COMMAND_UNSELECT:String = "unselect";
		public static const COMMAND_ATTACK:String = "attack";
		
		public var handlerTrigger:Function;
		
		protected var _pos:Point;
		protected var _popu:uint;
		protected var _level:uint;
		protected var _owner:uint;
		protected var _towerRange:Point;
		protected var _layer:int;
		protected var _nodeId:uint;
		protected var _type:uint;
		protected var _imgBuild:Image;
		protected var _imgHover:Image;
		protected var _animSelect:AnimateObject;
		protected var _popuBar:PopulationBar;
		protected var _curState:uint = UP_STATE;
		protected var _select:Boolean = false;
		protected var _warzone:Warzone;
		protected var _armyType:uint;
		
		public static function getTextureName(build:Building):String {
			if (build == null)
				return "";
			return NAMES_BUILDING[build._type] + "_p" + build._owner + "_s4_l" + build._level;   
		}
		
		public function Building(warzone:Warzone) {
			_warzone = warzone;
		}
		
		public function init(xml:XML, parentW:uint, parentH:uint):Boolean {
			/*
			<city name="tower01" pos="197.00, 78.00" start_population="10" level="4" owner="1" tower_range="100.00, 100.00" layer="0" tower="true" count_node_number="1">
			*/
			
			name = xml.@name;
			_pos = ScriptHelper.parsePoint(xml.@pos);
			_popu = ScriptHelper.parseNumber(xml.@start_population);
			_level = ScriptHelper.parseNumber(xml.@level);
			_owner = ScriptHelper.parseNumber(xml.@owner);
			_towerRange = ScriptHelper.parsePoint(xml.@tower_range);
			_layer = ScriptHelper.parseNumber(xml.@labyer);
			_nodeId = ScriptHelper.parseNumber(xml.@count_node_number);
			
			if (ScriptHelper.parseBoolean(xml.@tower)) {
				_type = BUILD_TOWER;
				_armyType = ArmyManager.INFANTRY;
			} else if (ScriptHelper.parseBoolean(xml.@fast_armies)) {
				_type = BUILD_STABLE;
				_armyType = ArmyManager.SOWAR;
			} else if (ScriptHelper.parseBoolean(xml.@fortification)) {
				_type = BUILD_CASTLE;
				_armyType = ArmyManager.INFANTRY;
			} else if (ScriptHelper.parseBoolean(xml.@strong_armies)) {
				_type = BUILD_FORGE;
				_armyType = ArmyManager.ARMORED;
			} else {
				_type = BUILD_CITY;
			}
			
			var texName:String = NAMES_BUILDING[_type] + "_p" + _owner + "_s4_l" + _level;
			var bmd:BitmapData = App.resourceManager.getBitmapData(texName, TexPackManager.PACK_DEFAULT, 0xff000000);
			if (bmd == null)
				return false;
			
			_imgBuild = new Image(Texture.fromBitmapData(bmd, false));		
			addChild(_imgBuild);
			
			_popuBar = new PopulationBar();
			if (!_popuBar.init(_owner)) 
				return false;
			
			_popuBar.max = _level * 10;
			_popuBar.current = _popu;
			_popuBar.height *= 0.8;
			_popuBar.x = _imgBuild.x + (_imgBuild.width - _popuBar.width >> 1);
			_popuBar.y = _imgBuild.y + _imgBuild.height;
			addChild (_popuBar);
			
			pivotX = _imgBuild.width >> 1;
			pivotY = _imgBuild.y + _imgBuild.height - 12;
			
			x = (App.sceneWidth >> 1) + _pos.x;
			y = (App.sceneHeight>> 1) - _pos.y;
			
			if (_owner == OWNER_PLAYER)
				bmd = App.resourceManager.getBitmapData("our_selector");
			else
				bmd = App.resourceManager.getBitmapData("enemy_selector");
			if (bmd == null)
				return false;
			_imgHover = new Image(Texture.fromBitmapData(bmd));
			_imgHover.pivotX = _imgHover.width >> 1;
			_imgHover.pivotY = _imgHover.height >> 1;
			_imgHover.x = width >> 1;
			_imgHover.y = height >> 1;
			_imgHover.touchable = false;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			if (_owner != OWNER_PLAYER)
				touchable = false;
			
			return true;
		}
		
		public function get nodeId():uint {
			return _nodeId;
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is finished hovering; if so, it resets the upState texture */
		private function onParentTouchCheckHoverEnd(e:TouchEvent):void {
			
			var touch:Touch = e.getTouch(this);
			if (touch != null) {
				// click_down
				if (touch.phase == TouchPhase.BEGAN) {
					_curState = UP_STATE;
				}
				
				// click_up
				if (touch.phase == TouchPhase.ENDED) {
					if (handlerTrigger != null) {
						handlerTrigger(this);
						_curState = UP_STATE;
						addEventListener(TouchEvent.TOUCH, onTouch);
					} else {
						_curState = HOVER_STATE;
					}
					_select = !_select;
					updateSelectState();
				}
			} else {
				parent.removeEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				addEventListener(TouchEvent.TOUCH, onTouch);
				_curState = UP_STATE;
			}
			
			if (_curState == HOVER_STATE) {
				addChild(_imgHover);
			} else {
				if (contains(_imgHover))
					removeChild(_imgHover);
			}
			
		}
		
		private function onTouch(evt:TouchEvent):void {
			if (evt.interactsWith(this)) {
				
				removeEventListener(TouchEvent.TOUCH, onTouch);
				parent.addEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				
				_curState = HOVER_STATE;
			}
			
			if (_curState == HOVER_STATE) {
				addChild(_imgHover);
			} else {
				if (contains(_imgHover))
					removeChild(_imgHover);
			}
		}
		
		private function updateSelectState():void {
			
			if (_owner == OWNER_PLAYER) {
				
				if (_select) {
					if (_animSelect != null)
						return;
					
					_animSelect = App.resourceManager.getAnim("city_selector");
					if (_animSelect == null)
						return;
					_animSelect.pivotX = _animSelect.width >> 1;
					_animSelect.pivotY = _animSelect.height >> 1;
					_animSelect.x = pivotX;
					_animSelect.y = pivotY;
					
					addChildAt(_animSelect, 0);
					Starling.current.juggler.add(_animSelect);
				} else {
					if (_animSelect != null && contains(_animSelect)) {
						Starling.current.juggler.remove(_animSelect);
						removeChild(_animSelect);
						_animSelect.dispose();
						_animSelect = null;
					}
				}
			}
			
			if (_owner == OWNER_PLAYER) {
				_warzone.onBuildingCommand(this, _select ? COMMAND_SELECT : COMMAND_UNSELECT);				
			} else {
				_warzone.onBuildingCommand(this, COMMAND_ATTACK);
			}
		}
		
		protected function onRemove(e:Event):void {
			if (_animSelect != null && contains(_animSelect)) {
				Starling.current.juggler.remove(_animSelect);
				removeChild(_animSelect);
				_animSelect.dispose();
				_animSelect = null;
			}
		}
		
		public function upgrade():Boolean {
			if (_popu < (_level * 10 / 2))
				return false;
			
			_popu = _popu >> 1; // 升级，人口减半
			return true;
		}
		
		public function sendArmy():void {
			
		}
		
		public function get owner():uint {
			return _owner;
		}
		
		public function get armyType():uint {
			return _armyType;
		}
	}
}
import com.grabbers.globals.App;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;

import starling.display.DisplayObjectContainer;
import starling.display.Image;

class PopulationBar extends DisplayObjectContainer {
	protected var _fr:Image;
	protected var _bg:Image;
	protected var _max:uint;
	
	public function PopulationBar() {
		
	}
	
	public function init(ownerId:uint):Boolean {
		var texName:String = "population_p" + ownerId;
		var bmp:BitmapData = App.resourceManager.getBitmapData(texName);
		if (bmp == null)
			return false;
		
		_fr = Image.fromBitmap(new Bitmap(bmp), false);
		_bg = Image.fromBitmap(new Bitmap(bmp), false);
		_bg.color = 0x444444;
		
		addChild(_bg);
		addChild(_fr);
		
		return true;
	}
	
	public function set max(val:uint):void {
		_max = val;
	}
	
	public function set current(val:uint):void {
		_fr.setTexCoords(1, new Point(val / _max, 0));
		_fr.setTexCoords(3, new Point(val / _max, 1));
		_fr.width = _fr.texture.width * val / _max;
	}
}