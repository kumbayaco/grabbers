package com.grabbers.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Scale9Image extends DisplayObjectContainer
	{
		protected var _imgs:Vector.<Image>;
		
		public function Scale9Image() {
			super();
		}
		
		public function get border():Point {
			return new Point(_imgs[0].width, _imgs[0].height);
		}
		
		public function set border(pt:Point):void {			
			_imgs[0].width = pt.x;
			_imgs[0].height = pt.y;
			_imgs[2].width = pt.x;
			_imgs[2].height = pt.y;
			_imgs[6].width = pt.x;
			_imgs[6].height = pt.y;
			_imgs[8].width = pt.x;
			_imgs[8].height = pt.y;
			
			_imgs[1].height = pt.y;
			_imgs[3].width = pt.x;
			_imgs[5].width = pt.x;
			_imgs[7].height = pt.y;
		}
		
		public function init(ltBmp:BitmapData, tBmp:BitmapData, rtBmp:BitmapData,
							 lBmp:BitmapData,  cBmp:BitmapData, rBmp:BitmapData,
							 lbBmp:BitmapData, bBmp:BitmapData, rbBmp:BitmapData):Boolean {
			
			if (lBmp != null && tBmp != null && cBmp == null)
				cBmp = new BitmapData(tBmp.width, lBmp.height, true, 0xffff0000);
			var bmps:Array = [ltBmp, tBmp, rtBmp, lBmp, cBmp, rBmp, lbBmp, bBmp, rbBmp];			
			
			_imgs = new Vector.<Image>();
			
			var u:Number = 0;
			var v:Number = 0;
			for (var i:uint = 0; i < 9; i++) {	
				if (bmps[i] == null) {
					var fakImg:Image = Image.fromBitmap(new Bitmap(new BitmapData(1, 1)));
					fakImg.width = fakImg.height = 0;
					_imgs.push(fakImg);
					continue;
				}
								
				var img:Image = Image.fromBitmap(new Bitmap(bmps[i]));
				
				img.x = u;
				img.y = v;
				
				if (i%3 == 2) {
					u = 0;
					v += img.height;
				} else {
					u += img.width;
				}
				
				img.texture.repeat = true;	
				
				addChild(img);
				_imgs.push(img);
			}
			
			return true;
		}
		
		override public function set width(w:Number):void {
			
			var u:Number = 0;
			var uv:Point;
			for (var i:uint = 0; i < 9; i+=3) {
				var imgC:Image = _imgs[i+1];
				imgC.width = w - _imgs[i].width - _imgs[i+2].width;
				
				u = imgC.width/imgC.texture.width;
				uv = imgC.getTexCoords(1);
				uv.x = u;
				imgC.setTexCoords(1, uv);
				
				uv = imgC.getTexCoords(3);
				uv.x = u;
				imgC.setTexCoords(3, uv);
				
				imgC.x = _imgs[i].width;
				
				_imgs[i+2].x = imgC.x + imgC.width;
			}
		}
		
		override public function set height(h:Number):void {
			
			var v:Number = 0;
			var uv:Point;
			for (var i:uint = 3; i < 6; i++) {
				var imgC:Image = _imgs[i];
				var hh:Number = h - _imgs[i-3].height - _imgs[i+3].height;
				v = hh / imgC.texture.height;
				imgC.height = hh;
				
				uv = imgC.getTexCoords(2);
				uv.y = v;
				imgC.setTexCoords(2, uv);
				
				uv = imgC.getTexCoords(3);
				uv.y = v;
				imgC.setTexCoords(3, uv);
				
				imgC.y = _imgs[i-3].height;
				_imgs[i+3].y = imgC.y + imgC.height;
			}
		}
	}
}