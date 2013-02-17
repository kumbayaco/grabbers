package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.Scale9Image;
	import com.grabbers.ui.UIObjectFactory;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.utils.deg2rad;
	
	public class UIToolBar extends UIForm
	{
		// hide_angle="0" hide_alpha="0.01" effect_time="3000">
		static protected const _parser:Object = {
			name:			function(str:String, obj:UIToolBar, texPack:String):void {obj.name = str;},
			pos: 			function(str:String, obj:UIToolBar, texPack:String):void {obj._pos = ScriptHelper.parsePoint(str);},
			show_angle:		function(str:String, obj:UIToolBar, texPack:String):void {obj._angle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_pos: 		function(str:String, obj:UIToolBar, texPack:String):void {obj._hidePos = ScriptHelper.parsePoint(str);},
			hide_scale:		function(str:String, obj:UIToolBar, texPack:String):void {obj._hideScale = ScriptHelper.parsePoint(str);},
			hide_angle:		function(str:String, obj:UIToolBar, texPack:String):void {obj._hideAngle = -deg2rad(ScriptHelper.parseNumber(str));},
			hide_alpha:		function(str:String, obj:UIToolBar, texPack:String):void {obj._hideAlpha = ScriptHelper.parseNumber(str);},
			effect_time:	function(str:String, obj:UIToolBar, texPack:String):void {obj._effectTime = ScriptHelper.parseNumber(str)/1000; obj._bAnimate = true;},
			show:			function(str:String, obj:UIToolBar, texPack:String):void {obj.visible = ScriptHelper.parseBoolean(str);},
			center_items:	function(str:String, obj:UIToolBar, texPack:String):void {obj._bCenter = ScriptHelper.parseBoolean(str);},
			border:			function(str:String, obj:UIToolBar, texPack:String):void {obj._border = ScriptHelper.parsePoint(str);},
			tile_border:	function(str:String, obj:UIToolBar, texPack:String):void {obj._bBorder = ScriptHelper.parseBoolean(str);},
			vertical:		function(str:String, obj:UIToolBar, texPack:String):void {obj._bVertical = ScriptHelper.parseBoolean(str);},
			matrix:			function(str:String, obj:UIToolBar, texPack:String):void {/*obj._bAnimate = ScriptHelper.parseBoolean(str);*/},
			name_items:		function(str:String, obj:UIToolBar, texPack:String):void {obj._itemButtonType = str;},
			select_sfx_name:function(str:String, obj:UIToolBar, texPack:String):void {obj._sfxHover = str;},
			click_sfx_name:	function(str:String, obj:UIToolBar, texPack:String):void {obj._sfxClick = str;},
			size: 			function(str:String, obj:UIToolBar, texPack:String):void {
				obj._size = ScriptHelper.parsePoint(str);
				if (obj._type == BASIC_V_BAR && obj._bgQuad != null) {
					obj._bgQuad.width = obj._size.x;
					obj._bgQuad.height = obj._size.y;
					obj._bgQuad.color = obj._color;
					obj._bgQuad.alpha = obj._color >> 24;
				}
			},
			texture_theme_name:
				function(str:String, obj:UIForm, texPack:String):void {
					obj._scaleBg = new Scale9Image();
					obj._scaleBg.init(	
						App.resourceManager.getBitmapData(str+"lu", texPack),
						App.resourceManager.getBitmapData(str+"u", texPack),
						App.resourceManager.getBitmapData(str+"ru", texPack),
						App.resourceManager.getBitmapData(str+"l", texPack),
						App.resourceManager.getBitmapData(str+"c", texPack),
						App.resourceManager.getBitmapData(str+"r", texPack),
						App.resourceManager.getBitmapData(str+"ld", texPack),
						App.resourceManager.getBitmapData(str+"d", texPack),
						App.resourceManager.getBitmapData(str+"rd", texPack)
					);
				}
		};
		
		static protected const BASIC_V_BAR:uint = 0;
		static protected const BASIC_H_BAR:uint = 1;
		
//		protected var _bAnimate:Boolean = false;
//		protected var _pos:Point = new Point();
//		protected var _size:Point = new Point();
//		protected var _angle:Number = 0;
//		protected var _color:uint = 0xffffff;
//		protected var _border:Point = new Point();
//		protected var _hidePos:Point = new Point();
//		protected var _hideScale:Point = new Point();
//		protected var _hideAlpha:Number = 1;
//		protected var _hideAngle:Number = 0;
//		protected var _effectTime:Number = 0;
//		protected var _bBorder:Boolean = false;
//		protected var _type:uint;
//		protected var _bgQuad:Quad;
		protected var _margin:uint = 0;
		protected var _indent:uint = 0;
//		protected var _completeHandler:Function;
		protected var _bVertical:Boolean = true;
		protected var _sfxHover:String;
		protected var _sfxClick:String;
		protected var _bCenter:Boolean = true;
		protected var _itemButtonType:String;
		
		public function UIToolBar()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean 
		{
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
				_pos.x = y;
			}
			
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
				var border:Point = _scaleBg.border;
				_scaleBg.width = border.x * 2 + _size.x + 40;
				_scaleBg.height = border.y * 2 + height;
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
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint, texPack:String):Boolean
		{
			if (vXml == null)
				return true;
			
			for each (var xmlBasic:XML in vXml) {
				var att:XML;
				var key:String;
				var val:String;
				var strTag:String = xmlBasic.@name;
				switch (strTag) {
					case "basic_vertical_toolbar":
						/*
						<toolbar name="basic_vertical_toolbar" pos="0, 0" size="128, 256" border="64, 128" margin="8" indent="8" matrix="true" 
							vertical="true" flippable="false" center_items="true" autosize="false" alive="false" visible="false" enable="false" theme="false" tile_border="true" 
							select_sfx_name="selectmenu" click_sfx_name="clickmenu" texture_theme_name="menuform" hide_pos="0, -1000" hide_scale="1, 1" effect_time="1000" sfx_delay="100">
						<bitmap name="left_rope" pos="-62, -384" size="16, 256" top_anchor="true" left_anchor="true" texture_name="rope"></bitmap>
						<bitmap name="right_rope" pos="-62, -384" size="16, 256" top_anchor="true" right_anchor="true" texture_name="rope"></bitmap>
						</toolbar>
						*/
						_type = BASIC_V_BAR;
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this, texPack);
							}
						}
						
						if (_ropeL == null || _ropeR == null) {
							for each (var xmlRope:XML in xmlBasic.bitmap) {
								var bmp:UIBitmap = new UIBitmap();
								if (!bmp.init(xmlRope, _size.x, _size.y, texPack))
									continue;
								
								bmp.image.texture.repeat = true;
								if (bmp.name == "left_rope")
									_ropeL = bmp;
								else
									_ropeR = bmp;
							}
						}
						
						break;
					
					case "basic_horizontal_toolbar":
						/*
						<toolbar name="basic_horizontal_toolbar" pos="0, 0" size="300, 32" margin="8" indent="8" vertical="false" flippable="false" center_items="true" 
							autosize="false" theme="false" color="255, 255, 255, 255" select_sfx_name="selectmenu" click_sfx_name="clickmenu" texture_theme_name="" sfx_delay="100">
						</toolbar>
						*/
						_type = BASIC_H_BAR;
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this, texPack);
							}
						}
						break;
					
					default:
						/*
						<sys_vertical_toolbar name="city_select_toolbar" pos="400, 0" size="144, 700" name_items="icon_checkbutton" visible="false" alive="false">						
							<bitmap name="forward_scroll" pos="-5000, -5000" size="0, 0">
							</bitmap>
							<bitmap name="back_scroll" pos="-5000, -5000" size="0, 0">
							</bitmap>
							<item_list>
								forge_p0_s4_l1;				
							</item_list>	
						</sys_vertical_toolbar>
						*/
						// init self property
						for each (att in xmlBasic.attributes()) {
							key = att.name().toString();
							val = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this, texPack);
							}
						}
						
						// addChild
						var xmlList:XMLList = xmlBasic.children();
						for each (var xmlChild:XML in xmlList) {
							var tagName:String = xmlChild.name();
							switch (tagName) {
								case "item_list":
									var cont:String = xmlChild.toString();
									cont = cont.replace(/[\t;]/g, "");
									var arr:Array = cont.split("\r\n");
									var y:uint = 0;
									for each (var ss:String in arr) {
										if (ss == "")
											continue;
										
										var btn:UICheckButton = UIObjectFactory.createObject(_itemButtonType, parentW, parentH, texPack) as UICheckButton;
										if (btn == null)
											continue;
										
										if (ss == "-") {
											y += btn.height;
											continue;
										}
										
										btn.x = 0;
										btn.y = y;
										btn.name = ss;
										btn.initFromMem(ss != App.resourceManager.getTextString(ss) ? App.resourceManager.getTextString(ss) : " ", _sfxHover, _sfxClick);
										addChild(btn);
										y += btn.height + _margin;
									}
									break;
								
								default:
									var uiObj:UIObject = UIObjectFactory.createObject(tagName, parentW, parentH, texPack);
									if (uiObj == null || !uiObj.init(xmlChild, _size.x, _size.y, texPack))
										continue;
									
									uiObj.x = 0;
									uiObj.y = y;
									
									addChild(uiObj);
									break;
							}
							
						}
						break;
				} // switch end				
			} // for end
			
			return true;
		}
		
