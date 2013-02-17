package com.grabbers.dialogs
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UIForm;
	
	import starling.events.Event;
	
	public class DialogVolumn extends DialogWrapper
	{
		private var _btnOK:UICheckButton;
		
		public function DialogVolumn(form:UIForm)
		{
			super(form);
			_btnOK = form.getChildByName("ok") as UICheckButton;
			if (_btnOK != null) {
				_btnOK.handlerTrigger = function():void {
					(form.parent as UIScene).execCommand(form.name, "ok", {});
				}
			}
		}
		
	}
}