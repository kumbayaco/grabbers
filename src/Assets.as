package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
//	import starling.textures.Texture;

	public class Assets
	{
		[Embed(source="assets/backbar.png")]
		private static const LoadBarBg:Class;
		
		[Embed(source="assets/loadbar.png")]
		private static const LoadBar:Class;
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameBitmaps:Dictionary = new Dictionary();
		
		public function Assets()
		{
		}
		
/*		public static function getTextures(name:String) : Texture 
		{
			if (gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
*/		
		public static function getBitmap(name:String) : Bitmap
		{
			if (gameBitmaps[name] == undefined)
			{
				gameBitmaps[name] = new Assets[name]();
			}
			
			return gameBitmaps[name];
		}
	}
}