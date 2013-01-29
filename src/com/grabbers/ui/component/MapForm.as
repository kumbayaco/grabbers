package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.type.Anchor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class MapForm extends DisplayObjectContainer
	{
		private static var _dictLevelBtn:Dictionary = new Dictionary();
		private static var _bg:BitmapData;
		private static var _border:Point;
		private var _showPos:Point;
		private var _hidePos:Point;
		private var _hideScale:Point;
		private var _showAngle:Number;
		private var _hideAngle:Number;
		private var _hideAlpha:Number;
		private var _effectTime:Number;
		private var _bAnimate:Boolean;
		private var _bShow:Boolean;
		private var _sQuad:Quad;
		
		public function MapForm()
		{
			super();
			_sQuad = new Quad(1, 1, 0);
			_sQuad.alpha = 0.1;
			_bShow = false;
			addEventListener(Event.ADDED_TO_STAGE, addToStageListener);
			_sQuad.addEventListener(TouchEvent.TOUCH, onBgTouch);
		}
		
		public function setAnimateInfo(params:Object):void {
			_showPos = params["show_pos"];
			_hidePos = params["hide_pos"];
			_hideScale = params["hide_scale"];
			_showAngle = deg2rad(params["show_angle"]);
			_hideAngle = deg2rad(params["hide_angle"]);
			_hideAlpha = params["hide_alpha"];
			_effectTime = params["effect_time"];
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			_showPos.x += (width >> 1);
			_showPos.y += (height >> 1);
			_hidePos.x += (width >> 1);
			_hidePos.y += (height >> 1);
			
			_bAnimate = true;
		}
		
		public function isShow():Boolean {
			return _bShow;
		}
		
		private function close():void {
			if (parent == null)
				return;
			
			if (_sQuad.parent != null)
				_sQuad.parent.removeChild(_sQuad);	
			if (!_bAnimate) {
				parent.removeChild(this);
			} else {
				Starling.current.juggler.tween(this, _effectTime/1000, 
					{	transition:Transitions.EASE_IN_OUT_BACK, 
						scaleX:_hideScale.x,
						scaleY:_hideScale.y,
						rotation:_hideAngle,
						alpha:0,
						x:_hidePos.x,
						y:_hidePos.y,
						onComplete: function():void {_bShow = false; removeSelf();}
					});
			}
		}
		
		private function addToStageListener(e:Event):void {
			if (!_bAnimate)
				return;
			
			_sQuad.width = parent.width;
			_sQuad.height = parent.height;
			parent.addChildAt(_sQuad, parent.getChildIndex(this) - 1);
			
			x = _hidePos.x;
			y = _hidePos.y;
			rotation = _hideAngle;
			alpha = _hideAlpha;
			scaleX = _hideScale.x;
			scaleY = _hideScale.y;
			
			Starling.current.juggler.tween(this, _effectTime/1000, 
				{	transition:Transitions.EASE_IN_OUT_BACK, 
					scaleX:1,
					scaleY:1,
					rotation:_showAngle,
					alpha:1,
					x:_showPos.x,
					y:_showPos.y,
					onComplete: function():void {_bShow = true;}
				});
		}
		
		private function removeSelf():void {
			if (parent != null)
				parent.removeChild(this);
		}
		
		private function onClose(e:Event):void {
			close();
		}
		
		private function onBgTouch(e:TouchEvent):void {
			if (e.getTouch(_sQuad, TouchPhase.ENDED) != null) {
				close();
			}
		}
		
		private function onLevelBtn(btn:MapLevelButton):void {
			trace(btn.name);
		}
		
		static public function init():void {
			//<form name="map_form" pos="-100, 80" size="512, 512" matrix="true" border="16, 16" 
			//theme="false" texture_theme_name="minimap" visible="false" enabled="false">
			var text:String = "<e>" + App.resourceManager.getConfigXml("scripts/components/map_form.txt") + "</e>";
			var xml:XML = new XML(text);
			var xmlForm:XML = new XML(xml.form);
			
			var pos:Point = ScriptHelper.parsePoint(xmlForm.@pos);
			var size:Point = ScriptHelper.parsePoint(xmlForm.@size);
			_border = ScriptHelper.parsePoint(xmlForm.@border);
			pos = ScriptHelper.parsePosition(pos.x, pos.y, size.x, size.y, ScriptHelper.parseAnchorType(xmlForm),
				App.stage.stageWidth, App.stage.stageHeight);
			
			_bg = new BitmapData(size.x + _border.x * 2, size.y + _border.y * 2, true, 0);
			
			var arr:Array = [	"minimaplu", "minimapl", "minimapld",
								"minimapu", "xxx", "minimapd", 
								"minimapru", "minimapr", "minimaprd"];
			var bmps:Vector.<BitmapData> = new Vector.<BitmapData>();			
			for (var i:uint = 0; i < arr.length; i++) {
				if (i == 4) {
					bmps.push(null);
					continue;
				}
				
				var bmpSub:BitmapData = App.resourceManager.getBitmapData(Resources.MAP_PACK, arr[i]);
				var x:uint = 0;
				var y:uint = 0;
				var matrix:Matrix = new Matrix();				
				
				bmps.push(bmpSub);
				
				switch (i % 3) {
					case 0: matrix.d = _border.y / bmpSub.height; break;
					case 1: matrix.ty = _border.y; break;
					case 2: matrix.ty = size.y; matrix.d = _border.y / bmpSub.height; break;
				}
				
				switch (i / 3 >> 0) {
					case 0: matrix.a = _border.x / bmpSub.width; break;
					case 1: matrix.tx = _border.x; break;
					case 2: matrix.tx = size.x; matrix.a = _border.x / bmpSub.width; break;
				}
				
				_bg.draw(bmps[i], matrix);
			}
			
			// <maplevelbutton name="level_button" size="64, 64" visible="true" enabled="false">
			for each (var xmlLevelBtn:XML in xml.maplevelbutton) {
				var xmlSub:XMLList =xmlLevelBtn.children();
				for (i = 0; i < xmlSub.length(); i++) {
					switch (xmlSub[i].name().localName) {
						case "bitmap":
							//<bitmap name="selection" texture_name="level_selector" pos="0, -13" size="96, 88" 
							//visible="false" pulsating="true" pulse_factor="7" pulse_speed="0.4" color="255, 255, 255, 196">
							registerLevelBtn(xmlSub[i].@name, AnimateImage.parse, xmlSub[i]);
							break;
						
						case "activeelement":
							//<activeelement name="expert_flag_picture" texture_name="level_flag_expert" 
							//pos="0, 0" size="64, 64">
							registerLevelBtn(xmlSub[i].@name, ButtonImage.parse, xmlSub[i]);
							break;
					}
				}
			}
		}
		
		static public function registerLevelBtn(name:String, handler:Function, xml:XML):void {
			_dictLevelBtn[name] = {parse:handler, xmlContext:xml};
		}
		
		static public function getLevelBtn(name:String):DisplayObject {
			if (_dictLevelBtn[name] != null) {
				var obj:Object = _dictLevelBtn[name] as Object;
				return obj.parse(Resources.MAP_PACK, obj.xmlContext, _bg.width, _bg.height);
			}
			return null;
		}
		
		static public function parse(texPack:String, xml:XML, parentW:uint, parentH:uint):MapForm {
			if (_bg == null)
				init();
			
			//<map_form name="forest_minimap" visible="true" enabled="true" 
			//hide_pos="290, -130" hide_scale="0.01, 0.01" show_angle="5" 
			//hide_angle="180" hide_alpha="0" effect_time="500">
			
			var form:MapForm = new MapForm();
			if (xml.@visible == "false") {
				form.visible = false;
			}
			if (xml.@enabled == "false") {
				form.touchable = false;
			}
			form.name = xml.@name;
			
			var animObj:Object = new Object();
			var pos:Point;
			var f:Number;
			
			pos = ScriptHelper.parsePosition(0, 0, _bg.width, _bg.height, 
				ScriptHelper.parseAnchorType(xml), parentW, parentH);
			animObj["show_pos"] = pos;
			form.x = pos.x;
			form.y = pos.y;			
			
			
			//<bitmap name="map" pos="0, 0" size="512, 512" texture_name="map_forest">
			form.addChild(Image.fromBitmap(new Bitmap(_bg)));
			var bg:AnimateImage = AnimateImage.parse(Resources.MAP_PACK, new XML(xml.bitmap), _bg.width, _bg.height);
			bg.x = _border.x;
			bg.y = _border.y;
			form.addChildAt(bg, 0);
			
			//<activeelement name="close" pos="-16, -16" size="32, 32" right_anchor="true" top_anchor="true" texture_name="close_minimap_button">
			var btnClose:ButtonHover = ButtonHover.parse(Resources.MAP_PACK, new XML(xml.activeelement), _bg.width, _bg.height);
			btnClose.x -= _border.x + btnClose.width/2;
			btnClose.y -= _border.y;
			btnClose.addEventListener(Event.TRIGGERED, form.onClose);
			form.addChild(btnClose);
			
			for each (var xmlBtn:XML in xml.level_button) {
				var levelBtn:MapLevelButton = MapLevelButton.parse(xmlBtn, _bg.width, _bg.height);
				levelBtn.state = MapLevelButton.LEVEL_FLAG_EXPERT;
				levelBtn.handlerTriggered = form.onLevelBtn;
				form.addChild(levelBtn);
			}
			
			pos = ScriptHelper.parsePoint(xml.@hide_pos); 
			animObj["hide_pos"] = ScriptHelper.parsePosition(-pos.x, -pos.y, _bg.width, _bg.height, Anchor.ANCHOR_DEFAULT, parentW, parentH);
			
			animObj["hide_scale"] = ScriptHelper.parsePoint(xml.@hide_scale);
			
			animObj["show_angle"] = -ScriptHelper.parseNumber(xml.@show_angle);
			
			animObj["hide_angle"] = -ScriptHelper.parseNumber(xml.@hide_angle);
			
			animObj["hide_alpha"] = ScriptHelper.parseNumber(xml.@hide_alpha);
			
			animObj["effect_time"] = ScriptHelper.parseNumber(xml.@effect_time);
			form.setAnimateInfo(animObj);

			return form;
		}
	}
}