package com.grabbers.core.bean
{
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.warzone.Building;

	public class Player
	{
		protected var _popuGrowth:Number = 0;
		protected var _towerSpeed:Number = 0;
		protected var _armySpeed:Number = 0;
		protected var _armyAttack:Number = 0;
		protected var _armyDefense:Number = 0;
		protected var _towerRange:Number = 0;			//塔的攻击范围
		protected var _attackInterval:Number = 0;		//攻击间隔
		protected var _maxArmyPerAttack:Number = 0;		//最多同时派出几支军队
		protected var _upgradeTreshold:Number = 0.5;	//何时升级
		protected var _attackTreshold:Number = 1.0; 	//何时发起攻击		
		
		protected var _builds:Vector.<Building> = new Vector.<Building>();
		
		public function Player() {
		}
		
		public function addBuilding(build:Building):void {
			_builds.push(build);
		}
		
		public function init(xml:XML):Boolean {
			//<player population_growth="1.00" tower_speed="1.00" army_speed="1.00" army_attack="1.00" 
			// army_defence="1.00" tower_range="1.00" ai_attack_delay="10" ai_max_armies_per_attack="3" ai_upgrade_treshold="0.70" ai_panic_attack_treshold="0.90">
			
			_popuGrowth = ScriptHelper.parseNumber(xml.@population_growth);
			_towerSpeed = ScriptHelper.parseNumber(xml.@tower_speed);
			_armySpeed = ScriptHelper.parseNumber(xml.@army_speed);
			_armyAttack = ScriptHelper.parseNumber(xml.@army_attack);
			_armyDefense = ScriptHelper.parseNumber(xml.@army_defence);
			_towerRange = ScriptHelper.parseNumber(xml.@tower_range);
			
			_attackInterval = ScriptHelper.parseNumber(xml.@ai_attack_delay);
			_maxArmyPerAttack = ScriptHelper.parseNumber(xml.@ai_max_armies_per_attack);
			_upgradeTreshold = ScriptHelper.parseNumber(xml.@ai_upgrade_treshold);
			_attackTreshold = ScriptHelper.parseNumber(xml.@ai_panic_attack_treshold);
			
			return true;
		}
		
		public function tick(time:Number):void {
			// 人口增长
		}
		
		public function clone():Player {
			var newPlayer:Player = new Player();
			
			newPlayer._popuGrowth = _popuGrowth;
			newPlayer._towerSpeed = _towerSpeed;
			newPlayer._armySpeed = _armySpeed;
			newPlayer._armyAttack = _armyAttack;
			newPlayer._armyDefense = _armyDefense;
			newPlayer._towerRange = _towerRange;
			newPlayer._attackInterval = _attackInterval;
			newPlayer._maxArmyPerAttack = _maxArmyPerAttack;
			newPlayer._upgradeTreshold = _upgradeTreshold;
			newPlayer._attackTreshold = _attackTreshold;		
			
			return newPlayer;
		}
	}
}