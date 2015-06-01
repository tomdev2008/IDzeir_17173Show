package com._17173.flash.core.net.socket
{
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**
	 * 实现Socket功能的封装类.可以继承来实现不同监听事件的处理逻辑. 
	 * @author Shunia
	 */	
	public class BaseSocketService
	{
		/**
		 * 出错最大自动重试次数. 
		 */		
		private static const ERROR_TRY:int = 3;
		/**
		 * 出错后已重试的次数. 
		 */		
		private var _errorTried:int = 0;
		/**
		 * Socket. 
		 */		
		protected var _socket:Socket;
		/**
		 * Socket的目标地址. 
		 */		
		protected var _host:String;
		/**
		 * Socket的端口. 
		 */		
		protected var _port:int;
		/**
		 * crossdomain的目标地址. 
		 */		
		protected var _securityHost:String;
		/**
		 * crossdomain的端口. 
		 */		
		protected var _securityPort:int;
		/**
		 * 数据到达的解析函数引用. 
		 */		
		protected var _onDataArrive:Function;
		/**
		 * 连接成功回调. 
		 */		
		protected var _connectedCallback:Function;
		protected var _connected:Boolean = false;
		/**
		 * 连接断开回调 
		 */		
		protected var _closedCallback:Function;
		/**
		 * 是否已初始化 
		 */		
		protected var _inited:Boolean = false;
		
		public function BaseSocketService()
		{
		}
		
		/**
		 * 设置当有数据到达时的解析函数. 
		 * @param value
		 * 
		 */		
		public function set dataArriveCallback(value:Function):void {
			_onDataArrive = value;
		}
		
		/**
		 * 设置连接成功回调. 
		 * @param value
		 * 
		 */		
		public function set conectedCallback(value:Function):void {
			_connectedCallback = value;
		}
		
		/**
		 * 连接断开回调 
		 * @param value
		 */		
		public function set closedCallback(value:Function):void {
			_closedCallback = value;
		}
		
		/**
		 * 初始化Socket并连接. 
		 * @param host
		 * @param port
		 */		
		public function init(host:String, port:int, securityHost:String, securityPort:int):void {
			if (_inited) return;
			
			_inited = true;
			
			_host = host;
			_port = port;
			_securityHost = securityHost;
			_securityPort = securityPort;
			
			Security.loadPolicyFile("xmlsocket://" + _securityHost + ":" + _securityPort);
			
			_socket = new Socket();
			_socket.timeout = 10000;
			//Debugger.log(Debugger.INFO,"[baseSocketService]","endian = "+_socket.endian);
			//_socket.endian = Endian.BIG_ENDIAN;
			_socket.addEventListener(Event.CONNECT, onSocketConnected);
			_socket.addEventListener(Event.CLOSE, onSocketClosed);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(Event.DEACTIVATE, onSocketDeactivate);
			_socket.addEventListener(Event.ACTIVATE, onSocketActivate);
			_socket.connect(_host, _port);
		}
		
		protected function onSocketConnected(e:Event):void {
			_connected = true;
			
			_errorTried = 0;
			
			if (_connectedCallback != null) {
				_connectedCallback();
			}
		}
		
		protected function onSocketClosed(e:Event):void {
			_connected = false;
			
			clear();
			
			if (_closedCallback != null) {
				_closedCallback("服务器断开");
			}
		}
		
		/**
		 * 获得Server端数据,将其交给解析函数处理. 
		 * @param e
		 * 
		 */		
		protected function onSocketData(e:ProgressEvent):void {
			if (_onDataArrive != null) {
				_onDataArrive();
			}
		}
		
		/**
		 * 出错尝试自动重连. 
		 * @param e
		 * 
		 */		
		protected function onIOError(e:IOErrorEvent):void {
			clear();
			
			Debugger.log(Debugger.WARNING, this, e.type);
			_errorTried ++;
			if (_errorTried == ERROR_TRY) {
				countServiceError(e.errorID + e.text);
			} else {
				reconnect();
			}
		}
		
		/**
		 * 出错尝试自动重连. 
		 * @param e
		 * 
		 */	
		protected function onSecurityError(e:SecurityErrorEvent):void {
			clear();
			
			Debugger.log(Debugger.WARNING, this, e.type);
			_errorTried ++;
			if (_errorTried == ERROR_TRY) {
				countServiceError(e.errorID + e.text);
			} else {
				reconnect();
			}
		}
		
		protected function onSocketActivate(e:Event):void {
			
		}
		
		protected function onSocketDeactivate(e:Event):void {
			
		}
		
		/**
		 * 重连. 
		 */		
		public function reconnect():void {
			//Debugger.log(Debugger.INFO,"reconnect",this,_socket);
			if (_socket == null) {
				_inited = false;
				init(_host, _port, _securityHost, _securityPort);
			} else {
				_socket.connect(_host, _port);
			}
		}
		
		public function get socket():Socket {
			return _socket;
		}
		
		protected function countServiceError(result:String):void {
			//Debugger.log(Debugger.INFO,this,"countServiceError:"+result," _closedCallback:",_closedCallback);
			this._errorTried = 0;
			if (_closedCallback != null) {
				_closedCallback(result);
			}
		}
		
		/**
		 * 发送数据,从外部取的一个解析函数来将数据解析成字节流并发送. 
		 * @param serializer
		 * @param data
		 */		
		public function send(serializer:Function, data:Array):void {
			if (!_connected) return;
			
			if (serializer != null) {
				var pack:ByteArray = serializer(data);
				if (pack && pack.length) {
					_socket.writeBytes(pack, 0, pack.length);
					_socket.flush();
				}
			}
		}
		
		/**
		 * 如果已经连接，清空数据并关闭socket 
		 */		
		public function close():void {
			if (socket.connected && _connected) {
				clear();
				socket.close();
			}
		}
		
		/**
		 * 清空当前socket中的数据 
		 */		
		public function clear():void {
			try{
				//socket.readUTFBytes(socket.bytesAvailable);
			}catch(e:Error){
				Debugger.log(Debugger.INFO,"socket清楚数据失败",e.message);
			};
		}
		
		/**
		 * 手动销毁. 
		 */		
		public function dispose():void {
			clear();
			socket.close();
		}

		/**
		 * 是否已连接 
		 */
		public function get connected():Boolean
		{
			return _connected;
		}

		
	}
}