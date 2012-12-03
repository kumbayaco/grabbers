package
{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import scene.SceneWelcome;
	
	[SWF(width="1024", height="768", backgroundColor="#D1C4AC", frameRate="60")]
	
	public class LandGrabbers extends Sprite
	{
		public var mLoader:BulkLoader;
		
		private var _sceneWelcome:SceneWelcome = null;
		private var _sceneAchieve:SceneWelcome = null;
		private var _sceneWorldMap:SceneWelcome = null;
		private var _sceneGameMain:SceneWelcome = null;
		
		public function LandGrabbers()
		{
			mLoader = new BulkLoader("image_loader");
			mLoader.logLevel = BulkLoader.LOG_INFO;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			_sceneWelcome = new SceneWelcome();
			addChild(_sceneWelcome);
		}
	}
}