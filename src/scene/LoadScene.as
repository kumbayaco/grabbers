package scene
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;
	
	import globals.App;
	import globals.Resources;
	import globals.Setting;
	
	import log.Logger;
	
	import ui.component.Progress;

	public class LoadScene extends Sprite implements IScene
	{
		private var _bInit:Boolean = false;
		private var _loaderInit:BulkLoader = new BulkLoader("init");
		private var _textInit:TextField = new TextField();
		private var _progLoad:Progress;
		
		public function LoadScene() {
		}
		
		public function enter():void {
			if (_bInit)
				return;
			
			_loaderInit.add(Setting.RESOURCE_URL + Resources.LOADING_ASSETS, {context:new LoaderContext(false, ApplicationDomain.currentDomain)});
			_loaderInit.addEventListener(BulkLoader.PROGRESS, preProgressListener);
			_loaderInit.addEventListener(BulkLoader.COMPLETE, loadResources);
			
			_textInit = new TextField();
			_textInit.type = TextFieldType.DYNAMIC;
			_textInit.width = 100;
			_textInit.height = 20;
			_textInit.x = (App.stage.stageWidth - _textInit.width) / 2;
			_textInit.y = App.stage.stageHeight - _textInit.height - 20;
			addChild(_textInit);
			
			_loaderInit.start();
		}
		
		private function preProgressListener(e:BulkProgressEvent):void {
			_textInit.htmlText = "<font color='#FF0000'>" + (e.bytesLoaded * 100 / e.bytesTotal >> 0) + "%</font>";
		}
		
		private function loadResources(e:BulkProgressEvent):void {
			_loaderInit.removeEventListener(BulkLoader.PROGRESS, preProgressListener);
			_loaderInit.removeEventListener(BulkLoader.COMPLETE, loadResources);
			removeChild(_textInit);
			
			addChild(new Bitmap(getBitmapData("loadscreen")));			
			
			_progLoad = new Progress(getBitmapData("loadbar"), getBitmapData("backbar"));
			_progLoad.x = (App.stage.stageWidth - _progLoad.width) / 2 >> 0;
			_progLoad.y = App.stage.stageHeight - 50;
			addChild(_progLoad);
			
			_loaderInit.add(Setting.RESOURCE_URL + Resources.MAIN);
			_loaderInit.addEventListener(BulkLoader.PROGRESS, progressListener);
			_loaderInit.addEventListener(BulkLoader.COMPLETE, loadMain);
			_loaderInit.start();
		}
		
		private function progressListener(e:BulkProgressEvent):void {
			_progLoad.proc = e.bytesLoaded * 100 / e.bytesTotal >> 0;
		}
		
		private function loadMain(e:BulkProgressEvent):void {
			_bInit = true;
		}
		
		private function getBitmapData(key:String):BitmapData {
			var claz:Class = getDefinitionByName(key) as Class;
			if (claz == null) {
				Logger.error("loadbar definition not found");
				return null;
			}
			return new claz() as BitmapData;
		}
		
		public function exit():void {
			
		}
	}
}