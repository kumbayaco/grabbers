package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.MathUtil;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Slide extends DisplayObjectContainer
	{
		public var handler:Function;
		private var _imgBack:ScaleImage;
		private var _imgKnob:Image;
		private var _texKnobUp:Texture;
		private var _texKnobDown:Texture;
		private var _knobBeg:uint;
		private var _knobEnd:uint;
		private var _proc:uint;
		private var _sfx:String;
		
		static public const MAX_VALUE:uint = 100;
		
		//<slider name="basic_slider" pos="0, 0" size="256, 32" backtexture="slider_back" knobtexture="slider_knob">		
		public function Slide(texKnob:Texture, bmpBack:BitmapData, moveSfx:String)
		{
			super();
			
			_imgBack = new ScaleImage(bmpBack, new Rectangle(32,15,64,2));
			
			_texKnobUp = Texture.fromTexture(texKnob, new Rectangle(0, 0, texKnob.width, texKnob.height/2));
			_texKnobDown = Texture.fromTexture(texKnob, new Rectangle(0, texKnob.height/2, texKnob.width, texKnob.height/2));
			_imgKnob = new Image(_texKnobUp);
			
			_imgKnob.y = _imgBack.y + _imgBack.height/2 - _imgKnob.height/2 >> 0 - 5;
			_knobBeg = _imgBack.x + 10;
			_knobEnd = _imgBack.x + _imgBack.width - _imgKnob.width - 10;
			
			_sfx = moveSfx;
			addChild(_imgBack);
			addChild(_imgKnob);
			
			_imgKnob.addEventListener(TouchEvent.TOUCH, onMoveKnob);
			_imgBack.addEventListener(TouchEvent.TOUCH, onMoveKnob);
		}
		
		override public function set width(w:Number):void {
			_imgBack.width = w;
			_knobEnd = _imgBack.x + _imgBack.width - _imgKnob.width - 10;
			updateKnobPostion();
		}
		
		override public function set height(h:Number):void {
			_imgBack.height = h;
			_imgKnob.y = _imgBack.y + _imgBack.height/2 - _imgKnob.height/2 >> 0 - 5;
		}
		
		//<e name="slide" pos="367, 126" size="256, 128" backtexture="slider_back" knobtexture="slider_knob">
		static public function parse(texPak:String, xml:XML, parentW:uint, parentH:uint):Slide {
			var pt:Point = ScriptHelper.parsePoint(xml.@pos);
			var size:Point = ScriptHelper.parsePoint(xml.@size);
			var texBack:BitmapData = App.resourceManager.getBitmapData(texPak, xml.@backtexture);
			var texKnob:Texture = App.resourceManager.getTexture(texPak, xml.@knobtexture);
			
			var slide:Slide = new Slide(texKnob, texBack, xml.@sfx);
			pt = ScriptHelper.parsePosition(pt.x, pt.y, size.x, size.y, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			slide.x = pt.x;
			slide.y = pt.y;
			
			slide.width = size.x;
			slide.height = size.y;
			
			return slide;
		}
		
		protected function onMoveKnob(e:TouchEvent):void {
			var touch:Touch = e.getTouch(_imgKnob, TouchPhase.MOVED);
			if (touch == null)
				touch = e.getTouch(_imgBack, TouchPhase.ENDED);
			
			if (touch != null) {
				var pt:Point = new Point(touch.globalX-_imgKnob.width/2, touch.globalY);				
				pt = globalToLocal(pt);
				pt.x = MathUtil.clamp(pt.x, _knobBeg, _knobEnd);
				proc = (pt.x - _knobBeg) * MAX_VALUE / (_knobEnd - _knobBeg) >> 0;
				_imgKnob.texture = _texKnobDown;
				
				App.soundManager.playSfx(_sfx);
			} else {
				_imgKnob.texture = _texKnobUp;
			}
		}
		
		public function set proc(x:uint):void {
			_proc = x;
			if (handler != null)
				handler(_proc);
			updateKnobPostion();
		}
		
		public function get proc():uint {
			return _proc;
		}
		
		protected function updateKnobPostion():void {
			_imgKnob.x = _knobBeg + (_knobEnd - _knobBeg) * _proc / MAX_VALUE;
		}
	}
}