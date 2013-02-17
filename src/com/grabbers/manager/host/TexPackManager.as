package com.grabbers.manager.host
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class TexPackManager
	{
		static public const PACK_DEFAULT:String = "main_pack.swf";
		protected var _cachePack:Dictionary;
		
		public function TexPackManager() {
		}
		
		public function init():Boolean {
			
			_cachePack = new Dictionary();
			var content:String = App.resourceManager.getConfigXml("scripts/hosts/texturehost.txt");
			if (content == null || content == "") {
				return false;
			}
			
			try {
				var xmlRoot:XML = new XML(content);
				for each (var xml:XML in xmlRoot.children()) {
					//<main_pack static="gui,war,map,briefing,animations" dynamic="adfasdf">
					var packName:String = xml.name();
					var staticSet:String = xml.@static;
					var dynSet:String = xml.@dynamic;
					
					var arrStatic:Array = staticSet.split(",");
					var arrDynami:Array = dynSet.split(",");
					
					var arr:Array = new Array();
					for each (var strS:String in arrStatic) {
						if (strS != "")
							arr.push(strS + "_pack.swf");
					}
					for each (var strD:String in arrDynami) {
						if (strD != "")
							arr.push(strD + "_pack.swf");
					}
					
					_cachePack[packName] = arr;
				}
			} catch (e:Error) {
				Logger.error(e.message);
				return false;
			}
			
			return true;
		}
		
		public function getPacks(name:String):Array {
			if (name == null)
				return null;
			
			var swfname:String = name.substring(0, name.indexOf("."));
			
			if (_cachePack[swfname] == null) {
				return [name];
			}
			
			return _cachePack[swfname] as Array;
		}
	}
}