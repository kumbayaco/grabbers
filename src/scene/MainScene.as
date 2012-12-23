package scene
{
	import flash.display.Sprite;
	
	import globals.App;
	import globals.Resources;

	public class MainScene extends Sprite implements IScene
	{
		private var _bInit:Boolean = false;
		
		public function MainScene() {
		}
		
		
		public function enter():void {
			preEnter();
		}
		
		public function exit():void {
			
		}
		
		private function preEnter():void {
			if (!_bInit) {
				_bInit = true;
				App.loadManager.addTask(Resources.MAIN);
				App.loadManager.start(enter);
			}			
		}
	}
}