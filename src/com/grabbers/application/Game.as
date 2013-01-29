package com.grabbers.application
{
	import com.grabbers.globals.App;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game():void {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			App.init(Starling.current.stage);
			
			App.run();
		}
	}
}