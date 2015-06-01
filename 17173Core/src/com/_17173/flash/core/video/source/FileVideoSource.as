package com._17173.flash.core.video.source
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	
	/**
	 * 通过文件地址进行视频播放.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class FileVideoSource extends BaseVideoSource
	{
		
		/**
		 *配置数据 
		 */		
		private var _split:int = 0;
		private var _url:String = null;
		private var _size:Number = 0;
		private var _duration:Number = 0;
		/**
		 * 是不是已经全部加载完毕 
		 */		
		private var _isAllLoaded:Boolean = false;
		/**
		 * 是否刚开始进行加载 
		 */		
		private var _loadingStarted:Boolean = false;
		/**
		 * 是否已经开始加载(connect之后已经连接上,并拿到了文件信息) 
		 */		
		private var _loading:Boolean = false;
		/**
		 * 是否正在预加载 
		 */		
		private var _preloading:Boolean = false;
		/**
		 * 是否跳过事件回调 
		 */		
		private var _skipInvoke:Boolean = false;
		
		/**
		 * 同一分段上，由于seek会有延时，因此在取time并且没有seek正确成功的似乎后返回的应该是这个想要seek的时间点
		 */
		private var _sameStreamStartTime:Number = 0;
		
		/**
		 * 同一分段，seek跳转开始的时间 
		 */		
		private var _sameStreamSeekStartTime:Number = 0;
		
		private var _isFinished:Boolean = false;
		
		public function FileVideoSource(value:Object = null)
		{
			super();
			
			if(value && value.hasOwnProperty("url"))
			{
				_url = value["url"];
			}
			if(value && value.hasOwnProperty("size"))
			{
				_size = value["size"];
			}
			if(value && value.hasOwnProperty("duration"))
			{
				_duration = value["duration"];
			}
			if(value && value.hasOwnProperty("invokeFunction"))
			{
				_invokeFunc = value["invokeFunction"];
			}
			if (value && value.hasOwnProperty("split")) {
				_split = value["split"];
			}
		}
		
		override public function set time(value:Number):void {
			_preloading = false;
			_skipInvoke = false;
			_isFinished = false;
			_sameStreamStartTime = 0;
			Ticker.stop(listenSeekFinish);
			_time = value;
			Debugger.log(Debugger.INFO, "[stream]", "视频跳转至第(" + String(_split) + ")分段, 从第(" + String(_time) + ")秒开始播放!");
			if(!stream) {
				seekByConnect();
			} else {
				if(_time >= _loadStartTime && _time < (_loadStartTime + loadedTime)) {
					//在当前分段上，并且在已经加载过的分段上
					if(loadedTime == 0)
					{
						seekByConnect();
					}
					else
					{
						doSeekInTheBuffer();
					}
				} else {
					//在当前分段上，并且在为加载过的分段上(_loadStartTime之前，或者未加载，但是小于总数的部分)
					seekByConnect();
				}
			}
		}
		
		/**
		 * 通过重新获取的形式实现seek 
		 * 一般用在不存在stream的上seek，还没加载到的位置的seek
		 */		
		private function seekByConnect():void {
			Debugger.log(Debugger.INFO, "[stream]", "视频重新获取，从第（" + getStart(_time) + ")秒处加载");
			_loadStartTime = _time;
			Debugger.log(Debugger.INFO, "[stream]", "当前播放视频地址：" + (_url + getStart(_time)));
			connect(null, _url + getStart(_time), _invokeFunc);
		}
		
		/**
		 * 在已经缓冲的区域中seek
		 */		
		private function doSeekInTheBuffer():void
		{
			_sameStreamStartTime = _time - _loadStartTime;
			Ticker.tick(100, 
				function ():void{
					_sameStreamSeekStartTime = _stream.time;
					doTheSeek(_sameStreamStartTime);
				}
			);
		}
		
		/**
		 * 在缓冲区中直接seek 
		 * @param value 要跳转的时间点
		 * 
		 */		
		private function doTheSeek(value:Number):void
		{
			Debugger.log(Debugger.INFO, "[stream]", "视频直接跳转到第(" + _sameStreamStartTime +")秒处");
			super.time = value;
			listenSeekFinish();
		}
		
		/**
		 * 通过stream的time改变来判断是否已经seek结束
		 */		
		private function listenSeekFinish():void
		{
			if(_stream.time != _sameStreamSeekStartTime && _stream.time != _sameStreamStartTime)
			{
				Debugger.log(Debugger.INFO, "[stream]", "视频直接跳转结束，播放第(" + _stream.time + ")秒");
				_sameStreamStartTime = 0;
				Ticker.stop(listenSeekFinish);
			}
			else
			{
				Ticker.tick(50, listenSeekFinish);
			}
			
		}
		
		/**
		 * 视频预加载 
		 */		
		public function preload():void {
			if (_loading || _isAllLoaded) return;
			
			Debugger.log(Debugger.INFO, "[stream]", "第(" + _split + ")分段,开始从第(" + _time +")秒开始预加载");
			_skipInvoke = true;
			_preloading = true;
			_time = 0;
			_loadStartTime = 0;
			connect(null, _url + getStart(_time), _invokeFunc);
		}
		
		override protected function invoke(obj:Object, data:Object=null):void {
			var logInfo:String = null;
			switch (obj.type) {
				case  VideoSourceInfo.META_DATA : 
					logInfo = "配置时长(" + _duration + ")秒, 实际时长(" + _totalTime + ")秒";
					break;
				case  VideoSourceInfo.CONNECTED : 
					_loading = false;
					logInfo = "已连接, 是否跳过回调: " + String(_skipInvoke);
					break;
				case VideoSourceInfo.START : 
					_loadingStarted = true;
					logInfo = "配置大小(" + _size + ")字节,实际大小(" + _bytesTotal + ")字节";
					break;
				case VideoSourceInfo.SEEK : 
					break;
				case VideoSourceInfo.SEEK_START : 
					break;
				case VideoSourceInfo.FINISHED : 
					_isFinished = true;
					logInfo = "播放结束, 是否跳过回调: " + String(_skipInvoke);
					break;
				case VideoSourceInfo.STOP : 
					logInfo = "停止播放, 是否跳过回调: " + String(_skipInvoke);
					break;
				case VideoSourceInfo.BUFFER_FULL :
					break;
			}
			if (logInfo) {
				Debugger.log(Debugger.INFO, "[stream]", "第(" + _split + ")分段", logInfo);
			}
			if(obj.type == VideoSourceInfo.BUFFER_EMPTY || obj.type == VideoSourceInfo.FINISHED)
			{
				Debugger.log(Debugger.INFO, "[stream]", "第(" + _split + ")分段", obj.type);
			}
			if (!_skipInvoke) {
				super.invoke(obj, data);
			}
		}
		
		override public function connect(conntionURL:String=null, streamURL:String=null, streamInvoke:Function=null, faultRetryTime:int=3):void {
			super.connect(conntionURL, streamURL, streamInvoke, faultRetryTime);
			_loading = true;
		}
		
		override public function get time():Number
		{
			//如果没经过更新_loadStartTime是进度点直接点击的时间
			if(_sameStreamStartTime > 0)
			{
				return _sameStreamStartTime + _loadStartTime;
			}
			if (_isFinished) {
				return _loadStartTime + _stream.time;
			} else {
				return _loadStartTime + _stream.time;
			}
			
		}
		
		override public function get loadStartTime():Number
		{
			return _loadStartTime;
		}
		
		override protected function initStream():void {
			super.initStream();
			//			//强制暂停
			_stream.pause();
		}
		
		override public function get loadedTime():Number {
			if(_stream.bytesTotal == 0) {
				return 0;
			}
			var re:Number = _totalTime * (_stream.bytesLoaded / _stream.bytesTotal);
			return re;
		}
		
		/**
		 * 根据url地址判断start参数前面使用什么符号
		 */
		public function getStart(value:int):String {
			var re:String = "start=" + value;
			if(_url && _url.length > 0)
			{
				if(_url.indexOf("?hits") != -1) {
					re = "&" + re;
				} else if (_url.indexOf("?") != -1) {
					re = "&" + re;
				} else {
					re = "?" + re;
				}
			}
			return re;
		}
		
		override public function get bytesLoaded():int {
			if (_loadingStarted) {
				//尺寸不match配置,有两种可能:配置不准确或者不是从0秒开始加载
				//统一使用配置进行计算
				var tt:int = _totalTime + _loadStartTime;
				var beforeScale:Number = _loadStartTime / tt;
				var currentScale:Number = _totalTime / tt;
				var beforeBytes:int = _size * beforeScale;
				var currentBytes:int = _stream.bytesLoaded * currentScale;
				return beforeBytes + currentBytes;
			} else if (_isAllLoaded) {
				return _size;
			} else {
				return 0;
			}
		}
		
		private function get startLoadByte():Number {
			return bytesTotal / totalTime * _loadStartTime;
		}
		
		override protected function onMetaData(info:Object = null):void {
			if(_loadStartTime > 0)
			{
				_loadStartTime = _duration - info.duration;
			}
			else
			{
				_loadStartTime = 0;
			}
			super.onMetaData(info);
		}
		
		//		public function set invokeFunction(value:Function):void
		//		{
		//			_invokeFunc = value;
		//		}
		
		override public function get totalTime():Number {
			return _duration;
		}
		
		override public function close():void{
			if (!stream) {
				return;
			}
			Debugger.log(Debugger.INFO, "[stream]", "第(" + _split + ")分段", " close");
			_skipInvoke = true;
			if(stream.bytesLoaded < stream.bytesTotal) {
				super.close();
				_isAllLoaded = false;
			} else {
				super.pause();
				_isAllLoaded = true;
			}
			_loadingStarted = false;
			_loading = false;
			_preloading = false;
			_loadStartTime = 0;
		}
		
	}
}