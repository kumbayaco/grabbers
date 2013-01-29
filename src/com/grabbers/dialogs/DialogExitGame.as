package com.grabbers.dialogs
{
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UIForm;
	
	import flash.system.fscommand;

	public class DialogExitGame extends DialogWrapper
	{
		protected var _btnYes:UICheckButton;
		protected var _btnNo:UICheckButton;
		public function DialogExitGame(form:UIForm) {
			super(form);
			if (form == null)
				return;
			
			_btnYes = form.getChildByName("yes") as UICheckButton;
			_btnNo = form.getChildByName("no") as UICheckButton;
			
			if (_btnYes != null) {
				_btnYes.handlerTrigger = function(obj:UICheckButton):void {(form.parent as UIScene).execCommand(form.name, "yes");};
			}
			
			if (_btnNo != null) {
				_btnNo.handlerTrigger = function(obj:UICheckButton):void {form.hide();};
			}
		}
	}
}