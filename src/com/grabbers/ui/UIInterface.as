package com.grabbers.ui
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.component.AnimateImage;
	import com.grabbers.ui.component.UIActiveElement;
	import com.grabbers.ui.component.UIBitmap;
	import com.grabbers.ui.component.UILabel;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class UIInterface extends DisplayObjectContainer
	{
		protected var _bInit:Boolean = false;
		protected var _bResourceLoad:Boolean = false;
		protected var _objMap:Dictionary = new Dictionary();
		protected var _bg:Image = null;
		
		public function UIInterface() {
			super();
		}
		
		public function init():Boolean {
			_bInit = true;
			
			var xmlContent:String = App.resourceManager.getConfigXml(scriptFile);	
			var xml:XML;
			try {
				xml = new XML(xmlContent);
			} catch (err:Error) {
				Logger.error("interface is not a valid xml file. [" + err.message + "]");
				return false;
			}
			
			var texPack:String = xml.@texture_pack + ".swf";
			var scrW:uint = App.stage.stageWidth;
			var scrH:uint = App.stage.stageHeight;
			
			var list:XMLList = xml.children();
			var dictIgnored:Dictionary = new Dictionary();
			for (var i:uint = 0; i < list.length(); i++) {
				var obj:DisplayObject;
				var strType:String = list[i].name();
				switch (strType) {
					case "bitmap":
						obj = UIBitmap.parse(texPack, list[i], scrW, scrH);
						break;	
					
					case "activeelement":
						obj = UIActiveElement.parse(texPack, list[i], scrW, scrH);
						break;
					
					case "text":
						obj = UILabel.parse(list[i], scrW, scrH);
						break;
					
					case "basic_hint":
						break;
					
					default:
						dictIgnored[strType] = list[i].toXMLString();
						break;
				}
				
				if (obj == null)
					continue;
				
				_objMap[obj.name] = obj;
				if (obj.visible) {
					addChild(obj);
					if (_bg != null && obj.width == App.stage.stageWidth && obj.height == App.stage.stageHeight)
						_bg = obj as Image;
				} else {
					//obj.visible = true;
				}
			}
			
			for (var tag:String in dictIgnored) {
				trace("ignored tag: " + tag + ": " + dictIgnored[tag]);
			}
			
			return true;
		}
		
		public function get isInit():Boolean {
			return _bInit;
		}
		
		public function enter():Boolean {
			if (!_bResourceLoad) {
				App.loadManager.addTasks(resources);
				_bResourceLoad = true;
				App.loadManager.start(enter);
				return false;
			}
			
			if (!isInit) {
				if (!init()) {
					Logger.error("init failed. can not enter");
					return false;
				}
			}
			
			App.stage.addChildAt(this, 0);
			return true;
		}
		
		public function exit():Boolean {
			App.stage.removeChild(this);
			return true;
		}
		
		public function get background():Texture {
			if (_bg != null)
				return _bg.texture;
			return null;
		}
		
		public function get resources():Array {
			return null;
		}
		
		protected function get scriptFile():String {
			return "unknown file";
		}
	}
}