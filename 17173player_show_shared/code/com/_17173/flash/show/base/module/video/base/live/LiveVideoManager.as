package com._17173.flash.show.base.module.video.base.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.BaseVideoManager;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.player.VideoPlayer;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordType;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.utils.getTimer;
	
	/**
	 * 拉流管理类 
	 * @author qiuyue
	 * 
	 */	
	public class LiveVideoManager extends BaseVideoManager
	{
		
		private var _index:int;
		
		private var _videoByteCount:Number;
		
		private var TIME:int = 30000;
		
		private var _isCheckTimeOut:Boolean = false;
		
		public function LiveVideoManager()
		{
			super();
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
		//缓冲时间
		private var _bufferCTime:int = 0;
		private var _bufferTimeString:String = "";
		/**
		 * 点播源.
		 */		
		protected  override function prepSource():void {
			if(!_source){
				_source = new LiveVideoSource();
			}
			(_source as LiveVideoSource).index = _index;
		}
			
		override protected function onVideoStopped():void{
			Debugger.log(Debugger.INFO,"(LiveModule)","onVideoStopped",index);
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.IS_SHOW_LOADING,{"index":index,"isShow":1});
		}
		
		
		override public function dispose():void {
			if (_video) {
				_video.stop();
			}
			if (_source && _source.stream) {
				_source.close();
			}
			Ticker.stop(checkTimeOut);
			stopBufferQm();
		}
		
		/**
		 * 决定使用stageVideo还是video进行初始化. 
		 */		
		override protected function initInternal(videoData:IVideoData):void {
			if(!_video){
				_video = new VideoPlayer();
			}
			_video.isPlaying = true;
			super.initInternal(videoData);
		}
		
		override protected function prepVideo():void{
			if(!_video){
				_video = new VideoPlayer();
			}
			onVideoPrepComplete();
		}
		
		override protected function onVideoBufferFlush():void {
			if(_source.stream && _source.connection && _source.connection.connected){
				Ticker.stop(checkTimeOut);
				Debugger.log(Debugger.INFO,"[stream]","流文件停止加载，重新连接stream", "index为"+index);
				_source.stream.play(_source.streamURL);
			}
		}
		
		override protected function onVideoResume():void{
			super.onVideoResume();
		}
		
		override protected function onVideoBufferFull():void{
			super.onVideoBufferFull();
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.IS_SHOW_LOADING,{"index":index,"isShow":0});
			_isCheckTimeOut = false;
			onFullTime();
		}
		
		override protected function onVideoBufferEmpty():void{
			super.onVideoBufferEmpty();
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.IS_SHOW_LOADING,{"index":index,"isShow":1});
			_isCheckTimeOut = true;
			onEmptyTime();
		}
		
		override protected function onVideoStart():void {
			(Context.getContext(EventManager.CONTEXT_NAME) as EventManager).send(SEvents.LIVE_CONNECTED + index);
			Ticker.stop(checkTimeOut);
			Ticker.tick(TIME, checkTimeOut, -1);
			_videoByteCount = 0;
			startBufferQm();
			onStartQM();
		}
		
		override protected function onVideoNotFound():void {
			super.onVideoNotFound();
			Debugger.log(Debugger.INFO,"[stream]","流地址已经找不到！ 发送重新取调度消息" ,"index为"+index);
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LIVE_VIDEO_CONNECT,{"index":index});
			Ticker.stop(checkTimeOut);
			stopBufferQm();
		}
		
		override protected function onP2pFailed():void{
			super.onP2pFailed();
			reConnect();
			sendError(ErrorRecordType.LIVE_STREAM_ERROR);
		}
		
		override protected function onP2pClosed():void{
			super.onP2pClosed();
			reConnect();
			sendError(ErrorRecordType.LIVE_STREAM_CLOSE_ERROR);
		}
		
		override protected function onP2pRejected():void{
			super.onP2pRejected();
			reConnect();
			sendError(ErrorRecordType.LIVE_STREAM_REJECTED_ERROR);
		}
		
		override protected function onConnectionFailed():void{
			super.onConnectionFailed();
			reConnect();
			sendError(ErrorRecordType.LIVE_CONN_ERROR);
		}
		
		override protected function onConnectionRejected():void{
			super.onConnectionRejected();
			reConnect();
			sendError(ErrorRecordType.LIVE_CONN_REJECTED_ERROR);
		}
		
		override protected function onConnectClosed():void{
			super.onConnectClosed();
			Debugger.log(Debugger.INFO,"[stream]","Connection断开！ 发送重新取调度消息", "index为"+index);
			reConnect();
			sendError(ErrorRecordType.LIVE_CONN_CLOSE_ERROR);
		}
		
		private function reConnect():void{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LIVE_VIDEO_CONNECT,{"index":index});
			Ticker.stop(checkTimeOut);
			stopBufferQm();
		}
		
		private function checkTimeOut():void{
			if(_source.connection && _source.connection.connected && _source.stream){
				if(_isCheckTimeOut){
					if(_source.stream.info.videoByteCount <= _videoByteCount){
						Debugger.log(Debugger.INFO,"[stream]","流已经不再加载新的数据，重新获取调度", _videoByteCount, "index为"+index);
						(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LIVE_VIDEO_CONNECT,{"index":index});
					}
				}
				_videoByteCount = _source.stream.info.videoByteCount;
			}else{
				Ticker.stop(checkTimeOut);
				Debugger.log(Debugger.INFO,"[stream]","NetConnection和NetStream已经断开连接!", "index为"+index);
			}
		}
		
		private function testError():void{
			sendError(ErrorRecordType.LIVE_CONN_ERROR);
			sendError(ErrorRecordType.LIVE_CONN_CLOSE_ERROR);
			sendError(ErrorRecordType.LIVE_CONN_REJECTED_ERROR);
			sendError(ErrorRecordType.LIVE_STREAM_REJECTED_ERROR);
			sendError(ErrorRecordType.LIVE_STREAM_ERROR);
			sendError(ErrorRecordType.LIVE_STREAM_CLOSE_ERROR);
		}
		/**
		 *发送错误统计 
		 * @param type 错误统计类型 ErrorRecordType中定义
		 * 
		 */		
		private function sendError(type:String):void{
			var info:Object = {inter:"",info:"",name:source.connectionURL+source.streamURL};
			Context.getContext(CEnum.EVENT).send(SEvents.ERROR_RECORD,{code:type,info:info});
		}
		
		/************************************ 统计模块****************************************/
		/**********************之后需要把数据放入context中，以下代码移动到统计模块**********************/
		private function startBufferQm():void
		{
			stopBufferQm();
			Ticker.tick(120000, onBufferFullQm, -1);
		}
		
		private function stopBufferQm():void
		{
			Ticker.stop(onBufferFullQm);
			onClearTime();
		}
		
		private function onBufferFullQm():void
		{
			if (_bufferTimeString != "")
			{
				var e:IEventManager = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
				e.send(SEvents.SEND_QM,{"id":"buffer","info":"{"+_bufferTimeString+"}"});
				onClearTime();
			}
		}
		
		private function onEmptyTime():void
		{
			_bufferCTime = getTimer();
		}
		//当前缓冲结束后拼接缓冲时间
		private function onFullTime():void
		{
			if (_bufferCTime != 0)
			{
				_bufferCTime = getTimer() - _bufferCTime;
				//派发缓冲
				var vd:LiveVideoData = _videoData as LiveVideoData;
				var cid:String = vd.cId;
				var cdn:String = "";
				var opt:int = vd.optimal;
				if(vd.connectionURL == null || vd.connectionURL == ""){
					cdn = vd.streamName;
				}else{
					cdn = vd.connectionURL;
				}
				if(cdn){
					var urlSplited:Array = cdn.split("://");
					if (urlSplited.length > 1) {
						urlSplited = urlSplited[1].split("/");
						cdn = urlSplited[0];
					}
				}
				var bstr:String = "{" + _bufferCTime + "," + cid + "," + cdn + "," + opt + "}";
				if(_bufferTimeString == ""){
					_bufferTimeString = bstr;
				}else{
					_bufferTimeString +="," +  bstr;
				}
			}
		}
		
		private function onClearTime():void
		{
			_bufferTimeString = "";
		}
		//拉流开始发送质量统计
		private function onStartQM():void{
			var vd:LiveVideoData = _videoData as LiveVideoData;
			var cid:String = vd.cId;
			var cdn:String = "";
			var opt:int = vd.optimal;
			if(vd.connectionURL == null || vd.connectionURL == ""){
				cdn = vd.streamName;
			}else{
				cdn = vd.connectionURL;
			}
			var e:IEventManager = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
			e.send(SEvents.SEND_QM,{"id":"play", "cdn":cdn, "liveid":cid, "opt":opt});
//			var obj:Object = Context.variables;
			
			var data:Object = {};
			data.opt = opt;
			data.cdn = encodeURIComponent(cdn);
			e.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.EVENT_PLAY_START, "data":data});
		}
	}
}