package com.grabbers.ui.model
{
	import starling.display.DisplayObjectContainer;
	
	public class UICity extends UIObject
	{
		public function UICity()
		{
			super();
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean 
		{
			return false;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean 
		{
			return false;
		}
	}
}