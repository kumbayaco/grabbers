package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Global;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.IAnimatable;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	public class FormElement extends DisplayObjectContainer
	{
		private var _bAnimate:Boolean = false;
		private var _initPos:Point = null;
		private var _initScale:Point = new Point(1, 1);
		private var _initAlpha:uint = 255;
		private var _animTime:uint = 4;
		private var _tween:Tween;
		private var _bg:Quad;
		
		public function FormElement()
		{
			super();
			_bg = new Quad(1, 1, 0xff0000);
			_bg.alpha = 0;
			_bg.touchable = false;
			addChild(_bg);
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
		}
		
		override public function set width(w:Number):void {
			_bg.width = w;
		}
		
		override public function set height(h:Number):void {
			_bg.height = h;
		}
		
		public function set customShape(b:Boolean):void {
			if (b) {
				if (contains(_bg)) {
					removeChild(_bg);
				}					
			} else {
				addChild(_bg);
			}
		}
		
		private function addToStageListener(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			
			if (!_bAnimate)
				return;
			
			_tween = new Tween(this, _animTime/1000, Transitions.EASE_IN_BACK);
			scaleX = _initScale.x;
			scaleY = _initScale.y;
			_tween.animate("scaleX", 1);
			_tween.animate("scaleY", 1);
			
			if (_initPos != null) {
				var destX:uint = x;
				var destY:uint = y;
				x = _initPos.x;
				y = _initPos.y;
				
				_tween.animate("x", destX);
				_tween.animate("y", destY);
			}			
			
			alpha = _initAlpha;
			_tween.animate("alpha", 255);
			
			Starling.juggler.add(_tween);
			
			Starling.current.juggler.add(_tween);
		}
		
		
		static public function parse(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):FormElement {
			var form:FormElement = new FormElement();
			
			//<virtual_form name="change_player" pos="310, -134" size="512, 256" show="true" show_angle="353.8">
			if (xml.@show == "false") {
				form.visible = false;
			}
			
			var arr:Array;
			var pt:Point;
			
			form.name = xml.@name;
			arr = ScriptHelper.parseDigitArray(xml.@size);
			var size:Point = new Point(arr[0], arr[1]);
			form.width = size.x;
			form.height = size.y;
			
			arr = ScriptHelper.parseDigitArray(xml.@pos);			
			pt = ScriptHelper.parsePosition(arr[0], arr[1], size.x, size.y, ScriptHelper.parseAnchorType(xml), parentW, parentH);		
			form.x = pt.x;
			form.y = pt.y;
									
			var xmlList:XMLList = xml.children();
			for (var i:uint = 0; i < xmlList.length(); i++) {
				switch (xmlList[i].name().localName) {
					case "bitmap":
						form.addChild(AnimateImage.parse(texPack, xmlList[i], size.x, size.y));
						break;
					
					case "activeelement":
						//form.addChild(ButtonHover.parse(texPack, xmlList[i], size.x, size.y));
						form.addChild(ButtonImage.parse(texPack, xmlList[i], size.x, size.y));
						break;
						
					case "text":
						var label:Label = Label.parse(xmlList[i], form.width, form.height);
//						arr = ScriptHelper.parseDigitArray(xmlList[i].@pos);	
//						label.x = (size.x / 2 + parseInt(arr[0]) - label.width / 2) >> 0;
//						label.y = (size.y / 2 - parseInt(arr[1]) -  3 * label.height / 2) >> 0;	
						form.addChild(label);
						break;
					
					case "virtual_form":
						form.addChild(FormElement.parse(texPack, xmlList[i], size.x, size.y));
						break;
				}
			}
			
			str = xml.@show_angle;
			if (str != "") {
				form.pivotX = form.width / 2;
				form.pivotY = form.height / 2;
				form.x += form.pivotX;
				form.y += form.pivotY;
				form.rotation = -xml.@show_angle * Math.PI / 180;
			}
			
			
			/*
			<virtual_form name="sign_title" pos="0 ,286" size="1024, 128" 
			matrix="true" theme="false" show="false" hide_pos="0, -600" hide_scale="5, 5"  effect_time="1500" hide_alpha="1" 
			particles_on_show="true" show_particle_name="spark_fall" show_particle_timer="32" show_particle_zone="0, 0, 208, 24" 
			particles_on_end_show="true" end_show_particle_name="spark_clang" end_show_particle_quantity="60" end_show_particle_zone="0, 0, 240, 24" 
			show_mode="1">
			*/
			if (xml.@matrix == "true") {
				
				var animObj:Object = new Object();
				
				arr = ScriptHelper.parseDigitArray(xml.@hide_pos);
				animObj["initPos"] = Global.configPt2ScreenPt(arr[0], arr[1], size.x, size.y);
				arr = ScriptHelper.parseDigitArray(xml.@hide_scale);
				animObj["initScale"] = new Point(arr[0], arr[1]);
				arr = ScriptHelper.parseDigitArray(xml.@hide_alpha);
				animObj["initAlpha"] = arr[0];
				arr = ScriptHelper.parseDigitArray(xml.@effect_time);
				animObj["time"] = arr[0];
				
				if (xml.@particles_on_show == "true") {
					var partObj:Object = new Object();
					var str:String = xml.@show_particle_name;
					partObj["name"] = str;
					partObj["time"] = parseInt(xml.@show_particle_time);
					arr = ScriptHelper.parseDigitArray(xml.@show_particle_zone);
					var rc:Rectangle = new Rectangle(arr[0], arr[1], arr[2]-arr[0], arr[3]-arr[1]);
					rc.offsetPoint(Global.configPt2ScreenPt(rc.left, rc.top, rc.width, rc.height, size.x, size.y));
					partObj["zone"] = rc;
					
					animObj["part_on_show"] = partObj;
					form.visible = true;
				}
				
				if (xml.@particles_on_end_show == "true") {
					partObj = new Object();
					str = xml.@show_particle_name;
					partObj["name"] = str;
					partObj["time"] = parseInt(xml.@end_show_particle_time);
					arr = ScriptHelper.parseDigitArray(xml.@end_show_particle_zone);
					rc = new Rectangle(arr[0], arr[1], arr[2]-arr[0], arr[3]-arr[1]);
					rc.offsetPoint(Global.configPt2ScreenPt(rc.left, rc.top, rc.width, rc.height, size.x, size.y));
					partObj["zone"] = rc;
					
					animObj["part_on_end_show"] = partObj;
				}
				
				form.setAnimateInfo(animObj);
			}
			
			
			return form;
		}
				
		public function setAnimateInfo(params:Object):void {
			if (params["initPos"] != null) {
				_initPos = params["initPos"];
			}
			
			if (params["initScale"] != null) {
				_initScale = params["initScale"];
			}
			
			if (params["initAlpha"] != null) {
				_initAlpha = params["initAlpha"];
			}	
			
			if (params["time"] != null) {
				_animTime = params["time"];
			}
			
			
			_bAnimate = true;
		}
	}
}