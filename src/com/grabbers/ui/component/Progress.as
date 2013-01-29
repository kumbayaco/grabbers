package com.grabbers.ui.component
{
	import com.grabbers.globals.Global;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.model.UIBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ClippedSprite;
	import starling.textures.Texture;

;
	
//	import starling.textures.Texture;
	
	public class Progress extends Sprite
	{
		private var _fr:UIBitmap = null;
		private var _proc:uint = 0;
		private var _total:uint = 0;
		private var _pt0:Point = new Point();
		private var _pt1:Point = new Point();
		private var _pt2:Point = new Point();
		private var _pt3:Point = new Point();
		
		public function Progress(fr:UIBitmap)
		{
			super();
			if (!fr) {
				Logger.error("Progress resources not init");
				return;
			}
			
			_fr = fr;			
			x = _fr.x - _fr.pivotX;
			y = _fr.y - _fr.pivotY;
			_fr.x = 0;
			_fr.y = 0;			
			_fr.pivotX = 0;
			_fr.pivotY = 0;
			
			_proc = 0;
			_total = 100;
			addChild(_fr);
			updateProg();
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
			_pt0.x = 0; 				_pt0.y = 0;
			_pt1.x = _proc / total; 	_pt1.y = 0;
			_pt2.x = 0;					_pt2.y = 1;
			_pt3.x = _proc / total;		_pt3.y = 1;
			
			_fr.width = _fr.image.texture.width * _proc / total;
			
			_fr.image.setTexCoords(0, _pt0);
			_fr.image.setTexCoords(1, _pt1);
			_fr.image.setTexCoords(2, _pt2);
			_fr.image.setTexCoords(3, _pt3);
		}
	}
}