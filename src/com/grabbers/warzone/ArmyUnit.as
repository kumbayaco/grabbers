package com.grabbers.warzone
{
	import com.grabbers.globals.App;
	import com.grabbers.manager.host.AnimateManager;
	import com.grabbers.manager.host.ArmyManager;
	import com.grabbers.ui.AnimateObject;
	import com.grabbers.warzone.PathNode;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ArmyUnit extends AnimateObject
	{
		protected var _attack:uint = 1;		
		protected var _defence:uint = 1;
		protected var _type:uint;
		protected var _owner:uint;
		protected var _path:Vector.<PathNode>;
		protected var _nextNodeIndex:uint;
		protected var _bMoving:Boolean;
		protected var _speed:uint = 1;
		
		public function ArmyUnit(vTex:Vector.<Texture>, fps:uint, type:uint, owner:uint, man:AnimateManager) {
			super(vTex, man, fps);
			_type = type;
			_owner = owner;
			
			if (_type == ArmyManager.ARMORED)
				_attack = 2;
			
			if (_type == ArmyManager.SOWAR)
				_speed = 2;
		}
		
		public function set path(vPath:Vector.<PathNode>):void {
			if (vPath == null || vPath.length < 2)
				return;
			_path = vPath;
			x = vPath[0].x;
			y = vPath[0].y;
			_nextNodeIndex = 1;
		}
		
		public function startMove():void {
			if (_path == null || _nextNodeIndex >= _path.length)
				return;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			Starling.current.juggler.add(this);
		}
		
		public function pauseMove():void {
		}
		
		public function get type():uint {
			return _type;
		}
		
		public function get owner():uint {
			return _owner;
		}
		
		protected function getToken(type:uint, owner:uint):String {
			return "";
		}
		
		protected function onFrame(e:Event):void {
			
		}
	}
}