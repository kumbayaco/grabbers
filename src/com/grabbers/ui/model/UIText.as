package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.manager.ResourceManager;
	import com.grabbers.ui.LayoutUtil;
	
	import flash.geom.Point;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class UIText extends UIObject
	{
		private var _img:Image;
		private var _fontSize:uint;
		private var _text:String;
	
		public function UIText() {			
			
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean {
			
			//<text name="greetings_text" pos="3, 0" text_align="center" font_size="26" text_key="__">
			update(App.resourceManager.getTextString(xml.@text_key), ScriptHelper.parseNumber(xml.@font_size));
			
			touchable = false;
			
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH);
			
			name = xml.@name;		
			
			return true;
		}
		
		public function get fontSize():uint {
			return _fontSize;
		}
		
		public function get text():String {
			return _text;
		}
		
		public function update(str:String, fontSize:uint):void {
			_img = App.resourceManager.getTextImage(str);
			if (_img != null) {			
//				_img.pivotX = _img.texture.width >> 1;
//				_img.pivotY = _img.texture.height >> 1;
				var scale:Number = fontSize / ResourceManager.FONT_HEIGHT;
				_img.scaleX = _img.scaleY = scale;
				
				if (!contains(_img))
					addChild(_img);
			}
			
			_text = str;
			_fontSize = fontSize;
		}
		
	}
}