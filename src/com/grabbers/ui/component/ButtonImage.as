package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ButtonImage extends DisplayObjectContainer
	{
		public var handlerTrigger:Function;
		private var _imgText:Image;
		private var _fontSize:uint;
		private var _imgBg:Image;
		private var _curBmp:BitmapData;
		private var _vBmp:Vector.<BitmapData>;
		private var _vTex:Vector.<Texture> = new Vector.<Texture>();
		
		public function ButtonImage(vBmp:Vector.<BitmapData>, selectSfx:String, clickSfx:String)
		{
			_vBmp = vBmp;
			for (var i:uint = 0; i < vBmp.length; i++) {
				_vTex.push(Texture.fromBitmapData(vBmp[i], false));
			}
			
			_imgBg = Image.fromBitmap(new Bitmap(_vBmp[0]));
			_curBmp = _vBmp[0];
			addChild(_imgBg);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function set text(str:String):void {
			_imgText = App.resourceManager.getTextImage(str);
			if (_fontSize == 0)
				_fontSize = _imgText.height;
			centerImage();
			addChild(_imgText);
		}
		
		public function set fontSize(size:uint):void {
			if (_imgText != null && size > 0) {
				_fontSize = size;
				_imgText.scaleX = _imgText.scaleY = _imgText.texture.height / size;
				centerImage();
			}
		}
		
		override public function set width(w:Number):void {
			super.width = w;
			if (_imgText != null) {
				_imgText.scaleX = _imgText.scaleY = _imgText.texture.height / _fontSize;
				centerImage();
			}
		}
		
		override public function set height(h:Number):void {
			super.height = h;
			if (_imgText != null) {
				_imgText.scaleX = _imgText.scaleY = _imgText.texture.height / _fontSize;
				centerImage();
			}
		}
		
		private function centerImage():void {
			if (_imgText != null) {
				_imgText.x = _imgBg.width - _imgText.width >> 1;
				_imgText.y = _imgBg.height - _imgText.height >> 1;
			}
		}
		
		public function get textImage():Image {
			return _imgText;
		}
		
		static public function parse(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):ButtonImage {
			//<activeelement name="sign_options" pos="367, 126" size="256, 128" texture_name="sign_options" tex_mask_name="sign_options" select_sfx_name="selectmenu" click_sfx_name="clickmenu">
			var vBmp:Vector.<BitmapData> = App.resourceManager.getButtonBmpdata(texPack, xml.@texture_name);
			if (vBmp == null)
				return null;
			
			var arr:Array;
			arr = ScriptHelper.parseDigitArray(xml.@size);
			var size:Point = new Point(arr[0], arr[1]);
			
			var btn:ButtonImage = new ButtonImage(vBmp, xml.@select_sfx_name, xml.@click_sfx_name);
			
			//<text name="caption" pos="13, 0" text_align="center" font_size="28" text_key="share_caption">	
			for each (var textXml:XML in xml.text) {
				btn.text = App.resourceManager.getTextString(xml.text.@text_key);
				btn.fontSize = xml.text.@font_size;
				break;
			}
			
			arr = ScriptHelper.parseDigitArray(xml.@pos);			
			var pos:Point = ScriptHelper.parsePosition(arr[0], arr[1], size.x, size.y, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			btn.x = pos.x;
			btn.y = pos.y;
			btn.width = size.x;
			btn.height = size.y;
			btn.name = xml.@name;
			
			return btn;
		}
		
		private function onTouch(evt:TouchEvent):void {
			var touch:Touch = evt.getTouch(this);
			
			if (touch == null) {
				_imgBg.texture = _vTex[0];
				return;
			}
			
			switch (touch.phase) {
				case TouchPhase.BEGAN:
					
					_imgBg.texture = _vTex[1];
					break;
				
				case TouchPhase.ENDED:
					_imgBg.texture = _vTex[0];
					_curBmp = _vBmp[0];
					if (handlerTrigger != null)
						handlerTrigger(this);
					break;
				
				case TouchPhase.HOVER:
					_imgBg.texture = _vTex[1];
					_curBmp = _vBmp[1];
					break;
			}
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if (_curBmp == null)
				return null;
			
			if (forTouch && (!visible || !touchable))
				return null;
			
			var clr:uint = _curBmp.getPixel32(localPoint.x,localPoint.y);
			if ((clr & 0xff000000) == 0) {
				return null;
			}
			
			return this;
		}
	}
}