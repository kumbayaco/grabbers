package com.grabbers.application
{
	import com.grabbers.globals.App;
	import com.grabbers.manager.SceneManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	import test.TestGame;
	
//	[SWF(width="1280", height="768", backgroundColor="#D1C4AC", frameRate="60")]
	[SWF(width="1280", height="768", backgroundColor="#0", frameRate="60")]
	
	public class LandGrabbers extends Sprite
	{
		private var myStarling:Starling;
		public function LandGrabbers():void {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
//			stage.scaleMode = StageScaleMode.EXACT_FIT;
			// Initialize Starling object.
			myStarling = new Starling(Game, stage);
//			myStarling = new Starling(TestGame, stage);
			
			// Define basic anti aliasing.
			myStarling.antiAliasing = 1;
			
			// Show statistics for memory usage and fps.
			myStarling.showStats = true;
			
			myStarling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			// Position stats.
			myStarling.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			myStarling.start();
		}
	}
}