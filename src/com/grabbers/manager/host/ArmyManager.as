package com.grabbers.manager.host
{
	import com.grabbers.warzone.ArmyUnit;
	
	import flash.utils.Dictionary;

	public class ArmyManager
	{
		static public const INFANTRY:uint = 0;	// 步兵
		static public const SOWAR:uint = 1;		// 骑兵
		static public const ARMORED:uint = 2;	// 装甲兵
		protected var _armyPools:Dictionary = new Dictionary();
		
		public function ArmyManager() {
			
		}
//		
//		public function createArmy(type:uint, owner:uint, bFlag:Boolean):ArmyUnit {
//			var token:String = getToken(type, owner);
//			var dictArmy:Dictionary;
//			if (_armyPools[token] == null)
//				_armyPools[token] = new Vector.<ArmyUnit>;
//			
//			var v:Vector.<ArmyUnit> = _armyPools[token] as Vector.<ArmyUnit>;
//			if (v.length > 0)
//				return v.shift();
//			
//			var newArmy:ArmyUnit = new ArmyUnit(type, owner);
//			return newArmy;
//		}
//		
//		public function disposeArmy(unit:ArmyUnit):void {
//			if (unit == null)
//				return;
//			
//			var token:String = getToken(unit.type, unit.owner);
//			if (_armyPools[token] != null)
//				_armyPools[token] = new Vector.<ArmyUnit>();
//			
//			var v:Vector.<ArmyUnit> = _armyPools[token] as Vector.<ArmyUnit>;
//			v.push(unit);
//		}
		
		protected function getToken(type:uint, owner:uint):String {
			return type + "," + owner;
		}
	}
}