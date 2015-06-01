package com._17173.flash.core.video.source
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class BaseVideoSource implements IVideoSource
	{
		
		protected var _connection:NetConnection = null;
		protected var _stream:NetStream = null;
		protected var _sound:SoundTransform = null;
		
		protected var _connectionURL:String = null;
		protected var _streamURL:String = null;
		
		protected var _info:Object = null;
		protected var _currentVideoStatus:String = null;
		
		protected var _invokeFunc:Function = null;
		
		protected var _originalWidth:int = 0;
		protected var _originalHeight:int = 0;
		protected var _time:int = 0;
		
		protected var _totalTime:Number = 0;
		protected var _loadStartTime:Number = 0;
		
		protected var _bytesLoaded:int = 0;
		protected var _bytesTotal:int = 0;
		
		public function BaseVideoSource()
		{
		}
		
		public function connect(conntionURL:String=null, streamURL:String=null, streamInvoke:Function=null, faultRetryTime:int=3):void
		{
			_connectionURL = conntionURL;
			_streamURL = streamURL;
			_invokeFunc = streamInvoke;
			
			initConnection();
		}
		
		protected function initConnection():void {
			_connection = new NetConnection();
			_connection.client = {};
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionHandler);
			_connection.connect(_connectionURL);
		}
		
		protected function onConnectionHandler(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success" : 
					initStream();
					handlerStreamEvents();
					invoke({"type":VideoSourceInfo.CONNECTED, "code":event.info.code}, _streamURL);
					break;
				case "NetConnection.Connect.Closed":            //由服务器端,返回 关闭事件
					invoke({"type":VideoSourceInfo.CONNECTED_CLOSE, "code":event.info.code});
					break;
				case "NetConnection.Connect.Failed":            //尝试连接失败   //再试 ?????
					invoke({"type":VideoSourceInfo.CONNECTED_FAILED, "code":event.info.code});
					break;
				case "NetConnection.Connect.Rejected":          //没有权限,拒接访问  //关闭
					invoke({"type":VideoSourceInfo.CONNECTED_REJECTED, "code":event.info.code});
					break;
			}
		}
		
		protected function initStream():void {
			if (_stream == null) {
				_stream = new NetStream(_connection);
			}
			else
			{
				_stream.close();
				_stream = null;
				_stream = new NetStream(_connection);
			}
			configStream();
			Debugger.log(Debugger.INFO, "[stream]", "视频流开始加载");
			_stream.play(_streamURL);
		}
		
		protected function configStream():void {
			//临时解决花屏/绿屏现象,后续可以再优化
			_stream.useHardwareDecoder = false;
			_stream.bufferTime = 3;
			_stream.client = {"onMetaData":onMetaData, "onPlayStatus":onPlayStatus};
		}
		
		protected function handlerStreamEvents():void {
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		}
		
		protected function removeEvents():void{
			if (_stream) {
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, onStreamHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			}
		}
		
//		protected function onBWDone(info:Object):void {
//			Debugger.log(Debugger.INFO, "[stream]", "[status]", "Connection onBWDone", info);
//		}
		
		protected function onMetaData(info:Object = null):void {
			if (info != null) {
				if (info.hasOwnProperty("width")) 
					_originalWidth = info.width;
				if (info.hasOwnProperty("height")) 
					_originalHeight = info.height;
				if (info.hasOwnProperty("duration")) 
					_totalTime = info.duration;
			}
			
			_info = info;
			
			Debugger.log(Debugger.INFO, "[stream]", "文件信息已获取");
			invoke({"type":VideoSourceInfo.META_DATA, "code":"meta data"}, info);
		}
		
		protected function onPlayStatus(info:Object):void {
			if (info.code == "NetStream.Play.Complete") {
				invoke({"type":VideoSourceInfo.FINISHED, "code":info.code}, null);
			}
		}
		
		protected function onErrorHandler(e:Event):void {
			invoke({"type":VideoSourceInfo.FAULT, "code":""}, "Stream not found!");
		}
		
		protected function onStreamHandler(event:NetStatusEvent):void {
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
			invoke({"type":_type, "code":event.info.code}, _data);
		}
		
		public function get connection():NetConnection
		{
			return _connection;
		}
		
		public function get stream():NetStream
		{
			return _stream;
		}

		public function get originalWidth():int
		{
			return _originalWidth;
		}

		public function get originalHeight():int
		{
			return _originalHeight;
		}
		
		protected function invoke(obj:Object, data:Object = null):void {
			Debugger.log(Debugger.INFO, "[stream]", "视频状态: ", obj.type + ", code: " + obj.code);
			_currentVideoStatus = obj.type;
			if (_invokeFunc != null) {
				_invokeFunc.call(null, obj.type, data);
			}
		}

		public function get time():Number
		{
			if (_stream) {
				return _stream.time;
			}
			return 0;
		}

		public function set time(value:Number):void
		{
			_time = value;
			if (_stream) {
				_stream.seek(value);
			}
		}

		public function get totalTime():Number
		{
			return _totalTime;
		}
		
		public function set volume(value:Number):void {
			if (_stream) {
				if (_sound == null) {
					_sound = new SoundTransform();
				}
				_sound.volume = value / 100;
				_stream.soundTransform = _sound;
			}
		}
		
		public function get volume():Number {
			if (_stream) {
				return _stream.soundTransform.volume;
			}
			return 0;
		}
		
		public function get loadStartTime():Number
		{
			return _loadStartTime;
		}
		
		public function set loadStartTime(value:Number):void
		{
			_loadStartTime = value;
		}
		
		public function get connectionURL():String
		{
			return _connectionURL;
		}
		
		public function get streamURL():String
		{
			return _streamURL;
		}

		public function get bytesTotal():int
		{
			return _stream.bytesTotal;
		}

		public function get bytesLoaded():int
		{
			if(_stream)
			{
				return _stream.bytesLoaded;
			}
			else
			{
				return 0;
			}
		}
		
		public function close():void
		{
			removeEvents();
			if(_connection){
				_connection.close();
			}
			if(_stream){
				_stream.close();
			}
		}
		
		public function pause():void
		{
			_stream.pause();
			Debugger.log(Debugger.INFO,"BaseVideoSource pause()");
		}
		
		public function resume():void
		{
			_stream.resume();
		}
		
		public function get info():Object
		{
			return _info;
		}

		public function get currentVideoStatus():String
		{
			return _currentVideoStatus;
		}
		
		public function get loadedTime():Number
		{
			return _stream.bufferLength;
		}
		
	}
}