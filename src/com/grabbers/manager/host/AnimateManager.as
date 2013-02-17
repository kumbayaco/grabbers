package com.grabbers.manager.host
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.AnimateObject;
	import com.grabbers.warzone.ArmyUnit;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.utils.VAlign;

	public class AnimateManager
	{
		protected var _cacheXml:Dictionary;
		protected var _cacheAni:Dictionary = new Dictionary();
		
		public function AnimateManager() {
		}
		
		public function init():Boolean {
			_cacheXml = new Dictionary();
			var content:String = App.resourceManager.getConfigXml("scripts/hosts/animationhost.txt");
			if (content == null || content == "") {
				return false;
			}
			
			try {
				var xml:XML = new XML(content);
				for each (var xmlAnim:XML in xml.animation) {
					//<animation name="fireworks_anim" start_frame="24" end_frame="31" animation_time="0.5" delta_pos="0, 128" frame_size="128, 128" texname="magic_anim3">	
					var key:String = xmlAnim.@name;
					_cacheXml[key] = xmlAnim;
				}
			} catch (e:Error) {
				Logger.error(e.message);
				return false;
			}
			
			return true;
		}
		
		public function getAnim(name:String):AnimateObject {
			if (_cacheAni != null && _cacheAni[name] != null) {
				var v:Vector.<AnimateObject> = _cacheAni[name] as Vector.<AnimateObject>;
				if (v.length > 0)
					return v.shift() as AnimateObject;
			}
			
			if (_cacheXml == null) {
				Logger.error("animate manger not init");
				return null; 
			}
			
			if (_cacheXml[name] == null) {
				Logger.error("animate [" + name + "] not found");
				return null;
			}
			
			var xmlAnim:XML = _cacheXml[name] as XML;
			var texAnim:Texture = App.resourceManager.getTexture(xmlAnim.@texname, Resources.ANIMATION_PACK);
			if (texAnim == null)
				return null;
			
			var size:Point = ScriptHelper.parsePoint(xmlAnim.@frame_size);
			var delta:Point = ScriptHelper.parsePoint(xmlAnim.@delta_pos); //unknown
			var startFr:Number = ScriptHelper.parseNumber(xmlAnim.@start_frame);
			var endFr:Number = ScriptHelper.parseNumber(xmlAnim.@end_frame);
			var time:Number = ScriptHelper.parseNumber(xmlAnim.@animation_time);
			
			var nw:uint = texAnim.width / size.x >> 0;
			var nh:uint = texAnim.height / size.y >> 0;
			
			var vTex:Vector.<Texture> = new Vector.<Texture>();
			for (var fr:uint = startFr; fr <= endFr; fr++) {
				var x:uint = fr % nw;
				var y:uint = fr / nw >> 0;
				var tex:Texture = Texture.fromTexture(texAnim, new Rectangle(x*size.x, y*size.y, size.x, size.y));
				vTex.push(tex);
			}
			
			var mc:AnimateObject = new AnimateObject(vTex, this, vTex.length / time >> 0);			
			
			return mc;
		}
		
		public function disposeObject(obj:AnimateObject):void {
			if (obj == null)
				return;
			
			if (_cacheAni[obj.name] == null)
				_cacheAni[obj.name] = new Vector.<AnimateObject>();
			var v:Vector.<AnimateObject> = _cacheAni[obj.name] as Vector.<AnimateObject>;
			v.push(obj);
		}
		
		public function getUnitAnim(type:uint, owner:uint, bFlag:Boolean):ArmyUnit {
			var texName:String;
			var size:Point;
			var flag:String = bFlag ? "_flag" : "";
			switch (type) {
				case ArmyManager.INFANTRY:
					texName = "unit" + owner + "_walk" + flag;
					size = new Point(32, bFlag?48:32);
					break;
				
				case ArmyManager.SOWAR:
					texName = "unit" + owner + "_fast" + flag;
					size = new Point(48, 48);
					break;
				
				case ArmyManager.ARMORED:
					texName = "unit" + owner + "_strong" + flag;
					size = new Point(32, bFlag?48:32);
					break;
				
				default:
					Logger.error("owner unknown");
					return null;
			}
			
			if (_cacheAni != null && _cacheAni[texName] != null) {
				var v:Vector.<AnimateObject> = _cacheAni[texName] as Vector.<AnimateObject>;
				if (v.length > 0)
					return v.shift() as ArmyUnit;
			}
			
			if (_cacheXml == null) {
				Logger.error("animate manger not init");
				return null; 
			}
			
			if (_cacheXml["unit_anim"] == null) {
				Logger.error("animate [unit_anim] not found");
				return null;
			}
			
			var xmlAnim:XML = _cacheXml["unit_anim"] as XML;
			var texAnim:Texture = App.resourceManager.getTexture(texName, Resources.ANIMATION_PACK);
			if (texAnim == null)
				return null;
			
			var time:Number = ScriptHelper.parseNumber(xmlAnim.@animation_time);
			
			var nw:uint = texAnim.width / size.x >> 0;
			var nh:uint = texAnim.height / size.y >> 0;
			var nFrame:uint = nw * nh;
			var vTex:Vector.<Texture> = new Vector.<Texture>();
			for (var fr:uint = 0; fr <= nFrame; fr++) {
				var x:uint = fr % nw;
				var y:uint = fr / nw >> 0;
				var tex:Texture = Texture.fromTexture(texAnim, new Rectangle(x*size.x, y*size.y, size.x, size.y));
				vTex.push(tex);
			}
			
			var mc:ArmyUnit = new ArmyUnit(vTex, 8 / time >> 0, owner, type, this);			
			
			return mc;
		}
	}
}