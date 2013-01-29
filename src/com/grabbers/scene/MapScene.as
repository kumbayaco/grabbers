package com.grabbers.scene
{
	import com.grabbers.dialogs.MapFormWrapper;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
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
		protected var _curMiniMap:UIForm;
		
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
			
			_layerMask.width = width;
			_layerMask.height = height;
			_layerMask.touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			return true;
		}
		
		protected function showMinimap(btn:UIActiveElement):void {
			var name:String = btn.name.substring(0, btn.name.indexOf("_region"));
			var form:UIForm = _objMap[name + "_minimap"] as UIForm;
			addChild(_layerMask);
			form.show(this, null);
			_curMiniMap = form;
		}
		
		protected function onTouch(e:TouchEvent):void {
			if (e.getTouch(_layerMask, TouchPhase.ENDED)) {
				hideCurMiniMap();
			}
		}
		
		override public function execCommand(childName:String, command:String):void {
			var obj:DisplayObject = getChildByName(childName);
			if (obj is UIForm) {
				switch (command) {
					case "close":
						hideCurMiniMap();
						break;
				}
			}			
		}
		
		protected function hideCurMiniMap():void {
			if (_curMiniMap != null) {
				_curMiniMap.hide();
				_curMiniMap = null;
			}
			removeChild(_layerMask);
		}
	}
}
