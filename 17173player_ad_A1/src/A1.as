package
{
	import com._17173.flash.core.ad.AdEnum;
	import com._17173.flash.core.ad.display.AdTimeComp;
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.debug.DebuggerOutput_console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	/**
	 * 大前贴播放器
	 *  
	 * @author shunia-17173
	 * 
	 */	
	[SWF(width="1200", height="900")]
	public class A1 extends StageIniator
	{
		
		private var _ads:Array = null;
		private var _seperate:Boolean = false;
		private var _data:Object = null;
//		private var _retry:int = 3;
		private var _adLayer:Sprite = null;
		private var _adTime:AdTimeComp = null;
		private var _totalTime:int = 15;
		private var _currentTime:int = 0;
		private var _isPlaying:Boolean = false;
		private var _startTime:Number = 0;
		private var _adIsSwf:Boolean = false;
		private var _swf:MovieClip = null;
		private var _firstAdComplete:Boolean = true;
		private var _ns:String = "";
		
		private static const TEST:Array = [
			{"tsc":[],"extension":0, "jumpTo":"http://www.baidu.com", "round":1, "time":15, "type":"da_qian_tie", "url":"http://cdn4.v.17173.com/advideo/2014/09/02/sss.swf","sc":"http://www.baidu.com","cc":"http://www.baidu.com","totalTime":30}, 
			{"tsc":[],"extension":0, "jumpTo":"http://www.baidu.com", "round":1, "time":15, "type":"da_qian_tie", "url":"http://cdn4.v.17173.com/advideo/2014/09/02/sss.swf","sc":"http://www.baidu.com","cc":"http://www.baidu.com","totalTime":15}
		];
//		private static const TEST_OBJECT:Object = {"tsc":[],"extension":0, "jumpTo":"http://www.baidu.com", "round":1, "time":15, "type":"A1", "url":"http://cdn4.v.17173.com/advideo/2014/09/02/sss.swf","sc":"http://www.baidu.com"};
		
		public function A1()
		{
			super(true);
			buttonMode = true;
			_adLayer = new Sprite();
			addChild(_adLayer);
		}
		
		override protected function init():void {
			super.init();
			var version:String = "0.1.9";
			if (stage.loaderInfo.parameters.hasOwnProperty("guid") && stage.loaderInfo.parameters["guid"] != "") {
				_ns = stage.loaderInfo.parameters["guid"];
			}
			//点播用NO_SCALE 直播用SHOW_ALL
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			if (stage.loaderInfo.parameters.playerType == "live") {
				stage.scaleMode = StageScaleMode.SHOW_ALL;
			} else if (stage.loaderInfo.parameters.playerType == "videoOut") {
				stage.scaleMode = StageScaleMode.SHOW_ALL;
			} else {
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			//stage.loaderInfo.loaderURL
			stage.align = StageAlign.TOP_LEFT;
			Security.allowDomain("*");
			
			Debugger.source = "大前贴";
			Debugger.output = new DebuggerOutput_console();
			
			Debugger.log(Debugger.INFO, "版本: " + version);
			
			JSBridge.addCall("setAd", null, null, onAdData, true);
			
			var context:ContextMenu = new ContextMenu();
			context.hideBuiltInItems();
			var contexts:Array = [];
			var item:ContextMenuItem = new ContextMenuItem("17173 A1 Player,版本: " + version, false, false);
			//contexts.push(logMenuitem);
			contexts.push(item);
			
			context.customItems = contexts;
			this.contextMenu = context;
			
			addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(MouseEvent.CLICK, onAdClick);
			
//			onAdData(TEST);
			//时序会出问题,从而导致从缓存获取的广告文件无法正确加载crossdomain文件,所以增加延迟以避免这个现象
			delayRun(200, tellJSA1Ready);
		}
		
		private function delayRun(ms:int,func:Function):void {
			var interval:uint = setInterval(function():void {
				clearInterval(interval);
				func();
			}, 200)
		}
		
		private function tellJSA1Ready():void {
			JSBridge.addCall("onA1Ready", null, domainName);
		}
		
		private function tellJSAdBegin():void {
			JSBridge.addCall("onAdA1Begin", null, domainName);
		}
		
		protected function onResize(event:Event):void {
			// TODO Auto-generated method stub
			if (_adLayer.width && _adLayer.height) {
				_adLayer.width = stage.width;
				_adLayer.height = stage.height;
			}
		}
		
		private function onAdData(data:Object):void {
			Debugger.log(Debugger.INFO, "大前贴数据已获取!");
			if (data is Array) {
				_seperate = false;
				// 如果是数组,说明全都是大前贴
				_ads = data as Array;
				initAdTime();
				startNext();
			} else if (data) {
				_seperate = true;
				// 如果不是数组,说明是单个大前贴
				_ads = [data];
				initAdTime();
				startNext();
			} else {
				Debugger.log(Debugger.ERROR, "大前贴数据无效!");
				onAdComplete();
			}
		}
		
		/**
		 * 对时间计算的逻辑不一样 
		 */		
		private function initAdTime():void {
			if (!_adTime) {
				_adTime = new AdTimeComp();
				_adTime.visible = false;
				addChild(_adTime);
			}
			// 单个大前贴和多轮大前贴采用不同的计时逻辑
//			if (!_seperate) {
//				var tmp:int = 0;
//				for each (var ad:Object in _ads) {
//					tmp += ad.time;
//				}
//				_totalTime = _adTime.time = tmp;
//			} else {
//				_totalTime = _adTime.time = _ads[0].time;
//			}
			_adTime.soundUI = this;
//			_adTime.y = 74; //大前帖与播放器的高度差值，现在是固定值，如果动态可以使用配置文件里的y值
			_adTime.y = 40;
		}
		
		protected function startNext():void {
			if (_ads && _ads.length) {
				_data = _ads.shift();
				initAd();
				loadAdInternal();
			} else {
				_isPlaying = false;
				onAdComplete();
			}
		}
		
		protected function initAd():void {
			_currentTime = 0;
			_isPlaying = false;
			_totalTime = _adTime.time = _data.totalTime;
			Debugger.log(Debugger.INFO, "大前贴数据: ", sr(_data));
			while (_adLayer.numChildren) {
				_adLayer.removeChildAt(0);
			}
			_swf = null;
		}
		
		/**
		 * 验证并判断,以进行广告文件调度 
		 * @param ad
		 */		
		protected function loadAdInternal():void {
			var validatedEx:int = AdEnum.validateExtension(_data.url);
			var validate:Boolean = true;
			if (validatedEx == -1) {
				Debugger.log(Debugger.WARNING, "试图加载的广告文件是不支持的格式!");
				validate = false;
			}
			if (validate && _data.extension != validatedEx) {
				Debugger.log(Debugger.WARNING, "配置文件广告类型(" + _data.extension + ")与文件实际类型(" + validatedEx + ")不符!使用实际文件类型进行播放!");
				_data.extension = validatedEx;
			}
			startLoad();
		}
		
		/**
		 * 根据广告文件类型进行加载 
		 */		
		protected function startLoad():void {
			var e:String = null;
			if (_data.extension == AdEnum.EXTENSION_VIDEO) {
				e = "视频";
				loadVideo();
			} else if (_data.extension == AdEnum.EXTENSION_SWF) {
				e = "SWF";
				loadSWF();
			} else if (_data.extension == AdEnum.EXTENSION_IMAGE) {
				e = "图片";
				loadImage();
			} else {
				Debugger.log(Debugger.ERROR, "试图根据没有定义的广告类别(" + _data.extension + ")进行加载!");
			}
			
			if (e) {
				Debugger.log(Debugger.INFO, "启动加载: ", _data.url, ", 类型: ", e);
			}
		}
		
		protected function loadVideo():void {
		}
		
		/**
		 * 加载swf广告 
		 */		
		protected function loadSWF():void {
			//loadAsset(_data.url, LoaderProxyOption.FORMAT_SWF, onSWFLoaded);
			_adIsSwf = true;
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				_data.url, 
				LoaderProxyOption.FORMAT_SWF, 
				LoaderProxyOption.TYPE_ASSET_LOADER, 
				onSWFLoaded, 
				function (d:Object):void {
					Debugger.log(Debugger.WARNING, "[大前贴]", "广告文件加载失败! 类型 -> " + _data.type + ", 地址 -> ", _data.url);
					startNext();
				});
			loader.load(option);
		}
		
		/**
		 * 开始加载图片 
		 */		
		protected function loadImage():void {
//			loadAsset(_data.url, LoaderProxyOption.FORMAT_IMAGE, onImageLoaded);
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				_data.url, 
				LoaderProxyOption.FORMAT_IMAGE, 
				LoaderProxyOption.TYPE_ASSET_LOADER, 
				onImageLoaded, 
				function (d:Object):void {
					Debugger.log(Debugger.WARNING, "[大前贴]", "广告文件加载失败! 类型 -> " + _data.type + ", 地址 -> ", _data.url);
					startNext();
				});
			loader.load(option);
		}
		
		/**
		 * swf广告加载成功 
		 * @param swf
		 */		
		protected function onSWFLoaded(swf:MovieClip):void {
			tellJSAdBegin();

			_adTime.visible = true;
			_adLayer.addChildAt(swf, 0);
			onLoaded();
			_swf = swf;
			//_swf.gotoAndStop(1);
			Debugger.log(Debugger.INFO, "广告文件已加载, 启动倒计时: ", _data.time);
			this.setChildIndex(_adTime, this.numChildren - 1);
			//有时长定义才启动计时
		}
		
		/**
		 * 图片加载成功 
		 * @param image
		 */		
		protected function onImageLoaded(image:DisplayObject):void {
			tellJSAdBegin();
			
			_adTime.visible = true;
			_adLayer.addChildAt(image, 0);
			onLoaded();
			//有时长定义才启动计时
		}
		
		protected function onAdClick(event:MouseEvent):void {
			if (Util.validateStr(_data.jumpTo)) {
//				navigateToURL(new URLRequest(_data.jumpTo), "_blank");
				Util.toUrl(_data.jumpTo);
			}
			onAdClickPost();
		}
		
		/**
		 *点击请求 
		 * 
		 */		
		protected function onAdClickPost():void{
			var url:String = _data.cc;
			Debugger.log(Debugger.INFO, "[大前贴]", "广告点击请求 " + ", 地址 -> ", url);
			request(url);
		}		
		
		
		/**
		 *曝光请求 
		 * 
		 */		
		protected function onAdShowPost():void{
			var url:String = _data.sc;
			request(url);
			Debugger.log(Debugger.INFO, "[大前贴]", "广告曝光请求 " + ", 地址 -> ", url);
			var urls:Array = _data.tsc;
			var len:int = urls.length;
			for (var i:int = 0; i < len; i++) 
			{
				request(String(urls[i]));
			}
		}
		
//		/**
//		 * 通用的加载方法. 
//		 * @param url
//		 * @param format
//		 * @param callback
//		 */		
//		protected function loadAsset(url:String, format:String, callback:Function):void {
//			if(url == "")
//			{
//				Debugger.log(Debugger.WARNING, "[大前贴]", "无广告加载地址");
//				onAdComplete();
//			}
//			try {
//				var l:Loader = new Loader();
//				l.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
//					_isPlaying = true;
//					_startTime = getTimer();
//					callback(l);
//				});
//				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
//					//retry
//					_retry --;
//					if (_retry > 0) {
//						loadAsset(url, format, callback);
//					} else {
//						Debugger.log(Debugger.WARNING, "[大前贴]", "广告文件加载失败! 类型 -> " + _data.type + ", 地址 -> ", _data.url);
//						onAdComplete();
//					}
//				});
//				l.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent):void {
//					Debugger.log(Debugger.WARNING, "[大前贴]", "广告文件加载失败,安全域问题! 类型 -> " + _data.type + ", 地址 -> ", _data.url);
//					onAdComplete();
//				});
//				l.load(new URLRequest(url), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
////				l.load(new URLRequest(url));
//			} catch (e:Error) {
//				//retry
//				_retry --;
//				if (_retry > 0) {
//					loadAsset(url, format, callback);
//				} else {
//					Debugger.log(Debugger.WARNING, "[大前贴]", "广告文件加载失败! 类型 -> " + _data.type + ", 地址 -> ", _data.url);
//					onAdComplete();
//				}
//			}
//				
//		}
		/**
		 *曝光或者点击请求 
		 * @param url
		 * @param back
		 * 
		 */		
		public function request(url:String):void{
			var urlRequest:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,function(e:Event):void{
				Debugger.log(Debugger.INFO, "[大前贴]", "广告曝光或点击请求成功-> " + ", 地址 -> ", url);
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void{
				Debugger.log(Debugger.ERROR, "[大前贴]", "广告曝光或点击地址错误-> " + ", 地址 -> ", url);
			});
			loader.load(urlRequest);
		}
		
		private function onAdComplete():void {
			if (_firstAdComplete) {
				_firstAdComplete = false;
				Debugger.log(Debugger.WARNING, "[大前贴]", "大前贴播放完毕!");
				JSBridge.addCall("onA1Complete", null, domainName);
			} 
		}
		
		/**
		 * 加载广告成功 
		 */		
		private function onLoaded():void {
			_isPlaying = true;
			_startTime = getTimer();
			onAdShowPost();
		}
		
		private function sr(obj:Object):String {
			var r:String = "{";
			for (var k:String in obj) {
				r += k + ":" + String(obj[k]) + ",";
			}
			r += "}";
			return r;
		}
		
		public function update(evt:Event):void {
			if (_isPlaying) {
				_currentTime = getTimer();
				var s:int = (_currentTime - _startTime) / 1000;
				if (_adIsSwf && _swf) {
					s = _swf.currentFrame/_swf.totalFrames * _data.time;
				}
				if (s >= _data.time) {
					startNext();
				} else {
					if (_adTime) {
						_adTime.time = _totalTime - s;
					}
				}
			}
		}
		
		/**
		 * 站外播放器需要获取一个所在域的名字，站内不需要
		 */		
		private function get domainName():String {
			if (_ns && _ns != "") {
				return _ns;
			} else {
				return null;
			}
		}
	}
}