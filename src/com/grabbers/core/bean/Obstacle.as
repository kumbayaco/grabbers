package com.grabbers.core.bean
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Obstacle extends DisplayObjectContainer
	{
		protected var _pos:Point;
		protected var _yPoint:Number;
		protected var _texture:Texture;
		protected var _vImages:Vector.<Image> = new Vector.<Image>();
		protected var _layer:int;
		protected var _bSlide:Boolean;
		protected var _slideSpeed:Point;
		
		public function Obstacle()
		{
			super();
		}
		
		public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			/* 
			<obstacle name="obstacle" pos="434.00, 249.00" y_point="0.00" texture="water_tile" 
				p0="-111.00, 64.00" p1="64.00, 64.00" p2="64.00, -84.00" p3="-111.00, -84.00" 
				layer="-1" sliding="true" slide_speed="-3.00, 15.00">
			*/
			
			name = xml.@name;
			_pos = ScriptHelper.parsePoint(xml.@pos);
			_yPoint = ScriptHelper.parseNumber(xml.@y_point);
			_texture = App.resourceManager.getTexture(xml.@texture, texPack);
			if (_texture == null)
				return false;
			_layer = ScriptHelper.parseNumber(xml.@layer);
			_bSlide = ScriptHelper.parseBoolean(xml.@sliding);
			_slideSpeed = ScriptHelper.parsePoint(xml.@slide_speed);
			
			var keyN:uint = 0;
			do {
				if (!xml.hasOwnProperty("@p" + keyN))
					break;
				var pt:Point = ScriptHelper.parsePoint(xml["@p"+keyN]);
				var img:Image = new Image(_texture);
				img.x = pt.x;
				img.y = pt.y;
				keyN++;
				_vImages.push(img);
			} while(true);
			
			LayoutUtil.setLayoutInfoEx(this, Anchor.ANCHOR_DEFAULT, _pos.x, _pos.y, 0, 0, parentW, parentH);
			
			return true;
		}
	}
}