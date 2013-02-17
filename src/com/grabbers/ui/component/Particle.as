package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.utils.Color;
	
	public class Particle extends DisplayObjectContainer
	{
		private var _bmpData:BitmapData;
		private var _posScatter:Number;
		private var _startSpeed:Number;
		private var _speedScatter:Number;
		private var _gravity:Point;
		private var _startSize:Number;
		private var _sizeScatter:Number;
		private var _sizeSpeed:Number;
		private var _sizeSpeedScatter:Number;
		private var _startAngle:Number;
		private var _angleScatter:Number;
		private var _angleSpeed:Number;
		private var _angleSpeedScatter:Number;
		private var _color:Color;
		private var _colorSpeed:Array;
		private var _colorSpeedScatter:Array;
		
		public function Particle(params:Object)
		{
			name = params.name;
			_bmpData = params.image;
			_posScatter = params.posScatter;
			_startSpeed = params.startSpeed;
			_speedScatter = params.speedScatter;
			_gravity = params.gravity;
			_startSize = params.startSize;
			_sizeScatter = params.sizeScatter;
			_sizeSpeed = params.sizeSpeed;
			_sizeSpeedScatter = params.sizeSpeedScatter;
			_startAngle = params.startAngle;
			_angleScatter = params.params;
			_angleSpeed = params.angleSpeed;
			_angleSpeedScatter = params.angleSpeedScatter;
			_color = params.params;
			_colorSpeed = params.colorSpeed;
			_colorSpeedScatter = params.colorSpeedScatter;
			super();
		}
		
		public function start():void {
			
		}
		
		/*
		<particle_template name="explosion" image="particle_explosion" 
		pos_scatter="32" start_speed="0.03" speed_scatter="0.003" gravity="0, 0" blending="true" 
		start_size="32" size_scatter="5" size_speed="0.06" size_speed_scatter="0.004" 
		start_angle="0" angle_scatter="180" angle_speed="0.1" angle_speed_scatter="0.03" 
		color="200, 200, 200, 200" color_scatter="0, 0, 0, 55" color_speed="-0.1, -0.1, -0.1, -0.1" color_speed_scatter="0.001, 0.001, 0.001, 0.001">
		*/
		static public function parse(xml:XML) : Particle {
			var params:Object = new Object();
			var str:String;
			params["name"] = (str = xml.@name);
			
			var bmd:BitmapData = App.resourceManager.getBitmapData(xml.@image);
			if (bmd == null) {
				return null;
			}
			params["image"] = bmd;
			
			params["pos_scatter"] = ScriptHelper.parseNumber(xml.@pos_scatter);
			params["start_speed"] = ScriptHelper.parseNumber(xml.@start_speed);
			params["speed_scatter"] = ScriptHelper.parseNumber(xml.@speed_scatter);
			params["gravity"] = ScriptHelper.parsePoint(xml.@gravity);
			
			params["start_size"] = ScriptHelper.parseNumber(xml.@start_size);
			params["size_scatter"] = ScriptHelper.parseNumber(xml.@size_scatter);
			params["size_speed"] = ScriptHelper.parseNumber(xml.@size_speed);
			params["size_speed_scatter"] = ScriptHelper.parseNumber(xml.@size_speed_scatter);
			
			params["start_angle"] = ScriptHelper.parseNumber(xml.@start_angle);
			params["angle_scatter"] = ScriptHelper.parseNumber(xml.@angle_scatter);
			params["angle_speed"] = ScriptHelper.parseNumber(xml.@angle_speed);
			params["angle_speed_scatter"] = ScriptHelper.parseNumber(xml.@angle_speed_scatter);
			
			params["color"] = ScriptHelper.parseColor(xml.@color);
			params["color_scatter"] = ScriptHelper.parseDigitArray(xml.@color_scatter);
			params["color_speed"] = ScriptHelper.parseDigitArray(xml.@color_speed);
			params["color_speed_scatter"] = ScriptHelper.parseDigitArray(xml.@color_speed_scatter);
			
			return new Particle(params);
		}
		
	}
}