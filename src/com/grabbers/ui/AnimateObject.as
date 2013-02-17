package com.grabbers.ui
{
	import com.grabbers.globals.App;
	import com.grabbers.manager.host.AnimateManager;
	
	import flash.utils.Dictionary;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class AnimateObject extends MovieClip
	{
		static protected var POOLS:Dictionary = new Dictionary();
		protected var _mana:AnimateManager;
		
		public function AnimateObject(textures:Vector.<Texture>, mana:AnimateManager, fps:Number=12)
		{
			_mana = mana;
			super(textures, fps);
		}
		
		override public function dispose():void {
			if (_mana == null)
				return;
			_mana.disposeObject(this);
		}
	}
}