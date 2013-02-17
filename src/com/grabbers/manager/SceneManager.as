package com.grabbers.manager
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	import com.grabbers.scene.LoadScene;
	import com.grabbers.scene.MapScene;
	import com.grabbers.scene.MenuScene;
	import com.grabbers.scene.WarScene;
	import com.grabbers.ui.UIScene;
	
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class SceneManager
	{
		public static const SCENE_LOAD:uint = 0;
		public static const SCENE_MENU:uint = 1;
		public static const SCENE_MAP:uint = 2;
		public static const SCENE_WAR:uint = 3;
		public static const SCENE_ACHIEVE:uint = 4;
		
		private var _scenes:Dictionary = new Dictionary();
		private var _prevScene:UIScene = null;
		
		public function SceneManager() {	
			_scenes[SCENE_LOAD] = new LoadScene();			
			_scenes[SCENE_MENU] = new MenuScene();
			_scenes[SCENE_MAP] = new MapScene();
			_scenes[SCENE_WAR] = new WarScene();
		}	
		
		public function get loadScene():LoadScene {
			return _scenes[SCENE_LOAD] as LoadScene;
		}
		
		public function enterScene(sceneId:uint):void {
			if (_scenes[sceneId] == null) {
				Logger.error("scene " + sceneId + " not exists");
				return;
			}
			
			if (_prevScene != null) {				
				_prevScene.exit();
				if (sceneId != SCENE_MENU) {
					_scenes[sceneId].alpha = 0;
					_scenes[sceneId].enter();
					Starling.current.juggler.tween(_scenes[sceneId], 1, {alpha: 1});
				} else {
					_scenes[sceneId].enter();
				}
			} else {
				_scenes[sceneId].enter();
			}
			
			_prevScene = _scenes[sceneId];
		}
	}
}