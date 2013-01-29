package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Hint extends DisplayObjectContainer
	{
		static private var _curHintShow:Hint;
		static private var _hintFrame:ScaleImage;
		
		public var anchorObj:DisplayObject;		
		public var size:Point;
		public var pos:Point;
		public var image:Image;
		public var delay:Number;
		
		public function Hint(text:String = "") {
			image = App.resourceManager.getTextImage(text);
		}
		
		
		static public function parse(xml:XML, parent:DisplayObjectContainer):Hint {
//			<basic_hint activator="sign_options" pos="0, -87" size="110, 24" auto_text="false" manual_pos="true" global_pos="false" hint_delay="800">
//				<text text_key="options_caption">
//				</text>
//			</basic_hint>
			
			var anchorObj:DisplayObject = parent.getChildByName(xml.@activator);
			if (anchorObj == null) {
				Logger.error("can not locate anchor object \"" + xml.@activator + "\"");				return null;
			}
			
			var hint:Hint = new Hint();
			hint.anchorObj = anchorObj;
			hint.pos = ScriptHelper.parsePoint(xml.@pos);
			hint.size = ScriptHelper.parsePoint(xml.@size);
			hint.delay = ScriptHelper.parseNumber(xml.@hint_delay);
			hint.image = App.resourceManager.getTextImage(App.resourceManager.getTextString(xml.text.@text_key));
			
			hint.image.scaleX = hint.image.scaleY = Math.min(hint.size.x / hint.image.width, hint.size.y / hint.image.height);
			hint.size.offset(16, 16);
			
			return hint;
		}
				
		static public function register(hint:Hint):void {
			if (hint.anchorObj != null) {
				var hintObj:IHint = hint.anchorObj as IHint;
//				if (hintObj != null)
//					hintObj.setHint(hint);
			}
		}
		
		public function show():void {
			if (_curHintShow == this) 
				return;
			
			if (_curHintShow != null) {
				_curHintShow.hide();
			}
			
			_curHintShow = null;
			
			if (anchorObj == null)
				return;
			
			if (_hintFrame == null) {
				_hintFrame = new ScaleImage(App.resourceManager.getBitmapData(Resources.GUI_PACK, "hint_theme"), new Rectangle(8, 8, 16, 16));
			}
			
			_hintFrame.width = size.x;
			_hintFrame.height = size.y;
			addChild(_hintFrame);
			
			if (image != null) {
				image.x = _hintFrame.width - image.width >> 1;
				image.y = _hintFrame.height - image.height >> 1;
				addChild(image);
			}
			
			_curHintShow = this;
			x = anchorObj.x + (anchorObj.width - width >> 1) + pos.x;
			y = anchorObj.y + (anchorObj.height - height >> 1)  - pos.y;
			
			var tween:Tween = new Tween(this, delay/1000);
			alpha = 0;
			tween.animate("alpha", 1);
			Starling.current.juggler.add(tween);
			
			Starling.current.stage.addChild(this);
		}
		
		public function hide():void {
			if (parent)
				parent.removeChild(this);
			_curHintShow = null;
		}
	}
}