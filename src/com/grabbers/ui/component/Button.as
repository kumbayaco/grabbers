package com.grabbers.ui.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	// 2 state
	public class Button extends Sprite
	{
		public static const STATE_UP:uint = 0;
		public static const STATE_DOWN:uint = 1;
		public static const STATE_HOVER:uint = 2;
		public static const STATE_DISABLE:uint = 3;
		
		private var _skin:Bitmap;
		private var _state:uint;
		public function Button(bmdData:BitmapData) {
			_skin = new Bitmap();
			super();
		}
		
		public function set state(val:uint):void {
			updateState(val);
		}
		
		private function updateState(val:uint):void {
			_state = val;
		}
	}
}