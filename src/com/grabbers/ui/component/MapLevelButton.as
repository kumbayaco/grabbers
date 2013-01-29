package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class MapLevelButton extends DisplayObjectContainer
	{
		static public const LEVEL_LOCKED:uint = 0;
		static public const LEVEL_UNLOCKED:uint = 1;
		static public const LEVEL_FLAG_NORMAL:uint = 2;
		static public const LEVEL_FLAG_HARD:uint = 3;
		static public const LEVEL_FLAG_EXPERT:uint = 4;
		
		static private const LEVELS_PIC:Array = ["level_locked", "level_unlocked", "level_flag_normal", "level_flag_hard", "level_flag_expert"];
		static private const LEVEL_TEXTURES:Dictionary = new Dictionary();
		static private var _texSelected:Texture;
		
		public var handlerTriggered:Function;
		
		private var _state:uint = 80;
		private var _imgLocked:Image;
		private var _imgButton:Image;
		private var _imgText:Image;
		private var _imgSelect:Image;
		
		public function MapLevelButton(strLevel:String, state:uint = LEVEL_LOCKED) {
			super();
			
			_imgText = App.resourceManager.getTextImage(strLevel);
			_imgText.scaleX = _imgText.scaleY = 24 / _imgText.height;
			_imgText.color = Color.YELLOW;
			if (_texSelected == null) {
				_texSelected = App.resourceManager.getTexture(Resources.MAP_PACK, "level_selector");
			}
			_imgSelect = new Image(_texSelected);
			this.state = state;
		}
		
		public function set select(bSel:Boolean):void {
			if (bSel) {
				addChildAt(_imgSelect, 0);
			} else {
				if (contains(_imgSelect))
					removeChild(_imgSelect);
			}
		}
		
		public function set state(val:uint):void {
			if (_state == val)
				return;
			
			removeChildren();
			
			_state = val;
			if (val == LEVEL_LOCKED) {
				if (_imgLocked == null)
					_imgLocked = new Image(getLevelTexture(val, true));
				addChild(_imgLocked);
				touchable = false;
			} else {
				if (_imgButton == null) {
					_imgButton = new Image(getLevelTexture(val, true));
					addEventListener(TouchEvent.TOUCH, onTouch);
				}
				else {
					_imgButton.texture = getLevelTexture(val, true);
					removeEventListener(TouchEvent.TOUCH, onTouch);
				}
				touchable = true;
				addChild(_imgButton);
			}
			
			
			if (_state == LEVEL_LOCKED) {
				if (contains(_imgText))
					removeChild(_imgText);
			} else {
				if (!contains(_imgText)) {
					addChild(_imgText);
					_imgText.x = width - _imgText.width >> 1;
					_imgText.y = height - _imgText.height;
				}
			}
				
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if (touch != null) {
				if (touch.phase == TouchPhase.ENDED) {
					// clicked
					_imgButton.texture = getLevelTexture(_state, true);
					if (handlerTriggered != null) {
						handlerTriggered(this);
					}
				} else if (touch.phase == TouchPhase.HOVER) {
					_imgButton.texture = getLevelTexture(_state, false);
				} else {
					_imgButton.texture = getLevelTexture(_state, true);
				}
			} else {
				_imgButton.texture = getLevelTexture(_state, true);
			}
		}
		
		static public function register(name:String, handler:Function, xml:XML):void {
			
		}
		
		static private function getLevelTexture(level:uint, bUp:Boolean):Texture {
			var tok:String = level + "," + bUp;
			if (LEVEL_TEXTURES[tok] != null)
				return LEVEL_TEXTURES[tok];
			
			var tex:Texture = App.resourceManager.getTexture(Resources.MAP_PACK, LEVELS_PIC[level]);
			
			if (level == LEVEL_LOCKED) {
				var texLok:Texture = Texture.fromTexture(tex);
				LEVEL_TEXTURES[level + "," + true] = texLok;
				LEVEL_TEXTURES[level + "," + false] = texLok;
			} else {
				var texUp:Texture = Texture.fromTexture(tex, new Rectangle(0, 0, tex.width, tex.height >> 1));
				var texDown:Texture = Texture.fromTexture(tex, new Rectangle(0, tex.height >> 1, tex.width, tex.height >> 1));
				LEVEL_TEXTURES[level + "," + true] = texUp;
				LEVEL_TEXTURES[level + "," + false] = texDown;
			}
			
			return LEVEL_TEXTURES[tok] as Texture;
		}
		
		static public function parse(xml:XML, parentW:uint, parentH:uint):MapLevelButton {
			//<level_button name="st1_forest02" pos="150, 90">
			//<number text_key="2">			
			//	</number>
			//</level_button>
			var pt:Point = ScriptHelper.parsePoint(xml.@pos);
			var strLevel:String = xml.number.@text_key;
			var btn:MapLevelButton = new MapLevelButton(strLevel);
			pt = ScriptHelper.parsePosition(pt.x, pt.y, btn.width, btn.height, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			btn.x = pt.x;
			btn.y = pt.y;
			btn.name = xml.@name;
			
			return btn;
		}
	}
}