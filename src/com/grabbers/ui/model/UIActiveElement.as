package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.component.IHint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class UIActiveElement extends UIObject implements IHint
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
		private var _hint:UIHint;
		
		public function UIActiveElement() {			
			
		}		
		
		//<activeelement name="sign_options" pos="367, 126" size="256, 128" texture_name="sign_options" tex_mask_name="sign_options" 
		// select_sfx_name="selectmenu" click_sfx_name="clickmenu">
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean {
			
			// bg
			_vBmp = App.resourceManager.getButtonBmpdata(texPack, xml.@texture_name);
			if (_vBmp == null)
				return false;
			
			_vTex = new Vector.<Texture>;
			for (var i:uint = 0; i < _vBmp.length; i++) {
				_vTex.push(Texture.fromBitmapData(_vBmp[i], false));
			}
			_bg = new Image(_vTex[_curState]);
			addChild(_bg);
			
			// mask
			if (xml.hasOwnProperty("@tex_mask_name")) {
				var strTex:String = xml.@texture_name;
				var strMask:String = xml.@tex_mask_name;
				if (strTex != strMask) {
					var bmd:BitmapData = App.resourceManager.getBitmapData(texPack, xml.@tex_mask_name);
					if (bmd != null) {
						_mask = new BitmapData(_bg.width, _bg.height, true, 0);
						_mask.draw(bmd, new Matrix(_mask.width/bmd.width, 0, 0, _mask.height/bmd.height));
					}
				}
			}
			if (_mask != null)				
				_bg.touchable = false;
			
			// sfx
			_hoverSfx = xml.@select_sfx_name;
			_clickSfx = xml.@click_sfx_name;
			
			// layout
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			var size:Point = ScriptHelper.parsePoint(xml.@size);
			LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH);
			
			name = xml.@name;
			
			addEventListener(TouchEvent.TOUCH, onTouch);	
			
			return true;
		}
		
		public function setHint(hint:UIHint):void {
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
					if (_hint != null)
						_hint.hide();
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
				if (_hoverSfx != "")
					App.soundManager.playSfx(_hoverSfx);
			}
			
			_bg.texture = _vTex[_curState];
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject {
			if (_mask == null)
				return super.hitTest(localPoint, forTouch);
			
			if (forTouch && (!visible || !touchable))
				return null;
			
			var clr:uint = _mask.getPixel32(localPoint.x,localPoint.y);
			if ((clr & 0xff000000) == 0) {
				return null;
			}
			
			return this;
		}
	}
}