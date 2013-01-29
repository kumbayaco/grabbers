package com.grabbers.scene
{
	import com.grabbers.dialogs.DialogSetting;
	import com.grabbers.dialogs.MsgBox;
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.manager.ResourceManager;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.UIUtil;
	import com.grabbers.ui.component.AnimateImage;
	import com.grabbers.ui.component.ButtonHover;
	import com.grabbers.ui.component.DialogModal;
	import com.grabbers.ui.component.FormElement;
	import com.grabbers.ui.component.Hint;
	import com.grabbers.ui.component.Label;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.fscommand;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class MainScene2 extends Sprite implements IScene
	{
		private var _bInitResource:Boolean = false;
		private var _bInitUI:Boolean = false;
		private var _bg:Image;
		private var _sky:Image;
		private var _tick:uint = 0;
		private var _btnStart:Button;
		private var _btnOption:Button;
		private var _btnExit:Button;
		private var _objDict:Dictionary = new Dictionary();
		private var _btnDict:Dictionary = new Dictionary();
		private var _dlgSet:DialogSetting;
		private var _dlgExit:MsgBox;
		
		public function MainScene2() {
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event = null):void {
			if (!_bInitResource) {
				initResource();
			} else {
				UIUtil.initComponents();
				
				if (!_bInitUI)
					initUI();
				
				App.soundManager.playTheme("main_theme");				
			}
		}
		
		public function enter():void {
			App.stage.addChildAt(this, 0);			
		}
		
		public function exit():void {
			App.stage.removeChild(this);
		}
		
		private function initResource():void {
			if (!_bInitResource) {
				_bInitResource = true;
//				App.loadManager.addTask(Resources.CREDITS_PACK, "swf");
//				App.loadManager.addTask(Resources.GUI_PACK, "swf");
//				App.loadManager.addTask(Resources.MAP_PACK, "swf");
//				App.loadManager.addTask(Resources.MENU_PACK, "swf");
//				App.loadManager.addTask(Resources.TROPHY_PACK, "swf");
//				App.loadManager.addTask(Resources.ANIMATION_PACK, "swf");
//				App.loadManager.addTask(Resources.SFX_FILES, "zip");
//				App.loadManager.addTask(Resources.VO_FILES, "zip");
//				App.loadManager.addTask(Resources.THEME_FILES, "zip");
				App.loadManager.start(onAdd);
			}
		}
		
		private function initUI():void {	
			var xmlContent:String = App.resourceManager.getConfigXml("scripts/interfaces/menuinterface.txt");
			var xml:XML = new XML(xmlContent);				
			var texPack:String = xml.@texture_pack + ".swf";
			
			var xmlList:XMLList = xml.children();
			for (var i:uint = 0; i < xmlList.length(); i++) {
				var obj:DisplayObject = null;
				switch (xmlList[i].name().localName) {
					case "bitmap":
						obj = AnimateImage.parse(texPack, xmlList[i]);
						break;
				
					case "activeelement":
						obj = ButtonHover.parse(texPack, xmlList[i]);
						break;
					
					case "virtual_form":
						obj = FormElement.parse(texPack, xmlList[i]);
						break;
					
					case "text":
						obj = Label.parse(xmlList[i]);
						break;
					
					case "basic_hint":
						obj = Hint.parse(xmlList[i], this);
						Hint.register(obj as Hint);
						break;
				}
				
				if (obj != null && !(obj is Hint)) {
					addChild(obj);
					_objDict[obj.name] = obj;
					
					if (obj is ButtonHover) {
						_btnDict[obj.name] = obj;
						obj.addEventListener(Event.TRIGGERED, btnHandler);
					}
				}
			}
			
			_bInitUI = true;
		}
		
		private function btnHandler(e:Event):void {
			var btn:ButtonHover = e.target as ButtonHover;
			switch (btn.name) {
				case "sign_options": {
					if (_dlgSet == null) {
						_dlgSet = new DialogSetting();
					}
					_dlgSet.doModal(this, null);
					break;
				}
				
				case "sign_exit":
					if (_dlgExit == null) {
						_dlgExit = new MsgBox("exit_game_caption", MsgBox.MSG_YESNO);
					}
					_dlgExit.doModal(this, function(ret:uint):void{if (ret==DialogModal.YES) fscommand("quit");});
					break;
				
				case "sign_start":
					App.sceneManager.enterScene(SceneManager.SCENE_MAP);
					break;
			}
		}
		
	}
}