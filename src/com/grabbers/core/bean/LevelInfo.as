package com.grabbers.core.bean
{
	public class LevelInfo
	{
		static public const LEVEL_LOCKED:uint = 0;
		static public const LEVEL_UNLOCKED:uint = 1;
		static public const LEVEL_FLAG_NORMAL:uint = 2;
		static public const LEVEL_FLAG_HARD:uint = 3;
		static public const LEVEL_FLAG_EXPERT:uint = 4;
		
		static public const STAR_NORMAL:uint = 0;
		static public const STAR_HARD:uint = 0;
		static public const STAR_EXPERT:uint = 0;
		
		public var levelState:uint;
		public var star:uint;
		public var name:String;
		public function LevelInfo() {
			levelState = LEVEL_UNLOCKED;
			star = STAR_NORMAL;
		}
	}
}