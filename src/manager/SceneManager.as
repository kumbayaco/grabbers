package manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.ContainerFormattedElement;
	
	import log.Logger;
	
	import scene.AchieveScene;
	import scene.BattleScene;
	import scene.IScene;
	import scene.LoadScene;
	import scene.MainScene;
	import scene.MapScene;

	public class SceneManager extends Sprite
	{
		public static const SCENE_MAIN:uint = 1;
		public static const SCENE_MAP:uint = 2;
		public static const SCENE_BATTLE:uint = 3;
		public static const SCENE_ACHIEVE:uint = 4;
		
		private var _scenes:Dictionary = new Dictionary();
		private var _prevScene:IScene = null;
		
		public function SceneManager() {			
			_scenes[SCENE_MAIN] = new MainScene();
			_scenes[SCENE_MAP] = new MapScene();
			_scenes[SCENE_BATTLE] = new BattleScene();
			_scenes[SCENE_ACHIEVE] = new AchieveScene();
		}	
		
		public function enterScene(sceneId:uint):void {
			if (_scenes[sceneId] == null) {
				Logger.error("scene " + sceneId + " not exists");
				return;
			}
			
			if (_prevScene != null) {
				if (contains(_prevScene as DisplayObject))
					removeChild(_prevScene as DisplayObject);
				_prevScene.exit();
			}
			
			addChild(_scenes[sceneId] as Sprite);			
			_scenes[sceneId].enter();
			
			_prevScene = _scenes[sceneId];
		}
	}
}