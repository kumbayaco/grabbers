package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.manager.ResourceManager;
	
	import flash.geom.Point;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class Label extends DisplayObjectContainer
	{
		private var _img:Image;
		private var _bg:Quad;
		public function Label()
		{			
			super();
			_bg = new Quad(1, 1, 0xffffff00);
			_bg.alpha = 0;
			addChild(_bg);
		}
		
		static public function parse(xml:XML, parentW:uint = 1280, parentH:uint = 768):Label {
			var label:Label = new Label();
			
			//<text name="greetings_text" pos="3, 0" text_align="center" font_size="26" text_key="__">
			label.name = xml.@name;
			var arr:Array;
			
			
			var image:Image = App.resourceManager.getTextImage(App.resourceManager.getTextString(xml.@text_key));
			if (image != null) {
				var scale:Number = (xml.@font_size) / ResourceManager.FONT_HEIGHT;
				image.scaleX = image.scaleY = scale;				
				label.textImage = image;
				
				image.blendMode = BlendMode.NORMAL;
				image.touchable = false;
			}
			
			arr = ScriptHelper.parseDigitArray(xml.@size);
			if (arr.length == 2) {
				label.width = arr[0] as int;
				label.height = arr[1] as int;
			}
			
			arr = ScriptHelper.parseDigitArray(xml.@pos);
			var pt:Point = new Point(arr[0], arr[1]);
			pt = ScriptHelper.parsePosition(pt.x, pt.y, label.width, label.height, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			label.x = pt.x;
			label.y = pt.y;
			
			label.touchable = false;
			return label;
		}
		
		
		override public function set width(w:Number):void {
			_bg.width = w;
			centerImage();
		}
		
		override public function set height(h:Number):void {
			_bg.height = h;
			centerImage();
		}
		
		public function set textImage(img:Image):void {
			_img = img;
			addChild(_img);
			centerImage();
		}
		
		private function centerImage():void {
			if (_img != null) {
				_img.x = width - _img.width >> 1;
				_img.y = height - _img.height >> 1;
			}
		}
	}
	
}