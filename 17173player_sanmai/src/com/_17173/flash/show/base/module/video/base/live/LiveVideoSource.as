package com._17173.flash.show.base.module.video.base.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.source.BaseVideoSource;
	import com._17173.flash.core.video.source.VideoSourceInfo;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	public class LiveVideoSource extends BaseVideoSource
	{
		private var _index:int = 0;
		
		private var _e:IEventManager = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
		public function LiveVideoSource()
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
		
		protected override function onConnectionHandler(event:NetStatusEvent):void
		{
			Debugger.log(Debugger.INFO,"[stream]", event.info.code);
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success" :
					initStream();
					invoke({"type":VideoSourceInfo.CONNECTED, "code":event.info.code}, _streamURL);
					break;
				case "NetConnection.Connect.NetworkChange":     //网络状态改变
					break;
				case "NetConnection.Connect.Closed":            //由服务器端,返回 关闭事件
					close();
					invoke({"type":VideoSourceInfo.CONNECTED_CLOSE, "code":event.info.code});
					break;
				case "NetConnection.Connect.Failed":            //尝试连接失败   //再试 ?????
					close();
					invoke({"type":VideoSourceInfo.CONNECTED_FAILED, "code":event.info.code});
					break;
				case "NetConnection.Connect.Rejected":          //没有权限,拒接访问  //关闭
					close();
					invoke({"type":VideoSourceInfo.CONNECTED_REJECTED, "code":event.info.code});
					break;
				case "NetConnection.Call.BadVersion":           //接收到不能识别的编码 数据包  //关闭
				case "NetConnection.Call.Failed":               //无法调用服务器端的方法和命令  //关闭
				case "NetConnection.Call.Prohibited":           //域问题,错误   //关闭
				case "NetConnection.Connect.AppShutdown":       //正在关闭服务器端的应用程序  //关闭
				case "NetConnection.Connect.InvalidApp":        //调用的应用程序名字无效   //关闭
					break;
				default:
					break;
				
			}
		}
		
		override public function close():void
		{
			if (_stream && _connection && _connection.connected)
			{
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_stream.dispose();
				_stream.close();
				_stream = null;
			}
			if (_connection)
			{
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionHandler);
				_connection.close();
				_connection = null;
			}
		}
		
		override protected function initConnection():void {
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionHandler);
			_connection.client = {};
//			_connection.connect("rtmp://localhost/live")//_connectionURL);
			_connection.connect(_connectionURL);
		}

		protected override function initStream():void
		{
			if (_stream == null)
			{
				_stream = new NetStream(_connection);
			}
			else
			{
				_stream.close();
				_stream = null;
				_stream = new NetStream(_connection);
			}
			Debugger.log(Debugger.INFO, "[stream]", "视频流开始加载");
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_stream.bufferTime = 1;
			_stream.useHardwareDecoder = false;
			_stream.checkPolicyFile = true;
			var h264:H264VideoStreamSettings = new H264VideoStreamSettings();
			_stream.videoStreamSettings = h264;
			_stream.client = {"onMetaData":onMetaData, "onPlayStatus":onPlayStatus};;
//			_stream.play("hello");//streamURL);
			_stream.play(streamURL);
		}
		override protected function onStreamHandler(event:NetStatusEvent):void
		{
			Debugger.log(Debugger.INFO,"[stream]",event.info.code);
			super.onStreamHandler(event);
			switch (event.info.code)
			{
				case "NetStream.Buffer.Full":
					break;
				case "NetStream.Buffer.Empty":
					break;
				case "NetStream.Play.Start" : 
					break;
				case "NetStream.Connect.Closed":
					break;
			}
//			switch (event.info.code) 
//			{        
//				case "NetStream.Buffer.Full":
//					break;
//				case "NetStream.Buffer.Empty":
//					break;
//				case "NetStream.Connect.Closed":                // "status" 成功关闭 P2P 连接。info.stream 属性指示已关闭的流。
//				case "NetStream.Connect.Failed":                // "error" P2P 连接尝试失败。info.stream 属性指示已失败的流。
//				case "NetStream.Connect.Rejected":              // "error" P2P 连接尝试没有访问另一个对等方的权限。info.stream 属性指示被拒绝的流。
//				case "NetStream.Failed":                        // "error" (Flash Media Server) 发生了错误，其他事件代码中没有列出此错误的原因
//				case "NetStream.Play.Failed":
//				case "NetStream.Play.NoSupportedTrackFound":    //未检测到任何受支持的轨道（视频、音频或数据）
//				case "NetStream.Play.FileStructureInvalid":     //文件结构无效
//					break;
//				default:
//					break;
//			}
		}

	}
}
