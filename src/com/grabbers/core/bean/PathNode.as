package com.grabbers.core.bean
{
	import com.grabbers.globals.ScriptHelper;
	
	import flash.geom.Point;

	public class PathNode
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
		
		public function init(xml:XML):Boolean {
			//<path_count_node number="8" radius="10.00" point="-37.00, 108.00" layer="0" sanctuary="false" invisible="false" edge="15,30">
			_id = ScriptHelper.parseNumber(xml.@number);
			_radius = ScriptHelper.parseNumber(xml.@radius);
			_pos = ScriptHelper.parsePoint(xml.@point);
			_layer = ScriptHelper.parseNumber(xml.@layer);
			_bSafePlace = ScriptHelper.parseBoolean(xml.@sanctuary);
			_bVisible = !ScriptHelper.parseBoolean(xml.@invisible);
			
			_neighbors = ScriptHelper.parseDigitArray(xml.@edge);
			
			return true;
		}
	}
}