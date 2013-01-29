package com.grabbers.ui
{
	import com.grabbers.log.Logger;
	import com.grabbers.ui.model.UIObject;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;

	public class LayoutUtil
	{
		public function LayoutUtil() {
		}
		
		static public function setLayoutInfo(target:UIObject, anchor:Anchor, x:int, y:int, parentW:uint, parentH:uint, co:Point=null):void {
			if (target == null || anchor == null) {
				Logger.error("setLayoutInfo parameters error");
				return;
			}
			
			var w:uint = target.width / target.scaleX;
			var h:uint = target.height / target.scaleY;
			switch (anchor.horzAnchor) {
				case Anchor.LEFT_ANCHOR:
					if (co != null) {
						target.pivotX = co.x - x;
						target.x = co.x;
					} else {
						target.pivotX = 0;
					}								
					break;
				
				case Anchor.CENTER_ANCHOR:
					if (co != null) {
						target.pivotX = co.x - ((parentW >> 1) + x - (w>>1));
						target.x = co.x;
					} else {
						target.pivotX = w >> 1;
						target.x = (parentW >> 1) + x;
					}
					break;
				
				case Anchor.RIGHT_ANCHOR:
					if (co != null) {
						target.pivotX = co.x - (parentW + x - w);
						target.x = co.x;
					} else {
						target.pivotX = w;
						target.x = parentW - x;
					}
					break;				
			}
			
			switch (anchor.vertAnchor) {
				case Anchor.TOP_ANCHOR:
					if (co != null) {
						target.pivotY = co.y - y;
						target.y = co.y;
					} else {
						target.pivotY = 0;
						target.y = y;
					}
					break;
				
				case Anchor.CENTER_ANCHOR:
					if (co != null) {
						target.pivotY = co.y - ((parentH>>1) - y - (h>>1));
						target.y = co.y;
					} else {
						target.pivotY = h >> 1;
						target.y = (parentH >> 1) - y;
					}
					break;
				
				case Anchor.BOT_ANCHOR:
					if (co != null) {
						target.pivotY = co.y - (parentH - y - h);
						target.y = co.y;
					} else {
						target.pivotY = h;
						target.y = parentH - y;
					}
					break;
			}
		}
	}
}