package com.grabbers.scene
{
	import com.grabbers.dialogs.DialogExitGame;
	import com.grabbers.dialogs.DialogOption;
	import com.grabbers.dialogs.DialogVolumn;
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIBitmap;
	
	import flash.system.fscommand;
	
	import starling.display.DisplayObject;
	
	public class MenuScene extends UIScene
	{
		protected var _dlgExit:DialogExitGame;
		protected var _dlgOpt:DialogOption;
		protected var _dlgVol:DialogVolumn;
		
		public function MenuScene() {
			super();
		}
		
		override public function init():Boolean {
			if (!super.init())
				return false;
			
			regActObjHandler("sign_exit", onExit);
			regActObjHandler("sign_options", onOpt);
			regActObjHandler("sign_start", onStart);
			
			_dlgExit = bindObj("exit_game_dialog", DialogExitGame) as DialogExitGame;
			_dlgOpt = bindObj("options_toolbar", DialogOption) as DialogOption;
			_dlgVol = bindObj("volume_dialog", DialogVolumn) as DialogVolumn;
			return true;
		}
		
		override public function enter():Boolean {
			if (!super.enter())
				return false;
			
			App.soundManager.playTheme("menu_theme");
			return true;
		}
		
		override protected function get scriptFile():String {
			return "scripts/interfaces/menuinterface.txt";
		}
		
		override public function get resources():Array {
			return [
				Resources.CREDITS_PACK,
				Resources.GUI_PACK,
				Resources.MAP_PACK,
				Resources.MENU_PACK,
				Resources.TROPHY_PACK,
				Resources.ANIMATION_PACK,
				Resources.SFX_FILES,
				Resources.VO_FILES,
				Resources.THEME_FILES
			];
		}
		
		protected function onExit(obj:UIActiveElement):void {
			super.popupDialog("exit_game_dialog");
		}
		
		protected function onOpt(obj:UIActiveElement):void {
			super.popupDialog("options_toolbar");
		}
		
		protected function onStart(obj:UIActiveElement):void {
			App.sceneManager.enterScene(SceneManager.SCENE_MAP);
		}
		
		override public function execCommand(childName:String, command:String):void {
			switch (childName) {
				case "exit_game_dialog": {
					switch (command) {
						case "yes":
							fscommand("quit");
							break;
						
						case "no":
							_dlgExit.form.hide();
							break;
					}
					break;
				}
				
				case "options_toolbar" : {
					switch (command) {
						case "set_volume_caption":
							_dlgOpt.form.hide();//function():void {popupDialog("volume_dialog");});
							popupDialog("volume_dialog");
							break;
						
					}
					break;
				}
					
				case "volume_dialog" : {
					switch (command) {
						case "ok":
							_dlgVol.form.hide();//function():void {popupDialog("options_toolbar");});
							popupDialog("options_toolbar");
							break;
					}
					break;
				}
			}
		}
	}
}