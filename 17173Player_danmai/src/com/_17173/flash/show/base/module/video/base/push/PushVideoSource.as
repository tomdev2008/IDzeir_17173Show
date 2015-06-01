package com._17173.flash.show.base.module.video.base.push
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
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	
	public class PushVideoSource extends BaseVideoSource
	{
		private var _e:IEventManager = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
		public function PushVideoSource()
		{
			super();
		}
		public override function connect(conntionURL:String=null, streamURL:String=null, streamInvoke:Function=null, faultRetryTime:int=3):void
		{
			super.connect(conntionURL,streamURL,streamInvoke,faultRetryTime);
		}
	
		protected override function onConnectionHandler(event:NetStatusEvent):void
		{
			Debugger.log(Debugger.INFO,"[stream]",event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					initStream();
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
				
			}
		}
		
		override public function close():void
		{
			Debugger.log(Debugger.INFO,"清空推流方的stream和connection");
			if (_stream && _connection && _connection.connected) {
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_stream.dispose();
				_stream.close();
				_stream.attachAudio(null);
				_stream.attachCamera(null);
				_stream = null;
			}
			if (_connection) {
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionHandler);
				_connection.close();
				_connection = null;
			}
		}
		
		override protected function initConnection():void {
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionHandler);
			_connection.objectEncoding = ObjectEncoding.AMF0;
			_connection.client = {};
//			_connection.connect("rtmp://localhost/live")//_connectionURL);
			_connection.connect(_connectionURL);
		}

		
		protected override function initStream():void
		{
			if (_stream == null) {
				_stream = new NetStream(_connection);
			}
			else
			{
				_stream.close();
				_stream = null;
				_stream = new NetStream(_connection);
			}
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_stream.bufferTime = 1;
			_stream = VideoEquipmentManager.getInstance().setH264(_stream);
			_stream.attachCamera(VideoEquipmentManager.getInstance().camera);
			_stream.attachAudio(VideoEquipmentManager.getInstance().mic);
//			_stream.publish("hello")//streamURL);
			_stream.publish(streamURL);
		}
		
		private function getAudioCodecId(codecName:String):int {
			var codecId:int = -1;
			switch(codecName){
				case SoundCodec.NELLYMOSER.toLocaleLowerCase():
					codecId = 6;
					break;
				case SoundCodec.SPEEX.toLocaleLowerCase():
					codecId = 11;
					break;
			}
			return codecId;
		}
		
		override protected function onStreamHandler(event:NetStatusEvent):void {
			var _type:String = null;
			var _data:Object = null;
			switch (event.info.code) {
				case "NetStream.Play.Reset":
					break;
				case "NetStream.Connect.Success" : 
					_type = VideoSourceInfo.CONNECTED;
					break;
				case "NetStream.Play.Start" : 
					_type = VideoSourceInfo.START;
					_bytesTotal = _stream.bytesTotal;
					break;
				case "NetStream.Buffer.Full" : 
					_type = VideoSourceInfo.BUFFER_FULL;
					break;
				case "NetStream.Buffer.Empty" : 
					_type = VideoSourceInfo.BUFFER_EMPTY;
					break;
				case "NetStream.Pause.Notify" : 
					_type = VideoSourceInfo.PAUSE;
					_data = event.currentTarget.info.resourceName;
					break;
				case "NetStream.Unpause.Notify" : 
					_type = VideoSourceInfo.RESUME;
					break;
				case "NetStream.Buffer.Flush" : 
					_type = VideoSourceInfo.BUFFER_FLUSH;
					break;
				case "NetStream.Play.Stop" : 
					_type = VideoSourceInfo.STOP;
					break;
				case "NetStream.SeekStart.Notify" : 
					_type = VideoSourceInfo.SEEK_START;
					_data = event.info;
					break;
				case "NetStream.Play.StreamNotFound" : 
					_type = VideoSourceInfo.STREAM_NOT_FOUND;
					Debugger.log(Debugger.INFO, "[stream]", "找不到视频文件,连接: ", _connectionURL, ", 地址: ", _streamURL);
					break;
				case "NetStream.Seek.Notify" : 
					_type = VideoSourceInfo.SEEK;
					_data = event.info;
					break;
				//p2p
				case "NetStream.Connect.Failed" : 
					_type = VideoSourceInfo.P2P_FAILED;
					_data = "P2P";
					break;
				case "NetStream.Connect.Closed" : 
					_type = VideoSourceInfo.P2P_CLOSED;
					break;
				case "NetStream.Connect.Rejected" : 
					_type = VideoSourceInfo.P2P_REJECTED;
					break;
				case "NetStream.Video.DimensionChange" : 
					_type = VideoSourceInfo.DIMONSION_CHANGE;
					break;
				case "NetStream.Publish.Start":
					_type = VideoSourceInfo.PUBLISH;
					break;
				default:
					break;
			}
			if(_type != VideoSourceInfo.BUFFER_EMPTY && _type != VideoSourceInfo.BUFFER_FULL){
				invoke({"type":_type, "code":event.info.code}, _data);
			}
			
//			super.onStreamHandler(event);
//			switch (event.info.code) {
//				case "NetStream.Buffer.Full":
//					break;
//				case "NetStream.Buffer.Empty":
//					break;
//				case "NetStream.Connect.Failed":                // "error" P2P 连接尝试失败。info.stream 属性指示已失败的流。
//				case "NetStream.Connect.Closed":                // "status" 成功关闭 P2P 连接。info.stream 属性指示已关闭的流。
//				case "NetStream.Connect.Rejected":              // "error" P2P 连接尝试没有访问另一个对等方的权限。info.stream 属性指示被拒绝的流。
//				case "NetStream.Failed":                        // "error" (Flash Media Server) 发生了错误，其他事件代码中没有列出此错误的原因
//				case "NetStream.Play.Failed":
//				case "NetStream.Play.NoSupportedTrackFound":    //未检测到任何受支持的轨道（视频、音频或数据）
//				case "NetStream.Play.FileStructureInvalid":     //文件结构无效
//					Debugger.log(Debugger.INFO, "[stream]", event.info.code);
//					break;
//			}
		}
		
	}
}