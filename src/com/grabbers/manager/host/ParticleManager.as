package com.grabbers.manager.host
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	
	import flash.utils.Dictionary;

	public class ParticleManager
	{
		protected var _cacheXml:Dictionary;
		protected var _cachePar:Dictionary;
		public function ParticleManager() {
		}
		
		public function init():Boolean {
			_cacheXml = new Dictionary();
			var content:String = App.resourceManager.getConfigXml("scripts/hosts/particlehost.txt");
			if (content == null || content == "") {
				return false;
			}
			
			try {
				var xmlRoot:XML = new XML(content);
				for each (var xml:XML in xmlRoot.children()) {
					//<main_pack static="gui,war,map,briefing,animations" dynamic="adfasdf">
					_cacheXml[xml.@name] = xml;
				}
			} catch (e:Error) {
				Logger.error(e.message);
				return false;
			}
			
			return true;
		}
		
		public function getParticle(name:String):void {
			
		}
	}
}