//		override public function show(objParent:DisplayObjectContainer, completeHandler:Function):void {
//			if (_bAnimate) {
//				
//				// init bg
//				var border:Point = _scaleBg.border;
//				_scaleBg.width = border.x * 2 + width;
//				_scaleBg.height = border.y * 2 + height;
//				_scaleBg.pivotX = _scaleBg.width >> 1;
//				_scaleBg.pivotY = _scaleBg.height >> 1;
//				_scaleBg.x = pivotX;
//				_scaleBg.y = pivotY;
//				addChildAt(_scaleBg, 0);
//				
//				if (_ropeL != null) {
//					_ropeL.height = objParent.height - _scaleBg.height >> 1;
//					_ropeL.x = _scaleBg.x - _scaleBg.pivotX + 2;
//					_ropeL.y = _scaleBg.y - _scaleBg.pivotY - _ropeL.height;
//					addChildAt(_ropeL, 0);
//				}
//				
//				if (_ropeR != null) {
//					_ropeR.height = objParent.height - _scaleBg.height >> 1;
//					_ropeR.x = _scaleBg.x - _scaleBg.pivotX + _scaleBg.width - 2;
//					_ropeR.y = _scaleBg.y - _scaleBg.pivotY - _ropeL.height;
//					addChildAt(_ropeR, 0);
//				}
//				
//				x = _hidePos.x;
//				y = _hidePos.y;
//				scaleX = 1;
//				scaleY = 1;
//				alpha = _hideAlpha;
//				rotation = _hideAngle;
//				addEventListener(Event.ADDED_TO_STAGE, onAdd);
//			} else {
//				x = _pos.x;
//				y = _pos.y;
//			}
//			
//			objParent.addChild(this);
//			_completeHandler = completeHandler;
//		}
//		
//		override public function hide():void {
//			if (_bAnimate) {
//				Starling.current.juggler.tween(this, _effectTime, 
//					{
//						transition: Transitions.EASE_IN_OUT_BACK,
//						x: _hidePos.x,
//						y: _hidePos.y,
//						scaleX: _hideScale.x,
//						scaleY: _hideScale.y,
//						rotation: _hideAngle,
//						alpha: _hideAlpha,
//						onComplete: onHide
//					});
//			} else {
//				parent.removeChild(this);
//				if (_completeHandler != null)
//					_completeHandler();
//			}
//		}
//		
//		override protected function onAdd(e:Event):void {
//			
//			Starling.current.juggler.tween(this, _effectTime, 
//				{
//					transition: Transitions.EASE_IN_OUT_BACK,
//					x: _pos.x,
//					y: _pos.y,
//					scaleX: 1,
//					scaleY: 1,
//					rotation: _angle,
//					alpha: 1
//				});
//		}
//		
//		override protected function onHide():void {
//			if (contains(_scaleBg))
//				removeChild(_scaleBg);			
//			if (contains(_ropeL))
//				removeChild(_ropeL);
//			if (contains(_ropeR))
//				removeChild(_ropeR);
//			parent.removeChild(this); 
//			if (_completeHandler != null) _completeHandler();
//		}
	}
}