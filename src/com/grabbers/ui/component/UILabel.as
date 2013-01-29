package com.grabbers.ui.component
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
	
	public class UILabel extends DisplayObjectContainer
	{
		private var _img:Image;
		
		/**
		 * 
		 * @param text
		 * @param fontSize
		 * @param align TODO
		 * 
		 */		
		public function UILabel(text:String, fontSize:uint, align:String = "center")
		{			
			_img = App.resourceManager.getTextImage(text);
			if (_img != null) {
				_img.pivotX = _img.width >> 1;
				_img.pivotY = _img.height >> 1;
				var scale:Number = (fontSize) / ResourceManager.FONT_HEIGHT;
				_img.scaleX = _img.scaleY = scale;
				
				addChild(_img);
			}
			touchable = false;
		}
		
		static public function parse(xml:XML, parentW:uint = 1280, parentH:uint = 768):UILabel {
			
			//<text name="greetings_text" pos="3, 0" text_align="center" font_size="26" text_key="__">
			var strText:String = App.resourceManager.getTextString(xml.@text_key);
			var fontSize:uint = ScriptHelper.parseNumber(xml.@font_size);
			var label:UILabel = new UILabel(strText, fontSize, xml.@text_align);
			
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
//			LayoutUtil.setLayoutInfo(label, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, _size.x, _size.y, parentW, parentH);
			
			label.name = xml.@name;		
			
			return label;
		}		
	}
}