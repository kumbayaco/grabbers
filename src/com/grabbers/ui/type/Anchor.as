package com.grabbers.ui.type
{
	import flash.utils.Dictionary;

	public class Anchor
	{
		public static const TOP_ANCHOR:String = "top";
		public static const BOT_ANCHOR:String = "bottom";
		public static const LEFT_ANCHOR:String = "left";
		public static const RIGHT_ANCHOR:String = "right";
		public static const CENTER_ANCHOR:String = "center";
		
		protected static var _pools:Dictionary = new Dictionary();
		public static const ANCHOR_DEFAULT:Anchor = new Anchor(CENTER_ANCHOR, CENTER_ANCHOR);
		
		private var _horzAnchor:String = CENTER_ANCHOR;
		private var _vertAnchor:String = CENTER_ANCHOR;
		public function Anchor(horz:String, vert:String) {
			_horzAnchor = horz;
			_vertAnchor = vert;
			_pools[horz+","+vert] = this;
		}
		
		public static function getAnchor(horz:String, vert:String):Anchor {
			var tok:String = horz + "," + vert;
			if (_pools[tok] == null) {
				_pools[tok] = new Anchor(horz, vert); 
			}
			
			return _pools[tok] as Anchor;
		}
		
		public function get horzAnchor():String {
			return _horzAnchor;
		}
		
		public function get vertAnchor():String {
			return _vertAnchor;
		} 
	}
}