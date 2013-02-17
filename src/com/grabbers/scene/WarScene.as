package com.grabbers.scene
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.log.Logger;
	import com.grabbers.manager.LevelManager;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIWarzone;
	import com.grabbers.warzone.Warzone;
	
	import starling.display.DisplayObject;
	
	public class WarScene extends UIScene
	{
		protected var _warzone:UIWarzone;
		protected var _bInitUI:Boolean = false;
		protected var _bWarzoneResourcePrepared:Boolean = false;
		protected var _btnPlay:UIActiveElement;
		
		public function WarScene() {
			super();
		}
		
		override protected function get scriptFile():String {
			return "scripts/interfaces/warinterface.txt";
		}
		
		override public function enter():Boolean {
			if (!_bResourceLoad) {
				App.loadManager.addTasks(resources);
				_bResourceLoad = true;
				App.loadManager.start(enter);
				return false;
			}
			
			if (!_bWarzoneResourcePrepared) {
				_bWarzoneResourcePrepared = true;
				
				if (_warzone == null || _warzone.name != App.levelManager.curLevel) {
					var resName:String = App.levelManager.curLevelAsset;
					if (resName == null)
						return false;
					
					App.loadManager.addTask(resName);
					App.loadManager.start(enter);
					return false;
				}
			}
			
			if (!init()) {
				Logger.error("init failed. can not enter");
				return false;
			}
			
			App.stage.addChildAt(this, 0);
			return true;
		}
		
		override public function init():Boolean {
			if (!_bInitUI) {
				if (!super.init())
					return false;
				_warzone = _objMap["warzone"] as UIWarzone;
				_bInitUI = true;
			}
			
			if (_warzone == null)
				return false;			
			
			if (_warzone.updateWarzone(App.levelManager.curLevel, App.levelManager.curLevelAsset)) 
				addChildAt(_warzone, 0);			
			
			_btnPlay = _objMap["hud_play"] as UIActiveElement;
			if (_btnPlay != null)
				_btnPlay.handlerTrigger = function():void {App.sceneManager.enterScene(SceneManager.SCENE_MAP);};
			return true;
		}
		
		override public function exit():Boolean {
			_bWarzoneResourcePrepared = false;
			return super.exit();
		}

		override public function get resources():Array {
			return [
				Resources.WAR_PACK,
				Resources.ANIMATION_PACK
			];
		}
	}
}