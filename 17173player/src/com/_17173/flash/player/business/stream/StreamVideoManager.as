package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.player.VideoPlayer;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoManager;
	
	/**
	 * 直播视频管理器
	 *  
	 * @author shunia-17173
	 */	
	public class StreamVideoManager extends VideoManager
	{
		
		private static const TIME_UP:int = 5000;
		private static const waitingToLoad:Number = 600 * 1024;
		
		private var _stopped:Boolean = false;
		private var _isConnecting:Boolean = false;
		
		private var _reseted:Boolean = false;
		private var _currentTime:int = 0;
		
		public function StreamVideoManager()
		{
			super();
		}
		
		private function get loadToStart():int {
			return Context.getContext(ContextEnum.SETTING).loadToStart;
		}
		
		override protected function prepStreamSource():void {
			//是否是p2p
			if (_videoData.useP2P) {
				//cdnType==5 是网宿的p2p 
				//cdnType!=5 是云成的p2p
				if (Context.variables["cdnType"]==5) {
					Debugger.log(Debugger.INFO,"[p2p]","use ws p2p");
					_source = new WSP2PVideoSource(loadToStart);
				} else {
					//默认使用云成 以后通过配置设置使用p2p提供方
					Debugger.log(Debugger.INFO,"[p2p]","use yc p2p");
					_source = new YCP2PVideoSource(loadToStart);
				}
			} else {
				Debugger.log(Debugger.INFO,"[p2p]","use normal");
				_source = new StreamVideoSource(loadToStart);
			}
		}
		
		override public function update(time:int):void {
			super.update(time);
			
			//是否重新拉流,并且当前不是断开状态,则进入检测状态
			if (isBlockActivated() && _videoData && _source && _source.stream) {
				var bufferFull:Boolean = isBufferFull();
				var bytesFull:Boolean = isBytesFull();
				//去掉了5秒超时设置
//				var timeUp:Boolean = isTimeUp();
				if (bufferFull || bytesFull) {
					var l:String = bufferFull ? "buffer时长超过" + loadToStart + "秒" : 
						bytesFull ? "达到" + waitingToLoad / 1024 + "k字节" : 
//						timeUp ? "超时" + TIME_UP / 1000 + "秒" : 
						"都没满足?";
					Debugger.log(Debugger.WARNING, "[video]", 
						l + ", 开始播放");
					unblockPlay();
				} else {
					updateLoadedTime();
				}
			}
		}
		
		private function checkVideoBuffer():Boolean {
			if (_source.stream.info.videoBufferByteLength > 1000) {
				return true;
			} else {
				return false;
			}
		}
		
		override public function togglePlay(value:Boolean=false):void {
			//判断是否是第一次的异常数据
			if (isBlockActivated()) return;
			
			super.togglePlay(value);
		}
		
		override protected function onVideoFinished():void {
			_reseted = true;
			//如果强制中断,则发出断流消息,否则重连
			if (_stopped) {
				super.onVideoFinished();
			} else {
				reconnect(1);
			}
		}
		
		override protected function onVideoBufferFull():void {
			if (!isBlockActivated()){
				togglePlay(true);
			}
			super.onVideoBufferFull();
		}
		
		override protected function onVideoStopped():void {
			_reseted = true;
			if (_stopped) {
				super.onVideoStopped();
			} else {
				reconnect(2);
			}
		}
		
		protected function reconnect(reason:int):void {
			Debugger.log(Debugger.INFO, "[video]", "视频停止播放: 服务器发送停止消息" + (reason == 1 ? "finish" : "stop"));
			if (!_isConnecting) {
//				var i:int = Math.random() * 3;
//				Debugger.log(Debugger.INFO, "[video]", "视频停止播放: 随机处理" + (i + 1));
//				if (i == 0) {
					Debugger.log(Debugger.INFO, "[video]", "检测到停止播放消息,使用方式1: stream重连");
					connectStream();
//				} else if (i == 1) {
//					Debugger.log(Debugger.INFO, "[video]", "检测到停止播放消息,使用方式2: 先resume再seek");
//					togglePlay(false);
//					seek(0);
//				} else if (i == 2) {
//					Debugger.log(Debugger.INFO, "[video]", "检测到停止播放消息,使用方式3: 调用play2方法续播");
//					_source["usePlay2"]();
//				}
//				else if (i == 3) {
//					Debugger.log(Debugger.INFO, "[video]", "检测到停止播放消息,随机使用方式4: 忽略");
//				}
			} else {
				Debugger.log(Debugger.INFO, "[video]", "视频停止播放: 默认忽略");
			}
		}
		
		override protected function onVideoStart():void {
			_stopped = false;
			_isConnecting = false;
			super.onVideoStart();
			//p2p情况下需要在开始就显示
		}
		
		override public function connectStream():Boolean {
			//如果使用p2p则替换stream地址
			var v:Object = Context.variables;
			if (_videoData.useP2P) {
				//cdnType==5 是网宿的p2p 
				//cdnType!=5 是云成的p2p
				if (v["cdnType"] != 5) {
					_videoData.streamName = Context.variables["p2pUrl"];
				}
			}
			_isConnecting = true;
			blockPlay();
			return super.connectStream();
		}
		
		override public function stop():void {
			_stopped = true;
			super.stop();
		}
		
		/**
		 * 是否满足了buffertime设置
		 *  
		 * @return 
		 */		
		private function isBufferFull():Boolean {
			if (isRtmp()) {
				return _source.loadedTime >= loadToStart;
			} else {
				if (checkHttpBufferTime()) {
					return (_source.loadedTime - _currentTime) >= loadToStart;
				} else {
					return false;
				}
			}
		}
		
		private function checkHttpBufferTime():int {
			if (_currentTime == 0 && 
				_source.stream.info && 
				_source.stream.info.videoBytesPerSecond > 1000) {
				_currentTime = _source.stream.bufferLength;
			}
			return _currentTime;
		}
		
		/**
		 * 是否加载了超过基准数值大小的视频数据
		 *  
		 * @return 
		 */		
		private function isBytesFull():Boolean {
			return _source.bytesLoaded >= waitingToLoad;
		}
		
		
		/**
		 * 阻塞播放 
		 */		
		/**
		 * 阻塞播放 
		 */		
		private function blockPlay():void {
			if (!isRtmp()) {
				//http需要手动暂停,rtmp暂停会导致无法播放,因为rtmp是实时的
				super.togglePlay(false);
			}
			_reseted = true;
		}
		
		/**
		 * 是不是当前处于阻塞状态
		 *  
		 * @return 
		 */		
		private function isBlockActivated():Boolean {
			return _reseted;
		}
		
		/**
		 * 重置所有阻塞状态,允许重新更新状态 
		 */		
		private function resetBlock():void {
			_reseted = false;
			_currentTime = 0;
			//加载时间手动设置为缓冲时长以去掉loading
			_videoData.loadedTime = loadToStart;
		}
		
		private function unblockPlay():void {
			resetBlock();
			onVideoBufferFull();
		}
		
		private function updateLoadedTime():void {
			if (!isRtmp()) {
				var percent:Number = _source.bytesLoaded / waitingToLoad;
				_videoData.loadedTime = loadToStart * percent;
			}
		}
		
		private function isRtmp():Boolean {
			return Util.validateStr(_videoData.connectionURL);
		}
		
		override public function get originalHeight():Number {
			return _video.originalHeight;
		}
		
		override public function get originalWidth():Number {
			return _video.originalWidth;
		}
		
	}
}