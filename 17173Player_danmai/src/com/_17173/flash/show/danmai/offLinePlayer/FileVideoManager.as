package com._17173.flash.show.danmai.offLinePlayer
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.core.video.source.BaseVideoSource;
	import com._17173.flash.core.video.source.FileVideoSource;
	import com._17173.flash.show.model.CEnum;
	
	public class FileVideoManager extends VideoManager
	{
		
		private static const TIME_LEFT_TO_LOAD_NEXT:int = 10;
		
		private var _currentCDN:int = 0;
		private var _currentDef:String = "-1";//清晰度,默认值为不存在（正常为1，2，4，8）
		private var _currentSplit:int = 0;
		private var _currentLoadVS:int = 0;
		private var _vsArr:Vector.<BaseVideoSource> = null;
		private var _isToggledPlay:Boolean = false;
		private var _isSeeking:Boolean = false;
		//		private var _isStart:Boolean = false;
		private var _isSwitching:Boolean = false;
		private var _lastSource:IVideoSource = null;
		
		private var _vd:FilePlayerVideoData = null;
		
		//记录是否为第一次加载的分段，当有t参数的时候，可能直接不从第一个分段开始播放，所以需要有个记录派发事件
		private var _isFirstPlay:Boolean = true;
		
		private var _checkFinishNum:int = 0;//全视频播放完毕之后，验证播放时间是否正确的计时器
		
		/**
		 * loading开始时视频加载的字节数字
		 */		
		private var _startLoadingNum:Number = 0;
		
		//当前source之前加载过的source，用户快速多分段切换时清空以前source
		private var _sourceArr:Array;
		
		//当前是否可以seek标识
		private var _seekFlag:Boolean = true;
		
		public function FileVideoManager()
		{
			super();
		}
		
		override public function init(videoData:IVideoData):void
		{
			_vd = videoData as FilePlayerVideoData;
			if (_vd) {
				_currentDef = _vd.defaultDef;
				prepareVideoDataInfo(_vd);
				super.init(_vd);
			}
		}
		
		private function prepareVideoDataInfo(value:FilePlayerVideoData):Boolean
		{
			if(value.switchTo(_currentCDN, _currentDef, _currentSplit))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		override protected function prepSource():void {
			prepVSArr();
			
			_currentSplit = 0;
			updateSource(_currentSplit, 0);
		}
		
		private function prepVSArr():void
		{
			_vsArr = new Vector.<BaseVideoSource>();
			_vd.totalBytes = 0;
			_vd.totalTime = 0;
			var tempLength:int = (_vd.info[_currentDef].split as Array).length;
			for (var i:int = 0; i < tempLength; i ++) {
				var url:String = _vd.info[_currentDef].split[i].url[_currentCDN];
				var size:Number = _vd.info[_currentDef].split[i].size;
				var duration:Number = _vd.info[_currentDef].split[i].duration;
				var obj:Object = new Object();
				obj.url = url;
				obj.size = size;
				obj.duration = duration;
				obj.invokeFunction = invokeFunction;
				obj.split = i;
				_vsArr.push(new FileVideoSource(obj));
				_vd.totalBytes += size;
				_vd.totalTime += duration;
			}
		}
		
		override public function connectStream():Boolean
		{
			var startTime:int = Context.variables["t"];
			if(startTime &&  startTime > 0)
			{
				seek(startTime);
			}
			else
			{
//				volume = 50;
				if (Context.variables.hasOwnProperty("PlayerFileVideoVolume") && int(Context.variables["PlayerFileVideoVolume"]) >= 0) {
					volume = int(Context.variables["PlayerFileVideoVolume"]);
				} else {
					volume = 50;
					Context.variables["PlayerFileVideoVolume"] = 50;
				}
			}
			return true;
		}
		
		/**
		 * 更新当前视频源(分段).
		 * 先赋新源,后销毁旧源 
		 * @param split
		 * @param time
		 */		
		protected function updateSource(split:int, time:int = 0):void {
			Debugger.log(Debugger.INFO, "[video]", "正在更新第(" + split + ")分段, 第(" + time + ")秒");
			if (split != _currentSplit) {
				_isSwitching = true;
			}
			if (!_sourceArr) {
				_sourceArr = [];
			}
			//在更新当前source之前关闭并清空之前的source
			for (var i:int = 0; i < _sourceArr.length; i++) {
				if (_sourceArr[i]) {
					_sourceArr[i].close();
					_sourceArr[i] = null;
				}
			}
			_source = _vsArr[split];
			togglePlay(_isToggledPlay);
			_source.time = time;
			_sourceArr.push(_source);
			if (Context.variables.hasOwnProperty("PlayerFileVideoVolume") && int(Context.variables["PlayerFileVideoVolume"]) >= 0) {
				volume = int(Context.variables["PlayerFileVideoVolume"]);
			} else {
				volume = 50;
				Context.variables["PlayerFileVideoVolume"] = 50;
			}
			
			if (_isSwitching) {
				//由于在onVideoBufferFull的时候切换_video，所以切换分段时会出现当前的_video不是上一个分支的video，
				//这样会导致切换到新分支的时候新的分支不知道当前的播放状态，所以强制执行一下播放状态
				if (_isToggledPlay) {
					_source.stream.resume();
				} else {
					source.stream.pause();
				}
				var source:IVideoSource = _vsArr[_currentSplit];
				if (source != _source) {
					Debugger.log(Debugger.INFO, "[video]", "正在销毁第(" + _currentSplit + ")分段");
					_lastSource = source;
					if (source && source.stream) {
						source.stream.pause();
					}
				}
			}
		}
		
		override protected function invokeFunction(type:String, data:Object=null):void {
			super.invokeFunction(type, data);
		}
		
		override public function seek(time:Number):Boolean {
			if (_seekFlag) {
				//seek 10秒机制
				_seekFlag = false;
				Ticker.tick(1000, seekTimer);
			} else {
				return false;
			}
			if (time <= 0)
			{
				time = 0;
			} else if (time > _vd.totalTime) {
				time = _vd.totalTime;
			}
			_isSeeking = true;
			var splitInfo:Object = _vd.getSplitInfo(_currentDef, time);
			if(!splitInfo)
			{
				return false;
			}
			var i:int = splitInfo.index;
			var t:int = splitInfo.time;
			updateSource(i, t);
			_currentSplit = splitInfo.index;
			onVideoSeekStart(null);
			return true;
		}
		
		private function seekTimer():void {
			_seekFlag = true;
		}
		
		public function set definition(value:String):void {
			var resultDef:String = _currentDef;
			_currentDef = value;
			_currentSplit = _vd.getSplitInfo(_currentDef, _vd.playedTime).index;
			//记录切换清晰度之前播放器的状态
			var tempIsPlaying:Boolean = _video.isPlaying;
			if (prepareVideoDataInfo(_vd)) {
				for(var i:int = 0; i < _vsArr.length; i++) {
					var item:FileVideoSource = _vsArr[i] as FileVideoSource;
					if(item.stream)
					{
						if (item.stream != _source.stream) {
							item.close();
						}
					}
				}
				_vd.loadedBytes = 0;
				_lastSource = _source;
				_source.stream.pause();
				prepVSArr();
				seek(_vd.playedTime);
				togglePlay(tempIsPlaying);
				
				resultDef = _currentDef;
			}
			Context.variables["PlayerFileVideoDef"] = resultDef;
			
			Context.getContext(CEnum.EVENT).send(PlayerEvents.BI_VIDEO_DEF_CHANGED);
		}
		
		override public function update(time:int):void {
			if (_video == null || _source == null || _vd == null || _source.stream == null) return;
			//			if (_isSeeking) {
			_vd.loadedTime = _source.stream.bufferLength;
			//			} else {
			//				_vd.loadedTime = 0;
			//			}
			var t:Number = 0;
			var b:Number = 0;
			var tempLength:int = (_vd.info[_currentDef].split as Array).length;
			for (var i:int = 0; i < tempLength; i++) {
				//使用配置数据作为基准进行播放时间计算
				if (i < _currentSplit) {
					t += Number(_vd.info[_currentDef].split[i].duration);
					b += Number(_vd.info[_currentDef].split[i].size);
				} else {
					if (i == _currentSplit) {
						t += Number(_source.time);
					}
					b += _vsArr[i].bytesLoaded;
				}
			}
			//防止单段视频出现实际视频时长是30.123，理论时长是31，导致播放进度条不全的情况
			if(_isFinished)
			{
				_vd.playedTime = _vd.totalTime;
			}
			else
			{
				_vd.playedTime = t;
			}
			_vd.loadedBytes = b;
			//			checkLoadNextVS();
			checkNextStreamToLoad();
		}
		
		/**
		 * 检查单个视频是否快播放结束了
		 */
		private function checkNextStreamToLoad():void {
			var currentSource:IVideoSource = _vsArr[_currentSplit];
			//提前5秒开始加载
			if(!_isSeeking && 
				(currentSource.time + TIME_LEFT_TO_LOAD_NEXT) >= currentSource.totalTime && 
				currentSource.bytesLoaded >= currentSource.bytesTotal && 
				!isLastSplit) {
				var source:IVideoSource = _vsArr[_currentSplit + 1];
				if (source) {
					FileVideoSource(source).preload();
					FileVideoSource(source).pause();
				}
			}
		}
		
		/**
		 * 视频开始播放.即metadata事件已经到达.
		 * 直播也会提供metadata事件. 
		 * @param info
		 */		
		override protected function onVideoReadyToPlay(info:Object):void {
			//_isFirstPlay:当有t参数的时候，可能直接不从第一个分段开始播放，如果没有这个事件派发，那么初始播放的video画面尺寸太小
			if(isFirstSplit || _isFirstPlay) {
				super.togglePlay(_isToggledPlay);
				Context.getContext(CEnum.EVENT).send(PlayerEvents.VIDEO_LOADED, info);
				_isFirstPlay = false;
			}
		}
		
		override protected function onVideoReadyFail():void {
			changeCDN();
			
			if(_currentCDN >= _vd.getCdnNum(_currentDef, _currentSplit)) {
				Debugger.log(Debugger.ERROR, "[fileVideoManager]" + "cdn越界");
			}
		}
		
		override protected function onVideoNotFound():void
		{
			changeCDN();
			if(_currentCDN >= _vd.getCdnNum(_currentDef, _currentSplit)) {
				Debugger.log(Debugger.ERROR, "[fileVideoManager]" + "视频文件未找到");
			}
		}
		
		private function changeCDN():void {
			_checkFinishNum = 0;
			_currentCDN++;
			if (prepareVideoDataInfo(_vd)) {
				prepVSArr();
				seek(_vd.playedTime);
			}
		}
		
		/**
		 * 变换播放状态,播放或暂停. 
		 */		
		override public function togglePlay(value:Boolean = false):void {
			_isToggledPlay = value;
			if (_video == null) {
				return;
			}
			if (_isToggledPlay == _video.isPlaying) return;
			super.togglePlay(value);
		}
		
		/**
		 * 连上之后就已经开始下载了. 
		 */		
		override protected function onVideoConnected(data:Object = null):void {
			_source.stream.resume();
			_source.stream.bufferTime = 3;
			
			if(isFirstSplit) {
				Context.getContext(CEnum.EVENT).send(PlayerEvents.VIDEO_INIT);
			}
			
			if (_source.stream) {
				Ticker.stop(checkLoadStatus);
				_startLoadingNum = source.stream.bytesLoaded;
				Ticker.tick(10000, checkLoadStatus);
			}
		}
		
		override protected function onVideoStart():void {
			_isFinished = false;
			//默认是3秒,setting里面的参数可以控制
			_source.stream.bufferTime = 3;
			super.togglePlay(_isToggledPlay);
			super.onVideoStart();
		}
		
		override protected function onVideoBufferEmpty():void {
			if (_isFinished) return;
			super.onVideoBufferEmpty();
		}
		
		override protected function onVideoBufferFull():void {
			if (_lastSource) {
				_lastSource.close();
				_lastSource = null;
			}
			if (_sourceArr != null) {
				_sourceArr = [];
			}
			if (_video.stream != _source.stream) {
				_video.stream = _source.stream;
			}
			_isSeeking = false;
			super.onVideoBufferFull();
		}
		
		override protected function onVideoSeek(data:Object):void {
			_isSeeking = true;
			super.onVideoSeek(data);
		}
		
		override protected function onVideoSeekStart(data:Object):void {
			_isSeeking = true;
			//延迟一下,避免出现瞬间loading消失的现象
			Ticker.tick(300, onActuallyDispatchSeek);
		}
		
		private function onActuallyDispatchSeek():void {
			if (_isSeeking) {
				super.onVideoSeekStart(null);
			}
		}
		
		override protected function onVideoResume():void{
			super.onVideoResume();
		}
		
		override protected function onVideoFinished():void {
			//判断是否是最后一个分段
			if(isLastSplit) {
				Debugger.log(Debugger.INFO, "[video]", "全视频播放结束");
				//最后一段也加载完成了,那么可以认为是快要结束了,这个时候启动计时器,计算播放时长
				Ticker.stop(checkVideoComplete);
				checkVideoComplete();
			} else {
				//如果不是最后分段,则切换到下一段,从0秒开始播放
				Debugger.log(Debugger.INFO, "[video]", "切换下一段");
				updateSource(_currentSplit + 1, 0);
				_currentSplit ++;
			}
		}
		
		override protected function onVideoStopped():void {
			//置空,啥也不干
		}
		
		private function checkVideoComplete():void {
			if (isLastSplit) {
				var lastSource:IVideoSource = _vsArr[_vsArr.length - 1];
				if (_checkFinishNum >= 100) {
					//如果已经重试了100次，那么认为视频实际播放时间远远小于理论时间，需要重新切换cdn
					changeCDN();
				} else {
					//播放时间向上取整,避免后台给的总时间为取整的数字
					if (Math.ceil(lastSource.time) >= lastSource.totalTime) {
						//					_vd.playedTime = Math.ceil(_vd.playedTime);
						_checkFinishNum = 0;
						_isFinished = true;
						Context.getContext(CEnum.EVENT).send(PlayerEvents.VIDEO_FINISHED);
					} else {
						_checkFinishNum++;
						Ticker.tick(30, checkVideoComplete);
					}
				}
			}
		}
		
		/**
		 * 当前分段是否最后一个分段 
		 * @return 
		 */		
		private function get isLastSplit():Boolean {
			return _currentSplit == (_vsArr.length - 1);
		}
		
		/**
		 * 当前分段是否第一个分段 
		 * @return 
		 */		
		private function get isFirstSplit():Boolean {
			return _currentSplit == 0;
		}
		
		//		override protected function onVideoStopped():void {
		//			//ignore
		//			Debugger.log(Debugger.INFO, "[video]", "视频停止播放!");
		//			//判断当前的播放状态
		//			if(checkVideoPlayTime())
		//			{
		//				onVideoFinished();
		//			}
		//			else
		//			{
		//				//有事会出现seek之后停止的情况,需要再次seek
		//				seek(_lastSeekTime);
		//			}
		//		}
		
		/**
		 * 重播 
		 */		
		override public function replay():void {
			seek(0);
		}
		
		/**
		 * @inherit 
		 */		
		override public function get isPlaying():Boolean {
			return super.isPlaying && !_isFinished;
		}
		
		/**
		 * 10秒检测
		 * 如果10秒内未加载到任何数据，向后端发送一个记录
		 */		
		private function checkLoadStatus():void {
			Ticker.stop(checkLoadStatus);
			var end:Number = source.stream.bytesLoaded;
			if (end - _startLoadingNum <= 0) {
				Debugger.log(Debugger.INFO, "[video]" + "10秒内未加载任何数据，执行切换");
				changeCDN();
			}
		}
		
	}
}

