package com.grabbers.manager
{
	import com.grabbers.core.bean.LevelInfo;
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	
	import flash.globalization.NumberFormatter;
	import flash.utils.Dictionary;

	public class LevelManager
	{
		static protected const CHAPTER_NAME:Array = 
			[
				"st1_forest",
				"st2_prairie",
				"st3_fjord",
				"st4_island",
				"st5_lava"
			];
		
		static protected const SCRIPT_DIR:String = "scripts/levels/"; 
		
		static protected const LEVEL_NUM:uint = 9; 
		
		protected var _curLevel:String;
		protected var _level2Asset:Dictionary = new Dictionary();
		
		public function LevelManager() {
		}
		
		public function set curLevel(str:String):void {
			_curLevel = str;
		}
		
		public function get curLevel():String {
			return _curLevel;
		}
		
		public function get curLevelAsset():String {
			return getAsset(_curLevel);
		}
		
		public function init():Boolean {
			for each (var chapter:String in CHAPTER_NAME) {
				for (var i:uint = 0; i < LEVEL_NUM; i++) {
					var levelName:String = chapter + "0" + (i+1);
					var fileName:String = SCRIPT_DIR + levelName + ".txt";
					
					var str:String = App.resourceManager.getConfigXml(fileName);
					
					try {
						var xml:XML = new XML(str);
						var strAsset:String = xml.@background_texture;
						_level2Asset[levelName] = "wz_" + strAsset + "_pack.swf";
					} catch (e:Error) {
						Logger.error(fileName + " is not a valid file");
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function getAsset(strLevel:String):String {
			if (_level2Asset[strLevel] == null) {
				Logger.error("unrecognized level " + strLevel);
				return null;
			}
			
			return _level2Asset[strLevel] as String;
		}
		
		
	}
}