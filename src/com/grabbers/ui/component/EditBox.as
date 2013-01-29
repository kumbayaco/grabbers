package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class EditBox extends DisplayObjectContainer
	{
		static public const MAX_LEN:uint = 256;
		public function EditBox(bg:Image, fontSize:uint, maxLen:uint = MAX_LEN)
		{
			super();
		}
		
		static public function parseBasic(texPack:String, xml:XML):EditBox {
			//<editbox name="basic_editbox" size="2048, 2048" pos="0, 0" font_size="32" max_len="16">
			var size:Point = ScriptHelper.parsePoint(xml.@size);
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			var fontSize:uint = ScriptHelper.parseNumber(xml.@font_size);
			var maxLen:uint = MAX_LEN;
			if (xml.hasOwnProperty("max_len"))
				maxLen = ScriptHelper.parseNumber(xml.@max_len); 
			
			//<bitmap name="inputbox" pos="0, 0" size="200, 30" color="0, 0, 0, 0">
			var xmlBg:XML = xml.bitmap;
			var texBg:Texture;
			if (xmlBg != null) {
				texBg = App.resourceManager.getTexture(texPack, xmlBg.@texture_name);
				if (texBg == null) {
					var bgSize:Point = ScriptHelper.parsePoint(xmlBg.@size);
					var color:uint = ScriptHelper.parseColor(xmlBg.@color);
					texBg = Texture.fromBitmapData(new BitmapData(bgSize.x, bgSize.y));
				}
				
				var texPos:Point = ScriptHelper.parsePoint(xmlBg.@pos);
			}
		}
	}
}