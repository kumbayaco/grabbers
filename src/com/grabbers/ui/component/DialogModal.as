package com.grabbers.ui.component
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class DialogModal extends DisplayObjectContainer
	{
		public static const OK:uint = 1;
		public static const CANCEL:uint = 0;
		public static const YES:uint = 1;
		public static const NO:uint = 0;
		
		protected var sQuad:Quad;
		protected var _parentDlg:DisplayObjectContainer;
		protected var _result:uint = OK; 
		protected var _handler:Function;
		
		protected var _bg:Sprite = new Sprite();
		protected var _rope:Sprite = new Sprite();
		public function DialogModal()
		{
			sQuad = new Quad(1, 1, 0);
			sQuad.alpha = 0;
			super();
		}
		
		public function doModal(parentDlg:DisplayObjectContainer, handler:Function):void {
			if (parentDlg == null)
				return;
			
			x = Starling.current.stage.stageWidth - width >> 1;
			y = -height;
			_handler = handler;
			
			sQuad.width = parentDlg.width;
			sQuad.height = parentDlg.height;
			sQuad.x = parentDlg.x;
			sQuad.y = parentDlg.y;
			parentDlg.addChild(sQuad);
			
			Starling.current.stage.addChild(this);
			_parentDlg = parentDlg;
			
			
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT);
			tween.animate("y", 0);
			Starling.current.juggler.add(tween);
		}
		
		public function close():void {
			
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT_BACK);
			tween.animate("y", -height);
			tween.onComplete = function():void {
				if (_parentDlg != null && _parentDlg.contains(sQuad)) {
					_parentDlg.removeChild(sQuad);
				}
				
				_close();
				
				if (_handler != null) 
					_handler(_result);				
			}
			Starling.current.juggler.add(tween);
		}
		
		private function _close():void {
			if (parent)
				parent.removeChild(this);
//			if (sQuad != null && sQuad.parent != null)
//				sQuad.parent.removeChild(sQuad);
		}
		
		protected function initBG(width:uint, height:uint):void {
			var imgRopeL:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "rope"));
			var imgRopeR:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "rope"));
			var imgLU:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformlu"));
			var imgLC:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuforml"));
			var imgLD:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformld"));
			
			var imgRU:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformru"));
			var imgRC:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformr"));
			var imgRD:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformrd"));
			
			var imgU:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformu"));
			var imgC:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformc"));
			var imgD:Image = new Image(App.resourceManager.getTexture(Resources.GUI_PACK, "menuformd"));
			
			var f:Number = 0;
			
			// rope
			var ropeH:uint = Starling.current.stage.stageHeight - height >> 1;
			f = ropeH / imgRopeL.texture.height;
			imgRopeL.height = ropeH;
			imgRopeR.height = ropeH;
			imgRopeL.texture.repeat = true;
			imgRopeL.setTexCoords(2, new Point(0, f));
			imgRopeL.setTexCoords(3, new Point(1, f));
			imgRopeR.setTexCoords(2, new Point(0, f));
			imgRopeR.setTexCoords(3, new Point(1, f));
			imgRopeL.x = 2;
			imgRopeR.x = width - imgRopeR.width - 2;
			_rope.addChild(imgRopeL);
			_rope.addChild(imgRopeR);
			
			// left
			var bg:Sprite = new Sprite();
			_bg.addChild(imgLU);		
			f = (height - imgLU.height - imgLD.height) / imgLC.height;
			imgLC.setTexCoords(2, new Point(0, f));
			imgLC.setTexCoords(3, new Point(1, f));
			imgLC.height *= f;
			imgLC.y = imgLU.y + imgLU.height;
			_bg.addChild(imgLC);
			imgLD.y = imgLC.y + imgLC.height;
			_bg.addChild(imgLD);
			
			// right
			imgRU.x = width - imgRU.width;
			_bg.addChild(imgRU);
			f = (height - imgRU.height - imgRD.height) / imgRC.height;
			imgRC.setTexCoords(2, new Point(0, f));
			imgRC.setTexCoords(3, new Point(1, f));
			imgRC.height *= f;
			imgRC.x = imgRU.x;
			imgRC.y = imgRU.y + imgRU.height;
			_bg.addChild(imgRC);
			imgRD.x = imgRU.x;
			imgRD.y = imgRC.y + imgRC.height;
			_bg.addChild(imgRD);
			
			// top
			imgU.x = imgLU.x + imgLU.width;
			f = (width - imgLU.width - imgRU.width) / imgU.width;
			imgU.width *= f;
			imgU.setTexCoords(1, new Point(f, 0));
			imgU.setTexCoords(3, new Point(f, 1));
			_bg.addChild(imgU);
			
			// bottom
			imgD.x = imgLD.x + imgLD.width;
			imgD.y = height - imgD.height;			
			f = (width - imgLD.width - imgRD.width) / imgD.width;
			imgD.width *= f;
			imgD.setTexCoords(1, new Point(f, 0));
			imgD.setTexCoords(3, new Point(f, 1));
			_bg.addChild(imgD);
			
			// center
			var f2:Number = (height - imgU.height - imgD.height) / imgC.height;
			imgC.x = imgLU.x + imgLU.width;
			imgC.y = imgLU.y + imgLU.height;
			imgC.texture.repeat = true;
			imgC.setTexCoords(1, new Point(f, 0));			
			imgC.setTexCoords(2, new Point(0, f2));
			imgC.setTexCoords(3, new Point(f, f2));
			imgC.width *= f;
			imgC.height *= f2;
			_bg.addChild(imgC);
			
			
			addChild(_rope);
			_bg.y = _rope.height;
			addChild(_bg);
		}
	}
}