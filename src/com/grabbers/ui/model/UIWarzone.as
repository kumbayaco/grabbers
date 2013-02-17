package com.grabbers.ui.model
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.UIObjectFactory;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import com.grabbers.warzone.Warzone;

	public class UIWarzone extends UIObject
	{
		protected var _size:Point;
		protected var _objMap:Dictionary = new Dictionary();
		protected var _warzone:Warzone;
		
		public function UIWarzone()
		{
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			/*
			<warzone name="warzone" pos="0, 0" size="1280, 768" left_anchor="true" right_anchor="true" background_texture="empty">
			<truce_button/>
			<slow_button/>
			<haste_button/>
			<tornado_button/>
			<plague_button/>
			<condom_button/>
			<toredown_button/>
			<invisibility_button/>
			<shield_button/>
			<target_button/>
			<fireball_button/>
			<turncoat_button/>
			<lightning_button/>
			<dynamite_button/>
			<invulnerability_button/>
			<freeze_button/>
			<bloodlust_button/>
			<babyboom_button/>
			<drunk_button/>
			<overpop_button/>
			<indoctrinate_button/>
			</warzone>
			*/
			_size = ScriptHelper.parsePoint(xml.@size);
			name = xml.@name;
			
			// add child
			var xmlList:XMLList = xml.children();
			for each (var xmlChild:XML in xmlList) {
				var tagName:String = xmlChild.name();
				var uiObj:UIObject = UIObjectFactory.createObject(tagName, _size.x, _size.y, texPack);
				if (uiObj == null || !uiObj.init(xmlChild, _size.x, _size.y, texPack))
					continue;
				
				_objMap[uiObj.name] = uiObj;
			}	
			
			LayoutUtil.setLayoutInfoEx(this, Anchor.ANCHOR_DEFAULT, 0, 0, _size.x, _size.y, parentW, parentH);
			
			return true;
		}
		
		public function updateWarzone(name:String, texPack:String):Boolean {
			if (_warzone != null && _warzone.name == name)
				return true;
			
			if (_warzone != null && contains(_warzone)) {
				removeChild(_warzone);
				_warzone = null;
			}
			
			var content:String = App.resourceManager.getConfigXml("scripts/levels/" + App.levelManager.curLevel + ".txt");
			if (content == null || content == "") {
				Logger.error("level " + App.levelManager.curLevel + " not found");
				return false;
			}
			
			_warzone = new Warzone();
			if (!_warzone.init(new XML(content), App.sceneWidth, App.sceneHeight, texPack)) {
				Logger.error(name + ": warzone init failed");
				return false;
			}
			
			addChildAt(_warzone, 0);
			this.name = name;
			return true;
		}
	}
}