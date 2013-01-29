package com.grabbers.globals
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		public static function clamp(n:Number, min:Number, max:Number):Number {
			if (n <= min) {
				n = min;
			}
			if (n >= max) {
				n = max;
			}
			return n;
		}
	}
}