package com.grabbers.ui.model
{
	import starling.display.DisplayObjectContainer;

	public class UIObject extends DisplayObjectContainer
	{
		public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			return false;
		}
		
		public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean {
			return true;
		}
	}
}