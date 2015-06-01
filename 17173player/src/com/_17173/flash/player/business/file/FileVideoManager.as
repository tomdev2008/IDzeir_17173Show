package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.core.video.source.BaseVideoSource;
	import com._17173.flash.core.video.source.FileVideoSource;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoManager;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	public class FileVideoManager extends VideoManager
	{
		
		private static const TIME_LEFT_TO_LOAD_NEXT:int = 10;
		
		private var _currentCDN:int = 0;
		private var _currentDef:String = "1";
		private var _currentSplit:int = 0;
		private var _currentLoadVS:int = 0;
		private var _vsArr:Vector.<BaseVideoSource> = null;
		private var _isToggledPlay:Boolean = false;
		private var _isSeeking:Boolean = false;
		//		private var _isStart:Boolean = false;
		private var _isSwitching:Boolean = false;
		private var _lastSource:IVideoSource = null;
		
		private var _vd:FileVideoData = null;
		
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
			Debugger.log(Debugger.INFO, "[FileVideoManager]", "视频开始初始化:");
			_vd = videoData as FileVideoData;
			if (_vd) {
				Debugger.log(Debugger.INFO, "[FileVideoManager]", "视频开始初始化  视频信息ID：" + _vd.cid);
				_currentDef = Context.getContext(ContextEnum.SETTING).def;
				if (_currentDef == "-1") {
					_currentDef = _vd.defaultDef;
				}
				if (_currentDef.indexOf(":") != -1) {
					_currentDef = _currentDef.split(":")[1];
				}
				prepareVideoDataInfo(_vd);
				super.init(_vd);
			}
		}
		
		private function prepareVideoDataInfo(value:FileVideoData):Boolean
		{
			Debugger.log(Debugger.INFO, "[FileVideoManager]", "prepareVideoDataInfo:" + value.cid);
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
			Debugger.log(Debugger.INFO, "[FileVideoManager]", "prepSource");
			prepVSArr();
			
			_currentSplit = 0;
			if (Context.variables.hasOwnProperty("t") && int(Context.variables["t"]) == 0) {
				updateSource(_currentSplit, 0);
			}
		}
		
		private function prepVSArr():void
		{
			Debugger.log(Debugger.INFO, "[FileVideoManager]", "prepVSArr");
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
			Debugger.log(Debugger.INFO, "[FileVideoManager]", "connectStream 起点时间：" + startTime);
			var startTime:int = Context.variables["t"];
			if(startTime &&  startTime > 0)
			{
				seek(startTime);
			}
			else
			{
				volume = Context.getContext(ContextEnum.SETTING).volume;
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
			closeOtherStream();
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
			volume = Context.getContext(ContextEnum.SETTING).volume;
			
			if (_isSwitching) {
				//由于在onVideoBufferFull的时候切换_video，所以切换分段时会出现当前的_video不是上一个分支的video，
				//这样会导致切换到新分支的时候新的分支不知道当前的播放状态，所以强制执行一下播放状态
				if (_isToggledPlay) {
					_source.stream.resume();
				} else {
					_source.stream.pause();
				}
				var source:IVideoSource = _vsArr[_currentSplit];
				if (source != _source) {
					Debugger.log(Debugger.INFO, "[video]", "正在销毁第(" + _currentSplit + ")分段");
					_lastSource = source;
					if (source.stream) {
//						source.stream.pause();
						source.close();
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
//				time = _vd.totalTime - 1;
				time = 0;
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
			_isFinished = false;
			return true;
		}
		
		private function seekTimer():void {
			_seekFlag = true;
		}
		
		public function set definition(value:String):void {
			changeCurrentDef(value);
		}
		
		/**
		 * 更改当前清晰度
		 * @param value 要更改的目标清晰度
		 * @param saveFlage 是否保存到cookie中
		 * 
		 */		
		private function changeCurrentDef(value:String, isAuto:Boolean = false):void {
			var resultDef:String = _currentDef;
			_currentDef = value;
			_currentSplit = _vd.getSplitInfo(_currentDef, _vd.playedTime).index;
			//记录切换清晰度之前播放器的状态
			var tempIsPlaying:Boolean = _video.isPlaying;
			if (prepareVideoDataInfo(_vd)) {
				closeOtherStream();
				_vd.loadedBytes = 0;
				_lastSource = _source;
				_source.stream.pause();
				prepVSArr();
				seek(_vd.playedTime);
				togglePlay(tempIsPlaying);
				
				resultDef = _currentDef;
			}
			
			Context.getContext(ContextEnum.SETTING).def = resultDef;
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_VIDEO_DEF_CHANGED, {"def": resultDef});
		}
		
		/**
		 * 关闭非当前的分段的缓冲
		 */		
		private function closeOtherStream():void {
			for(var i:int = 0; i < _vsArr.length; i++) {
				var item:FileVideoSource = _vsArr[i] as FileVideoSource;
				if(item.stream)
				{
					if (item.stream != _source.stream) {
						item.close();
					}
				}
			}
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
		 * 判断当前分段是否加载完毕，如果加载完毕了，加载下一个分段
		 */
		//		private function checkLoadNextVS():void
		//		{
		//			var item:FileVideoSource = (_vsArr[_currentLoadVS] as FileVideoSource);
		//			if(item.stream.bytesLoaded >= item.stream.bytesTotal)
		//			{
		//				if(_currentLoadVS < (_vsArr.length - 1))
		//				{
		//					_currentLoadVS ++;
		//					if(!(_vsArr[_currentLoadVS] as FileVideoSource).stream || (_vsArr[_currentLoadVS] as FileVideoSource).stream.bytesLoaded < (_vsArr[_currentLoadVS] as FileVideoSource).stream.bytesTotal)
		//					{
		//						(_vsArr[_currentLoadVS] as FileVideoSource).loadStartTime = 0;
		//						(_vsArr[_currentLoadVS] as FileVideoSource).time = 0;
		//						(_vsArr[_currentLoadVS] as FileVideoSource).pause();
		//					}
		//				}
		//			}
		//		}
		
		/**
		 * 视频开始播放.即metadata事件已经到达.
		 * 直播也会提供metadata事件. 
		 * @param info
		 */		
		override protected function onVideoReadyToPlay(info:Object):void {
			//_isFirstPlay:当有t参数的时候，可能直接不从第一个分段开始播放，如果没有这个事件派发，那么初始播放的video画面尺寸太小
			if(isFirstSplit || _isFirstPlay) {
				super.togglePlay(_isToggledPlay);
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_LOADED, info);
				_isFirstPlay = false;
			}
		}
		
		override protected function onVideoReadyFail():void {
			changeCDN();
			
			if(_currentCDN >= _vd.getCdnNum(_currentDef, _currentSplit)) {
				var preDef:String = _vd.getPreviousDef(_currentDef);
				if (preDef == "-1") {
					Debugger.log(Debugger.INFO, "[video]", "当前视频分段加载错误");
					Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ON_PLAYER_ERROR, PlayerErrors.packUpError(PlayerErrors.VIDEO_FILE_CAN_NOT_CONNECT));
				} else {
					Debugger.log(Debugger.INFO, "[video]", "当前清晰度(" + _currentDef + ")下连接视频出错,更换到清晰度(" + preDef + ")");
					changeDefByFail(preDef);
				}
			}
		}
		
		override protected function onVideoNotFound():void {
			changeCDN();
			if(_currentCDN >= _vd.getCdnNum(_currentDef, _currentSplit)) {
				var preDef:String = _vd.getPreviousDef(_currentDef);
				if (preDef == "-1") {
					Debugger.log(Debugger.INFO, "[video]", "当前视频分段文件不存在");
					Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ON_PLAYER_ERROR, PlayerErrors.packUpError(PlayerErrors.VIDEO_FILE_NOT_EXISTS));
				} else {
					Debugger.log(Debugger.INFO, "[video]", "当前清晰度(" + _currentDef + ")下视频文件不存在,更换到清晰度(" + preDef + ")");
					changeDefByFail(preDef);
				}
			} 
		}
		
		/**
		 * 内部错误（文件无法找到，连接视频出错）导致视频无法播放时，切换到下一档清晰度
		 * @param def
		 * 
		 */		
		private function changeDefByFail(def:String):void {
			_currentCDN = 1;
			seekTimer();
			changeCurrentDef(def);
		}
		/**
		 * 当前cdn有问题，切换cdn
		 */		
		private function changeCDN():void {
			_checkFinishNum = 0;
			_currentCDN++;
			if (prepareVideoDataInfo(_vd)) {
				prepVSArr();
				seek(_vd.playedTime);
			}
			//切换cdn统计
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.QM, StatTypeEnum.EVENT_SWITCH_CDN, null);
		}
		
		/**
		 * 变换播放状态,播放或暂停. 
		 */		
		override public function togglePlay(value:Boolean = false):void {
			//如果出现后推就不执行
//			if (Global.settings.params["showBackRec"]) {
			if (Context.variables["showBackRec"]) {
				return;
			}
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
			_source.stream.bufferTime = Context.getContext(ContextEnum.SETTING).loadToStart;
			
			if(isFirstSplit) {
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_INIT);
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
			_source.stream.bufferTime = Context.getContext(ContextEnum.SETTING).loadToStart;
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
				for (var i:int = 0; i < _sourceArr.length; i++) {
					var item:FileVideoSource = _sourceArr[i] as FileVideoSource;
					if(item && item.stream)
					{
						if (item.stream != _source.stream) {
							item.close();
						}
					}
				}
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
			//如果视频起始播放分段非第一段开始，那么不会派发出buffFull事件，因此在这里做一个给video赋值的操作
			if (!_video.stream) {
				_video.stream = _source.stream;
			}
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
						Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_FINISHED);
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
			if (source && source.stream) {
				var end:Number = source.stream.bytesLoaded;
				if (end - _startLoadingNum <= 0) {
					Debugger.log(Debugger.INFO, "[video]" + "10秒内未加载任何数据，执行切换");
					changeCDN();
				}
			}
		}
	}
}