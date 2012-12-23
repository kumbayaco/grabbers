package application
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import globals.App;
	
	import manager.SceneManager;
	
	[SWF(width="1024", height="768", backgroundColor="#D1C4AC", frameRate="60")]
	
	public class LandGrabbers extends Sprite
	{
		public function LandGrabbers():void {
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			App.init(stage);
			
			App.run();
		}
	}
}