package com.grabbers.dialogs
{
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIForm;

	public class DialogWrapper
	{
		protected var _form:UIForm;
		protected var _scene:UIScene;
		protected var _command:String = "undefined";
		public function DialogWrapper(form:UIForm)
		{
			_form = form;
		}
		
		public function get form():UIForm {
			return _form;
		}
	}
}