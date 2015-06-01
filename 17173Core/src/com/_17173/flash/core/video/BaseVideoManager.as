package com._17173.flash.core.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.core.video.interfaces.IVideoPlayer;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.core.video.player.StageVideoPlayer;
	import com._17173.flash.core.video.player.VideoPlayer;
	import com._17173.flash.core.video.source.BaseVideoSource;
	import com._17173.flash.core.video.source.P2PVideoSource;
	import com._17173.flash.core.video.source.StreamingVideoSource;
	import com._17173.flash.core.video.source.VideoSourceInfo;
	
	import flash.display.Stage;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.media.StageVideoAvailability;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 抽取videoManager中的基础逻辑,作为基本的videoManager类使用.
	 *  
	 * @author shunia-17173
	 * v1 2013/09/10 
	 */	
	public class BaseVideoManager implements IVideoManager
	{
		
		private var _stage:Stage = null;
		
		private var _isUsingStageVideo:Boolean = false;
		private var _stageVideoAwaitTime:int = 2000;
		private var _stageVideoAwaitInterval:uint = 0;
		
		protected var _videoData:IVideoData = null;
		protected var _video:IVideoPlayer = null;
		protected var _source:IVideoSource = null;
		protected var _isFinished:Boolean = false;
		protected var _volume:int = 50;
		
//		protected var _videoParent:DisplayObjectContainer = null;
		
		public function BaseVideoManager()
		{
			_stage = Context.stage;
		}
		
		public function init(videoData:IVideoData):void
		{
			initInternal(videoData);
		}
		
		/**
		 * 决定使用stageVideo还是video进行初始化. 
		 */		
		protected function initInternal(videoData:IVideoData):void {
			_videoData = videoData;
			//检查当前播放器是否支持stageVideo特性
			if (false) {
//			if (VideoSupport.fpVersionSupportStageVideo()) {
				_stage.addEventListener(
					StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, 
					onStageVideoAvailability);
				_isUsingStageVideo = true;
				prepStageVideo();
			} else {
				_isUsingStageVideo = false;
				prepVideo();
			}
		}
		
		/**
		 * 初始化stageVideo进行播放. 
		 */		
		private function prepStageVideo():void {
			if (_stage.stageVideos == null || _stage.stageVideos.length <= 0) {
				//指定时间后还是没等到stageVideo实例,直接用video播放
				_stageVideoAwaitInterval = setInterval(function ():void {
					clearInterval(_stageVideoAwaitInterval);
					if (_video == null) {
						_isUsingStageVideo = false;
						prepVideo();
					}
				}, _stageVideoAwaitTime);
				//侦听舞台的stageVideo变化
			} else if (_stage.stageVideos && _stage.stageVideos.length > 0) {
				_isUsingStageVideo = true;
				prepVideo();
			}
		}
		
		/**
		 * stageVideo可用性侦听. 
		 * @param event
		 */		
		private function onStageVideoAvailability(event:StageVideoAvailabilityEvent):void {
			if (event.availability == StageVideoAvailability.AVAILABLE && 
				_stage.stageVideos.length) {
				clearInterval(_stageVideoAwaitInterval);
				_isUsingStageVideo = true;
			} else {
				_isUsingStageVideo = false;
			}
			prepVideo();
		}
		
		/**
		 * 初始化video进行播放. 
		 */		
		protected function prepVideo():void {
			if (_isUsingStageVideo) {
				_video = new StageVideoPlayer(_stage.stageVideos);
			} else {
				_video = new VideoPlayer();
			}
			if (_source) {
				_video.stream = _source.stream;
			}
			onVideoPrepComplete();
		}
		
		/**
		 * stageVideo/video控件初始化完毕.准备播放源. 
		 */		
		protected function onVideoPrepComplete():void {
			if (_videoData.isStream) {
				prepStreamSource();
			} else {
				prepSource();
			}
			
			onSourcePrepComplete();
		}
		
		/**
		 * 点播源.
		 */		
		protected function prepSource():void {
			_source = new BaseVideoSource();
		}
		
		/**
		 * 根据是否使用p2p决定使用普通直播源,还是进行p2p连接. 
		 */		
		protected function prepStreamSource():void {
			if (_videoData.useP2P) {
				_source = new P2PVideoSource();
			} else {
				_source = new StreamingVideoSource();
			}
		}
		
		/**
		 * 视频源准备完毕 
		 */		
		protected function onSourcePrepComplete():void {
			connectStream();
		}
		
		/**
		 * 开始连接视频源 
		 * @return 
		 */		
		public function connectStream():Boolean {
			_source.connect(_videoData.connectionURL, _videoData.streamName, invokeFunction);
			return true;
		}
		
		/**
		 * 视频源信息回调方法 
		 * @param type
		 * @param data
		 * 
		 */		
		protected function invokeFunction(type:String, data:Object=null):void {
			switch (type) {
				case VideoSourceInfo.CONNECTED : 
					onVideoConnected(data);
					break;
				case VideoSourceInfo.META_DATA : 
					onVideoReadyToPlay(data);
					break;
				case VideoSourceInfo.START : 
					onVideoStart();
					break;
				case VideoSourceInfo.PAUSE : 
					onVideoPause(data);
					break;
				case VideoSourceInfo.RESUME : 
					onVideoResume();
					break;
				case VideoSourceInfo.SEEK : 
					onVideoSeek(data);
					break;
				case VideoSourceInfo.SEEK_START : 
					onVideoSeekStart(data);
					break;
				case VideoSourceInfo.FINISHED : 
					onVideoFinished();
					break;
				case VideoSourceInfo.BUFFER_FULL : 
					onVideoBufferFull();
					break;
				case VideoSourceInfo.BUFFER_EMPTY : 
					onVideoBufferEmpty();
					break;
				case VideoSourceInfo.BUFFER_FLUSH :
					onVideoBufferFlush();
					break;
				case VideoSourceInfo.FAULT : 
					onVideoReadyFail();
					break;
				case VideoSourceInfo.STREAM_NOT_FOUND : 
					onVideoNotFound();
					break;
				case VideoSourceInfo.STOP : 
					onVideoStopped();
					break;
				case VideoSourceInfo.DIMONSION_CHANGE : 
					onVideoDimensionChanged();
					break;

				case VideoSourceInfo.PUBLISH:
					onVideoPubilsh();
					break;
				
				case VideoSourceInfo.CONNECTED_CLOSE:
					onConnectClosed();
					break;
				
				case VideoSourceInfo.P2P_FAILED:
					onP2pFailed();
					break;
				
				case VideoSourceInfo.P2P_CLOSED:
					onP2pClosed();
					break;
				
				case VideoSourceInfo.P2P_REJECTED:
					onP2pRejected();
					break;
				
				case VideoSourceInfo.CONNECTED_FAILED:
					onConnectionFailed();
					break;
				
				case VideoSourceInfo.CONNECTED_REJECTED:
					onConnectionRejected();
					break;
				
				
			}
		}
		
		protected function onP2pFailed():void{
			Debugger.log(Debugger.INFO, "[video]", VideoSourceInfo.P2P_FAILED);
		}
		
		protected function onP2pClosed():void{
			Debugger.log(Debugger.INFO, "[video]", VideoSourceInfo.P2P_CLOSED);
		}
		
		protected function onP2pRejected():void{
			Debugger.log(Debugger.INFO, "[video]", VideoSourceInfo.P2P_REJECTED);
		}
		
		protected function onConnectionFailed():void{
			Debugger.log(Debugger.INFO, "[video]", VideoSourceInfo.CONNECTED_FAILED);
		}
		
		protected function onConnectionRejected():void{
			Debugger.log(Debugger.INFO, "[video]", VideoSourceInfo.CONNECTED_REJECTED);
		}
		
		protected function onConnectClosed():void{
			Debugger.log(Debugger.INFO, "[video]", "视频链接断开");
		}
		
		/**
		 * 视频源大小变化 
		 */		
		protected function onVideoDimensionChanged():void {
			
		}
		
		/**
		 * 开始推流
		 */		
		protected function onVideoPubilsh():void {
			Debugger.log(Debugger.INFO, "[video]", "视频开始推流");
		}
		
		/**
		 * 停止播放 
		 */		
		protected function onVideoStopped():void {
//			Debugger.log(Debugger.INFO, "[video]", "视频停止播放");
		}
		
		/**
		 * 连上之后就已经开始下载了. 
		 */		
		protected function onVideoConnected(data:Object = null):void {
			_video.stream = _source.stream;
		}
		
		/**
		 * 视频播放完成 
		 */		
		protected function onVideoFinished():void {
//			Debugger.log(Debugger.INFO, "[video]", "视频播放结束");
		}
		
		protected function onVideoPause(data:Object = null):void {
			_isFinished = false;
		}
		
		protected function onVideoResume():void {
			_isFinished = false;
		}
		
		protected function onVideoBufferEmpty():void {
			if (_isFinished) return;
		}
		
		protected function onVideoBufferFlush():void {
		}
		
		protected function onVideoBufferFull():void {
		}
		
		protected function onVideoStart():void {
		}
		
		/**
		 * 视频开始播放.即metadata事件已经到达.
		 * 直播也会提供metadata事件. 
		 * @param info
		 */		
		protected function onVideoReadyToPlay(info:Object):void {
			if (info && info.hasOwnProperty("duration")) {
				_videoData.totalTime = info.duration;
			}
		}
		
		protected function onVideoSeek(data:Object):void {
			_isFinished = false;
		}
		
		protected function onVideoSeekStart(data:Object):void {
		}
		
		protected function onVideoReadyFail():void {
		}
		
		protected function onVideoNotFound():void {
			Debugger.log(Debugger.INFO, "[video]", _videoData.isStream ? "获取视频流失败" : "视频文件不存在");
		}
		
		/**
		 * 切换播放状态 
		 * @param value
		 */		
		public function togglePlay(value:Boolean = false):void {
			if (_video == null) return;
			
			if (value) {
				_video.resume();
			} else {
				_video.pause();
			}
		}
		
		/**
		 * 停止播放,掐断netStream 
		 */		
		public function stop():void {
			dispose();
//			//清除显示对象
//			if (_videoParent && _videoParent.numChildren) {
//				while (_videoParent.numChildren) {
//					_videoParent.removeChildAt(0);
//				}
//			}
		}
		
		public function dispose():void {
			if (_video) {
//				_video.stop();
				_video.dispose();
				_video = null;
			}
			if (_source) {
				_source.close();
				_source = null;
			}
		}
		
		/**
		 * 按时间搜索播放,以秒为单位 
		 * @param time
		 */		
		public function seek(time:Number):Boolean {
			if (_source) {
				_source.time = time;
				return true;
			}
			return false;
		}
		
		/**
		 * 重播 
		 */		
		public function replay():void {
			seek(0);
		}
		
		/**
		 * 每帧更新 
		 * @param time
		 */		
		public function update(time:int):void
		{
			if (_videoData && _source && _source.stream) {
				_videoData.playedTime = _source.time;
				_videoData.loadedBytes = _source.bytesLoaded;
				_videoData.totalBytes = _source.bytesTotal;
				_videoData.loadedTime = _source.loadedTime;
			}
		}
		
		/**
		 * 是否需要每帧更新 
		 * @return 
		 */		
		public function get needUpdate():Boolean
		{
			return true;
		}
		
		/**
		 * 是否正在播放 
		 * @return 
		 */		
		public function get isPlaying():Boolean {
			return _video && _video.isPlaying;
		}
		
		/**
		 * 当前视频 
		 * @return 
		 */		
		public function get video():IVideoPlayer {
			return _video;
		}
		
		/**
		 * 当前源 
		 * @return 
		 */		
		public function get source():IVideoSource {
			return _source;
		}
		
		public function set isFinished(value:Boolean):void{
			_isFinished = value;
		}
		
		public function get isFinished():Boolean
		{
			return _isFinished;
		}
		
//		/**
//		 * 切换当前视频所在的父容器. 
//		 * @param parent
//		 */		
//		public function swapVideoParent(parent:DisplayObjectContainer):void {
//			_videoParent = parent;
//			if (_video && _video.video) {
//				parent.addChild(_video.video);
//			}
//		}
		
		public function get data():IVideoData
		{
			return _videoData;
		}
		
		public function set data(value:IVideoData):void {
			_videoData = value;
		}
		
		/**
		 * 设置从0-100的音量.
		 */		
		public function set volume(value:int):void
		{
			_volume = value;
			if (_volume < 0) {
				_volume = 0;
			} else if (_volume > 100) {
				_volume = 100;
			}
			if (_source) {
				_source.volume = _volume;
			}
		}
		
		public function get volume():int {
			return _volume;
		}
		
		public function get originalHeight():Number
		{
			return _source.originalHeight;
		}
		
		public function get originalWidth():Number
		{
			return _source.originalWidth;
		}
		
	}
}