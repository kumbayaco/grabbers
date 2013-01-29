package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.model.UIObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	public class UIBitmap extends UIObject implements IAnimatable
	{
		private var _image:Image;
		private var _slideSpeed:Point = null;
		private var _deltaRot:Number;
		private var _speedRot:Number;
		private var _initRot:Number;
		private var _rotDirect:Number = 1;
		private var _bAnimate:Boolean;
		private var _bRandomTimer:Boolean;
		private var _speedPulse:Number;		
		private var _factorPulse:Number;
		private var _speedBlink:Number;
		private var _factorBlink:Number;
		private var _initSize:Point;
		
		public function UIBitmap() {		
		}
		
		public function get image():Image {
			return _image;
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean {
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			var size:Point = ScriptHelper.parsePoint(xml.@size);
			
			var tex:Texture;
			if (xml.hasOwnProperty("@texture_name")) {
				tex = App.resourceManager.getTexture(texPack, xml.@texture_name);
				if (tex == null) {
					Logger.error(xml.@texture_name + " not found in " + texPack);
					return false;
				}
			} else {
				tex = Texture.fromColor(size.x, size.y);
			}		
			
			_image = new Image(tex);
			addChild(_image);
			
			_image.width = size.x;
			_image.height = size.y;
			
			
			if (xml.hasOwnProperty("@center_pos")) {
				var co:Point = ScriptHelper.parsePoint(xml.@center_pos);
				co.x = (App.stage.stageWidth >> 1) + co.x;
				co.y = (App.stage.stageHeight >> 1) - co.y;
				LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH, co);
			} else {
				LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH, null);
			}
			
			if (xml.hasOwnProperty("@texcoord")) {
				var arr:Array = ScriptHelper.parseDigitArray(xml.@texcoord);
				if (arr != null && arr.length == 4) {
					_image.setTexCoords(0, new Point(arr[0], arr[1]));
					_image.setTexCoords(1, new Point(arr[2], arr[1]));
					_image.setTexCoords(2, new Point(arr[0], arr[3]));
					_image.setTexCoords(3, new Point(arr[2], arr[3]));
					_image.texture.repeat = true;
				}
			}
			
			if (xml.hasOwnProperty("@color")) {
				var color:uint = ScriptHelper.parseColor(xml.@color);
				_image.color = color;
				_image.alpha = (Color.getAlpha(color)) / 255;
			}
			
			if (xml.@addictive == "true") {
				_image.blendMode = BlendMode.SCREEN;
			}
			
			if (xml.hasOwnProperty("@slide_speed")) {
				var speed:Point = ScriptHelper.parsePoint(xml.@slide_speed);
				_slideSpeed = speed;
				_bAnimate = true;
			}
			
			if (xml.hasOwnProperty("@rotate_speed") && xml.hasOwnProperty("@delta_rotate")) {
				if (xml.hasOwnProperty("@start_angle"))
					_initRot = -deg2rad(ScriptHelper.parseNumber(xml.@start_angle));
				_speedRot = deg2rad(ScriptHelper.parseNumber(xml.@rotate_speed));
				_deltaRot = deg2rad(ScriptHelper.parseNumber(xml.@delta_rotate));
				_bAnimate = true;
			}
			
			if (xml.hasOwnProperty("@blinking") && xml.hasOwnProperty("@blink_speed") && xml.hasOwnProperty("@blink_factor")) {
				_speedBlink = ScriptHelper.parseNumber(xml.@blink_speed);
				_factorBlink = ScriptHelper.parseNumber(xml.@blink_factor);
				_bAnimate = true;
			}
			
			if (xml.hasOwnProperty("@pulsating") && xml.hasOwnProperty("@pulse_speed") && xml.hasOwnProperty("@pulse_factor")) {
				_speedPulse = ScriptHelper.parseNumber(xml.@pulse_speed);
				_factorPulse = ScriptHelper.parseNumber(xml.@pulse_factor);
				_bAnimate = true;
			}
			
			if (xml.@random_timer == "true") {
				_bRandomTimer = true;
			}
			
			if (xml.hasOwnProperty("@start_angle")) {
				rotation = -deg2rad(ScriptHelper.parseNumber(xml.@start_angle));
			}
			
			name = xml.@name;
			touchable = false;	
			
			if (_bAnimate) {
				addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
				addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			} else {
				removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			}
			
			return true;
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
			if (_image == null)
				return;
			
			var pt:Point;
			
			if (_initSize == null) {
				_initSize = new Point(width, height);
			}
			
			var time:Number = timeX;
			if (_bRandomTimer)
				time *= ((Math.random() - 0.5) * 0.1 + 1);
			
			if (_slideSpeed != null) {
				for (var i:uint = 0; i < 4; i++) {
					pt = _image.getTexCoords(i);
					pt.x = (pt.x + _slideSpeed.x * time) % int.MAX_VALUE;
					pt.y = (pt.y + _slideSpeed.y * time) % int.MAX_VALUE;
					_image.setTexCoords(i, pt);
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
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean 
		{
			return true;
		}
	}
}