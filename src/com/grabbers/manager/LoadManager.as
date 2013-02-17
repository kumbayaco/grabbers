package com.grabbers.manager
{	
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.globals.Setting;
	import com.grabbers.log.Logger;
	import com.grabbers.scene.LoadScene;
	import com.grabbers.ui.component.Progress;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class LoadManager
	{
		private var _textInit:TextField = new TextField();
		private var _tasks:Vector.<String> = new Vector.<String>();
		private var _loader:LoaderMax = new LoaderMax(null);
		private var _handler:Function = null;
		
		public function LoadManager() {
		}
		
		// 加载swf
		public function addTask(url:String):void {
			_tasks.push(url);
		}
		
		public function addTasks(vTasks:Array):void {
			if (vTasks != null) {
				for (var i:uint = 0; i < vTasks.length; i++) {
					_tasks.push(vTasks[i] as String);
				}
			}
		}
		
		public function start(handler:Function, bgImg:Image = null):void {
			if (_loader.status == LoaderStatus.LOADING) {
				Logger.error("one task one time");
				return;
			}
			_handler = handler;
			
			if (!App.sceneManager.loadScene.isInit) {
				preLoad();
			} else {
				loadResources(bgImg);
			}
		}
		
		private function addPreloadTask(vTasks:Array):void {
			for (var i:uint = 0; i < vTasks.length; i++) {
				var fileName:String = vTasks[i] as String;
				var url:String = Setting.RESOURCE_URL + fileName; 
				var format:String = fileName.substring(fileName.lastIndexOf(".") + 1);
				
				if (format == "swf") {
					var domain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					App.resourceManager.regSwf(fileName, domain);
					_loader.append(new SWFLoader(url, {name:fileName, context:new LoaderContext(false, domain)}));
				}
				if (format == "zip") {
					_loader.append(new DataLoader(url, {name:fileName, format:"binary"}));
				}
			}
		}
		
		private function preLoad():void {
			addPreloadTask(App.sceneManager.loadScene.resources);			
			_loader.addEventListener(LoaderEvent.PROGRESS, preProgressListener);
			_loader.addEventListener(LoaderEvent.COMPLETE, preCompleteListener);	
			_loader.load();
		}
		
		private function preProgressListener(e:LoaderEvent):void {
		}
		
		private function preCompleteListener(e:LoaderEvent):void {
			_loader.removeEventListener(LoaderEvent.PROGRESS, preProgressListener);
			_loader.removeEventListener(LoaderEvent.COMPLETE, preCompleteListener);
			
			App.resourceManager.init(_loader.getLoader(Resources.CONFIG_FILES).content as ByteArray);
			
			if (!App.sceneManager.loadScene.init()) {
				Logger.error("loaderinterface init failed");
				return;
			}

			loadResources();
		}
		
		
		private function loadResources(bg:Image = null):void {			
			App.sceneManager.loadScene.enter();
			
			for (var i:int = 0; i < _tasks.length; i++) {
				var url:String = Setting.RESOURCE_URL + _tasks[i];
				if (_loader.getLoader(_tasks[i]) != null)
					continue;
				
				var format:String = _tasks[i].substring(_tasks[i].lastIndexOf(".") + 1);
				
				if (format == "swf") {
					var domain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					App.resourceManager.regSwf(_tasks[i], domain);
					_loader.append(new SWFLoader(url, {name:_tasks[i], context:new LoaderContext(false, domain)}));
				}
				if (format == "zip") {
					_loader.append(new DataLoader(url, {name:_tasks[i], format:"binary"}));
				}
			}
			
			_loader.addEventListener(LoaderEvent.PROGRESS, progressListener);
			_loader.addEventListener(LoaderEvent.COMPLETE, completeListener);
			_loader.load();
		}
		
		private function progressListener(e:LoaderEvent):void {
			App.sceneManager.loadScene.loadProcess = e.target.bytesLoaded * 100 / e.target.bytesTotal >> 0;
		}
		
		private function completeListener(e:LoaderEvent):void {
			App.sceneManager.loadScene.exit();
			
			for (var i:uint = 0; i < _tasks.length; i++) {
				var format:String = _tasks[i].substring(_tasks[i].lastIndexOf(".") + 1);
				if (format == "zip") {
					App.resourceManager.regZip(_tasks[i], _loader.getLoader(_tasks[i]).content as ByteArray);
				}
			}
			_tasks.splice(0, _tasks.length);
			if (_handler != null)
				_handler();
		}
	}
}