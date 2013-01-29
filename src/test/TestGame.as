package test  
{  
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import starling.core.Starling;
	
	[SWF(width="1280", height="768", backgroundColor="#D1C4AC", frameRate="60")]
	
	public class TestGame extends flash.display.Sprite
	{
		private var myStarling:Starling;
		public function TestGame():void {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			
			// Initialize Starling object.
			myStarling = new Starling(TestGameIn, stage);
			
			// Define basic anti aliasing.
			myStarling.antiAliasing = 1;
			
			// Show statistics for memory usage and fps.
			myStarling.showStats = true;
			
			// Position stats.
			myStarling.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			myStarling.start();
		}
	}
	
	
} 
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.deg2rad;

class TestGameIn extends Sprite 
{ 	
	public function TestGameIn() 
	{   
		addEventListener(Event.ADDED_TO_STAGE, onAdded); 
	} 
	
	private function onAdded ( e:Event ):void 
	{ 
		stage.color = 0x002143;
		
		var bg:Quad = new Quad(800, 600, Color.WHITE);
		addChild(bg);
		bg.addEventListener(TouchEvent.TOUCH, onMove);
		
		var btn:Quad = new Quad(50, 50, Color.LIME);
		addChild(btn);
		btn.x = bg.width - btn.width;
		btn.addEventListener(TouchEvent.TOUCH, modalTest);
	}
	
	private function modalTest(e:TouchEvent):void {
		
		var obj:DisplayObject = e.currentTarget as DisplayObject;
		var touch:Touch = e.getTouch(obj, TouchPhase.ENDED); 
		if (touch != null) {
			var dlg:TestDialog = new TestDialog();
			//addChild(dlg);
			dlg.doModal(this);
		}
	}
	
	private function onMove(e:TouchEvent):void {
		var obj:DisplayObject = e.currentTarget as DisplayObject;
		var touch:Touch = e.getTouch(obj, TouchPhase.MOVED); 
		if ( touch != null) {
			x = touch.globalX;
			y = touch.globalY;
		}
	}
} 

class TestDialog extends Sprite {
	private var layerMask:Quad;
	
	public function TestDialog() {
		addEventListener(Event.ADDED_TO_STAGE, onAdded); 
	}
	
	public function doModal(paren:DisplayObjectContainer):void {
		
		paren.addChild(this);
		
		layerMask = new Quad(paren.width, paren.height, 0x0);
		layerMask.alpha = 0.1;
		layerMask.blendMode = BlendMode.SCREEN;
		paren.addChildAt(layerMask, paren.getChildIndex(this));
	}
	
	private function onAdded (e:Event):void {
		var bg:Quad = new Quad(400, 400, Color.GRAY);
		addChild(bg);
		
		var content:Quad = new Quad(50, 50, Color.PURPLE);
		content.x = bg.width - content.width >> 1;
		content.y = bg.height - content.height >> 1;		
		addChild(content);
		
		var close:Quad = new Quad(10, 10, Color.RED);
		close.x = bg.width - close.width;
		close.y = 0;
		addChild(close);
		
		close.addEventListener(TouchEvent.TOUCH, onClose);
	}
	
	private function onClose(e:TouchEvent):void {
		var obj:DisplayObject = e.currentTarget as DisplayObject;
		var touch:Touch = e.getTouch(obj, TouchPhase.ENDED); 
		if (touch != null) {
			if (layerMask && layerMask.parent == parent)
				parent.removeChild(layerMask, true);
			parent.removeChild(this, true);
		}
	}
}