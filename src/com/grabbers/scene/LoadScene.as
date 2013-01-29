package com.grabbers.scene
{	
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.Setting;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.UIScene;
	import com.grabbers.ui.UIUtil;
	import com.grabbers.ui.component.Progress;
	import com.grabbers.ui.model.UIBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class LoadScene extends UIScene
	{		
		private var _progLoad:Progress;
		
		public function LoadScene() {
			
		}
		
		override public function init():Boolean {
			if (!super.init())
				return false;
			
			if (_objMap["loadbar"] != null) {
				var bmp:UIBitmap = _objMap["loadbar"] as UIBitmap;
				if (bmp != null) {
					_progLoad = new Progress(bmp);
					_progLoad.proc = 0;
					addChild(_progLoad);
				}
			}
			
			App.stage.addChildAt(this, 0);
			return true;
		}
		
		override public function enter():Boolean {
			if (!isInit) {
				if (!init()) {
					Logger.error("init failed. can not enter");
					return false;
				}
			}
			
			loadProcess = 0;
			
			return true;
		}
		
		override public function get resources():Array {
			return [
				Resources.LOADER_PACK, 
				Resources.FONTS_PACK,
				Resources.CONFIG_FILES
			];
		}
		
		override protected function get scriptFile():String {
			return "scripts/interfaces/loaderinterface.txt";
		}
		
		public function set background(bg:Texture):void {
			if (bg != null)
				UIUtil.replaceChild(_objMap["loadscreen"], new Image(bg));
			else
				addChildAt(_objMap["loadscreen"], 0);
		}
		
		public function set loadProcess(proc:uint):void {
			if (_progLoad != null)
				_progLoad.proc = proc;
		}
	}
}