package com.grabbers.dialogs
{
	import com.grabbers.ui.component.ButtonHover;
	import com.grabbers.ui.component.ButtonImage;
	import com.grabbers.ui.component.DialogModal;
	import com.grabbers.ui.component.Label;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class MsgBox extends DialogModal
	{
		public static const MSG_YESNO:uint = 0;
		private var _btnYes:ButtonImage;
		private var _btnNo:ButtonImage;
		private var _label:Label;
		private var _labelKey:String;
		
		public function MsgBox(strKey:String, type:uint)
		{
			super();
			_labelKey = strKey;
			initUI();
		}
		
		private function initUI():void {
			super.initBG(600, 360);
			
			//<text name="greetings_text" pos="3, 0" text_align="center" font_size="26" text_key="__">
			_label = Label.parse(new XML("<text name=\"greetings_text\" pos=\"0, 28\" text_align=\"center\" font_size=\"32\" text_key=\""+_labelKey+"\"/>"), _bg.width, _bg.height);
			
			_btnYes = ButtonImage.parse("gui_pack.swf", 
				new XML("<e name=\"volumn\" pos=\"-120,-56\" size=\"205,64\" texture_name=\"txtbtn_menu\" select_sfx_name=\"selectmenu\" click_sfx_name=\"clickmenu\">" + 
					"<text name=\"yes_caption\" pos=\"0, 0\" font_size=\"16\" text_key=\"yes_caption\"/></e>"), _bg.width, _bg.height);
			_btnNo = ButtonImage.parse("gui_pack.swf", 
				new XML("<e name=\"volumn\" pos=\"120,-56\" size=\"205,64\" texture_name=\"txtbtn_menu\" select_sfx_name=\"selectmenu\" click_sfx_name=\"clickmenu\">" + 
					"<text name=\"no_caption\" pos=\"0, 0\" font_size=\"16\" text_key=\"no_caption\"/></e>"), _bg.width, _bg.height);
			//back_caption
			_bg.addChild(_btnYes);
			_bg.addChild(_btnNo);
			_bg.addChild(_label);
			
			_btnYes.handlerTrigger = onClose;
			_btnNo.handlerTrigger = onClose;
		}
		
		override public function doModal(parentDlg:DisplayObjectContainer, handler:Function):void {
			super.doModal(parentDlg, handler);
		}
		
		private function onClose(btn:ButtonImage):void {
			if (btn == _btnYes)
				_result = DialogModal.YES;
			else if (btn == _btnNo)
				_result = DialogModal.NO;
			close();
		}
	}
}