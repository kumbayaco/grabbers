package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.MathUtil;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.component.ScaleImage;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class UISlider extends UIObject
	{
		static public const MAX_VALUE:uint = 100;
		static protected const _parser:Object = {
			name:			function(str:String, obj:UISlider):void {obj.name = str;},
			size: 			function(str:String, obj:UISlider):void {obj._size = ScriptHelper.parsePoint(str);},
			pos: 			function(str:String, obj:UISlider):void {obj._pos = ScriptHelper.parsePoint(str);},
			backtexture:	function(str:String, obj:UISlider):void {
				var bmd:BitmapData = App.resourceManager.getBitmapData(str);
				if (bmd == null)
					return;
				
				obj._imgBack = new ScaleImage(bmd, new Rectangle(32,15,64,2));				
				obj.addChild(obj._imgBack);
				obj._imgBack.addEventListener(TouchEvent.TOUCH, obj.onMoveKnob);
			},
			
			knobtexture:	function(str:String, obj:UISlider):void {
				var bmps:Vector.<BitmapData> = App.resourceManager.getBitmapDataTwin(str);
				if (bmps == null || bmps.length < 2 || obj._imgBack == null)
					return;
				
				obj._texKnobUp = Texture.fromBitmapData(bmps[0], false);
				obj._texKnobDown = Texture.fromBitmapData(bmps[1], false);
				obj._imgKnob = new Image(obj._texKnobUp);
				
				obj._imgKnob.y = obj._imgBack.y + obj._imgBack.height/2 - obj._imgKnob.height/2 >> 0 - 5;
				obj._knobBeg = obj._imgBack.x + 10;
				obj._knobEnd = obj._imgBack.x + obj._imgBack.width - obj._imgKnob.width - 10;
				
				obj.addChild(obj._imgKnob);				
				
				obj._imgKnob.addEventListener(TouchEvent.TOUCH, obj.onMoveKnob);
			}
		};
		
		public var handler:Function;
		protected var _size:Point;
		protected var _pos:Point;		
		private var _imgBack:ScaleImage;
		private var _imgKnob:Image;
		private var _texKnobUp:Texture;
		private var _texKnobDown:Texture;
		private var _knobBeg:uint;
		private var _knobEnd:uint;
		private var _proc:uint;
		private var _sfx:String;
		
		public function UISlider()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean 
		{
			for each (var att:XML in xml.attributes()) {
				var key:String = att.name().toString();
				var val:String = att.toString();
				if (_parser.hasOwnProperty(key)) {
					_parser[key](val, this);
				}
			}
			
			width = _size.x;
			height = _size.y;
			LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), _pos.x, _pos.y, parentW, parentH);
			return true;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean
		{
			if (vXml == null)
				return true;
			/*
			<slider name="basic_slider" pos="0, 0" size="256, 32" backtexture="slider_back" knobtexture="slider_knob">
			</slider>
			*/
			
			for each (var xmlBasic:XML in vXml) {
				var tagName:String = xmlBasic.@name;
				switch (tagName) {
					case "basic_slider":
						for each (var att:XML in xmlBasic.attributes()) {
							var key:String = att.name().toString();
							var val:String = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							}
						}
						break;
				}
			}
			
			return true;
		}
		
		override public function set width(w:Number):void {
			if (_imgBack != null)
				_imgBack.width = w;
			if (_imgBack != null && _imgKnob != null)
				_knobEnd = _imgBack.x + _imgBack.width - _imgKnob.width - 10;
			updateKnobPostion();
		}
		
		override public function set height(h:Number):void {
			if (_imgBack != null)
				_imgBack.height = h;
			if (_imgBack != null && _imgKnob != null)
				_imgKnob.y = _imgBack.y + _imgBack.height/2 - _imgKnob.height/2 >> 0 - 5;
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
				
				if (_sfx != "" && _sfx != null)
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
			if (_imgKnob == null)
				return;
			_imgKnob.x = _knobBeg + (_knobEnd - _knobBeg) * _proc / MAX_VALUE;
		}
	}
}