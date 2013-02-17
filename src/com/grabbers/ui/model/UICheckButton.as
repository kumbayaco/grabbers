package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.manager.ResourceManager;
	import com.grabbers.ui.LayoutUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class UICheckButton extends UIObject
	{
		static protected const _parser:Object = {
			name:			function(str:String, obj:UICheckButton):void {obj.name = str.replace(/\W/g, "");},
			size: 			function(str:String, obj:UICheckButton):void {obj._size = ScriptHelper.parsePoint(str);},
			pos: 			function(str:String, obj:UICheckButton):void {obj._pos = ScriptHelper.parsePoint(str);},
			font_size:		function(str:String, obj:UICheckButton):void {obj._fontSize = ScriptHelper.parseNumber(str);},
//			add_caption:	function(str:String, obj:UICheckButton):void {obj._bAddText = ScriptHelper.parseBoolean(str);},
			text_shift:		function(str:String, obj:UICheckButton):void {obj._textShift = ScriptHelper.parseNumber(str);},
			texture_name:	function(str:String, obj:UICheckButton):void {
				var vBmp:Vector.<BitmapData> = App.resourceManager.getBitmapDataTwin(str);
				if (vBmp == null)
					return;
				obj._bgUp = Texture.fromBitmapData(vBmp[0]);
				obj._bgDown = Texture.fromBitmapData(vBmp[1]);
				if (obj._bg != null && obj.contains(obj._bg))
					obj.removeChild(obj._bg);
				obj._bg = new Image(obj._bgUp);
				
				obj._bg.width = obj._size.x;
				obj._bg.height = obj._size.y;
				obj.addChild(obj._bg);
			},
			select_sfx_name:function(str:String, obj:UICheckButton):void {obj._sfxHover = str;},
			click_sfx_name:	function(str:String, obj:UICheckButton):void {obj._sfxClick = str;}
		};
		
		static public const UP_STATE:uint = 0;
		static public const HOVER_STATE:uint = 1;
		
		public var handlerTrigger:Function;
		
		protected var _curState:uint = UP_STATE;
		protected var _pos:Point = new Point(0,0);
		protected var _size:Point = new Point(0,0);
		protected var _fontSize:uint = ResourceManager.FONT_HEIGHT;
		protected var _textShift:uint = 0;
		protected var _bgUp:Texture;
		protected var _bgDown:Texture;
		protected var _bg:Image;
		protected var _bAddText:Boolean = true;
		protected var _text:Image;
		protected var _sfxClick:String;
		protected var _sfxHover:String;
		
		public function UICheckButton()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean 
		{
			for each (var att:XML in xml.attributes()) {
				var key:String = att.name().toString();
				var val:String = att.toString();
				if (_parser.hasOwnProperty(key)) {
					_parser[key](val, this);
				}
			}				
			
			if (_bg != null) {
				_bg.width = _size.x;
				_bg.height = _size.y;
			}
			
			if (_bAddText) {
				text = App.resourceManager.getTextString(name + "_caption");
			}		
			
			LayoutUtil.setLayoutInfoEx(this, ScriptHelper.parseAnchorType(xml), _pos.x, _pos.y, _size.x, _size.y, parentW, parentH);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			return true;
		}
		
		public function initFromMem(text:String, hoverSfx:String, clickSfx:String):void {
			this.text = App.resourceManager.getTextString(text);
			if (!hasEventListener(TouchEvent.TOUCH))
				addEventListener(TouchEvent.TOUCH, onTouch);
			_sfxHover = hoverSfx;
			_sfxClick = clickSfx;
		}
		
		public function set text(str:String):void {
			if (_text != null && contains(_text))
				removeChild(_text);
			
			_text = App.resourceManager.getTextImage(str);
			if (_text == null) {
				Logger.error(str + " text not found");
				return;
			}
			
			_text.scaleX = _text.scaleY = _fontSize / ResourceManager.FONT_HEIGHT;
			_text.x = ((width - _text.width) >> 1) + _textShift;
			_text.y = (height - _text.height) >> 1;
			addChild(_text);
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean 
		{
			/*
			<checkbutton name="basic_button" pos="0, 0" size="224, 40" font_size="24" text_shift="1" font_scale="true" texture_name="txtbtn_menu" select_sfx_name="selectmenu" 
			click_sfx_name="clickmenu">
			</checkbutton>
			<checkbutton name="sys_button" pos="0, 0" size="96, 32" add_caption="false" font_size="24" font_scale="true" texture_name="sys_button">
			</checkbutton>
			<checkbutton name="basic_checkbutton" pos="0, 0" size="224, 48" font_size="28" text_shift="3" font_scale="true" add_caption="false" texture_name="txtbtn_menu">
			</checkbutton>
			
			<checkbutton name="icon_checkbutton" pos="0, 0" size="128, 128" font_size="24" font_scale="true" add_caption="false" icon="true" text_shift="40" 
			texture_name="chkbtn_fill_black">
			
			</checkbutton>
			*/
			if (vXml == null)
				return true;
			
			for each (var xmlBasic:XML in vXml) {
				for each (var att:XML in xmlBasic.attributes()) {
					var key:String = att.name().toString();
					var val:String = att.toString();
					if (_parser.hasOwnProperty(key)) {
						_parser[key](val, this);
					}
				}				
			}
			
			
			return true;
		}
		
		private function onParentTouchCheckHoverEnd(e:TouchEvent):void {
			
			var touch:Touch = e.getTouch(this);
			if (touch != null) {
				// click_down
				if (touch.phase == TouchPhase.BEGAN) {
					_curState = UP_STATE;
					if (_sfxClick != "")
						App.soundManager.playSfx(_sfxClick);
				}
				
				// click_up
				if (touch.phase == TouchPhase.ENDED) {
					
					if (handlerTrigger != null) {
						handlerTrigger(this);
						_curState = UP_STATE;
					} else {
						_curState = HOVER_STATE;
					}
				}
			} else {
				parent.removeEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				addEventListener(TouchEvent.TOUCH, onTouch);
				_curState = UP_STATE;
			}
			
			if (_bg != null)
				_bg.texture = _curState==UP_STATE ? _bgUp : _bgDown;
		}
		
		private function onTouch(evt:TouchEvent):void {
			if (evt.interactsWith(this)) {
				
				removeEventListener(TouchEvent.TOUCH, onTouch);
				parent.addEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				
				_curState = HOVER_STATE;
				if (_sfxHover != "")
					App.soundManager.playSfx(_sfxHover);
			}
			
			if (_bg != null)
				_bg.texture = _curState==UP_STATE ? _bgUp : _bgDown;
		}
	}
}