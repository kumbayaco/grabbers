package manager
{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import log.Logger;

	public class ResourceManager
	{
		private var _assets:Dictionary = new Dictionary();
		
		public function ResourceManager() {
		}
		
		public function regAsset(name:String, domain:ApplicationDomain):void {
			_assets[name] = domain;
		}
		
		public function getBitmap(key:String, url:String):Bitmap {
			var data:BitmapData = getBitmapData(key, url);
			if (data != null) 
				return new Bitmap(data);
			return null;
		}
		
		public function getBitmapData(url:String, key:String):BitmapData {
			if (_assets[url] == null) {
				Logger.error("asset " + url + " not exist");
				return null;
			}
			
			var claz:Class = (_assets[url] as ApplicationDomain).getDefinition(key) as Class;
			if (claz == null) {
				Logger.error("definition " + key + " not exist in " + url);
				return null;
			}
			
			return new claz() as BitmapData;
		}		
	}
}