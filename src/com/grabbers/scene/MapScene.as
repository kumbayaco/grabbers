package com.grabbers.scene
{
	import com.grabbers.dialogs.MapFormWrapper;
	import com.grabbers.dialogs.StatFormWrapper;
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.log.Logger;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UIForm;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MapScene extends UIScene
	{
		protected var _regionDict:Dictionary = new Dictionary();
		protected var _miniMapDict:Dictionary = new Dictionary();
		protected var _curMiniMap:MapFormWrapper;
		protected var _statForm:StatFormWrapper;
		
		public function MapScene() {
			super();
			_layerMask.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		override protected function get scriptFile():String {
			return "scripts/interfaces/mapinterface.txt";
		}
		
		override public function init():Boolean {
			if (!super.init())
				return false;
			
			for each (var obj:DisplayObject in _objMap) {
				if (obj.name.indexOf("_region") != -1) {
					var uiActObj:UIActiveElement = (obj as DisplayObjectContainer).getChildByName(obj.name) as UIActiveElement;
					if (uiActObj != null)
						uiActObj.handlerTrigger = showMinimap;
					if (!contains(obj))
						addChild(obj);
				}
				if (obj.name.indexOf("_minimap") != -1 && obj is UIForm) {
					if (contains(obj))
						removeChild(obj);
					_miniMapDict[obj.name] = new MapFormWrapper(obj as UIForm);
				}
			}
			
			_statForm = new StatFormWrapper(_objMap["stats_form"]);
			
			_layerMask.width = width;
			_layerMask.height = height;
			_layerMask.touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			regBtnHandler("exit", onExit);
			
			return true;
		}
		
		protected function showMinimap(btn:UIActiveElement):void {
			var name:String = btn.name.substring(0, btn.name.indexOf("_region"));
			var miniForm:MapFormWrapper = _miniMapDict[name + "_minimap"] as MapFormWrapper;
			if (miniForm == null || _statForm.form == null)
				return;
			
			addChild(_layerMask);
			miniForm.show(this);
			_statForm.form.show(this, null);
			_curMiniMap = miniForm;
		}		
		
		protected function onTouch(e:TouchEvent):void {
			if (e.getTouch(_layerMask, TouchPhase.ENDED)) {
				hideCurMiniMap();
			}
		}
		
		override public function execCommand(childName:String, command:String, params:Object):void {
			switch (command) {
				case "close":
					hideCurMiniMap();
					break;
				
				case "select":
					App.levelManager.curLevel = params.level;
					_statForm.title = App.resourceManager.getTextString(params.level);
					break;
			}		
		}
		
		protected function hideCurMiniMap():void {
			if (_curMiniMap != null) {
				_curMiniMap.hide();
				_curMiniMap = null;
			}
			
			if (_statForm.form != null && contains(_statForm.form)) {
				_statForm.form.hide();
			}
			removeChild(_layerMask);
		}
		
		protected function regBtnHandler(name:String, handler:Function):Boolean {
			var uiActObj:UICheckButton;
			if (_objMap[name] != null) {
				uiActObj = _objMap[name] as UICheckButton;
				if (uiActObj != null) {
					uiActObj.handlerTrigger = handler;
					return true;
				}
			}
			
			Logger.error("regActObj [" + name + "] failed. ");
			
			return false;
		}
		
		protected function onExit(btn:UICheckButton):void {
			App.sceneManager.enterScene(SceneManager.SCENE_MENU);
		}
		
		override public function get resources():Array {
			return [
				Resources.MAP_PACK,
				Resources.MAPGUI_PACK
			];
		}
	}
}
