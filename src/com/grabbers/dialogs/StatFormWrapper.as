package com.grabbers.dialogs
{
	import com.grabbers.core.bean.LevelInfo;
	import com.grabbers.globals.App;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UIForm;
	import com.grabbers.ui.model.UIText;

	public class StatFormWrapper
	{
		protected var _form:UIForm;
		protected var _title:UIText;
		public function StatFormWrapper(form:UIForm) {
			_form = form;
			if (form == null)
				return;
			
			_title = form.getChildObject("level_name") as UIText;
			
			for (var i:uint = 0; i < form.numChildren; i++) {
				var btn:UICheckButton = form.getChildAt(i) as UICheckButton;
				if (btn != null)
					btn.handlerTrigger = startWar;
			}
		}
		
		public function set title(str:String):void {
			if (str != null)
				_title.update(str, _title.fontSize);
		}
		
		public function update(levelInfo:LevelInfo):void {
			
		}
		
		public function get form():UIForm {
			return _form;
		}
		
		protected function startWar(btn:UICheckButton):void {
			App.sceneManager.enterScene(SceneManager.SCENE_WAR);
		}
	}
}