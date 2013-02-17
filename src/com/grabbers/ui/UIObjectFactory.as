package com.grabbers.ui
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	import com.grabbers.manager.host.TexPackManager;
	import com.grabbers.ui.model.UIActiveElement;
	import com.grabbers.ui.model.UIBalloon;
	import com.grabbers.ui.model.UIBitmap;
	import com.grabbers.ui.model.UICheckBox;
	import com.grabbers.ui.model.UICheckButton;
	import com.grabbers.ui.model.UICity;
	import com.grabbers.ui.model.UIComponentPalette;
	import com.grabbers.ui.model.UIEditBox;
	import com.grabbers.ui.model.UIForm;
	import com.grabbers.ui.model.UIHint;
	import com.grabbers.ui.model.UIImageShow;
	import com.grabbers.ui.model.UIMapLevelButton;
	import com.grabbers.ui.model.UIObject;
	import com.grabbers.ui.model.UISlider;
	import com.grabbers.ui.model.UISpellButton;
	import com.grabbers.ui.model.UISprite;
	import com.grabbers.ui.model.UIText;
	import com.grabbers.ui.model.UITextBox;
	import com.grabbers.ui.model.UIToolBar;
	import com.grabbers.ui.model.UIWarzone;
	import com.grabbers.warzone.Warzone;
	
	import flash.utils.Dictionary;

	public class UIObjectFactory
	{
		static private var _bInit:Boolean;
		static private var _dictObj:Dictionary;
		
		public function UIObjectFactory() {
		}
		
		static public function createObject(modelType:String, pW:uint, pH:uint, texPack:String = TexPackManager.PACK_DEFAULT):UIObject {
			if (_dictObj != null && _dictObj[modelType] != null) {
				var modInfo:ModelInfo = _dictObj[modelType] as ModelInfo;
				var obj:UIObject = new modInfo.claz() as UIObject;
				if (!obj.initBasic(UIObjectFactory.getObjectBasicXml(modelType), pW, pH, texPack))
					return null;
				
				return obj;
			}
			return null;
		}
		
		static public function getObjectBasicXml(modelType:String):Vector.<XML> {
			if (_dictObj != null && _dictObj[modelType] != null) {
				var modInfo:ModelInfo = _dictObj[modelType] as ModelInfo;
				var cont:XmlContent = modInfo.content;
				if (cont == null)
					return null;
				
				var vXml:Vector.<XML> = new Vector.<XML>();
				while (cont != null) {
					vXml.push(cont.content);
					cont = cont.parent;					
				}
				vXml.reverse();
				return vXml;
			}
			return null;
		}
		
		static public function init():void {
			if (_bInit)
				return;
			
			var arrFiles:Array = [	
				"basic_editbox.txt", 
				"basic_textbox.txt",
				"city.txt",
				"extra_components.txt",
				"menu_toolbar.txt",
				"simple_balloon.txt",
				"splash.txt",
				"splasher.txt",
				"spell_buttons.txt",
				"map_form.txt",
				"basic_form.txt",
				"statistics.txt",
				"edit_level.txt",
				"edit_player.txt",
				"spell_selection.txt",
			];
			
			var classDict:Object = {
				"editbox": UIEditBox,
				"form": UIForm,
				"city": UICity,
				"hint": UIHint,
				"slider": UISlider,
				"textbox": UITextBox,
				"bitmap": UIBitmap,
				"spellbutton": UISpellButton,
				"maplevelbutton": UIMapLevelButton,
				"checkbutton": UICheckButton,
				"toolbar": UIToolBar,
				"balloon": UIBalloon,
				"checkbox": UICheckBox,
				"componentpalette": UIComponentPalette,
				"imageshow": UIImageShow
			}
			
			_dictObj = new Dictionary();
			_dictObj["form"] = new ModelInfo(UIForm, null);
			_dictObj["text"] = new ModelInfo(UIText, null);
			_dictObj["activeelement"] = new ModelInfo(UIActiveElement, null);
			_dictObj["bitmap"] = new ModelInfo(UIBitmap, null);
			_dictObj["sprite"] = new ModelInfo(UISprite, null);
			_dictObj["warzone"] = new ModelInfo(UIWarzone, null);
			
			for (var i:uint = 0; i < arrFiles.length; i++) {
				var xml:XML;
				var str:String = "<e>" + App.resourceManager.getConfigXml("scripts/components/" + arrFiles[i]) + "</e>";
				try {
					xml = new XML(str);
				} catch (e:Error) {
					Logger.error(arrFiles[i] + " is not a valid xml file. [" + e.message + "]");
					continue;
				}
				
				var list:XMLList = xml.children();
				for (var j:uint = 0; j < list.length(); j++) {
					var xmlBasic:XML = list[j];
					var xmlParent:XmlContent = null;
					
					var nameBasic:String = xmlBasic.name();
					if (nameBasic == null)
						continue;					
					var claz:Class = classDict[nameBasic];
					if (claz == null) {
						if (_dictObj[nameBasic] != null) {
							claz = (_dictObj[nameBasic] as ModelInfo).claz;
							xmlParent = (_dictObj[nameBasic] as ModelInfo).content;
						}
					}
					
					if (claz == null) {
						Logger.error("unrecognized basic model: " + nameBasic);
						continue;
					}
					
					var nameModel:String = xmlBasic.@name;
					_dictObj[nameModel] = new ModelInfo(claz, new XmlContent(xmlBasic, xmlParent));
				}
			}
			
			_bInit = true;
		}
	}
}

class ModelInfo {
	public var claz:Class;
	public var content:XmlContent;
	public function ModelInfo(clz:Class, xmlContent:XmlContent) {
		claz = clz;
		content = xmlContent;
	}
}

class XmlContent {
	public var parent:XmlContent;
	public var content:XML;
	public function XmlContent(xml:XML, parentCont:XmlContent = null) {
		content = xml;
		parent = parentCont;
	}
}