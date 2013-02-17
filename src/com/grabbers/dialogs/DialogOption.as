package com.grabbers.dialogs
{
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UIForm;
	
	import starling.events.Event;
	
	public class DialogOption extends DialogWrapper
	{
		protected var _btnBack:UICheckButton;
		protected var _btnVolu:UICheckButton;
		public function DialogOption(form:UIForm) {
			super(form);
			
			if (form == null)
				return;
			
			
			_btnBack = form.getChildByName("back_caption") as UICheckButton;
			if (_btnBack != null) {
				_btnBack.handlerTrigger = function(obj:UICheckButton):void {
					form.hide();
					(form.parent as UIScene).execCommand(form.name, "back_caption", {});
				};
			}
			
			_btnVolu = form.getChildByName("set_volume_caption") as UICheckButton;
			if (_btnVolu != null) {
				_btnVolu.handlerTrigger = function(obj:UICheckButton):void {
					(form.parent as UIScene).execCommand(form.name, "set_volume_caption", {});
				};
			}
		}
	}
}