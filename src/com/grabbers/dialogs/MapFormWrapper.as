package com.grabbers.dialogs
{
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIForm;

	public class MapFormWrapper
	{
		protected var _form:UIForm;
		protected var _btnClose:UIActiveElement;
		public function MapFormWrapper(form:UIForm) {
			_form = form;
			
			_btnClose = form.getChildByName("close") as UIActiveElement;
			if (_btnClose != null) {
				_btnClose.handlerTrigger = function(obj:UIActiveElement):void {(form.parent as UIScene).execCommand(form.name, "close");};
			}
		}
	}
}