package com.grabbers.ui
{
	import com.grabbers.globals.App;
	import com.grabbers.log.Logger;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import com.grabbers.ui.model.UIObject;

	public class UIUtil
	{
		static private var _bInitComponents:Boolean = false;
		
		public function UIUtil() {
		}		
		
		static public function replaceChild(objToHide:DisplayObject, objToShow:DisplayObject, parent:DisplayObjectContainer = null):void {
			if (parent == null && objToHide != null)
				parent = objToHide.parent;
			if (parent == null)
				return;
			
			if (parent.contains(objToHide)) {
				var index:int = parent.getChildIndex(objToHide);
				if (objToShow != null) {
					objToShow.x = objToHide.x;
					objToShow.y = objToHide.y;
					parent.addChildAt(objToShow, index);
				}
				parent.removeChild(objToHide);								
			} else {
				parent.addChild(objToShow);
			}		
		}
		
	}
}