package com.grabbers.globals
{
	import com.grabbers.manager.LoadManager;
	import com.grabbers.manager.ResourceManager;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.manager.SoundManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;

	public class App
	{
		private static var _stage:Stage;
		private static var _loadManager:LoadManager;
		private static var _resourceManager:ResourceManager;
		private static var _sceneManager:SceneManager;
		private static var _soundManager:SoundManager;
		
		public function App()
		{
		}
		
		public static function init(stage:starling.display.Stage):void {
			_stage = stage;
			_loadManager = new LoadManager();
			_resourceManager = new ResourceManager();
			_sceneManager = new SceneManager();		
			_soundManager = new SoundManager();
		}
		
		public static function run():void {
			_sceneManager.enterScene(SceneManager.SCENE_MENU);
		}
		
		public static function get stage():Stage {
			return _stage;
		}
		
		public static function set stage(stage:Stage):void {
			_stage = stage;
		}
		
		public static function get resourceManager():ResourceManager {
			return _resourceManager;
		}
		
		public static function get sceneManager():SceneManager {
			return _sceneManager;
		}
		
		public static function get loadManager():LoadManager {
			return _loadManager;
		}
		
		public static function get soundManager():SoundManager {
			return _soundManager;
		}
	}
}