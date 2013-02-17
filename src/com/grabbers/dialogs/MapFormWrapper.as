package com.grabbers.dialogs
{
	import com.grabbers.core.bean.LevelInfo;
	import com.grabbers.globals.App;
	import com.grabbers.scene.MapScene;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIForm;
	import com.grabbers.ui.model.UIMapLevelButton;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class MapFormWrapper
	{
		protected const DEFAULT_LEVEL:uint = 0;
		
		protected var _form:UIForm;
		protected var _btnClose:UIActiveElement;
		protected var _curSelect:UIMapLevelButton;
		protected var _buttons:Dictionary = new Dictionary();
		protected var _scene:UIScene;
		public function MapFormWrapper(form:UIForm) {
			_form = form;
			if (form == null)
				return;
			
			_btnClose = form.getChildByName("close") as UIActiveElement;
			if (_btnClose != null) {
				_btnClose.handlerTrigger = function(obj:UIActiveElement):void {(form.parent as UIScene).execCommand(form.name, "close", {});};
			}
			
			for (var i:uint = 0; i < form.numChildren; i++) {
				var btn:UIMapLevelButton = form.getChildAt(i) as UIMapLevelButton;
				if (btn == null)
					continue;
				
				_buttons[btn.name] = btn;
				btn.setLevelInfo(new LevelInfo());
				btn.handlerTrigger = onLevelSelect;
			}
		}
		
		public function get form():UIForm {
			return _form;
		}
		
		public function show(objParent:UIScene):void {
			if (_form == null)
				return;
			
			_scene = objParent;
			if (_curSelect == null) {
				var index:uint = 0;
				for each (var btn:UIMapLevelButton in _buttons) {
					if (index == DEFAULT_LEVEL) {
						onLevelSelect(btn);
						break;
					}
					index++;
				}
			}
			_form.show(objParent, null);
		}
		
		public function hide():void {
			if (_form == null)
				return;
			
			_form.hide();
		}
		
		protected function onLevelSelect(btn:UIMapLevelButton):void {
			if (_curSelect == btn)
				return;
			
			if (_curSelect != null)
				_curSelect.select = false;
			btn.select = true;
			_curSelect = btn;
			
			if (_scene != null) {
				_scene.execCommand(_form.name, "select", {level:btn.name});
			}
		}
		
		/**
		 * TODO: 根据数据更新minimap 
		 * 
		 */		
		public function updateMapInfo():void {
			
		}
	}
}