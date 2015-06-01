package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.AdEnum;
	import com._17173.flash.core.ad.BaseAdDisplay;
	import com._17173.flash.core.ad.interfaces.IAdData;
	import com._17173.flash.core.ad.model.AdDataResolver;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.interfaces.IRendable;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	
	/**
	 * 前贴广告 
	 * @author shunia-17173
	 */	
	public class AdA2 extends BaseAdDisplay implements IRendable
	{
		
		private var _adTime:AdTimeComp = null;
		private var _totalTime:int = 30;
		private var _currentTime:int = 0;
		private var _myvideo:Video;
		private var _ns:NetStream;
		private var _isAdVideo:Boolean = false;
		private var _startTime:Number = 0;
		private var _scale:Number = 0;
		private var _videoWidth:Number = 0;
		private var _videoHeight:Number = 0;
		private var _loader:Loader;
		private var _offsetH:Number = 35;//播放器高度偏移量
		private var _isBaidu:Boolean = false;
		private var _baiduWidth:int;
		private var _baiduHeight:int;
		private var _canThird:Boolean = true;
		private var _videoAdPlayTime:Number = 0;
		//针对ns在stop然后seek(0)之后 ns.time不会立刻变为0 设置一个标志位
		private var _nsEnd:Boolean = false;
		private var _firstMetaData:Boolean = true;
		private var _mute:Boolean = false;
		
		/**
		 * 因为swf和视频的时间取法不一样，所以用_adTimeDelta来保存已经播放过的广告的总时长,按段来记
		 * 那么
		 * 视频的currentTime为 _adTimeDelta + ns.time 
		 * swf的currentTime为 currentTime + time
		 */
		private var _adTimeDelta:int = 0;
		/**
		 * 为了防止视频的时间戳是从中间开始的情况，记录第一个非0的时间为起始时间，并用当前的时间戳减掉起始时间，来得到视频播放时间
		 */
		private var _firstNotZeroTimeGet:Boolean = false;
		
		public function AdA2()
		{
			super();
			
			_adTime = new AdTimeComp();
			addChild(_adTime);	
			_adTime.addEventListener("mute",onVolumeMute);
			_adTime.addEventListener("notMute",onVolumeNotMute);
		}
		
		private function onVolumeMute(e:Event):void {
			_mute = true;
			if (_isAdVideo) {
				_ns.soundTransform = new SoundTransform(0);
			} else {
				this.soundTransform = new SoundTransform(0);
			}
		}
		
		private function onVolumeNotMute(e:Event):void {
			_mute = false;
			if (_isAdVideo) {
				_ns.soundTransform = new SoundTransform(1);
			} else {
				this.soundTransform = new SoundTransform(1);
			}
		}
		
		override protected function onRemoveState(e:Event):void{
			super.onRemoveState(e);
			if (_ns) {
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
				_ns.pause();
				_ns.close();
			}
		}
		
		override public function set data(value:Array):void {
			_currentTime = 0;
			if (!value || value.length == 0) {
				//插件屏蔽了广告调度，导致a2没值，这时候默认显示黑屏；如果放在方法最后value会被删除一位，导致在只有一个a2的情况下广告未被加载就开始倒计时
				_isPlaying = true;
				//				resize(Context.stage.stage.width, Context.stage.stageHeight - 35);
			}
			//先计算总时间
			if (value) {
				var tempTime:int = 0;
				for each (var item:IAdData in value) {
					if (!_canThird && item.url == AdDataResolver.AD_TYPE_BAIDU) {
						
					} else {
						tempTime += item.time;
					}
				}
				if (tempTime > 0 && tempTime != _totalTime) {
					_totalTime = tempTime;
				}
				super.data = value;
			}
			_adTime.time = _totalTime;
			_adTime.soundUI = this;
		}
		
		override protected function onAdComplete():void {
			//如果还有,接着播
			_videoAdPlayTime = 0;
			_firstMetaData = true;
			_adTimeDelta += _currentAdData.time * 1000;
			removeCurrentAd();
			if (hasNextAd()) {
				loadNextAd();
			} else {
				super.onAdComplete();
			}
		}
		
		/**
		 * 检查是否还有下一个 
		 */		
		protected function hasNextAd():Boolean {
			if (_data && _data.length > 0) {
				return true;
			}
			return false;
		}
		
		private function removeCurrentAd():void {
			if (_ad && _adLayer.contains(_ad)) {
				_adLayer.removeChild(_ad);
			}
			
			if (_ad && _ad is MovieClip && _ad.loaderInfo && _ad.loaderInfo.loader) {
				_ad.loaderInfo.loader.unloadAndStop(true);
			}
			if (_ad && _ad is Loader) {
				(_ad as Loader).unloadAndStop(true);
			}
			_ad = null;
		}
		
		protected function loadNextAd():void {
			_currentAdData = _data.shift();
			loadAdInternal(_currentAdData);
		}
		
		override public function resize(w:Number, h:Number):void {
			_w = w;
			_h = h;
			resizeAd();
			if ((_w && _w != _bg.width) || (_h && _h != _bg.height)) {
				drawBg(_w, _h);
			}
			if (_adTime) {
				_adTime.x = w - _adTime.width;
				_adTime.y = 0;
			}
			if (_ad == null) return;
			
			/**
			 * 保证ad在背景中居中显示
			 */
			var ww:Number = 0;
			var hh:Number = 0;
			if (_isBaidu) {
				ww = _w;
				hh = _h;
				if (_loader &&　_loader.content) {
					_loader.content["setSize"](w, h);
				}
			} else {
				//由于加载过来的swf是动态的，所以需要取他的准确的宽高
				if (_ad is Loader) {
					ww = (_ad as Loader).contentLoaderInfo.width;
					hh = (_ad as Loader).contentLoaderInfo.height;
				} else if (_ad is Video){
					ww = (_ad as Video).videoWidth;
					hh = (_ad as Video).videoHeight;
				} else if (_ad.hasOwnProperty("root")) {
					ww = _ad.root.width;
					hh = _ad.root.height;
				}
			}
			_adLayer.x = (_bg.width - (ww * _ad.scaleX)) / 2;
			_adLayer.y = (_bg.height - (hh * _ad.scaleY)) / 2;
		}
		
		override protected function resizeAd():void {
			if (_ad) {
				var sx:Number = ADWidth > _w ? _w / ADWidth : 1;
				var sy:Number = ADHeight > _h ? _h / ADHeight : 1;
				_scale = sx > sy ? sy : sx;
				_ad.scaleX = _ad.scaleY = _scale;
			}
		}
		
		
		/**
		 * 根据广告文件类型进行加载 
		 */		
		protected override function startLoad(ad:IAdData):void {
			if (ad.url == AdDataResolver.AD_TYPE_BAIDU) {
				_isAdVideo = false;
				if (_canThird) {
					_isBaidu = true;
					loadBaidu();
				} else {
					Debugger.log(Debugger.ERROR, "[ad]", "此版本不能播放百度广告，直接跳过");
					onAdComplete();
				}
			} else {
				_isBaidu = false;
				if (ad.extension == AdEnum.EXTENSION_VIDEO) {
					loadVideo(ad);
					_isAdVideo = true;
				} else if (ad.extension == AdEnum.EXTENSION_SWF) {
					loadSWF(ad);
					_isAdVideo = false;
				} else if (ad.extension == AdEnum.EXTENSION_IMAGE) {
					loadImage(ad);
					_isAdVideo = false;
				} else {
					Debugger.log(Debugger.ERROR, "[ad]", "试图根据没有定义的广告类别(" + ad.extension + ")进行加载!");
				}
			}
		}
		
		private function loadBaidu():void {
			_adTime.soundUI = this;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onBaiduAdInit);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest("http://cpro.baidu.com/cpro/ui/baiduLoader_as3.swf"));
			_loader.addEventListener(MouseEvent.CLICK, onBaiduAdClick);
			_ad = _loader;
			_adLayer.addChild(_ad);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			Debugger.log(Debugger.INFO, "[AD_A2_baidu]", "百度联盟io错误!");
			onError({"url":"baidu", "type": "baidu"});
		}
		
		/**
		 * 百度广告加载完毕
		 * 该函数设置参数，并调用接口发出广告请求
		 */
		private function onBaiduAdInit(e : Event) : void {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onBaiduAdInit);
			_baiduWidth = (_w && _w > 0) ? _w : Context.stage.stageWidth;
			_baiduHeight = (_h && _h > 0) ? _h : Context.stage.stageHeight - _offsetH;
			if (_baiduWidth < 430 || _baiduHeight < 350) {
//				onError({"url":"baidu", "type":"小于百度广告默认宽高"});
				Debugger.log(Debugger.INFO, "[AD_A2_baidu] 初始化错误");
				_adLayer.removeChild(_loader);
				_totalTime -= _currentAdData.time;
				onAdComplete();
				return;
			}
			var param : Object = {};
			param.cpro_channel = getChannel();
			param.cpro_client = getClient();
			Debugger.log(Debugger.INFO, "[AD_A2_baidu]" + param.cpro_client + "   url:" + getUrl());
			param.cpro_filters = ["多玩","178","爱拍","太平洋游戏网","yy"];
			param.cpro_url = getUrl();
			param.cpro_template = "baiduxml_tiepian_400_300";
			param.cpro_w = _baiduWidth;
			param.cpro_h = _baiduHeight;
			param.cpro_plan = 4;
			//param.参数名 = 参数值;
			(_loader.content as Object)["requestAdData"](markPlaying, param);
			
			//曝光
			super.onAdShowPost();
			resize(_w, _h);
			
