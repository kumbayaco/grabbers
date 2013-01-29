package com.grabbers.manager
{	
	import com.grabbers.globals.Resources;
	import com.grabbers.globals.ScriptHelper;
	import com.grabbers.log.Logger;
	import com.grabbers.ui.UIObjectFactory;
	import com.grabbers.ui.component.Particle;
	import com.greensock.loading.core.LoaderCore;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.text.FontStyle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class ResourceManager
	{
		public static const ASSET_IMAGE_TYPE:uint = 0;
		public static const ASSET_SOUND_TYPE:uint = 1;
		
		private var _swfAssets:Dictionary = new Dictionary();
		private var _zipAssets:Dictionary = new Dictionary();
		private var _cacheTexAtlas:Dictionary = new Dictionary();
		private var _cacheTex:Dictionary = new Dictionary();
		private var _cacheTexUnique:Dictionary = new Dictionary();
		private var _cacheBmd:Dictionary = new Dictionary();
		private var _cacheBmdUnique:Dictionary = new Dictionary();
		private var _cacheSound:Dictionary = new Dictionary();	
		private var _cacheString:Dictionary;
		private var _spriteAssetsXml:Dictionary = new Dictionary();
		private var _configZip:FZip;
		private var _cursor:BitmapData;
		private var _fontRcDict:Dictionary;
		private var _cachePartHost:Dictionary;
		private var _cacheBmdHost:Dictionary;
		private var _cacheAnimHost:Dictionary;
		
		public static const FONTSTRING:String = 
										 " !\"#$%&'()*+,-./0123456789:;<=>?" + 
										 "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" + 
										 "`abcdefghijklmnopqrstuvwxyz{|}~。" + 
										 "一万三上下不与且世丢两严个中为主么之乐也了二于亚亡产享人什仅从仔"+
										 "他付以仪们任份伍休优伙会传伤但位何作你使供侵便保倍候值做停傻像充"+
									     "入全关兵其具内再军冠冰冻准减出击分则刚删利别到制剂力功加务动助劳"+
										 "势勇化北匠区升半协单占卡卫却卷历原厩去参又双发取变口古只召可右号"+
										 "合同名后向吗否吧启吸呃员呢命咋和咒咯品响哦哪唤啊喜嘛器回因围固国"+
										 "图在地场坏块坚坠型垒城域基堡塔增壁士壮处备多够大天太失头夺奋好始"+
										 "威子存它完官定宜实室家对导封射将尉尊小少尚尝就尽尾屏属山屿岛岩崇"+
										 "巨差己已巴币市师帝帮常帽幕并底庞度建开异式引强当录形影待很得御心"+
										 "必忘快念态怎怕思恭恰恶情想意感愧慢戏成我或战所扁手才打扫把投护披"+
										 "抵拜择指按挑挡挥损换授掠接控提援搞摧撤播支攻效敌教敢敬数整斗斧斯"+
										 "新方旗无时明星是普暂暴更最有望木未本术机杀束条来杰极林标校样档棒"+
										 "森模次欢止正此步残段毁每比毫沙没治法派流消涩添游满漠火灭炮点烤烧"+
										 "热然照熔熟牛特犯状狡猪献猾王玩现球瓜甚甜用由电界略疫瘟百的皇盔直"+
										 "盾看真眼着瞭知石砰破确神离种移程空穿窗立第等筑算管箭系红级纪练组"+
										 "终经结给统继绩绪续缓群考者而耗聪肩胜能脚自至致般色花苦英范荒药获"+
										 "菜落蓄蓝蜜血行衫衬被装要规角言让训议记许设诅试诚该语请谁败质费贿"+
										 "赂赚赢起越足路踩转较辐达过迎近返还这进远迹退逃选通速造道遣邀那邪"+
										 "邻部都酋酷里重量金针钉钮钱钻铁铺链锁错键镜镣镶长闪闭问间队防阻降"+
										 "限除陨随隐难需震非面革靴音项顾领颜风飞饰饶马驻验骑骚高龙！（），"+
										 "：；？";
		public static const FONT_WIDTH:uint = 64;
		public static const FONT_HEIGHT:uint = 64;
		
		public function ResourceManager() {
		}
		
		public function regSwf(name:String, domain:ApplicationDomain):void {
			_swfAssets[name] = domain;
		}
		
		public function regZip(name:String, data:ByteArray):void {
			var zipNew:FZip = new FZip();
			zipNew.loadBytes(data);
			_zipAssets[name] = zipNew;
		}
			
		
		public function parseConfigZip(data:ByteArray):Boolean {
			_configZip = new FZip();
			_configZip.loadBytes(data);
			_cursor = getBitmapData(Resources.FONTS_PACK, "cursor");
			if (_cursor != null) {
				var cursorData:MouseCursorData = new MouseCursorData();
				cursorData.data = new Vector.<BitmapData>();
				cursorData.data.push(_cursor);
				
				Mouse.registerCursor(MouseCursor.ARROW, cursorData);
				Mouse.registerCursor(MouseCursor.AUTO, cursorData);
				Mouse.registerCursor(MouseCursor.BUTTON, cursorData);
				Mouse.registerCursor(MouseCursor.HAND, cursorData);
				Mouse.registerCursor(MouseCursor.IBEAM, cursorData);
				Mouse.cursor = MouseCursor.ARROW;
			}
			
			UIObjectFactory.init();
			return true;
		}
		
		public function getConfigXml(url:String):String {
			var fzipFile:FZipFile = _configZip.getFileByName(url);
			if (fzipFile == null)
				return null;
			//var cont:String = fzipFile.content.readMultiByte(fzipFile.content.bytesAvailable, "unicode");
			return fzipFile.getContentAsString(false, "unicode");
		}
		
		public function getTexture(url:String, key:String):Texture {
			var tex:Texture = getUniqueTexture(key);
			if (tex != null)
				return tex;
				
			var texTok:String = getCacheToken(url, key);
			if (_cacheTex[texTok] != null) {
				return _cacheTex[texTok] as Texture;
			}
			
			var bmd:BitmapData = getBitmapData(url, key);
			if (bmd == null) {
				return null;
			}
			_cacheTex[texTok] = Texture.fromBitmapData(bmd, false);
			
			return _cacheTex[texTok] as Texture;
		}
		
		public function getButtonBmpdata(url:String, key:String):Vector.<BitmapData> {
			
			var tokUp:String = getCacheToken(url, key, "up");
			var tokDown:String = getCacheToken(url, key, "down");
			var bmpUp:BitmapData = _cacheBmd[tokUp];
			var bmpDown:BitmapData = _cacheBmd[tokDown];
			
			if (bmpUp == null || bmpDown == null) {			
				var bmpAll:BitmapData;
				if (url == "" || url == null)
					bmpAll = getUniqueBitmapData(key);
				else
					bmpAll = getBitmapData(url, key);
				
				if (bmpAll == null)
					return null;
				
				bmpUp = new BitmapData(bmpAll.width, bmpAll.height >> 1);
				bmpDown = new BitmapData(bmpAll.width, bmpAll.height >> 1);
				
				bmpUp.copyPixels(bmpAll, new Rectangle(0,0,bmpAll.width, bmpAll.height>>1), new Point(0,0));
				bmpDown.copyPixels(bmpAll, new Rectangle(0,bmpAll.height>>1,bmpAll.width, bmpAll.height>>1), new Point(0,0));
				
				_cacheBmd[tokUp] = bmpUp;
				_cacheBmd[tokDown] = bmpDown;
			}
			
			if (bmpUp == null || bmpDown == null)
				return null;
			
			var vBmd:Vector.<BitmapData> = new Vector.<BitmapData>();
			vBmd.push(bmpUp);
			vBmd.push(bmpDown);
			return vBmd;
		}
		
		public function getAnim(key:String):MovieClip {
			if (_cacheAnimHost == null) {
				_cacheAnimHost = new Dictionary();
				var xml:XML = new XML(getConfigXml("scripts/hosts/animationhost.txt"));
				for each (var xmlAnim:XML in xml.animation) {
					//<animation name="fireworks_anim" start_frame="24" end_frame="31" animation_time="0.5" delta_pos="0, 128" frame_size="128, 128" texname="magic_anim3">					
					var texAnim:Texture = getTexture(Resources.ANIMATION_PACK, xmlAnim.@texname);
					if (texAnim == null)
						continue;
					
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
					
					var mc:MovieClip = new MovieClip(vTex, vTex.length / time >> 0);
					
					var str:String = xmlAnim.@name;
					_cacheAnimHost[str] = mc;
				}
			}
			
			if (_cacheAnimHost[key] == null)
				return null;
			
			return _cacheAnimHost[key] as MovieClip;
		}
		
		public function getTextString(key:String):String {
			if (_cacheString == null) {
				_cacheString = new Dictionary();
				
				var fzipFile:FZipFile = _configZip.getFileByName("scripts/eng.txt");
				if (fzipFile == null) {
					Logger.error("scripts/eng.txt not found");
					return "error";
				}
				
				var text:String = fzipFile.getContentAsString(false, "unicode");
				var arr:Array = text.split(/(\r)\n/g);
				var strtt:Array = new Array();
				for (var i:uint = 0; i < arr.length; i++) {
					var arrSub:Array = arr[i].split(" = ");
					if (arrSub.length != 2)
						continue;
					
					var keyName:String = arrSub[0].replace(/[\t ]/g, "");
					_cacheString[keyName] = arrSub[1];
				}
			}
			
			if (_cacheString[key] != null)
				return _cacheString[key] as String;
			
			return key; 
		}
		
		public function getSound(packName:String, url:String):Sound {
			var sndTok:String = getCacheToken(packName, url);
			if (_cacheSound[sndTok] != null) {
				return _cacheSound[sndTok] as Sound;
			}
			
			var zip:FZip = _zipAssets[packName];
			if (zip == null) {
				Logger.error(packName + " not found");
				return null;
			}
			
			var zipFile:FZipFile = zip.getFileByName(url);
			if (zipFile == null) {
				Logger.error(url + " not found in " + packName);
				return null;
			}
			
			var snd:Sound = new Sound();
			snd.loadCompressedDataFromByteArray(zipFile.content, zipFile.sizeUncompressed);
			_cacheSound[sndTok] = snd;
			
			return snd;
		}
		
		public function getParticles(str:String):Particle {
			if (_cachePartHost == null) {
				var fzipFile:FZipFile = _configZip.getFileByName("scripts/host/particlehost.txt");
				if (fzipFile == null) {
					Logger.error("open scripts/host/particlehost.txt failed");
					return null;
				}
				
				
				_cachePartHost = new Dictionary();
				str = fzipFile.getContentAsString(false, "unicode");
				var xml:XML = new XML(str);
				for each (var partXml:XML in xml.particle_template) {
					
				}
			}
			
			if (_cachePartHost[str] == null) {
				Logger.error("particle " + str + " not found");
				return null;
			}
			
			return _cachePartHost[str];
		}
		
		//<image name="particle_zap" texture="particles" rect="65, 1, 127, 63">
		public function getHostBitmapData(name:String):BitmapData {
			if (_cacheBmdHost == null) {
				var fzipFile:FZipFile = _configZip.getFileByName("scripts/host/imagehost.txt");
				if (fzipFile == null) {
					Logger.error("open scripts/host/imagehost.txt failed");
					return null;
				}
				
				_cacheBmdHost = new Dictionary();
				var str:String = fzipFile.getContentAsString(false, "unicode");
				var xml:XML = new XML(str);
				var rect:Rectangle = new Rectangle();
				var arr:Array;
				for each (var partXml:XML in xml.image) {
					var bmdTex:BitmapData = getBitmapData(Resources.GUI_PACK, partXml.@texture);
					if (bmdTex == null) {
						continue;
					}
					
					arr = ScriptHelper.parseDigitArray(xml.@rect);
					rect.setTo(arr[0], arr[1], arr[2]-arr[0], arr[3]-arr[1]);
					var bmdHost:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
					bmdHost.copyPixels(bmdTex, rect, new Point(0,0));
						
					_cacheBmdHost[partXml.@name] = bmdHost;
				}
			}
			
			if (_cacheBmdHost[name] == null) {
				Logger.error("particle " + name + " not found");
				return null;
			}
			
			return _cacheBmdHost[name] as BitmapData;
		}
		
		public function getTextImage(str:String):Image {
			var bmd:BitmapData = getBitmapData(Resources.FONTS_PACK, "lat");
			if (bmd == null)
				return null;
			
			if (_fontRcDict == null) {
				// init font rects
				_fontRcDict = new Dictionary();
				var bmdTemp:BitmapData = new BitmapData(FONT_WIDTH, FONT_HEIGHT, true, 0);
				var rect:Rectangle = new Rectangle(0, 0, FONT_WIDTH, FONT_HEIGHT);
				var wordPerLine:uint = bmd.width / FONT_WIDTH;
				var point:Point = new Point(0, 0);
				for (var i:uint = 1; i < FONTSTRING.length; i++) {
					rect.setTo((i % wordPerLine) * FONT_WIDTH, (i / wordPerLine >> 0) * FONT_HEIGHT, FONT_WIDTH, FONT_HEIGHT);
					bmdTemp.copyPixels(bmd, rect, point);					
					
					var rectTight:Rectangle = bmdTemp.getColorBoundsRect(0xff000000, 0, false);
					rectTight.setTo(rect.left + rectTight.left, rect.top, rectTight.width, FONT_HEIGHT);
					_fontRcDict[FONTSTRING.charAt(i)] = rectTight;
				}
				
				_fontRcDict[" "] = new Rectangle(0, 0, 48, FONT_HEIGHT);
			}			
			
			// determine bmp size
			var rcArr:Vector.<Rectangle> = new Vector.<Rectangle>();
			var rcWhole:Rectangle = new Rectangle(0, 0, 0, FONT_HEIGHT);
			for (i = 0; i < str.length; i++) {
				var rc:Rectangle = _fontRcDict[str.charAt(i)];
				if (rc == null)
					continue;
				rcArr.push(rc);
				rcWhole.right += rc.width; 
			}
			
			if (rcArr.length == 0)
				return null;
			
			var bmdNew:BitmapData = new BitmapData(rcWhole.width, FONT_HEIGHT, true, 0);	
			var pt:Point = new Point(0, 0);
			for (i = 0; i < rcArr.length; i++) {												
				bmdNew.copyPixels(bmd, rcArr[i], pt);
				pt.x += rcArr[i].width;
			}
			
			return Image.fromBitmap(new Bitmap(bmdNew));
		}
		
		public function getAtlasTexture(url:String, imgAsset:String, key:String):Texture {
			var texTok:String = getCacheToken(url, imgAsset, key);
			if (_cacheTex[texTok] != null) {
				return _cacheTex[texTok] as Texture;
			}
			
			var bmd:BitmapData = getBitmapData(url, imgAsset);
			if (bmd == null) {
				return null;
			}
			
			_cacheTexAtlas[texTok] = new TextureAtlas(Texture.fromBitmapData(bmd), _spriteAssetsXml[imgAsset]);		
			_cacheTex[texTok] = (_cacheTexAtlas[texTok] as TextureAtlas).getTexture(key);
			return _cacheTex[texTok] as Texture;
		}	
		
		public function getUniqueBitmapData(key:String):BitmapData {
			if (_cacheBmdUnique[key] != null)
				return _cacheBmdUnique[key] as BitmapData;
			
			for (var str:String in _swfAssets) {
				var data:BitmapData = getBitmapData(str, key, true);
				if (data != null) {
					_cacheBmdUnique[key] = data;
					return data;
				}
			}
			return null;
		}
		
		public function getUniqueTexture(key:String):Texture {
			if (_cacheTexUnique[key] != null)
				return _cacheTexUnique[key] as Texture;
			
			var bmd:BitmapData = getUniqueBitmapData(key);
			if (bmd != null) {
				_cacheTexUnique[key] = Texture.fromBitmapData(bmd, false);
				return _cacheTexUnique[key] as Texture;
			}
			
			return null;
		}
		
		public function getBitmapData(url:String, key:String, bTry:Boolean = false):BitmapData {
			var bmdTok:String = getCacheToken(url, key);
			if (_cacheBmd[bmdTok] == null) {
				if (_swfAssets[url] == null) {
					if (!bTry)
						Logger.error("asset " + url + " not exist");
					return null;
				}
				
				var claz:Class;
				try {
					claz = (_swfAssets[url] as ApplicationDomain).getDefinition(key) as Class;
				} catch (e:Error) {
					if (!bTry)
						Logger.error("definition " + key + " not exist in " + url);
					return null;
				}
				
				var bmd:BitmapData = new claz() as BitmapData;
				if (bmd == null) {
					if (!bTry)
						Logger.error("definition " + key + " in " + url + " is not a image data");
					return null;
				}
				
				_cacheBmd[bmdTok] = bmd;
			}
			
			//trace(bmdTok);
			return _cacheBmd[bmdTok];
		}
		
		
		private function getCacheToken(...keys):String {
			var str:String = "";
			for (var i:String in keys)
				str += keys[i] + "/";
			if (str.lastIndexOf("/") == str.length-1)
				str = str.slice(0, str.length-1);
			return str;
		}
		
	}
}