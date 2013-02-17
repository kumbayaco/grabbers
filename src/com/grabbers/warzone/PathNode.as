package com.grabbers.warzone
{
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;

	public class PathNode extends DisplayObjectContainer
	{
		protected var _id:uint;
		protected var _radius:Number;
		protected var _pos:Point;
		protected var _layer:int;
		protected var _bSafePlace:Boolean;
		protected var _bVisible:Boolean;
		protected var _neighbors:Array;
		
		public function PathNode() {
		}
		
		public function init(xml:XML, parentW:uint, parentH:uint):Boolean {
			//<path_count_node number="8" radius="10.00" point="-37.00, 108.00" layer="0" sanctuary="false" invisible="false" edge="15,30">
			_id = ScriptHelper.parseNumber(xml.@number);
			_radius = ScriptHelper.parseNumber(xml.@radius);
			_pos = ScriptHelper.parsePoint(xml.@point);
			_layer = ScriptHelper.parseNumber(xml.@layer);
			_bSafePlace = ScriptHelper.parseBoolean(xml.@sanctuary);
			_bVisible = !ScriptHelper.parseBoolean(xml.@invisible);
			
			LayoutUtil.setLayoutInfo(this, Anchor.ANCHOR_DEFAULT, _pos.x, _pos.y, parentW, parentH);
			_pos.x = x;
			_pos.y = y;
			
			_neighbors = ScriptHelper.parseDigitArray(xml.@edge);
			
			return true;
		}
		
		public function get neighbors():Array {
			return _neighbors;
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function get position():Point {
			return _pos;
		}
	}
}