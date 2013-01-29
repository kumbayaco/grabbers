package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.ScriptHelper;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * The HoverButton Class
	 * Essentially adds an overState to the Starling Button class.
	 * @author Tony Downey
	 */
	public class ButtonHover extends Button{
		
		private var mUpState:Texture;
		private var mOverState:Texture;
		private var mIsOver:Boolean;
		private var mOverSfx:String;
		private var mClickSfx:String;
		private var mLabel:Label;
		private var mHint:Hint;
		
		public function ButtonHover(label:Label, upState:Texture, downState:Texture=null, overState:Texture=null, overSfx:String=null, clickSfx:String=null) {
			super(upState, "", downState);
			mLabel = label;
			mOverState = overState;
			mUpState = upState;
			mOverSfx = overSfx;
			mClickSfx = clickSfx;
			addEventListener(TouchEvent.TOUCH, onTouchCheckHover);
			if (mLabel != null) {
				addChild(mLabel);
				mLabel.x = (width - mLabel.width) / 2 >> 0;
				mLabel.y = (height - mLabel.height) / 2 >> 0;				
			}
		}
		
		override public function set width (w:Number):void {
			super.width = w;
			if (mLabel != null) {
				mLabel.scaleX = 1 / scaleX;
//				mLabel.x = (width - mLabel.width) / 2 >> 0;
//				mLabel.y = (height - mLabel.height) / 2 >> 0;	
			}
		}
		
		override public function set height (h:Number):void {
			super.height = h;
			if (mLabel != null) {
				mLabel.scaleY = 1 / scaleY;	
//				mLabel.x = (width - mLabel.width) / 2 >> 0;
//				mLabel.y = (height - mLabel.height) / 2 >> 0;
			}
		}
		
		static public function parseBasic(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):ButtonHover {
			// xmlList[i].text = new XML("<text name=\"caption\" pos=\"13, 5\" font_size=\"28\" text_key=\""+xmlList[i].@name + "_caption\"/>");
			// <basic_button name="exit" pos="8, 8" size="128, 48" font_size="32" draw_text="true" left_anchor="true" bottom_anchor="true" texture_name="back_button">
			xml.text = new XML("<text name=\"caption\" pos=\"-5, 2\" font_size=\""+ xml.@font_size +"\" text_key=\""+xml.@name + "_caption\"/>");
			return parse(texPack, xml, parentW, parentH);
		}
		
		static public function parse(texPack:String, xml:XML, parentW:uint = 1280, parentH:uint = 768):ButtonHover {
			//<activeelement name="sign_options" pos="367, 126" size="256, 128" texture_name="sign_options" tex_mask_name="sign_options" select_sfx_name="selectmenu" click_sfx_name="clickmenu">
			var tex:Texture = App.resourceManager.getTexture(texPack, xml.@texture_name);
			var upTex:Texture = Texture.fromTexture(tex, new Rectangle(0, 0, tex.width, tex.height / 2));
			var hoverTex:Texture = Texture.fromTexture(tex, new Rectangle(0, tex.height/2, tex.width, tex.height / 2));	
			
			var arr:Array;
			arr = ScriptHelper.parseDigitArray(xml.@size);
			var size:Point = new Point(arr[0], arr[1]);
			
			//<text name="caption" pos="13, 0" text_align="center" font_size="28" text_key="share_caption">			
			var strText:String = "";
			var label:Label = null;
			for each (var textXml:XML in xml.text) {
				label = Label.parse(textXml, size.x, size.y);
				label.touchable = false;
				break;
			}
			
			var btn:ButtonHover = new ButtonHover(label, upTex, upTex, hoverTex, xml.@select_sfx_name, xml.@click_sfx_name);
			
			arr = ScriptHelper.parseDigitArray(xml.@pos);			
			var pos:Point = ScriptHelper.parsePosition(arr[0], arr[1], size.x, size.y, ScriptHelper.parseAnchorType(xml), parentW, parentH);
			btn.x = pos.x;
			btn.y = pos.y;
			btn.width = size.x;
			btn.height = size.y;
			btn.name = xml.@name;
			
			return btn;
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is hovering; if so, it replaces the upState texture */
		private function onTouchCheckHover(e:TouchEvent):void {

			if (parent && mOverState && upState != mOverState && e.interactsWith(this)) {
				removeEventListener(TouchEvent.TOUCH, onTouchCheckHover);
				parent.addEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				upState = mOverState;
				if (mHint != null)
					mHint.show();
				if (mOverSfx && mOverSfx != "")
					App.soundManager.playSfx(mOverSfx);
			}
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is finished hovering; if so, it resets the upState texture */
		private function onParentTouchCheckHoverEnd(e:TouchEvent):void {
			
			var touch:Touch = e.getTouch(this);
			if (touch != null) {
				// click_down
				if (touch.phase == TouchPhase.BEGAN) {
				  	if (mClickSfx && mClickSfx != "")
						App.soundManager.playSfx(mClickSfx);
					if (mHint != null)
						mHint.hide();
				}
				
				// click_up
				if (touch.phase == TouchPhase.ENDED) {
					upState = mOverState;
					if (mHint != null)
						mHint.hide();
				}
			}
			
			if (parent && mOverState && !touch) {
				// mouse out
				parent.removeEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
				addEventListener(TouchEvent.TOUCH, onTouchCheckHover);
				upState = mUpState;
				if (mHint != null)
					mHint.hide();
			}
		}
		
		/** The texture that is displayed while the button is hovered over. */
		public function get overState():Texture { return mOverState; }
		public function set overState(value:Texture):void{ if (mOverState != value) mOverState = value; }
		
		/** The texture that is displayed when the button is not being touched. */
		override public function get upState():Texture { return mUpState; }
		override public function set upState(value:Texture):void {
			if (mOverState != value) mUpState = value;
			super.upState = value;
		}
		
//		public function setHint(hint:Hint):void {
//			mHint = hint;
//		}
	}
}