package com.grabbers.dialogs
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	import com.grabbers.ui.component.ButtonHover;
	import com.grabbers.ui.component.DialogModal;
	import com.grabbers.ui.component.Label;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class DialogSetting extends DialogModal
	{
		private var btnVolumn:ButtonHover;
		private var btnReturn:ButtonHover;
		private var dlgVolumn:DialogVolumn;
		
		public function DialogSetting()
		{
			super();
			initUI();
		}
		
		override public function doModal(parentDlg:DisplayObjectContainer, handler:Function):void {			
			super.doModal(parentDlg, handler);
		}
		
		private function onClose(e:Event):void {
			close();
		}
		
		private function onVolumn(e:Event):void {
			if (dlgVolumn == null)
				dlgVolumn = new DialogVolumn();
			close();
			dlgVolumn.doModal(this, onShow);
		}
		
		private function onShow(result:uint):void {
			doModal(_parentDlg, _handler);
		}
		
		private function initUI():void {
			initBG(370, 400);
			
			btnVolumn = ButtonHover.parse("gui_pack.swf", 
				new XML("<e name=\"volumn\" pos=\"0,35\" size=\"256,64\" texture_name=\"txtbtn_menu\" select_sfx_name=\"selectmenu\" click_sfx_name=\"clickmenu\">" + 
						"<text name=\"set_volume_caption\" pos=\"13, 0\" font_size=\"26\" text_key=\"set_volume_caption\"/></e>"), _bg.width, _bg.height);
			btnReturn = ButtonHover.parse("gui_pack.swf", 
				new XML("<e name=\"return\" pos=\"0,-35\" size=\"256,64\" texture_name=\"txtbtn_menu\" select_sfx_name=\"selectmenu\" click_sfx_name=\"clickmenu\">" + 
					"<text name=\"back_caption\" pos=\"13, 0\" font_size=\"26\" text_key=\"back_caption\"/></e>"), _bg.width, _bg.height);
			//back_caption
			_bg.addChild(btnVolumn);
			_bg.addChild(btnReturn);
			
			btnReturn.addEventListener(Event.TRIGGERED, onClose);
			btnVolumn.addEventListener(Event.TRIGGERED, onVolumn);
		}
	}
}