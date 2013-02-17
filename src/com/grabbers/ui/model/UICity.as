package com.grabbers.ui.model
{
	import starling.display.DisplayObjectContainer;
	
	public class UICity extends UIObject
	{
		public function UICity()
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