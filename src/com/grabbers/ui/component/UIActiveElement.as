package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class UIActiveElement extends DisplayObjectContainer implements IHint
	{
		static public const UP_STATE:uint = 0;
		static public const HOVER_STATE:uint = 1;
		
		public var handlerTrigger:Function;
		
		private var _bg:Image;
		private var _mask:BitmapData;
		private var _vTex:Vector.<Texture>;		
		private var _vBmp:Vector.<BitmapData>;
		private var _curState:uint = UP_STATE;
		private var _hoverSfx:String;
		private var _clickSfx:String;		
		private var _hint:Hint;
		
		public function UIActiveElement(vBmp:Vector.<BitmapData>, mask:BitmapData, hoverSfx:String, clickSfx:String) {			
			_vBmp = vBmp;			
			_mask = mask;
			_hoverSfx = hoverSfx;
			_clickSfx = clickSfx;
			
			_vTex = new Vector.<Texture>;
			for (var i:uint = 0; i < vBmp.length; i++) {
				_vTex.push(Texture.fromBitmapData(vBmp[i]));
			}
			
			
			_bg = new Image(_vTex[_curState]);
			_bg.touchable = false;
			addChild(_bg);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function setHint(hint:Hint):void {
			_hint = hint;
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is finished hovering; if so, it resets the upState texture */
		private function onParentTouchCheckHoverEnd(e:TouchEvent):void {
			
			var touch:Touch = e.getTouch(this);
			if (touch != null) {
				// click_down
				if (touch.phase == TouchPhase.BEGAN) {
					_curState = UP_STATE;
					if (_clickSfx != "")
						App.soundManager.playSfx(_clickSfx);
					if (_hint != null)
						_hint.hide();
				}
				
				// click_up
				if (touch.phase == TouchPhase.ENDED) {
					_curState = HOVER_STATE;
					if (_hint != null)
						_hint.hide();
				}
			} else {
				parent.removeEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				addEventListener(TouchEvent.TOUCH, onTouch);
				if (_hint != null)
					_hint.hide();
				_curState = UP_STATE;
			}
			
			_bg.texture = _vTex[_curState];
		}
		
		private function onTouch(evt:TouchEvent):void {
			
			if (evt.interactsWith(this)) {
				
				removeEventListener(TouchEvent.TOUCH, onTouch);
				parent.addEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				
				_curState = HOVER_STATE;
				if (_hint != null)
					_hint.show();
				App.soundManager.playSfx(_hoverSfx);
			}
			
			_bg.texture = _vTex[_curState];
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			var realMask:BitmapData = _mask;
			if (realMask == null)
				realMask = _vBmp[_curState];
			
			if (forTouch && (!visible || !touchable))
				return null;
			
			var clr:uint = realMask.getPixel32(localPoint.x,localPoint.y);
			if ((clr & 0xff000000) == 0) {
				return null;
			}
			
			return this;
		}
		
		//<activeelement name="sign_options" pos="367, 126" size="256, 128" texture_name="sign_options" tex_mask_name="sign_options" 
		// select_sfx_name="selectmenu" click_sfx_name="clickmenu">
		static public function parse(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):UIActiveElement {
			
			var vBmps:Vector.<BitmapData> = App.resourceManager.getButtonBmpdata(texPack, xml.@texture_name);
			var mask:BitmapData;
			if (xml.hasOwnProperty("@tex_mask_name")) {
				var strTex:String = xml.@texture_name;
				var strMask:String = xml.@tex_mask_name;
				if (strTex != strMask)
					mask = App.resourceManager.getBitmapData(texPack, xml.@tex_mask_name);
			}
			
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			var size:Point = ScriptHelper.parsePoint(xml.@size);	
			var uiAct:UIActiveElement = new UIActiveElement(vBmps, mask, xml.@select_sfx_name, xml.@click_sfx_name);
			
			LayoutUtil.setLayoutInfo(uiAct, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH);
			
			return uiAct;
		}
	}
}