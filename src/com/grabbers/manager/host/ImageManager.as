package com.grabbers.manager.host
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class ImageManager
	{
		protected var _cacheXml:Dictionary;
		protected var _cacheBmd:Dictionary = new Dictionary();
		public function ImageManager()
		{
		}
		
		
		public function init():Boolean {
			_cacheXml = new Dictionary();
			var content:String = App.resourceManager.getConfigXml("scripts/hosts/imagehost.txt");
			if (content == null || content == "") {
				return false;
			}
			
			try {
				var xmlRoot:XML = new XML(content);
				for each (var xml:XML in xmlRoot.children()) {
					var key:String = xml.@name;
					_cacheXml[key] = xml;
				}
			} catch (e:Error) {
				Logger.error(e.message);
				return false;
			}
			
			return true;
		}
		
		public function getHostBitmapData(name:String):BitmapData {
			//<image name="attack_screen" texture="gui01" rect="384, 208, 656, 288">
			if (_cacheXml == null) {
				Logger.error("imagehost not init");
				return null;
			}
			
			var xml:XML = _cacheXml[name];
			if (xml == null) {
				return null;
			}
			
			if (_cacheBmd[name] != null)
				return _cacheBmd[name] as BitmapData;
			
			var texName:String = xml.@texture;
			if (texName == name) {
				Logger.error(name + ": ooops, dead loop");
				return null;
			}
			
			var bmd:BitmapData = App.resourceManager.getBitmapData(xml.@texture);
			if (bmd == null)
				return null;
			
			var rect:Rectangle = ScriptHelper.parseRect(xml.@rect);
			if (rect.isEmpty()) {
				Logger.error(name + " rect is invalid");
				return null;
			}
			
			var bmdSub:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bmdSub.copyPixels(bmd, rect, new Point());
			_cacheBmd[name] = bmdSub;
			
			return bmdSub;
		}
	}
}