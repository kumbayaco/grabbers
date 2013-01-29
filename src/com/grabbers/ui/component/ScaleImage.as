package com.grabbers.ui.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	public class ScaleImage extends DisplayObjectContainer
	{
		private var _imgs:Vector.<Image> = new Vector.<Image>();
		private var _scaleRegion:Rectangle;
		
		public function get border():Point {
			if (_imgs.length > 0 && _imgs[0] != null)
				return new Point(_imgs[0].width, _imgs[1].height);
			return new Point(0, 0);
		}
		
		public function ScaleImage(bmp:BitmapData, scaleRegion:Rectangle) {			
			super();
			
			var dx:Array = [scaleRegion.left, scaleRegion.width, bmp.width - scaleRegion.right];
			var dy:Array = [scaleRegion.top, scaleRegion.height, bmp.height - scaleRegion.bottom];
			
			_scaleRegion = scaleRegion;
			var u:Number = 0;
			var v:Number = 0;
			for (var i:uint = 0; i < 9; i++) {
				
				var w:uint = dx[i%3];
				var h:uint = dy[i/3 >> 0];
								
				var bmdSub:BitmapData = new BitmapData(w, h, true, 0);
				bmdSub.copyPixels(bmp, new Rectangle(u,v,w,h), new Point(0,0));
				var texture:Texture = Texture.fromBitmapData(bmdSub, false);
				var img:Image = new Image(texture);
				
				img.x = u;
				img.y = v;
				
				if (i%3 == 2) {
					u = 0;
					v += h;
				} else {
					u += w;
				}
				
				img.texture.repeat = true;	
		
				addChild(img);
				_imgs.push(img);
			}
		}
		
		override public function set width(w:Number):void {
			
			var u:Number = 0;
			var uv:Point;
			for (var i:uint = 0; i < 9; i+=3) {
				var imgC:Image = _imgs[i+1];
				imgC.width = w - _imgs[i].texture.width - _imgs[i+2].texture.width;
				
				u = imgC.width/imgC.texture.width;
				uv = imgC.getTexCoords(1);
				uv.x = u;
				imgC.setTexCoords(1, uv);
				
				uv = imgC.getTexCoords(3);
				uv.x = u;
				imgC.setTexCoords(3, uv);
				
				_imgs[i+2].x = imgC.x + imgC.width;
			}
		}
		
		override public function set height(h:Number):void {
			
			var v:Number = 0;
			var uv:Point;
			for (var i:uint = 3; i < 6; i++) {
				var imgC:Image = _imgs[i];
				var hh:Number = h - _imgs[i-3].texture.height - _imgs[i+3].texture.height;
				v = hh / imgC.texture.height;
				imgC.height = hh;
				
				uv = imgC.getTexCoords(2);
				uv.y = v;
				imgC.setTexCoords(2, uv);
				
				uv = imgC.getTexCoords(3);
				uv.y = v;
				imgC.setTexCoords(3, uv);
				
				_imgs[i+3].y = imgC.y + imgC.height;
			}
		}
	}
}