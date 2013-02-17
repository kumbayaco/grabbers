package com.grabbers.ui.model
{
	import com.grabbers.core.bean.Building;
	import com.grabbers.core.bean.Obstacle;
	import com.grabbers.core.bean.Player;
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.type.Anchor;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class Warzone extends UIObject
	{
		protected var _xml:XML;
		
		protected var _pos:Point;
		protected var _size:Point;
		protected var _musicTheme:String;
		protected var _musicAmbient:String;
		protected var _bgTexture:Texture;
		protected var _maxLevel:uint;
		protected var _bonusAttack:uint;
		protected var _bonusDefence:uint;
		protected var _bonusSpeed:uint;
		protected var _needClients:uint;
		protected var _trophyTimeNormal:Number;
		protected var _trophyTimeHard:Number;
		protected var _trophyTimeExpert:Number;
		protected var _trophyTime:Number;
		
		protected var _players:Vector.<Player> = new Vector.<Player>();
		protected var _builds:Vector.<Building> = new Vector.<Building>();
		protected var _obstacles:Vector.<Obstacle> = new Vector.<Obstacle>();
		
		/*
		<warzone name="warzone" pos="0.00, 0.00" size="1280.00, 768.00" music_name="gameplay_theme1" ambient_name="forest_ambient" background_texture="forest09" 
			max_upgrade_level="3" bonus_attack="2.00" bonus_defence="2.00" bonus_speed="2.00" needed_clients="2" 
			trophy_time_normal="0.00" trophy_time_hard="0.00" trophy_time_expert="0.00" trophy_time="32000.00">
		*/
		public function Warzone() {
		}
		
		override public function init(xml:XML, parentW:uint, parentH:uint, texPack:String):Boolean {
			name = xml.@background_texture;
			_pos = ScriptHelper.parsePoint(xml.@pos);
			_size = ScriptHelper.parsePoint(xml.@size);
			_musicTheme = xml.@music_name;
			_musicAmbient = xml.@ambient_name;
			_bgTexture = App.resourceManager.getTexture(xml.@background_texture, texPack);
			
			if (_bgTexture != null)
				addChild(new Image(_bgTexture));
						
			_maxLevel = ScriptHelper.parseNumber(xml.@max_upgrade_level);
			_bonusAttack = ScriptHelper.parseNumber(xml.@bonus_attack);
			_bonusDefence = ScriptHelper.parseNumber(xml.@bonus_defence);
			_bonusSpeed = ScriptHelper.parseNumber(xml.@bonus_speed);
			_needClients = ScriptHelper.parseNumber(xml.@needed_clients);
			
			_trophyTime = ScriptHelper.parseNumber(xml.@trophy_time);
			_trophyTimeNormal = ScriptHelper.parseNumber(xml.@trophy_time_normal);
			_trophyTimeHard = ScriptHelper.parseNumber(xml.@trophy_time_hard);
			_trophyTimeExpert = ScriptHelper.parseNumber(xml.@trophy_time_expert);
			
			var xmlSub:XMLList = xml.children();
			for each (var xmlChild:XML in xmlSub) {
				var tagName:String = xmlChild.name();
				switch (tagName) {
					case "player":
						var player:Player = new Player();
						if (!player.init(xmlChild))
							return false;
						_players.push(player);
						break;
					
					case "city":
						var build:Building = new Building();
						if (!build.init(xmlChild, _size.x, _size.y))
							return false;
						_builds.push(build);
						addChild(build);
						break;
					
					case "obstacle":
						var obs:Obstacle = new Obstacle();
						if (!obs.init(xmlChild, _size.x, _size.y, texPack))
							return false;
						_obstacles.push(obs);
						addChild(obs);
						break;
					
					case "spell_list":
						break;
				}
			}
			
			LayoutUtil.setLayoutInfoEx(this, Anchor.ANCHOR_DEFAULT, _pos.x, _pos.y, _size.x, _size.y, parentW, parentH);
			
			if (_players.length == 0)
				return false;
			
			_players.unshift(_players[0].clone()); //0-中立，1-玩家，2.3.4-电脑
			for each (var city:Building in _builds) {
				if (city.owner >= _players.length) {
					Logger.error("invalid building");
					return false;
				}
				
				_players[city.owner].addBuilding(city);
			}			
			
			return true;
		}
		
	}
}