//			Ticker.tick(_currentAdData.time * 1000, onAdComplete);
		}
		
		private function getClient():String {
			var re:String;
			switch (Context.variables["type"]) {
				case "f1":
					re = "43067007_4_tp_cpr";
					break;
				case "f3":
					re = "43067007_3_tp_cpr";
					break;
				case "f5":
					re = "43067007_3_tp_cpr";
					break;
				default:
					re = "43067007_4_tp_cpr";
					break;
			}
			return re;
		}
		
		private function getChannel():String {
			var re:String;
			switch (Context.variables["type"]) {
				case "f1":
					re = "2";
					break;
				case "f3":
					re = "1";
					break;
				case "f5":
					re = "1";
					break;
				default:
					re = "2";
					break;
			}
			return re;
		}
		
		/**
		 * 获取当前的url
		 * @return 
		 * 
		 */		
		private function getUrl():String {
			var temp:String = Util.refPage;
			var re:String = "17173.tv.sohu.com";
			if (Util.validateStr(temp) && temp.indexOf("http://") != -1) {
				re = temp;
			}
			return re;
		}
		
		/**
		 * 加载flv或者mp4视频
		 */
		protected override function loadVideo(ad:IAdData):void {
			/**
			 * 在这里放广告加载的逻辑
			 */
			var nc:NetConnection = new NetConnection();
			
			nc = new NetConnection();
			nc.connect(null);
			_ns = new NetStream(nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
			_ns.play(ad.url);
			_ns.bufferTime = 3;
			var customclient:Object = new Object();
			customclient.onCuePoint = cuePointHandler;
			customclient.onMetaData = metaDataHandler;
			_ns.client = customclient;
		}
		
		private function onStreamHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.Stop":
					checkPlayTime();
					break;
				case "NetStream.Play.StreamNotFound":
					videoStatusClose();
					break;
				case "NetStream.Connect.Failed":
					videoStatusClose();
					break;
				case "NetStream.Connect.Closed":
					videoStatusClose();
					break;
			}
		}
		
		/**
		 * 判断当前广告是否已经播放超过15秒 如果不是 就重播
		 */
		private function checkPlayTime():void {
			if (_videoAdPlayTime + _ns.time < _currentAdData.time ) {
				_videoAdPlayTime += _ns.time;
				_ns.seek(0);
				_nsEnd = true;//标示netstream流播放结束 为了防止ns流结束 但ns.time未更新到0的bug
			} else {
				_ns.pause();
				_ns.close();
				_isPlaying = false;
				_error = false;
				onAdComplete();
			}
		}
		
		private function cuePointHandler(infoObject:Object):void {
			
		}
		
		private function metaDataHandler(infoObject:Object):void {
			if (!_firstMetaData) return;
			
			_firstMetaData = false;
			_videoWidth = infoObject.width;
			_videoHeight = infoObject.height;
			_myvideo = new Video(infoObject.width, infoObject.height);
			_myvideo.attachNetStream(_ns);
			_ad = _myvideo;
			onAdLoadSuccess();
			_adLayer.addChildAt(_ad,0);
			//有时长定义才启动计时
			if (_currentAdData.time > 0) {
				_ns.resume();
				markPlaying();
			} else {
				onAdComplete();
			}
		}
		
		protected override function onAdLoadSuccess():void {
			if (_mute) onVolumeMute(null);
			else onVolumeNotMute(null);
			super.onAdLoadSuccess();
		}
		
			
		public function get needUpdate():Boolean {
			return true;
		}
		
		
		public override function get ADWidth():Number
		{
			var re:Number = _ad.width;
			if (_ad is Loader) {
				if (_isBaidu) {
					re = _baiduWidth;
				} else {
					re = (_ad as Loader).contentLoaderInfo.width;
				}
			} else if (_ad is Video){
				re = _videoWidth;
			}else if (_ad.hasOwnProperty("root")) {
				re = _ad.root.width;
			}
			return re;
		}
		
		public override function get ADHeight():Number
		{
			var re:Number = _ad.height;
			if (_ad is Loader) {
				if (_isBaidu) {
					re = _baiduHeight;
				} else {
					re = (_ad as Loader).contentLoaderInfo.height;
				}
			} else if (_ad is Video){
				re = _videoHeight;
			}else if (_ad.hasOwnProperty("root")) {
				re = _ad.root.height;
			}
			return re;
		}
		
		override protected function onError(error:Object):void {
			super.onError(error);
			
			markPlaying();
		}
		
		private function videoStatusClose():void {
			_adTime.time = 0;
			_isPlaying = false;
			_error = false;
			onAdComplete();
		}
		
		public function update(time:int):void {
			if (_isPlaying || _error) 
			{
				var s:int = 0;
				var r:int = 0;
				if (_isAdVideo)
				{
					if ((_nsEnd)&&(_ns.time > 0.5)) return ;
					_nsEnd = false;
					if ((_ns.time > 0.0001) &&(!_firstNotZeroTimeGet))
					{
						_firstNotZeroTimeGet = true;
						_startTime  = _ns.time;
					}
					
					_currentTime = _adTimeDelta + _videoAdPlayTime*1000 + _ns.time*1000 - _startTime*1000;
					s = _currentTime/1000;
					if (_videoAdPlayTime + _ns.time >= _currentAdData.time) {
						_ns.pause();
						_ns.close();
						_isPlaying = false;
						_error = false;
						onAdComplete();
					} else {
						if (_adTime) {
							_adTime.time = _totalTime - s;;
						}
					}
				}
				else
				{
					_currentTime += time;
					s = _currentTime / 1000;
					if (s >= _currentAdData.time) {
						_isPlaying = false;
						_error = false;
						_currentTime = 0;
						_totalTime -= _currentAdData.time;
						onAdComplete();
					} else {
						if (_adTime) {
							_adTime.time = _totalTime - s;;
						}
					}
					
				}
			}
		}

		public function get canThird():Boolean
		{
			return _canThird;
		}

		public function set canThird(value:Boolean):void
		{
			_canThird = value;
		}

		private function onBaiduAdClick(event:MouseEvent):void {
			super.onAdClickPost();
		}
		
		override protected function onAdClick(event:MouseEvent):void {
			if (_isBaidu) {
				return;
			} else {
				super.onAdClick(event);
			}
		}
	}
}