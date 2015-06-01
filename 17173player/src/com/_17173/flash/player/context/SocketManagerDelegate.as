package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.socket.ISocketManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.context.socket.SEnum;
	import com._17173.flash.player.context.socket.SocketService;
	
	import flash.utils.Dictionary;

	/**
	 * socket代理模块
	 */	
	public class SocketManagerDelegate implements IContextItem,ISocketManager
	{
		private var _socket:SocketService = null;
		private var _rid:String = null;
		private var _uid:String = null;
		private var _token:Object = null;
		private var _sendArrTemp:Dictionary;
		private var _arrNum:int = 0;
		private var _hasConnect:Boolean = false;
		/**
		 * 已经握手成功
		 */		
		private var _isHander:Boolean = false;
		
		public function SocketManagerDelegate()
		{
		}
		
		public function get contextName():String
		{
			return ContextEnum.SOCKET_MANAGER;
		}
		
		public function startUp(param:Object):void
		{
			_socket = new SocketService();
			_sendArrTemp = new Dictionary();
		}
		
		/**
		 * 启动socket连接
		 */		
		public function startConnect():void {
			if (_hasConnect) {
				return;
			}
			if (isDataReady()) {
				Ticker.stop(reConnect);
				init();
			} else {
				_hasConnect = true;
				Ticker.tick(500, reConnect);
				Debugger.log(Debugger.INFO, "[socket]", "socket数据缺失!" + " roomID:" + _rid + "  uid:" + _uid);
			}
		}
		
		private function reConnect():void {
			if (isDataReady()) {
				Ticker.stop(reConnect);
				init();
			} else {
				Ticker.tick(500, reConnect);
			}
		}
		
		/**
		 * socket发送请求
		 * @param service
		 * @param body
		 * 
		 */		
		public function send(service:Object, body:Object):void {
			//如果还未连接上，先做缓存
			if (!_isHander) {
				var temp:Array = [service, body]
				_sendArrTemp[_arrNum] = temp;
				_arrNum++;
			} else {
				_socket.send(service, body);
			}
		}
		
		/**
		 * socket监听
		 * @param type
		 * @param callback
		 * 
		 */		
		public function listen(type:Object, callback:Function):void {
			var action:int = int(type["action"]);
			var ty:int = int(type["type"]);
			_socket.listen(action, ty, callback);
		}
		
		private function init():void {
			Debugger.log(Debugger.INFO, "[socket]", "socket执行连接!" + " roomID:" + _rid + "  uid:" + _uid);
			Context.getContext(ContextEnum.DATA_RETRIVER)["getToken"](_rid, _uid, onGetTokenSucc, onGetTokenFail);
		}
		
		private function isDataReady():Boolean {
			_rid = Context.variables["liveRoomId"];
			_uid = Context.variables["userId"];
			return Util.validateStr(_rid) && Util.validateStr(_uid);
		}
		
		/**
		 * 获取token失败 
		 */		
		private function onGetTokenFail(data:Object):void {
			Debugger.log(Debugger.INFO, "[socket]", "socket模块Token获取失败!");
		}
		
		/**
		 * 获取token成功
		 *  
		 * @param data
		 */		
		private function onGetTokenSucc(data:Object):void {
			_token = data;
			_socket.domain = _token.node.ip;
			_socket.port = _token.node.port;
			_socket.securePort = _token.node.port;
			_socket.connect(onConnected, onError);
		}
		
		/**
		 * 连接错误
		 * @param data
		 */		
		private function onError(data:Object):void {
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.SOCKET_CONNECT_ERROR, data);
		}
		
		private function onConnected():void {
			socketHandShake();
			_socket.listen(0, 0, onHandShake);
		}
		
		/**
		 * 握手. 
		 */		
		private function socketHandShake():void {
			var v:Object = Context.variables["videoData"];
			var body:Object = {};
			body["_method_"] = "Enter";
			body["type"] = 0;
			body["rid"] = _token.node.chatRoomId;;
			body["uid"] = _uid;
			body["uname"] = "hehe";
			body["token"] = _token.t;
			body["md5"] = "RTYUI";
			body["majorType"] = 1;
			_socket.send(SEnum.S_ENTER, body);
		}
		
		private function onHandShake(data:Object):void {
			if (_isHander == false) {
				_isHander = true;
				//连接的时候会判断缓存中是否有内容
				if (_arrNum > 0) {
					for (var item:String in _sendArrTemp) {
						_socket.send(_sendArrTemp[item][0], _sendArrTemp[item][1]);
					}
					_arrNum = 0;
					_sendArrTemp = new Dictionary();
				}
			}
		}
	}
}