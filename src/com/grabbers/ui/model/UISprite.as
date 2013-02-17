package com.grabbers.ui.model
{	
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.ui.LayoutUtil;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;

	public class UISprite extends UIObject
	{
		protected var _mc:MovieClip = null;
		
		public function UISprite() {
			super();
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			//<sprite name="fire_candle" pos="493, -52" anim_name="fire_anim">
			_mc = App.resourceManager.getAnim(xml.@anim_name);
			if (_mc == null)
				return false;
			
			addChild(_mc);
			name = xml.@name;
			var pos:Point = ScriptHelper.parsePoint(xml.@pos);
			LayoutUtil.setLayoutInfo(this, ScriptHelper.parseAnchorType(xml), pos.x, pos.y, parentW, parentH);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			return true;
		}
		
		protected function onAdd(e:Event):void {
			Starling.current.juggler.add(_mc);
		}
		
		protected function onRemove(e:Event):void {
			Starling.current.juggler.remove(_mc);
		}
	}
}