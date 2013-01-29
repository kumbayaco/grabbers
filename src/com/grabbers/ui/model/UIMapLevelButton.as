package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.manager.ResourceManager;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.UIObjectFactory;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	public class UIMapLevelButton extends UIObject
	{
		static protected const _parser:Object = {
			name:			function(str:String, obj:UIMapLevelButton):void {obj.name = str;},
			size: 			function(str:String, obj:UIMapLevelButton):void {obj._size = ScriptHelper.parsePoint(str);},
			pos: 			function(str:String, obj:UIMapLevelButton):void {obj._pos = ScriptHelper.parsePoint(str);},
			enable:			function(str:String, obj:UIMapLevelButton):void {obj._enable = ScriptHelper.parseBoolean(str);}
		};
		
		protected var _size:Point = new Point();
		protected var _pos:Point = new Point();
		protected var _enable:Boolean = true;
		protected var _imgLevel:Image;
		
		public function UIMapLevelButton()
		{
			super();
		}
		
		override public function init(texPack:String, xml:XML, parentW:uint, parentH:uint):Boolean 
		{
			/*
			<level_button name="st1_forest01" pos="0, 183">
			<number text_key="1">
			</number>
			</level_button>
			*/
			// self
			for each (var att:XML in xml.attributes()) {
				var key:String = att.name().toString();
				var val:String = att.toString();
				if (_parser.hasOwnProperty(key)) {
					_parser[key](val, this);
				}
			}
			
			for each (var xmlN:XML in xml.number) {
				var text:UIText = getChildByName("number") as UIText;
				if (text != null)
					text.update(xmlN.@text_key, text.fontSize);
			}
			
			LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), _pos.x, _pos.y, parentW, parentH);
			
			return true;
		}
		
		override public function initBasic(vXml:Vector.<XML>, parentW:uint, parentH:uint):Boolean 
		{
			/*
			<maplevelbutton name="level_button" size="64, 64" visible="true" enabled="false">
			<bitmap name="selection" texture_name="level_selector" pos="0, -13" size="96, 88" visible="false" 
				pulsating="true" pulse_factor="7" pulse_speed="0.4" color="255, 255, 255, 196"
			</bitmap>
			<bitmap name="locked_picture" texture_name="level_locked" pos="0, -15" size="64, 64">
			</bitmap>
			<activeelement name="unlocked_picture" texture_name="level_unlocked" pos="0, 0" size="64, 64">
			</activeelement>
			<activeelement name="normal_flag_picture" texture_name="level_flag_normal" pos="0, 0" size="64, 64">
			</activeelement>
			<activeelement name="hard_flag_picture" texture_name="level_flag_hard" pos="0, 0" size="64, 64">
			</activeelement>
			<activeelement name="expert_flag_picture" texture_name="level_flag_expert" pos="0, 0" size="64, 64">
			</activeelement>
			<bitmap name="normal_star_picture" texture_name="level_star_normal" pos="0, 0" size="64, 64">
			</bitmap>
			<bitmap name="hard_star_picture" texture_name="level_star_hard" pos="0, 0" size="64, 64">
			</bitmap>
			<bitmap name="expert_star_picture" texture_name="level_star_expert" pos="0, 0" size="64, 64">
			</bitmap>
			<text name="number" pos="0, -21" color="255, 255, 0, 255" font_size="19" text_align="center" text_key="9">
			</text>
			</maplevelbutton>
			*/
			for each (var xml:XML in vXml) {
				var tagName:String = xml.@name;
				switch (tagName) {
					case "level_button":
						// self
						for each (var att:XML in xml.attributes()) {
							var key:String = att.name().toString();
							var val:String = att.toString();
							if (_parser.hasOwnProperty(key)) {
								_parser[key](val, this);
							}
						}
						
						// addChild
						var xmlList:XMLList = xml.children();
						for each (var xmlChild:XML in xmlList) {
							var childName:String = xmlChild.name();
							var uiObj:UIObject = UIObjectFactory.createObject(childName, parentW, parentH);
							var vXmls:Vector.<XML> = UIObjectFactory.getObjectBasicXml(childName);
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