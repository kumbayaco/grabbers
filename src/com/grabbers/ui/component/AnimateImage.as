package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class AnimateImage extends Image implements IAnimatable
	{
		private var _slideSpeed:Point = null;
		private var _deltaRot:Number;
		private var _speedRot:Number;
		private var _initRot:Number;
		private var _rotDirect:Number;
		private var _bAnimate:Boolean;
		private var _bRandomTimer:Boolean;
		private var _speedPulse:Number;		
		private var _factorPulse:Number;
		private var _speedBlink:Number;
		private var _factorBlink:Number;
		private var _initSize:Point;
		
		static public function parse(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):AnimateImage {
			var tex:Texture = App.resourceManager.getTexture(texPack, xml.@texture_name);
			if (tex == null) {
				Logger.error(xml.@texture_name + " not found in " + texPack);
				return null;
			}
			
			var img:AnimateImage = new AnimateImage(tex);
			var animObj:Object = new Object();
			
			var str:String;
			var arr:Array;
			var pos:Point;
			var anchorType:uint;
			
			arr = ScriptHelper.parseDigitArray(xml.@pos);
			pos = new Point(arr[0], arr[1]);
			
			arr = ScriptHelper.parseDigitArray(xml.@size);
			var size:Point = new Point(arr[0], arr[1]);
			
			
			pos = ScriptHelper.parsePosition(pos.x, pos.y, size.x, size.y, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			img.x = pos.x;
			img.y = pos.y;
			img.width = size.x;
			img.height = size.y;
			
			str = xml.@slide_speed;
			var str2:String = xml.@center_pos;
			if (str != "") {
				arr = ScriptHelper.parseDigitArray(xml.@slide_speed);
				img.setSlideSpeed(new Point(arr[0], arr[1]));
				img.animate = true;
			}
				
			str = xml.@center_pos;
			if (str != "") {
				arr = ScriptHelper.parseDigitArray(xml.@center_pos);
				var co:Point = Global.configPt2ScreenPt(arr[0], arr[1], 0, 0);		
				img.pivotX = (co.x - pos.x) / img.scaleX; 
				img.pivotY = (co.y - pos.y) / img.scaleY; 
				img.x = co.x;
				img.y = co.y;
					
				var rotateSpeed:Number = xml.@rotate_speed;
				var rotateDelta:Number = xml.@delta_rotate;
				if (rotateSpeed != 0) {
					img.animate = true;
					img.setRotate(-xml.@start_angle, xml.@rotate_speed, xml.@delta_rotate);
				}
			} else {
//				img.pivotX = img.width >> 1;
//				img.pivotY = img.height >> 1;
//				img.x += img.width >> 1;
//				img.y += img.height >> 1;
			}

			str = xml.@texcoord;
			if (str != "") {
				arr = ScriptHelper.parseDigitArray(xml.@texcoord);
				if (arr != null && arr.length == 4) {
					img.setTexCoords(0, new Point(arr[0], arr[1]));
					img.setTexCoords(1, new Point(arr[2], arr[1]));
					img.setTexCoords(2, new Point(arr[0], arr[3]));
					img.setTexCoords(3, new Point(arr[2], arr[3]));
					img.texture.repeat = true;
				}
			}
			
			//blinking="true" pulsating="true" random_timer="true" pulse_factor="0.7" pulse_speed="5" blink_factor="0.2" blink_speed="5"
			str = xml.@blinking;
			if (str == "true") {
				img.setBlink(xml.@blink_factor, xml.@blink_speed);
				img.animate = true;
			}
			
			str = xml.@pulsating;
			if (str == "true") {
				img.setPulse(xml.@pulse_factor, xml.@pulse_speed);
				img.animate = true;
			}
			
			str = xml.@random_timer;
			if (str == "true") {
				img.randomTimer = true;
				img.animate = true;
			}
			
			str = xml.@color;
			if (str != "") {
				arr = ScriptHelper.parseDigitArray(xml.@color);
				img.color = Color.argb(arr[3], arr[0], arr[1], arr[2]);
			}
			
			img.rotation = -xml.@start_angle * Math.PI / 180;
			
			str = xml.@addictive;
			if (str == "true")
				img.blendMode = BlendMode.SCREEN;
			
			img.name = xml.@name;
			img.touchable = false;
			
			return img;
		}
		
		public function AnimateImage(texture:Texture)
		{
			super(texture);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onAddToStage(e:Event):void {
			if (_bAnimate)
				Starling.current.juggler.add(this);
		}
		
		private function onRemoveFromStage(e:Event):void {
			if (_bAnimate)
				Starling.current.juggler.remove(this);
		}
		
		public function advanceTime(timeX:Number):void {
			var pt:Point;
			
			if (_initSize == null) {
				_initSize = new Point(width, height);
			}
			
			var time:Number = timeX;
			if (_bRandomTimer)
				time *= ((Math.random() - 0.5) * 0.1 + 1);
			
			if (_slideSpeed != null) {
				for (var i:uint = 0; i < 4; i++) {
					pt = getTexCoords(i);
					pt.x = (pt.x + _slideSpeed.x * time) % int.MAX_VALUE;
					pt.y = (pt.y + _slideSpeed.y * time) % int.MAX_VALUE;
					setTexCoords(i, pt);
				}
			}
			
			if (_speedRot > 0) {
				if (rotation > _initRot + _deltaRot)
					_rotDirect = -1.0;
				if (rotation <= _initRot - _deltaRot)
					_rotDirect = 1.0;
				
				var portion:Number = Math.min(Math.abs(rotation - _initRot) / _deltaRot, 1);
				var speedNow:Number = _speedRot * 0.2 + _speedRot  * (1 - portion) * 0.8;
				rotation = rotation + _rotDirect * speedNow * time;
			}
			
			if (_speedPulse > 0 && _factorPulse > 0) {
//				width = _initSize.x + _speedPulse * _factorPulse * time * 50;
//				height = _initSize.y + _speedPulse * _factorPulse * time * 50;
			}
			
			if (_speedBlink > 0 && _factorBlink > 0) {
				//var l:Number = 255 - _speedBlink * _factorBlink * time * 200;
				//color = Color.argb(l, l, l, l);
			}
		}
		
		public function setSlideSpeed(speed:Point):void {
			_slideSpeed = speed;
		}
		
		public function setRotate(initRot:Number, deltaRot:Number, speedRot:Number):void {
			_initRot = initRot * Math.PI / 180;
			_deltaRot = deltaRot * Math.PI / 180;
			_speedRot = speedRot * Math.PI / 180;	
			_rotDirect = 1.0;
		}
		
		public function set animate(bAnimate:Boolean):void {
			_bAnimate = bAnimate;
		}
		
		public function set randomTimer(bRandom:Boolean):void {
			_bRandomTimer = bRandom;
		}
		
		public function setBlink(factor:Number, speed:Number):void {
			_factorBlink = factor;
			_speedBlink = speed;
		}
		
		public function setPulse(factor:Number, speed:Number):void {
			_factorPulse = factor;
			_speedPulse = speed;
		}
	}
}