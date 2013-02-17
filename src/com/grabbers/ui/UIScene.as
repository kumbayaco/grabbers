package com.grabbers.ui
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	import com.grabbers.scene.MapScene;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIBitmap;
	import com.grabbers.ui.model.UIForm;
	import com.grabbers.ui.model.UIHint;
	import com.grabbers.ui.model.UIObject;
	import com.grabbers.ui.model.UIText;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	public class UIScene extends DisplayObjectContainer
	{
		protected var _bInit:Boolean = false;
		protected var _bResourceLoad:Boolean = false;
		protected var _objMap:Dictionary = new Dictionary();
		protected var _bg:Image = null;
		protected var _layerMask:Quad = new Quad(1, 1, 0);
		
		public function UIScene() {
			super();
			
			_layerMask.alpha = 0;
			_layerMask.touchable = true;
		}
		
		public function init():Boolean {
			trace(this);
			
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
			var scrW:uint = App.sceneWidth;
			var scrH:uint = App.sceneHeight;
			
			var list:XMLList = xml.children();
			var dictIgnored:Dictionary = new Dictionary();
			for (var i:uint = 0; i < list.length(); i++) {
				var modelName:String = list[i].name();
				var obj:UIObject = UIObjectFactory.createObject(modelName, scrW, scrH, texPack);				
				if (obj == null)
					continue;
				
				if (!obj.init(list[i], scrW, scrH, texPack))
					continue;
				
				if (list[i].attributes().length() == 0 && list[i].children().length() == 0)  // reference
					obj.visible = false;
				
				_objMap[obj.name] = obj;
				if (obj.visible) {
					addChild(obj);
					if (_bg == null && obj.width == App.sceneWidth && obj.height == App.sceneHeight)
						_bg = obj as Image;
				} else {
					obj.visible = true;
				}
				
				if (obj is UIHint) {
					(obj as UIHint).activate(this);
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
		
		public function getUIObject(name:String):UIObject {
			if (_objMap[name] != null) {
				return _objMap[name] as UIObject;
			}
			return null;
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
		
		protected function regActObjHandler(name:String, handler:Function):Boolean {
			var uiActObj:UIActiveElement;
			if (_objMap[name] != null) {
				uiActObj = _objMap[name] as UIActiveElement;
				if (uiActObj != null) {
					uiActObj.handlerTrigger = handler;
					return true;
				}
			}
			
			Logger.error("regActObj [" + name + "] failed. ");
			
			return false;
		}
		
		protected function bindObj(name:String, claz:Class):Object {
			if (_objMap[name] != null) {
				return new claz(_objMap[name]);
			} else {
				Logger.error("unrecognized member " + name);
				return null;
			}
		}
		
		public function popupDialog(name:String):Boolean {
			var uiForm:UIForm;
			if (_objMap[name] != null) {
				uiForm = _objMap[name] as UIForm;
				if (uiForm != null) {
					_layerMask.width = background!=null ? background.width : App.sceneWidth;
					_layerMask.height = background!=null ? background.height : App.sceneHeight;
					
					addChild(_layerMask);
					uiForm.show(this, function():void { removeChild(_layerMask); });
					
					return true;
				}
			}
			
			return false;
		}
		
		public function execCommand(childName:String, command:String, params:Object):void {
			
		}
	}
}