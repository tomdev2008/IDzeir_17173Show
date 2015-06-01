package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.video.source.VideoSourceInfo;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com.ws.event.PFVEvent;
	import com.ws.video.PFVNetStream;
	
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 *网宿p2p
	 * @author xppiao
	 *
	 */
	public class WSP2PVideoSource extends StreamVideoSource
	{
		private var _nc:NetConnection = null;
		private var _soundCtrl:SoundTransform = null;
		private var _video:Video = null;
		/**
		 * Server是否可以进行p2p
		 */
		private var _isServerAvailable:Boolean = false;
		private var _mainStream:String = null;
		private var _backStream:String = null;
		//_streamUrl is used for normal NetStream
		private var _streamUrl:String = null;
		private var _videoId:String = null;
		private var _domain:String = null;
		private var _token:String = null;
		//ex rtmp://push17173.wscdns.com/show/
		private var _connectionUrl:String = null;
		//_curl = _connectionUrl - rtmp prefix
		private var _curl:String = null;
		private var _listenEvent:Boolean = false;
		private var _wsStream:PFVNetStream = null;
		
		public function WSP2PVideoSource(loadToStart:int) {
			super(loadToStart);
		}
		//_source.connect(_videoData.connectionURL, _videoData.streamName, invokeFunction);
		override public function connect(conntionURL:String = null, streamURL:String = null, streamInvoke:Function = null, faultRetryTime:int = 3):void {
			_invokeFunc = streamInvoke;
			var cv:Object = Context.variables;
			/*
			cv["streamName"] = "17173p2p";
			_streamName = "17173p2p";
			cv["connectionUrl"] = "rtmp://push17173.wscdns.com/show/";
			var curl:String = cv["connectionUrl"].split("//")[1];
			_mainStream = "http://ifile.cdn1.v.17173.com/index.php?stream="+ curl + _streamName;
			_backStream = "http://sfile.cdn1.v.17173.com/index.php?stream="+ curl + _streamName;
			_videoId = "17173p2p";
			_domain = "17173live.com";
			_token = "8d99c23f899a46412321779ab05664dd1353139204";
			*/
			//rtmp://push17173.wscdns.com/show/17173p2p
			
			_streamURL = cv["streamNameWS"];
			_connectionUrl = cv["pushPathWS"];
			var curl:String = _connectionUrl.split("//")[1];
			//防止结尾没有/
			if (curl.charAt(curl.length-1)!="/") {
				curl += "/";
			}
			_mainStream = "http://ifile.cdn1.v.17173.com/index.php?stream="+curl + _streamURL;
			_backStream =  "http://sfile.cdn1.v.17173.com/index.php?stream="+curl + _streamURL;
			//如果有1935端口 那么p2p会失败 
			var myPattern:RegExp = /:1935/g;
			_mainStream = _mainStream.replace(myPattern,'');
			_backStream = _backStream.replace(myPattern,'');
			
			//如果有1935 那么会有问题 所以暂时hardcode一个
			_videoId = _streamURL;
			_domain = "17173live.com";
			_token = "8d99c23f899a46412321779ab05664dd1353139204";
			
			PFVNetStream.Load(startPlay, _domain, _token, _videoId, true); 
		}
		
		private function createConnection():void
		{
			if(_nc != null)
			{
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_nc.close();
				_nc = null;
			}
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			
			var client:Object = new Object();
			client.onBWDone = function():void {};
			_nc.client = client;			
		}
		
		override public function get stream():NetStream 
		{
			return _stream;
		}
		
		private function startPlay():void
		{
			createConnection();
			//=============step.3=======================================
			if(PFVNetStream.ServiceAvailable)  //pfv直播模式
			{
				_nc.connect(null);
				_isServerAvailable = true;
				
				if(_wsStream != null)
				{
					_wsStream.close();
					_wsStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
					_wsStream = null;
				}
				
				_wsStream = new PFVNetStream(_nc);
				//_wsStream.trackerAddr = "pflivetest1.lxdns.com";
				
				_wsStream.bufferTime = 3;
				_wsStream.addEventListener(PFVEvent.SVC_STATUS, onPFVHandler);
				
				var streamList:Array = new Array();
				
				streamList.push(_mainStream);
				streamList.push(_backStream);
				
				_wsStream.play(_videoId, streamList);			//播放多个直播流，当主流故障自动切换到备流，主流恢复后再切换回来
				configStream();
				_stream = _wsStream.netstream;
				_video = new Video();
				_wsStream.attachVideo(_video);
				
				_wsStream.soundTransform = new SoundTransform(0);
				
				
				invoke({"type": VideoSourceInfo.CONNECTED, "code": "NetConnection.Connect.Success"}, _streamURL);
				_listenEvent = true;
			}
			else  //普通直播播放
			{
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_P2P_FAIL);
			}
			//=============step.3 end=====================================
		}
		
		override protected function configStream():void
		{
			//临时解决花屏/绿屏现象,后续可以再优化
			_wsStream.bufferTime = 3;
			_wsStream.client = {"onMetaData": onMetaData, "onPlayStatus": onPlayStatus};
		}
		
		override protected function onMetaData(info:Object = null):void
		{
			super.onMetaData(info);
		}
		
		private function onNetStatusHandler(e:NetStatusEvent):void
		{
			trace("netStatus:" + e.info.code);
			if (!_listenEvent) return ;
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					if(!_isServerAvailable)
					{
						Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_P2P_FAIL);
					}
					break;
			}
		}
		
		//=========================step.4 pfv内部运行情况处理============================
		private function onPFVHandler(event:PFVEvent):void
		{
			switch(event.info.code)
			{
				//切换到普通模式继续播放
				case "PFVNetStream.Internal.Error":
					var playLen:Number = event.info.playTime;  //直播播放时长
					_isServerAvailable = false;
					_nc.connect(_streamUrl);
					break;
			}
		}
	}
}

