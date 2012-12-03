package scene
{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import ui.component.Progress;
	
	public class SceneWelcome extends Sprite
	{
		private var _loader:Loader;
		
		private var _progLoad:Progress;
		public function SceneWelcome()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
				
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			initUI();
			_loader = new Loader();
			startLoadBg();
		}
		
		private function initUI():void {
			_progLoad = new Progress();
			_progLoad.x = (stage.stageWidth - _progLoad.progWidth) / 2;
			_progLoad.y = stage.stageHeight - _progLoad.progHeight - 20;
			
			addChild(_progLoad);
		}
		
		private function startLoadBg():void {
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeListener);
			_loader.load(new URLRequest("assets/main.png"));
			addChildAt(_loader, 0);
		}
		
		private function startLoadWorldMap():void {
			
		}
		
		private function progressListener(e:ProgressEvent):void {
			_progLoad.proc = (100 * e.bytesLoaded / e.bytesTotal) >> 0;
		}
		
		private function completeListener(e:Event):void {
			trace("load complete");
		}
	}
}