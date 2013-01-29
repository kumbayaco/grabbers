package com.grabbers.globals
{
	import flash.geom.Point;

	public class Global
	{
		public function Global()
		{
		}
		
		/**
		 * 
		 * @param anchorVertType 0:居中, 1:居顶, 2:居底 
		 * @param anchorHorzType 0:居中, 1:居左, 2:居右 
		 */		
		static public function configPt2ScreenPt(x:int, y:int, w:int, h:int, parentW:int = 1280, parentH:int = 768):Point {
			
			var _y:Number = 0;
			var _x:Number = 0;
			_y = parentH / 2 - y - h / 2;
			_x = parentW / 2 + x - w / 2;
			
			return new Point(_x, _y);
		}
	}
}