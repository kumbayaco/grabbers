package com.grabbers.ui.model
{
	import starling.display.DisplayObjectContainer;

	public class UIObject extends DisplayObjectContainer
	{
		public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean {
			return false;
		}
		
		public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean {
			return true;
		}
	}
}