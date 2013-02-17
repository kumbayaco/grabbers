package com.grabbers.ui.model
{
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.UIObjectFactory;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	
	public class UIEditBox extends UIObject
	{
		static protected const _parser:Object = {
			name:		function(str:String, obj:UIEditBox):void {obj.name = str;},
			size: 		function(str:String, obj:UIEditBox):void {obj._size = ScriptHelper.parsePoint(str);},
			pos: 		function(str:String, obj:UIEditBox):void {obj._pos = ScriptHelper.parsePoint(str);},
			font_size:	function(str:String, obj:UIEditBox):void {obj._fontSize = ScriptHelper.parseNumber(str);},
			max_len:	function(str:String, obj:UIEditBox):void {obj._maxLen = ScriptHelper.parseNumber(str);}
		};
			
		protected var _pos:Point;
		protected var _size:Point;
		protected var _fontSize:uint;
		protected var _maxLen:uint;
		protected var _inputBox:UIBitmap;
		
		public function UIEditBox()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			return true;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean{
			
			if (vXml == null)
				return true;
			
			for each (var xmlBasic:XML in vXml) {
				var att:XML;
				var key:String;
				var val:String;
				var strTag:String = xmlBasic.@name;
				switch (strTag) {
					case "basic_editbox":
						/*
						<editbox name="basic_editbox" size="2048, 2048" pos="0, 0" font_size="32" max_len="16">
						<bitmap name="inputbox" pos="0, 0" size="200, 30" color="0, 0, 0, 0">
						*/
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							}
						}
						
						for each (var xmlInput:XML in xmlBasic.bitmap) {
							var bmp:UIBitmap = new UIBitmap();
							bmp.init(xmlInput, _size.x, _size.y, texPack);		
							addChild(bmp);
							if (bmp.name == "inputbox")
								_inputBox = bmp;
						}
						
						break;
					default:
						break;
				}
			}
			
			return true;
		}
	}
}