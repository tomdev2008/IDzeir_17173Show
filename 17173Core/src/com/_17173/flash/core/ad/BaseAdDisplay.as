package com._17173.flash.core.ad
{
	import com._17173.flash.core.ad.interfaces.IAdData;
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.data.BaseVideoData;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class BaseAdDisplay extends Sprite implements IAdDisplay
	{
		protected var _w:Number = 0;
		protected var _h:Number = 0;
		
		protected var _bg:Shape = null;
		protected var _ad:DisplayObject = null;
		protected var _adLayer:Sprite = null;
		protected var _data:Array = null;
		protected var _sourceData:Array;
		protected var _currentAdData:IAdData = null;
		protected var _videoData:BaseVideoData = null;
		protected var _isPlaying:Boolean = false;
		protected var _error:Boolean = false;
		/**
		 *是否加载到舞台 
		 */		
		protected var _onAdded:Boolean = false;
		/**
		 *是否显示中 
		 */		
		protected var _isShow:Boolean = false;
		/**
		 *是否加载完资源 
		 */		
		protected var _isload:Boolean = false;
		
		public function BaseAdDisplay()
		{
			super();
			
			_bg = new Shape();
			addChild(_bg);
			_adLayer = new Sprite();
			_adLayer.buttonMode = true;
			_adLayer.useHandCursor = true;
			_adLayer.mouseEnabled = true;
			_adLayer.mouseChildren = true;
			addChild(_adLayer);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(e:Event):void{
			_onAdded = true;
			checkSendPost();
			loadAdInternal(_currentAdData);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveState);
		}
		
		protected function onRemoveState(e:Event):void{
			_isShow = false;
			_onAdded = false;
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveState);
		}
		
		public function resize(w:Number, h:Number):void
		{
			_w = w;
			_h = h;
			resizeAd();
			if ((_w && _w != _bg.width) || (_h && _h != _bg.height)) {
				drawBg(_w, _h);
			}
			if (_ad == null) return;
			var ww:Number = 0;
			var hh:Number = 0;
			//由于加载过来的swf是动态的，所以需要取他的准确的宽高
			if (_ad is Loader) {
				ww = (_ad as Loader).contentLoaderInfo.width;
				hh = (_ad as Loader).contentLoaderInfo.height;
			} else if (_ad.hasOwnProperty("root")) {
				ww = _ad.root.width;
				hh = _ad.root.height;
			}
			
			_adLayer.x = (_bg.width - (ww * _ad.scaleX)) / 2;
			_adLayer.y = (_bg.height - (hh * _ad.scaleY)) / 2;
		}
		
		/**
		 * 绘制广告背景板
		 */
		protected function drawBg(w:Number, h:Number):void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000, 1);
			_bg.graphics.drawRect(0, 0, w, h);
			_bg.graphics.endFill();
		}
		
		public function get display():DisplayObject
		{
			return this;
		}
		
		public function set data(value:Array):void
		{
			_data = value;
			_sourceData = Util.clone(value) as Array;
			//取第一个开始
			_currentAdData = _data.shift();
		}
		
		/**
		 * 验证并判断,以进行广告文件调度 
		 * @param ad
		 */		
		protected function loadAdInternal(ad:IAdData):void {
			if (!ad) {
				Debugger.log(Debugger.WARNING, "正在加载广告: 广告数据为空，可能是百度广告");
				return;
			}
			Debugger.log(Debugger.WARNING, "正在加载广告: " + ad.url);
			_isPlaying = false;
			var validatedEx:int = AdEnum.validateExtension(ad.url);
			var validate:Boolean = true;
			if (validatedEx == -1) {
				Debugger.log(Debugger.WARNING, "[ad]", "试图加载的广告文件是不支持的格式!");
				validate = false;
			}
			if (validate && ad.extension != validatedEx) {
				Debugger.log(Debugger.WARNING, "[ad]", "配置文件广告类型(" + ad.extension + ")与文件实际类型(" + validatedEx + ")不符!使用实际文件类型进行播放!");
				ad.extension = validatedEx;
			}
			startLoad(ad);
		}
		
		/**
		 * 根据广告文件类型进行加载 
		 */		
		protected function startLoad(ad:IAdData):void {
			if (ad.extension == AdEnum.EXTENSION_VIDEO) {
				loadVideo(ad);
			} else if (ad.extension == AdEnum.EXTENSION_SWF) {
				loadSWF(ad);
			} else if (ad.extension == AdEnum.EXTENSION_IMAGE) {
				loadImage(ad);
			} else {
				Debugger.log(Debugger.ERROR, "[ad]", "试图根据没有定义的广告类别(" + ad.extension + ")进行加载!");
			}
		}
		
		protected function loadVideo(ad:IAdData):void {
			_videoData = new BaseVideoData();
			_videoData.connectionURL = null;
			_videoData.streamName = ad.url;
			
			_isload = true;
			checkSendPost();
		}
		
		/**
		 * 加载swf广告 
		 */		
		protected function loadSWF(ad:IAdData):void {
			loadAsset(ad.url, LoaderProxyOption.FORMAT_SWF, onSWFLoaded);
		}
		
		/**
		 * swf广告加载成功 
		 * @param swf
		 */		
		protected function onSWFLoaded(swf:DisplayObject):void {
			if (swf is Loader) {
				_ad = swf;
			} else {
				_ad = swf.loaderInfo.loader;
			}
			
			_adLayer.addChildAt(_ad, 0);
			
			onAdLoadSuccess();
			
			//有时长定义才启动计时
			if (_currentAdData.time > 0) {
				Ticker.tick(_currentAdData.time * 1000, onAdComplete);
				markPlaying();
			} else {
				onAdComplete();
			}
		}
		
		/**
		 * 开始加载图片 
		 */		
		protected function loadImage(ad:IAdData):void {
			loadAsset(ad.url, LoaderProxyOption.FORMAT_IMAGE, onImageLoaded);
		}
		
		/**
		 * 图片加载成功 
		 * @param image
		 */		
		protected function onImageLoaded(image:DisplayObject):void {
			if (image is Loader) {
				_ad = image;
			} else {
				_ad = image.loaderInfo.loader;
			}
			_adLayer.addChildAt(_ad, 0);
			
			onAdLoadSuccess();
			//有时长定义才启动计时
			if (_currentAdData.time > 0) {
				Ticker.tick(_currentAdData.time * 1000, onAdComplete);
				
				markPlaying();
			} else {
				onAdComplete();
			}
		}
		
		protected function onAdClick(event:MouseEvent):void {
			if (Util.validateStr(_currentAdData.jumpTo)) {
				if (Context.stage.displayState != StageDisplayState.NORMAL) {
					Context.stage.displayState = StageDisplayState.NORMAL;
				}
				Util.toUrl(_currentAdData.jumpTo);
			}
			onAdClickPost();
		}
		
		/**
		 *点击请求  
		 * 
		 */		
		protected function onAdClickPost():void{
			if(!_currentAdData || !_currentAdData.cc) return;
			var url:String = _currentAdData.cc;
			//废弃 点击请求添加时间戳后会导致请求失败
			//			request(url,function(o:Object = null):void{
			//				Debugger.log(Debugger.INFO, "[ad]", "广告点击请求成功 ", "地址 -> ", url);
			//			});
			clickRequest(url);
		}
		
		/**
		 *曝光请求 
		 * 
		 */		
		protected function onAdShowPost():void{
			if(!_currentAdData || !_currentAdData.sc) return;
			var url:String = _currentAdData.sc;
			request(url,function(o:Object = null):void{
				Debugger.log(Debugger.INFO, "[ad]", "广告曝光请求成功 ", "地址 -> ", url);
			});
			
			if(!_currentAdData.tsc) return;
			var urls:Array = _currentAdData.tsc;
			var len:int = urls.length;
			for (var i:int = 0; i < len; i++) 
			{
				request(String(urls[i]),function(o:Object = null):void{
					Debugger.log(Debugger.INFO, "[ad]", "广告曝光请求成功 ", "地址 -> ", url);
				});
			}
			
		}
		
		/**
		 * 标志开始播放
		 */		
		protected function markPlaying():void {
			_isPlaying  = true;
		}
		
		/**
		 * 加载广告成功 
		 */		
		protected function onAdLoadSuccess():void {
			_isload = true;
			checkSendPost();
			_adLayer.addEventListener(MouseEvent.CLICK, onAdClick);
			resize(_w, _h);
		}
		
		/**
		 * 重置广告位置 
		 */		
		protected function resizeAd():void {
			if (_ad) {
				//				_mask.graphics.clear();
				//				_mask.graphics.beginFill(0, 1);
				//				_mask.graphics.drawRect(0, 0, _ad.loaderInfo.width, _ad.loaderInfo.height);
				//				_mask.graphics.endFill();
				//				_adLayer.mask = _mask;
			}
		}
		
		/**
		 * 广告播放结束 
		 */		
		protected function onAdComplete():void {
			dispatchEvent(new Event("adComplete"));
		}
		
		/**
		 * 通用的加载方法. 
		 * @param url
		 * @param format
		 * @param callback
		 */		
		protected function loadAsset(url:String, format:String, callback:Function):void {
			try {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = new LoaderProxyOption(
					url, format, LoaderProxyOption.TYPE_ASSET_LOADER, callback, function (d:Object):void {
						onError({"url":url, "type":_currentAdData ? _currentAdData.type : ""});
					});
				loader.load(option);
			} catch (e:Error) {
				onError({"url":url, "type":_currentAdData ? _currentAdData.type : ""});
			}
		}
		/**
		 *发送请求 
		 * @param url
		 * 
		 */		
		protected function request(url:String,callback:Function):void {
			url = url + ("&t=" + new Date().time);
			if (url == "") {
				Debugger.log(Debugger.WARNING, "[ad]", "广告请求失败 -> ", "地址 -> ", url);
				return;
			}
			try {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = new LoaderProxyOption(
					url, null, null, callback, function (d:Object):void {
						Debugger.log(Debugger.WARNING, "[ad]", "广告请求失败 -> ", "地址 -> ", url);
					});
				loader.load(option);
			} catch (e:Error) {
				Debugger.log(Debugger.WARNING, "[ad]", "广告请求失败 -> ", "地址 -> ", url);
			}
		}
		
		/**
		 *点击统计方法 （通用request方法会在请求最后加入时间戳，但会导致好耶请求失败，所以单独写一个没有时间戳的点击请求）
		 * @param url
		 * 
		 */		
		private function clickRequest(url:String):void {
			Debugger.log(Debugger.WARNING, "[ad]", "广告点击统计 -> ", "地址 -> ", url);
			var request:URLRequest = new URLRequest(url);
			var load:URLLoader = new URLLoader();
			request.method = URLRequestMethod.GET;
			load.load(request);
		}
		
		protected function onError(error:Object):void {
			Debugger.log(Debugger.WARNING, "[ad]", "广告文件加载失败! 类型 -> " + error.type + ", 地址 -> ", error.url);
			
			_error = true;
			dispatchEvent(new Event("onAdError"));
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		public function dispose():void {
			_data = null;
		}
		
		public function replay():void {
			
		}
		
		public function get ADWidth():Number
		{
			var re:Number = _ad.width;
			if (_ad is Loader) {
				re = (_ad as Loader).contentLoaderInfo.width;
			} else if (_ad.hasOwnProperty("root")) {
				re = _ad.root.width;
			}
			return re;
		}
		/**
		 *检测是否可以发送曝光请求 
		 * 
		 */		
		protected function checkSendPost():void{
			//加载到舞台，并且加载资源完成;
			//如果已经展示过了，则不在发送(移出舞台后会重置展示为false)
			if (!_isShow && _isload && _onAdded) {
				onAdShowPost();
			}
		}
		
		public function get ADHeight():Number
		{
			var re:Number = _ad.height;
			if (_ad is Loader) {
				re = (_ad as Loader).contentLoaderInfo.height;
			} else if (_ad.hasOwnProperty("root")) {
				re = _ad.root.height;
			}
			return re;
		}
		
		public function get error():Boolean {
			return _error;
		}
			
		public function get sourceData():Array {
			return _sourceData;
		}
		
	}
}