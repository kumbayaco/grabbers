package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.Scale9Image;
	import com.grabbers.ui.UIObjectFactory;
	import com.grabbers.ui.UIUtil;
	import com.grabbers.ui.component.ScaleImage;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	public class UIForm extends UIObject
	{
		static protected const BASIC_FORM:uint = 0;
		static protected const VIRTUAL_FORM:uint = 1;
		
		protected var _bAnimate:Boolean = false;
		protected var _pos:Point = new Point();
		protected var _size:Point = new Point();
		protected var _angle:Number = 0;
		protected var _color:uint = 0xffffff;
		protected var _border:Point = new Point();
		protected var _hidePos:Point = new Point();
		protected var _hideScale:Point = new Point();
		protected var _hideAlpha:Number = 1;
		protected var _hideAngle:Number = 0;
		protected var _effectTime:Number = 0;
		protected var _bBorder:Boolean = false;
		protected var _type:uint;
		protected var _bgQuad:Quad;
		protected var _completeHandler:Function;
		
		protected var _scaleBg:Scale9Image; 
		protected var _ropeL:UIBitmap;
		protected var _ropeR:UIBitmap;
		
		// hide_angle="0" hide_alpha="0.01" effect_time="3000">
		static protected const _parser:Object = {
			name:			function(str:String, obj:UIForm):void {obj.name = str;},
			pos: 			function(str:String, obj:UIForm):void {obj._pos = ScriptHelper.parsePoint(str);},
			show_angle:		function(str:String, obj:UIForm):void {obj._angle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_pos: 		function(str:String, obj:UIForm):void {obj._hidePos = ScriptHelper.parsePoint(str);},
			hide_scale:		function(str:String, obj:UIForm):void {obj._hideScale = ScriptHelper.parsePoint(str);},
			hide_angle:		function(str:String, obj:UIForm):void {obj._hideAngle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_alpha:		function(str:String, obj:UIForm):void {obj._hideAlpha = ScriptHelper.parseNumber(str);},
			effect_time:	function(str:String, obj:UIForm):void {obj._effectTime = ScriptHelper.parseNumber(str)/1000; obj._bAnimate = true;},
			show:			function(str:String, obj:UIForm):void {obj.visible = ScriptHelper.parseBoolean(str);},
			border:			function(str:String, obj:UIForm):void {obj._border = ScriptHelper.parsePoint(str);},
			tile_border:	function(str:String, obj:UIForm):void {obj._bBorder = ScriptHelper.parseBoolean(str);},
			matrix:			function(str:String, obj:UIForm):void {/*obj._bAnimate = ScriptHelper.parseBoolean(str);*/},
			color:			function(str:String, obj:UIForm):void {obj._color = ScriptHelper.parseColor(str);},
			size: 			function(str:String, obj:UIForm):void {
				obj._size = ScriptHelper.parsePoint(str);
				
				obj._bgQuad = new Quad(1, 1, 0);
				obj._bgQuad.touchable = false;
				obj._bgQuad.width = obj._size.x;
				obj._bgQuad.height = 1;
				obj._bgQuad.alpha = 0;
				obj.addChildAt(obj._bgQuad, 0);
				if (obj._type == VIRTUAL_FORM) {
					obj._bgQuad.height = obj._size.y;
					obj._bgQuad.color = obj._color;
					obj._bgQuad.alpha = Color.getAlpha(obj._color) / 255;
				}
			},
			texture_theme_name:
							function(str:String, obj:UIForm):void {
								obj._scaleBg = new Scale9Image();
								if (!obj._scaleBg.init(	
										App.resourceManager.getUniqueBitmapData(str+"lu"),
										App.resourceManager.getUniqueBitmapData(str+"u"),
										App.resourceManager.getUniqueBitmapData(str+"ru"),
										App.resourceManager.getUniqueBitmapData(str+"l"),
										App.resourceManager.getUniqueBitmapData(str+"c"),
										App.resourceManager.getUniqueBitmapData(str+"r"),
										App.resourceManager.getUniqueBitmapData(str+"ld"),
										App.resourceManager.getUniqueBitmapData(str+"d"),
										App.resourceManager.getUniqueBitmapData(str+"rd")
									)) {
									Logger.error("scale image init failed. " + str);
									obj._scaleBg = null;
								} else {
									obj._scaleBg.border = obj._border;
								}
							}
		};
		
		public function UIForm()
		{
			super();
		}
		
		public function show(objParent:DisplayObjectContainer, completeHandler:Function):void {
			if (_bAnimate) {
				
				
				x = _hidePos.x;
				y = _hidePos.y;
				scaleX = 1;
				scaleY = 1;
				alpha = _hideAlpha;
				rotation = _hideAngle;
				addEventListener(Event.ADDED_TO_STAGE, onAdd);
			} else {
				x = _pos.x;
				y = _pos.y;
			}
			
			objParent.addChild(this);
			_completeHandler = completeHandler;
		}
		
		public function hide(handler:Function = null):void {
			if (_bAnimate) {
				Starling.current.juggler.tween(this, _effectTime, 
					{
						transition: Transitions.EASE_IN_OUT_BACK,
						x: _hidePos.x,
						y: _hidePos.y,
						scaleX: _hideScale.x,
						scaleY: _hideScale.y,
						rotation: _hideAngle,
						alpha: _hideAlpha,
						onComplete: function():void{onHide(); if (handler != null) handler();} 
					});
			} else {
				parent.removeChild(this);
				if (_completeHandler != null)
					_completeHandler();
			}
		}
		
		protected function onHide():void {
//			if (contains(_scaleBg))
//				removeChild(_scaleBg);			
//			if (contains(_ropeL))
//				removeChild(_ropeL);
//			if (contains(_ropeR))
//				removeChild(_ropeR);
			parent.removeChild(this); 
			if (_completeHandler != null) _completeHandler();
		}
		
		protected function onAdd(e:Event):void {
			
			Starling.current.juggler.tween(this, _effectTime, 
				{
					transition: Transitions.EASE_IN_OUT_BACK,
					x: _pos.x,
					y: _pos.y,
					scaleX: 1,
					scaleY: 1,
					rotation: _angle,
					alpha: 1
				});
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean 
		{
			/*
			<basic_form name="ingame_save_quit" pos="0, 0" size="300, 172" show="false">
			<text name="exit_caption" pos="0, 0" font_size="36" text_align="center" text_key="exit_caption" top_anchor="true">
			</text>
			<basic_button name="save_quit" pos="0, 80" top_anchor="true">
			</basic_button>
			<basic_button name="cancel" pos="0, 128" top_anchor="true">
			</basic_button>
			</basic_form>
			*/
			
			// init self property
			for each (var att:XML in xml.attributes()) {
				var key:String = att.name().toString();
				var val:String = att.toString();
				if (_parser.hasOwnProperty(key)) {
					_parser[key](val, this);
				}
			}
			
			// add child
			var xmlList:XMLList = xml.children();
			for each (var xmlChild:XML in xmlList) {
				var tagName:String = xmlChild.name();
				var uiObj:UIObject = UIObjectFactory.createObject(tagName, _size.x, _size.y);
				if (uiObj == null || !uiObj.init(texPack, xmlChild, _size.x, _size.y))
					continue;
					
				addChild(uiObj);
			}		
			
			
			// init position
			var anchor:Anchor = ScriptHelper.parseAnchorType(xml);
			if (_bAnimate) {
				LayoutUtil.setLayoutInfo(this, anchor, _pos.x, _pos.y, parentW, parentH);
				_pos.x = x;
				_pos.y = y;
				
				LayoutUtil.setLayoutInfo(this, anchor, _hidePos.x, -_hidePos.y, parentW, parentH);
				_hidePos.x = x;
				_hidePos.y = y;
			} else {
				LayoutUtil.setLayoutInfo(this, anchor, _pos.x, _pos.y, parentW, parentH);
				_pos.x = x;
				_pos.y = y;
			}			
			pivotX = _size.x >> 1;
			pivotY = _size.y >> 1;
			
			if (visible) {
				x = _pos.x;
				y = _pos.y;
			} else {
				x = _hidePos.x;
				y = _hidePos.y;
			}
			
			rotation = _angle;
			
			if (_scaleBg != null) {
				// init bg
				_scaleBg.width = _border.x * 2 + _size.x;
				_scaleBg.height = _border.y * 2 + _size.y;
				_scaleBg.pivotX = _scaleBg.width >> 1;
				_scaleBg.pivotY = _scaleBg.height >> 1;
				_scaleBg.x = pivotX;
				_scaleBg.y = pivotY;
				addChildAt(_scaleBg, 0);
				
				if (_ropeL != null) {
					_ropeL.height = parentH - _scaleBg.height >> 1;
					_ropeL.x = _scaleBg.x - _scaleBg.pivotX + 2;
					_ropeL.y = _scaleBg.y - _scaleBg.pivotY - _ropeL.height;
					addChildAt(_ropeL, 0);
				}
				
				if (_ropeR != null) {
					_ropeR.height = parentH - _scaleBg.height >> 1;
					_ropeR.x = _scaleBg.x - _scaleBg.pivotX + _scaleBg.width - 2;
					_ropeR.y = _scaleBg.y - _scaleBg.pivotY - _ropeL.height;
					addChildAt(_ropeR, 0);
				}
			}
			
			return true;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean 
		{
			if (vXml == null)
				return true;
			
			for each (var xmlBasic:XML in vXml) {
				
				var att:XML;
				var key:String;
				var val:String;
				var strTag:String = xmlBasic.@name;
				switch (strTag) {
					case "basic_form":
						_type = BASIC_FORM;
						/*
						basic_form
						<form name="basic_form" pos="0, 0" size="256, 256" border="64, 128" theme="false" tile_border="true" texture_theme_name="menuform" 
						matrix="true" hide_pos="0, -1000" hide_scale="1, 1" effect_time="1000">	
						<bitmap name="left_rope" pos="-62, -384" size="16, 256" top_anchor="true" left_anchor="true" texture_name="rope">
						</bitmap>
						<bitmap name="right_rope" pos="-62, -384" size="16, 256" top_anchor="true" right_anchor="true" texture_name="rope">
						</bitmap>
						</form>
						*/
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							}
						}
						
						if (_ropeL == null || _ropeR == null) {
							for each (var xmlRope:XML in xmlBasic.bitmap) {
								var bmp:UIBitmap = new UIBitmap();
								bmp.init(null, xmlRope, _size.x, _size.y);
								bmp.image.texture.repeat = true;
								if (bmp.name == "left_rope")
									_ropeL = bmp;
								else
									_ropeR = bmp;
							}
						}
						
						break;					
						
					
					case "virtual_form":						
						/*
						<form name="virtual_form" pos="0, 0" size="256, 256" theme="false" color="0, 0, 0, 0" show="false" matrix="true" 
						hide_pos="0, 0" hide_scale="1, 1" show_angle="0" hide_angle="0" hide_alpha="0.01" effect_time="3000">
						</form>
						*/
						_type = VIRTUAL_FORM;
//						for each (att in xmlBasic.attributes()) {
//							key = att.name().toString();
//							val = att.toString();
//							if (_parser.hasOwnProperty(key)) {
//								_parser[key](val, this);
//							}
//						}
						break;
					
					default:
						/*
						<basic_form name="exit_game_dialog" pos="0, 0" size="440, 100">
						<text name="exit_game_caption" pos="0, 0" font_size="36" text_align="center" text_key="exit_game_caption" top_anchor="true">
						</text>
						<basic_button name="yes" size="180, 40" pos="-120, 80" top_anchor="true">
						</basic_button>
						<basic_button name="no" size="180, 40" pos="120, 80" top_anchor="true">
						</basic_button>		
						</basic_form>
						*/
						// init self property
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							}
						}
						
						// addChild
						var xmlList:XMLList = xmlBasic.children();
						for each (var xmlChild:XML in xmlList) {
							var tagName:String = xmlChild.name();
							var uiObj:UIObject = UIObjectFactory.createObject(tagName, parentW, parentH);
							var vXmls:Vector.<XML> = UIObjectFactory.getObjectBasicXml(tagName);
							if (uiObj == null || !uiObj.init(null, xmlChild, _size.x, _size.y))
								continue;
							
							addChild(uiObj);
						}	
						break;
				}
			}
			
			return true;
		}
	}
}