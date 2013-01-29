package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.component.IHint;
	import com.grabbers.ui.component.ScaleImage;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class UIHint extends UIObject
	{
		protected var _pos:Point = new Point();
		protected var _size:Point = new Point();
		protected var _delay:Number;
		protected var _showSpeed:Number;
		protected var _fadeSpeed:Number;
		protected var _hideScale:Point = new Point();
		protected var _showAngle:Number;
		protected var _hideAngle:Number;
		protected var _hideAlpha:Number;
		protected var _effectTime:Number;
		protected var _border:Point = new Point();
		protected var _bGlobalPos:Boolean;
		
		protected var _text:UIText;
		
		protected var _activator:String;
		protected var _actObj:DisplayObject;
		
		static protected var _bg:ScaleImage;
		
		static protected const _parser:Object = {
			activator:		function(str:String, obj:Object):void {obj._activator = str;},
			pos: 			function(str:String, obj:Object):void {obj._pos = ScriptHelper.parsePoint(str);},
			size: 			function(str:String, obj:Object):void {obj._size = ScriptHelper.parsePoint(str);},
			hint_delay: 	function(str:String, obj:Object):void {obj._delay = ScriptHelper.parseNumber(str);},
			show_speed: 	function(str:String, obj:Object):void {obj._showSpeed = ScriptHelper.parseNumber(str) / 1000;},
			fade_speed: 	function(str:String, obj:Object):void {obj._fadeSpeed = ScriptHelper.parseNumber(str) / 1000;},
			hide_scale: 	function(str:String, obj:Object):void {obj._hideScale = ScriptHelper.parsePoint(str);},
			show_angle: 	function(str:String, obj:Object):void {obj._showAngle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_angle: 	function(str:String, obj:Object):void {obj._hideAngle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_alpha:		function(str:String, obj:Object):void {obj._hideAlpha = ScriptHelper.parseNumber(str);},
			effect_time: 	function(str:String, obj:Object):void {obj._effectTime = ScriptHelper.parseNumber(str) / 1000;},
			global_pos: 	function(str:String, obj:Object):void {obj._bGlobalPos = ScriptHelper.parseBoolean(str);},
			border: 		function(str:String, obj:Object):void {obj._border = ScriptHelper.parsePoint(str);},
			texture_theme_name:
							function(str:String, obj:Object):void {
								if (_bg == null) {
									_bg = new ScaleImage(App.resourceManager.getUniqueBitmapData(str), new Rectangle(8, 8, 16, 16));
								}
							}
		};
		
		public function UIHint()
		{
			super();
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean 
		{
			/*
			<basic_hint activator="sign_options" pos="0, -87" size="110, 24" auto_text="false" manual_pos="true" global_pos="false" hint_delay="800">
			<text text_key="options_caption">
			</text>
			</basic_hint>
			*/
			for each (var att:XML in xml.attributes()) {
				var key:String = att.name().toString();
				var val:String = att.toString();
				if (_parser.hasOwnProperty(key)) {
					_parser[key](val, this);
				}
			}
			
			for each (var xmlText:XML in xml.text) {
				_text.update(App.resourceManager.getTextString(xmlText.@text_key), 24);
				break;
			}
			
			return true;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean 
		{
			if (vXml == null)
				return true;
			
			/*
			<hint name="basic_hint" pos="0, -300" size="256, 192" hint_delay="250" show_speed="250" fade_speed="250" 
				show="false" auto_text="true" global_pos="true" hide_scale="0.01, 0.01" show_angle="0" hide_angle="0" 
				hide_alpha="0.0" effect_time="500" border="8, 8" texture_theme_name="hint_theme">			
			<text name="text" pos="0, 0" size="246, 192" font_size="20" text_align="center" text_key="-">			
			</text>
			</hint>
			*/
			for each (var xml:XML in vXml) {
				var tagName:String = xml.@name;
				switch (tagName) {
					case "basic_hint": {
						for each (var att:XML in xml.attributes()) {
							var key:String = att.name().toString();
							var val:String = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							} else {
								
							}
						}
						
						_text = new UIText();
						_text.init(null, xml.text[0], _size.x, _size.y);
						break;
					}
						
					default:
						break;
				}
			}
			
			return true;
		}
		
		public function activate(parent:DisplayObjectContainer):Boolean {
			if (parent == null)
				return false;
			
			var activeObj:IHint = parent.getChildByName(_activator) as IHint;
			if (activeObj == null) {
				Logger.error(_activator + " not found in " + parent.name + ", hint not activate");
				return false;
			}
			_actObj = activeObj as DisplayObject;
			
			activeObj.setHint(this);
			return true;
		}
		
		public function show():void {
			// init
			if (_bg == null)
				return;
			
			_bg.width = _border.x * 2 + _size.x;
			_bg.height = _border.y * 2 + _size.y;			
			addChild(_bg);
			
			_text.pivotX = 0;
			_text.pivotY = 0;
			_text.x = _bg.width - _text.width >> 1;
			_text.y = _bg.height - _text.height >> 1;
			addChild(_text);
			
			pivotX = _bg.width >> 1;
			pivotY = _bg.height >> 1;
			
			if (_bGlobalPos || _actObj == null) {
				x = _pos.x + (App.stage.stageWidth >> 1);
				y = (App.stage.stageHeight >> 1) - _pos.y;
			} else {
				x = _actObj.x + _pos.x;
				y = _actObj.y - _pos.y;				
			}			
			
			// show from hide position
			alpha = _hideAlpha;
			rotation = _hideAngle;
			scaleX = _hideScale.x;
			scaleY = _hideScale.y;
			
			// start show
			var startShow:Function = function(obj:DisplayObject):void {
				App.stage.addChild(obj);
			}
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			setTimeout(startShow, _delay, this);
		}
		
		public function onAdd(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			Starling.current.juggler.tween(this, _showSpeed,
				{
					transition: Transitions.EASE_IN_OUT,
					scaleX: 1,
					scaleY: 1,
					rotation: _showAngle,
					alpha: 1
				}
			);
		}
		
		public function hide():void {
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeChild(_bg);
			removeChild(_text);
			App.stage.removeChild(this);
		}
		
		public function onRemove(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			Starling.current.juggler.tween(this, _fadeSpeed,
				{
					transition: Transitions.EASE_IN_OUT,
					scaleX: _hideScale.x,
					scaleY: _hideScale.y,
					rotation: _hideAngle,
					alpha: _hideAlpha
				}
			);
		}
	}
}