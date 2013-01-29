package com.grabbers.scene
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.manager.SceneManager;
	import com.grabbers.ui.component.AnimateImage;
	import com.grabbers.ui.component.ButtonHover;
	import com.grabbers.ui.component.ButtonImage;
	import com.grabbers.ui.component.FormElement;
	import com.grabbers.ui.component.Hint;
	import com.grabbers.ui.component.Label;
	import com.grabbers.ui.component.MapForm;
	
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class MapScene2 extends Sprite implements IScene
	{
		private var _bInitResource:Boolean = false;
		private var _bInitUI:Boolean = false;
		private var _objDict:Dictionary = new Dictionary();
		private var _btnDict:Dictionary = new Dictionary();
		private var _mapDict:Dictionary = new Dictionary();
		private var _curMap:MapForm;
		
		public function MapScene2() {
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event = null):void {
			if (!_bInitResource) {
				initResource();
			} else {
				if (!_bInitUI)
					initUI();
								
				App.soundManager.playTheme("map_theme");		
			}
		}
		
		private function initResource():void {
			_bInitResource = true;
			onAdd();
		}
		
		private function initUI():void {
			var xmlContent:String = App.resourceManager.getConfigXml("scripts/interfaces/mapinterface.txt");
			var xml:XML = new XML(xmlContent);				
			var texPack:String = xml.@texture_pack + ".swf";
			
			var xmlList:XMLList = xml.children();
			for (var i:uint = 0; i < xmlList.length(); i++) {
				var obj:DisplayObject = null;
				switch (xmlList[i].name().localName) {
					case "bitmap":
						obj = AnimateImage.parse(texPack, xmlList[i]);
						break;
					
					case "activeelement":
						obj = ButtonHover.parse(texPack, xmlList[i]);
						break;
										
					case "basic_button":
						////<text name="caption" pos="13, 0" text_align="center" font_size="28" text_key="share_caption">
						obj = ButtonHover.parseBasic(Resources.GUI_PACK, xmlList[i]);
						break;
					
					case "form":
						obj = FormElement.parse(texPack, xmlList[i]);
						var texForm:Texture = App.resourceManager.getTexture(Resources.MAP_PACK, xmlList[i].@texture_theme_name + "c");
						if (obj != null && texForm != null) {
							var img:Image = new Image(texForm);
							img.touchable = false;
							(obj as FormElement).addChildAt(img, 0);
						}
						break;
						
					case "virtual_form":
						obj = FormElement.parse(texPack, xmlList[i]);
						(obj as FormElement).customShape = true;
						break;
					
					case "text":
						obj = Label.parse(xmlList[i]);
						break;
					
					case "map_form":
						obj = MapForm.parse(texPack, xmlList[i], App.stage.stageWidth, App.stage.stageHeight);
						_mapDict[obj.name] = obj;
						break;
					
					case "sprite":
						obj = AnimSprite.parse(xmlList[i], App.stage.stageWidth, App.stage.stageHeight);
						break;
				}
				
				if (obj != null && !(obj is Hint) && !(obj is MapForm)) {
					if (obj.visible)
						addChild(obj);
					obj.visible = true;
					_objDict[obj.name] = obj;
					
					if (obj is ButtonHover) {
						_btnDict[obj.name] = obj;
						obj.addEventListener(Event.TRIGGERED, btnHandler);
					}
					
					if (obj is FormElement) {
						obj.touchable = true;
						obj.addEventListener(TouchEvent.TOUCH, mapHandler);
					}
					
					if (obj is MovieClip) {
						Starling.current.juggler.add(obj as MovieClip);
					}
				}
			}
			
			_bInitUI = true;
		}
		
		public function enter():void {
			App.stage.addChildAt(this, 0);
		}
		
		public function exit():void {
			App.stage.removeChild(this);
		}
		
		private function btnHandler(e:Event):void {
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			if (obj == null)
				return;
			
			switch (obj.name) {
				case "exit":
					App.sceneManager.enterScene(SceneManager.SCENE_MENU);
					break;
			}
		}
		
		private function mapHandler(e:TouchEvent):void {
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			if (obj == null || e.getTouch(obj, TouchPhase.ENDED) == null)
				return;
			
			if (_curMap != null && _curMap.parent != null)
				_curMap.parent.removeChild(_curMap);
			
			var mapName:String = obj.name.substr(0, obj.name.length - "_region".length) + "_minimap";
			App.stage.addChild(_mapDict[mapName]);
			_curMap = _mapDict[mapName] as MapForm;
		}
	}
}
import com.grabbers.globals.App;
import com.grabbers.globals.ScriptHelper;
import com.grabbers.ui.type.Anchor;
import flash.geom.Point;
import starling.display.MovieClip;

class AnimSprite {
	static public function parse(xml:XML, parentW:uint, parentH:uint):MovieClip {
		//<sprite name="fire_candle" pos="493, -52" anim_name="fire_anim">
		var pos:Point = ScriptHelper.parsePoint(xml.@pos);
		var mc:MovieClip = App.resourceManager.getAnim(xml.@anim_name);
//		var mc:MovieClip = App.resourceManager.getAnim("indoctrinate_magic");
		
		if (mc == null)
			return null;
		
		pos = ScriptHelper.parsePosition(pos.x, pos.y, mc.width, mc.height, Anchor.ANCHOR_DEFAULT, parentW, parentH);
		mc.x = pos.x;
		mc.y = pos.y;
		mc.name = xml.@name;
		mc.touchable = false;
		
		return mc;
	}
}