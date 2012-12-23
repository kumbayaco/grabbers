package manager
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.utils.CharacterUtil;
	
	import globals.App;
	import globals.Resources;
	import globals.Setting;
	
	import log.Logger;
	
	import ui.component.Progress;

	public class LoadManager extends Sprite
	{
		private var _bLoadBarInit:Boolean = false;
		private var _textInit:TextField = new TextField();
		private var _bgDefault:Bitmap = new Bitmap();
		private var _tasks:Vector.<String> = new Vector.<String>();
		private var _progLoad:Progress;
		private var _loader:BulkLoader = new BulkLoader("Default");
		private var _handler:Function = null;
		
		public function LoadManager() {
		}
		
		// 加载swf
		public function addTask(url:String):void {
			_tasks.push(Setting.RESOURCE_URL + url);
		}
		
		public function start(handler:Function, bgImg:Bitmap = null):void {
			if (_loader.isRunning) {
				Logger.error("one task one time");
				return;
			}
			_handler = handler;
			
			App.stage.addChild(this);
			
			reset();
			if (!_bLoadBarInit) {
				preLoad();
			} else {
				loadResources(bgImg);
			}
		}
		
		private function preLoad():void {
			var appDomain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			App.resourceManager.regAsset(Resources.LOADING_ASSETS, appDomain);
			
			_loader.add(Setting.RESOURCE_URL + Resources.LOADING_ASSETS);
			_loader.add(Setting.RESOURCE_URL + Resources.LOADING_ASSETS, {context:new LoaderContext(false, appDomain)});
			_loader.addEventListener(BulkLoader.PROGRESS, preProgressListener);
			_loader.addEventListener(BulkLoader.COMPLETE, preCompleteListener);			
			
			_textInit = new TextField();
			_textInit.type = TextFieldType.DYNAMIC;
			_textInit.width = 100;
			_textInit.height = 20;
			_textInit.x = (App.stage.stageWidth - _textInit.width) / 2;
			_textInit.y = App.stage.stageHeight - _textInit.height - 20;
			addChild(_textInit);
		
			_loader.start();
		}
		
		private function preProgressListener(e:BulkProgressEvent):void {
			_textInit.htmlText = "<font color='#FF0000'>" + (e.bytesLoaded * 100 / e.bytesTotal >> 0) + "%</font>";
		}
		
		private function preCompleteListener(e:BulkProgressEvent):void {
			_loader.removeEventListener(BulkLoader.PROGRESS, preProgressListener);
			_loader.removeEventListener(BulkLoader.COMPLETE, preCompleteListener);
			
			_bgDefault.bitmapData = App.resourceManager.getBitmapData(Resources.LOADING_ASSETS, "loadscreen");
			_progLoad = new Progress(App.resourceManager.getBitmapData(Resources.LOADING_ASSETS, "loadbar"),
				App.resourceManager.getBitmapData(Resources.LOADING_ASSETS, "backbar"));
			
			_progLoad.x = (App.stage.stageWidth - _progLoad.width) / 2 >> 0;
			_progLoad.y = App.stage.stageHeight - 50;
			loadResources();
		}
		
		private function loadResources(bg:Bitmap = null):void {
			reset();
			
			if (bg == null) {
				addChild(_bgDefault);
			} else {
				addChild(bg);
			}
			
			addChild(_progLoad);
			
			for (var i:int = 0; i < _tasks.length; i++) {
				var domain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				App.resourceManager.regAsset(_tasks[i], domain);
				_loader.add(_tasks[i], {context:new LoaderContext(false, domain)});
			}
			
			_loader.addEventListener(BulkLoader.PROGRESS, progressListener);
			_loader.addEventListener(BulkLoader.COMPLETE, completeListener);
			_loader.start();
		}
		
		private function progressListener(e:BulkProgressEvent):void {
			_progLoad.proc = e.bytesLoaded * 100 / e.bytesTotal >> 0;
		}
		
		private function completeListener(e:BulkProgressEvent):void {
			App.stage.removeChild(this);
			if (_handler != null)
				_handler();
		}
		
		private function reset():void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
	}
}