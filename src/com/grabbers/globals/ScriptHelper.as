package com.grabbers.globals
{
	import com.grabbers.log.Logger;
	import com.grabbers.ui.component.AnimateImage;
	import com.grabbers.ui.component.ButtonHover;
	import com.grabbers.ui.component.FormElement;
	import com.grabbers.ui.type.Anchor;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;

	public class ScriptHelper
	{
		public function ScriptHelper()
		{
		}
		
		
		static public function parseDigitArray(str:String):Array {
			str = str.replace(/,/g, " ");
			
			var arr:Array = str.split(/ +/g);
			for (var i:uint = 0; i < arr.length; i++)
				arr[i] = parseFloat(arr[i]);
			return arr;
		}
		
		static public function parseNumber(str:String):Number {
			var arr:Array = parseDigitArray(str);
			if (arr.length > 0)
				return arr[0];
			return 0;
		}
		
		static public function parseColor(str:String):uint {
			var arr:Array = parseDigitArray(str);
			if (arr.length >= 4) {
				return Color.argb(arr[3], arr[0], arr[1], arr[2]);
			}
			
			return Color.argb(0, 0, 0, 0);
		}
		
		static public function parsePoint(str:String):Point {
			var arr:Array = parseDigitArray(str);
			if (arr.length > 1) {
				return new Point(arr[0], arr[1]);
			}
			
			return new Point(0,0);
		}
		
		static public function parseBoolean(str:String):Boolean {
			if (str == "true")
				return true;
			return false;
		}
		
		static public function parseRect(str:String):Rectangle {
			var arr:Array = parseDigitArray(str);
			if (arr.length > 4) {
				return new Rectangle(arr[0], arr[1], arr[2]-arr[0], arr[3]-arr[1]);
			}
			
			return new Rectangle(0,0,0,0);
		}
		
		static public function parseAnchorType(xml:XML):Anchor {
			var horz:String = Anchor.CENTER_ANCHOR;
			var vert:String = Anchor.CENTER_ANCHOR;
			if (xml.@bottom_anchor == "true") {
				vert = Anchor.BOT_ANCHOR;
			} else if (xml.@top_anchor == "true") {
				vert = Anchor.TOP_ANCHOR;
			}
			
			if (xml.@left_anchor == "true") {
				horz = Anchor.LEFT_ANCHOR;
			} else if (xml.@right_anchor == "true") {
				horz = Anchor.RIGHT_ANCHOR;
			}
			
			return Anchor.getAnchor(horz, vert);
		}
		
		static public function parsePosition(x:Number, y:Number, width:Number, height:Number, anchorType:Anchor, parentW:Number, parentH:Number):Point {
			var pt:Point = new Point(x, y);
			
			switch (anchorType.horzAnchor) {
				case Anchor.CENTER_ANCHOR:
					pt.x = parentW / 2 + pt.x - width / 2;
					break;
				
				case Anchor.RIGHT_ANCHOR:
					pt.x = parentW - pt.x - width;
					break;
				
				case Anchor.LEFT_ANCHOR:
					break; 
			}
			
			switch (anchorType.vertAnchor) {
				case Anchor.CENTER_ANCHOR:
					pt.y = parentH / 2 - pt.y - height / 2;
					break;
				
				case Anchor.BOT_ANCHOR:
					pt.y = parentH - pt.y - height;
					break;
				
				case Anchor.TOP_ANCHOR:
					pt.y = -pt.y;// + height / 2;
					break;
			}

			return pt;
		}
		
	}
}