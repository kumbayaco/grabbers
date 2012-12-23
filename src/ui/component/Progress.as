package ui.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import globals.Global;
	
	import log.Logger;
	
//	import starling.textures.Texture;
	
	public class Progress extends Sprite
	{
		private var _bg:Bitmap = null;
		private var _fr:Bitmap = null;
		private var _mask:Bitmap = null;
		private var _proc:uint = 0;
		private var _total:uint = 0;
		
		public function Progress(bg:BitmapData, fr:BitmapData)
		{
			super();
			if (!bg || !fr) {
				Logger.error("Progress resources not init");
				return;
			}
			
			_bg = new Bitmap(bg);
			_fr = new Bitmap(fr);
			mouseEnabled = false;
			
			_mask = new Bitmap(new BitmapData(_bg.width, _bg.height));
			_mask.bitmapData.draw(_bg);
			_mask.cacheAsBitmap = true;
			_fr.mask = _mask;
			
			addChild(_bg);
			addChild(_fr);
			addChild(_mask);
			
			_proc = proc;
			_total = total;
			updateProg();
		}
		
		public function get progWidth():uint {
			return _bg.width;
		}
		
		public function get progHeight():uint {
			return _bg.height;
		}
		
		public function get proc():uint
		{
			return _proc;
		}

		public function get total():uint
		{
			return _total;
		}

		public function set proc(proc:uint):void 
		{
			_proc = proc;
			updateProg();
		}
		
		public function set total(total:uint):void
		{
			_total = total;
			updateProg();
		}
		
		private function updateProg():void
		{
			_mask.x = -_mask.width + _mask.width * _proc / _total;
		}
	}
}