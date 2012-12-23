package globals
{
	import flash.display.Stage;
	
	import manager.LoadManager;
	import manager.ResourceManager;
	import manager.SceneManager;

	public class App
	{
		private static var _stage:Stage;
		private static var _loadManager:LoadManager;
		private static var _resourceManager:ResourceManager;
		private static var _sceneManager:SceneManager;
		
		public function App()
		{
		}
		
		public static function init(stage:Stage):void {
			_stage = stage;
			_loadManager = new LoadManager();
			_resourceManager = new ResourceManager();
			_sceneManager = new SceneManager();			
		}
		
		public static function run():void {
			_sceneManager.enterScene(SceneManager.SCENE_MAIN);
		}
		
		public static function get stage():Stage {
			return _stage;
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
	}
}