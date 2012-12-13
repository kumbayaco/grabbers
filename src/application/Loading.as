package application
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import globals.Global;
	import globals.Resources;
	import globals.Setting;
	
	import org.osmf.layout.ScaleMode;
	
	import ui.component.Progress;
	
	import util.ColorUtil;
	
	[SWF(width="1024", height="768", backgroundColor="#D1C4AC", frameRate="60")]
	
	public class Loading extends Sprite
	{
		private var _progLoad:Progress;
		private var _text:TextField;
		public function Loading()
		{
			super();
			
			//stage.scaleMode = ScaleMode.NONE;
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			// 仅显示进度条
			graphics.beginFill(ColorUtil.COLOR_MAIN);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			_text = new TextField();
			_text.type = TextFieldType.DYNAMIC;
			_text.width = 100;
			_text.height = 20;
			_text.x = (stage.stageWidth - _text.width) / 2;
			_text.y = stage.stageHeight - _text.height - 20;
			addChild(_text);
			
			/*_progLoad = new Progress();
			_progLoad.x = (stage.stageWidth - _progLoad.progWidth) / 2;
			_progLoad.y = stage.stageHeight - _progLoad.progHeight - 20;
			addChild(_progLoad);*/
			
			loadAssets();
		}
		
		private function loadAssets():void {
			
			Global.loader.add(Setting.RESOURCE_URL + Resources.LOADING_ASSETS);
			Global.loader.add(Setting.RESOURCE_URL + Resources.MAIN);
			Global.loader.addEventListener(BulkLoader.PROGRESS, progressListener);
			Global.loader.start();
		}
		
		private function progressListener(e:BulkProgressEvent):void {
			_text.htmlText = "<font color='#FFF000'>" + (e.bytesLoaded * 100 / e.bytesTotal >> 0) + "%</font>";
		}
	}
}