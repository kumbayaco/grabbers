package com.grabbers.warzone
{
	import com.grabbers.core.bean.Player;
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.LayoutUtil;
	import com.grabbers.ui.model.UIObject;
	import com.grabbers.ui.type.Anchor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Color;

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
		
		protected var _graph:WarzoneGraph;
		protected var _graphImage:Image;
		protected var _pathImage:Image;
		
		protected var _players:Vector.<Player> = new Vector.<Player>();
		protected var _builds:Vector.<Building> = new Vector.<Building>();
		protected var _obstacles:Vector.<Obstacle> = new Vector.<Obstacle>();
		protected var _pathNodes:Dictionary = new Dictionary();
		
		protected var _buildsSelect:Vector.<Building> = new Vector.<Building>();
		protected var _buildTarget:Building;
		
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
			_musicAmbient = xml .@ambient_name;
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
						var build:Building = new Building(this);
						if (!build.init(xmlChild, _size.x, _size.y))
							return false;
						_builds.push(build);
						addChild(build);
						break;
					
					case "path_count_node":
						var node:PathNode = new PathNode();
						if (!node.init(xmlChild, parentW, parentH))
							return false;
						_pathNodes[node.id] = node;
						break;
					
//					case "obstacle":
//						var obs:Obstacle = new Obstacle();
//						if (!obs.init(xmlChild, _size.x, _size.y, texPack))
//							return false;
//						_obstacles.push(obs);
//						addChild(obs);
//						break;
					
					case "spell_list":
						break;
				}
			}
			
			LayoutUtil.setLayoutInfo(this, Anchor.ANCHOR_DEFAULT, _pos.x, _pos.y, parentW, parentH);
			
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
			
			buildGraph();
			
			return true;
		}
		
		public function onBuildingCommand(build:Building, command:String):void {
			switch (command) {
				case Building.COMMAND_SELECT:
					if (_buildsSelect.indexOf(build) < 0)
						_buildsSelect.push(build);
					break;
				
				case Building.COMMAND_UNSELECT:
					if (_buildsSelect.indexOf(build) >= 0)
						_buildsSelect.splice(_buildsSelect.indexOf(build), 1);
					break;
				
				case Building.COMMAND_ATTACK:
					var path:Vector.<PathNode> = _graph.searchPath(_buildsSelect[0].nodeId, build.nodeId);
					var unit:ArmyUnit = App.resourceManager.getUnitAnim(_buildsSelect[0].armyType, _buildsSelect[0].owner, false);
					buildPathImage(path);
					addChild(unit);
					Starling.current.juggler.add(unit);
					unit.path = path;
					unit.startMove();
					break;
			}
			
			if (_buildsSelect.length > 0) {
				for each (build in _builds) {
					if (build.owner != Building.OWNER_PLAYER)
						build.touchable = true;
				}
			} else {
				for each (build in _builds) {
					if (build.owner != Building.OWNER_PLAYER)
						build.touchable = false;
				}
			}
		}
		
		protected function buildPathImage(path:Vector.<PathNode>):void {
			if (_pathImage != null && contains(_pathImage))
				removeChild(_pathImage);
			
			if (path == null)
				return;
			
			_pathImage = null;
			var s:flash.display.Sprite = new flash.display.Sprite();
			var color:uint = Math.random() * 0xFFFFFF;
			s.graphics.beginFill(color, 0);
			s.graphics.drawRect(0, 0, App.sceneWidth, App.sceneHeight);
			s.graphics.endFill();
			
			s.graphics.beginFill(Color.YELLOW, 0.5);
			for (var i:uint = 1; i < path.length; i++) {
				s.graphics.lineStyle(path[i].radius, Color.GREEN);
				s.graphics.moveTo(path[i-1].x, path[i-1].y);
				s.graphics.lineTo(path[i].x, path[i].y);
			}
			
			var bmd:BitmapData = new BitmapData(App.sceneWidth, App.sceneHeight, true, 0);
			bmd.draw(s);
			_pathImage = Image.fromBitmap(new Bitmap(bmd));
			_pathImage.touchable = false;
			addChild(_pathImage);
		}
		
		protected function buildGraph():void {
			_graph = new WarzoneGraph();
			_graph.init(_pathNodes);
			
			return;
			
			if (_graphImage != null && contains(_graphImage))
				removeChild(_graphImage);
			
			_graphImage = null;
			var s:flash.display.Sprite = new flash.display.Sprite();
			var color:uint = Math.random() * 0xFFFFFF;
			s.graphics.beginFill(color, 0);
			s.graphics.drawRect(0, 0, App.sceneWidth, App.sceneHeight);
			s.graphics.endFill();
				
//			s.graphics.beginFill(Color.RED, 0.5);
//			s.graphics.lineStyle(4, Color.GREEN);
			for each (var node:PathNode in _pathNodes) {
				var pt:Point = node.position;
				for each (var neighbor:uint in node.neighbors) {
					var ptNei:Point = (_pathNodes[neighbor] as PathNode).position;
//					s.graphics.lineStyle(4, Color.RED);
//					s.graphics.drawCircle(pt.x, pt.y, 2);
					
					s.graphics.lineStyle(1, Color.GREEN);
					s.graphics.moveTo(pt.x, pt.y);
					s.graphics.lineTo(ptNei.x, ptNei.y);
					
					var tex:TextField = new TextField();
					tex.text = node.id.toString();
					tex.x = pt.x;
					tex.y = pt.y;
					s.addChild(tex);
				}
			}
			
			var bmd:BitmapData = new BitmapData(App.sceneWidth, App.sceneHeight, true, 0);
			bmd.draw(s);
			_graphImage = Image.fromBitmap(new Bitmap(bmd));
			_graphImage.touchable = false;
			addChild(_graphImage);
		}
		
	}
}