package com.grabbers.ui.model
{
	import starling.display.DisplayObjectContainer;
	
	public class UIComponentPalette extends UIObject
	{
		public function UIComponentPalette()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean 
		{
			return false;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean
		{
			return false;
		}
	}
}