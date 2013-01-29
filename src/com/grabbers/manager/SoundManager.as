package com.grabbers.manager
{
	import com.grabbers.globals.App;
	import com.grabbers.globals.Resources;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundManager
	{
		private var _musicChannelCurr:SoundChannel = null;
		private var _sfxChannelCurr:SoundChannel = null;
		private var _musicSoundTransform:SoundTransform = new SoundTransform(0.1);
		private var _sfxSoundTransform:SoundTransform = new SoundTransform(0.1);
		
		public function SoundManager()
		{
		}
		
		public function playTheme(key:String):void {
			if (_musicChannelCurr != null) {
				_musicChannelCurr.stop();
			}
			
			var sound:Sound = App.resourceManager.getSound(Resources.THEME_FILES, key + ".mp3");
			if (sound != null) {
				_musicChannelCurr = sound.play(0, int.MAX_VALUE);
				_musicChannelCurr.soundTransform = _musicSoundTransform;
			}
		}
		
		public function playSfx(key:String):void {
			if (_sfxChannelCurr != null) {
				_sfxChannelCurr.stop();
			}
			
			var sound:Sound = App.resourceManager.getSound(Resources.SFX_FILES, key + ".mp3");
			if (sound != null) {
				_sfxChannelCurr = sound.play();
				_sfxChannelCurr.soundTransform = _sfxSoundTransform;
			}
		}
		
		public function setThemeVol(vol:uint):void {
			_musicSoundTransform.volume = vol / 100;
			if (_musicChannelCurr != null)
				_musicChannelCurr.soundTransform = _musicSoundTransform;
		}
		
		public function get themeVol():Number {
			return _musicSoundTransform.volume * 100;
		}
		
		public function get sfxVol():Number {
			return _sfxSoundTransform.volume * 100;
		}
		
		public function setSfxVol(vol:uint):void {
			_sfxSoundTransform.volume = vol / 100;
			if (_sfxChannelCurr != null)
				_sfxChannelCurr.soundTransform = _sfxSoundTransform;
		}
	}
}