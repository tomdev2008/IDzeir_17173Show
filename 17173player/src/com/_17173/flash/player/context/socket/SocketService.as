package com._17173.flash.player.context.socket
{
	import com._17173.flash.core.net.socket.SocketEvent;
	import com._17173.flash.core.net.socket.SocketManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class SocketService implements ISocketService
	{
		
		private var _domain:String = null;
		
		private var _port:int = 8000;
		
		private var _securePort:int = 843;
		
		private var _socketManager:SocketManager = null;
		
		private var _onConnected:Function = null;
		private var _onError:Function = null;
		
		private var _callbacks:Dictionary = null;
		
		private var _heartRecv:Array = null;
		
		public function SocketService()
		{
			_callbacks = new Dictionary();
			
			_socketManager = new SocketManager(SocketResolver);
			_socketManager.init();
			
			_socketManager.registerSerializer(new SocketSerializer());
			
			_socketManager.addEventListener(SocketEvent.SOCKET_CONNECTED, onConnected);
			//			_socketManager.addEventListener(SocketEvent.SOCKET_RECEIVED, onRecived);
			//			_socketManager.addEventListener(SocketEvent.SOCKET_SENDING, onSending);
			//			_socketManager.addEventListener(SocketEvent.SOCKET_CLOSED, onClosed);
			
			_heartRecv = [];
		}
		
		protected function onConnected(event:Event):void
		{
			Debugger.log(Debugger.INFO, "[soeckt]", "连接成功: 数据通道:", _domain, ":", _port, ",安全通道:", _domain, ":", _port);
			if (_onConnected != null) {
				_onConnected();
				_onConnected = null;
			}
			_socketManager.listen(0, onCallback, false);
			
			Ticker.stop(onSendHeart);
			Ticker.tick(30000, onSendHeart, 0);
		}
		
		/**
		 * 发送心跳数据包 
		 */		
		private function onSendHeart():void {
			//			Debugger.log(Debugger.INFO, "[socket]", "心跳验证");
			if (_socketManager.connected) {
				if (_heartRecv.length > 0) {
					_socketManager.socketService.reconnect();
				} else {
					//取随机值,当成心跳发出去
					var heartID:int = Math.random() * 1E10 >> 0;
					_heartRecv.push(heartID);
					send(SEnum.HEART_BEAT, heartID);
				}
			}
		}
		
		/**
		 * 数据解析出来了.
		 *  
		 * @param data
		 */		
		private function onCallback(data:Object):void {
			//验证数据是不是心跳,是心跳丢掉
			if (_heartRecv.indexOf(data) > -1) {
				_heartRecv.splice(_heartRecv.indexOf(data), 1);
			} else {
				if (data.hasOwnProperty("retcode") && data.retcode == "000000") {
					var result:Object = data.msg[0];
					//读取接口标识
					var action:int = result.action;
					var type:int = result.msgtype;
					if (type == 1) {
						if (Util.validateStr(result.ct)) {
							//还原字符串
							var escape:Boolean = data.hasOwnProperty("escapeflag") ? data["escapeflag"] == 1 : false;
							if (escape) {
								//解码html
								result.ct = unescape(result.ct);
							}
							//转成object
							result.ct = JSON.parse(result.ct);
						} else {
							//默认为空object
							result.ct = {};
						}
					}
					Debugger.log(Debugger.INFO, "[socket]", "返回消息action: " + action + ", msgtype: " + type);
					var key:String = action + "_" + type;
					//回调
					var callbacks:Array = _callbacks.hasOwnProperty(key) ? _callbacks[key] : null;
					if (callbacks) {
						for each (var call:Function in callbacks) {
							call.apply(null, [result]);
						}
					}
				} else {
					onError(data);
				}
			}
		}
		
		private function onError(data:Object):void {
			if (_onError != null) {
				_onError.apply(null, [data]);
			}
		}
		
		protected function onRecived(event:Event):void
		{
			
		}
		
		protected function onSending(event:Event):void
		{
			
		}
		
		protected function onClosed(event:Event):void
		{
			
		}
		
		public function connect(onConnected:Function, onError:Function):void
		{
			_onConnected = onConnected;
			_onError = onError;
			_socketManager.socketService.init(_domain, _port, _domain, _securePort);
		}
		
		public function close():void
		{
			_socketManager.close();
		}
		
		public function send(service:Object, body:Object):void
		{
			_socketManager.send(0, [service, body]);
		}
		
		public function listen(action:int, type:int, callback:Function):void
		{
			var arr:Array = null;
			var key:String = action + "_" + type;
			if (_callbacks.hasOwnProperty(key) && _callbacks[key]) {
				arr = _callbacks[key];
			} else {
				arr = [];
			}
			if (arr.indexOf(callback) == -1) {
				arr.push(callback);
				_callbacks[key] = arr;
			}
		}
		
		public function removeListen(action:int, type:int, callback:Function):void
		{
			var key:String = action + "_" + type;
			if (_callbacks.hasOwnProperty(key) && _callbacks[key]) {
				var arr:Array = _callbacks[key];
				if (arr.indexOf(callback)) {
					arr.splice(arr.indexOf(callback), 1);
				}
			}
		}
		
		public function set domain(value:String):void
		{
			_domain = value;
		}
		
		public function set port(value:int):void
		{
			_port = value;
		}
		
		public function set securePort(value:int):void
		{
			_securePort = value;
		}
		
		
	}
}