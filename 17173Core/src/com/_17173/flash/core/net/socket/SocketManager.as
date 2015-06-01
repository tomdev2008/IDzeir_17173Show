package com._17173.flash.core.net.socket
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	
	/**
	 * Socket连接的管理类. 
	 * @author Shunia
	 * 
	 */	
	public class SocketManager extends EventDispatcher
	{
		
		protected var _socketService:BaseSocketService;
		/**
		 * 解析逻辑类的缓存. 
		 */		
		private var _serializeDict:Dictionary;
		/**
		 * Socket的封装类定义. 
		 */		
		private var _serviceClass:Class = BaseSocketService;
		/**
		 * 是否已初始化 
		 */		
		protected var _initialized:Boolean = false;
		/**
		 * socket是否已关闭 
		 */		
		protected var _closed:Boolean = false;
		protected var _connected:Boolean = false;
		
		public function SocketManager(service:Class = null)
		{
			if (service != null) {
				_serviceClass = service;
			}
			_initialized = false;
		}
		
		/**
		 * 初始化. 
		 */		
		public function init():void {
			if (!_initialized) {
				_initialized = true;
				_serializeDict = new Dictionary();
				_socketService = new _serviceClass();
				_socketService.dataArriveCallback = onSocketDataCallback;
				_socketService.conectedCallback = onConnected;
				_socketService.closedCallback = onClosed;
			}
		}
		
		protected function onConnected():void {
			_closed = false;
			_connected = true;
			dispatchEvent(new SocketEvent(SocketEvent.SOCKET_CONNECTED));
		}
		
		private function onClosed(result:String=""):void {
			_closed = true;
			_connected = false;
			var event:SocketEvent = new SocketEvent(SocketEvent.SOCKET_CLOSED);
			event.serviceData = {info:result};
			dispatchEvent(event);
		}
		
		/**
		 * 注册解析类到缓存中,serializer需要在初始化ServiceManager的时候进行注册. 
		 * @param serializer
		 */		
		public function registerSerializer(serializer:BaseSocketDataSerializer):void {
			_serializeDict[serializer.id] = serializer;
		}
		
		/**
		 * 当Socket有数据到达时,会调用这个方法,判断需要调用哪个Serializer来进行解析. 
		 * @param type
		 * @return 
		 */		
		private function onSocketDataCallback(type:int, data:IDataInput):Boolean {
			if (_serializeDict.hasOwnProperty(type)) {
				//获取解析回调
				var deserializer:Function = BaseSocketDataSerializer(_serializeDict[type]).deserialize;
				//解析出数据
				var result:Object = deserializer(data);
				//事件派发
				var event:SocketEvent = new SocketEvent(SocketEvent.SOCKET_RECEIVED);
				event.serviceType = type;
				event.serviceData = result;
				dispatchEvent(event);
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 监听一个类型的数据返回. 
		 * @param type	返回的接口类型.
		 * @param callback	返回数据的回调.
		 * @param useWeakReference	若设置此属性为true,则当数据返回之后即删除回调,若需要数据则再次调用这个方法才有效.
		 * 							若设置为false,则回调一直保留引用.
		 */		
		public function listen(type:int, callback:Function, useWeakReference:Boolean = false):void {
			if (_serializeDict.hasOwnProperty(type)) {
				var serializer:BaseSocketDataSerializer = BaseSocketDataSerializer(_serializeDict[type]);
				if (serializer) {
					serializer.registerListener(callback, useWeakReference);
				}
			}
		}
		
		/**
		 * 移除服务器侦听函数
		 * @param type		服务器接口类型
		 * @param callback	回调函数
		 * 
		 */		
		public function removeListen(type:int, callback:Function):void {
			if (_serializeDict.hasOwnProperty(type)) {
				var serializer:BaseSocketDataSerializer = BaseSocketDataSerializer(_serializeDict[type]);
				serializer.removeListener(callback);
			}
		}
		
		/**
		 * 发送数据给Server.提供type以获取对应的解析类,将内置数据类型解析为字节流并发送到Server. 
		 * @param type	接口的类型.
		 * @param data	需要解析的参数数组.应为顺序的.
		 */		
		public function send(type:int, data:Array = null):void {
			if (_closed) return;
			
			if (_serializeDict.hasOwnProperty(type)) {
				//获取发送解析器进行解析并发送
				var serializer:BaseSocketDataSerializer = BaseSocketDataSerializer(_serializeDict[type]);
				_socketService.send(serializer.serialize, data);
				//派发事件
				var event:SocketEvent = new SocketEvent(SocketEvent.SOCKET_SENDING);
				event.serviceType = type;
				event.serviceData = data;
				dispatchEvent(event);
			}
		}

		/**
		 * 关闭socket连接 
		 */		
		public function close():void {
			if (_connected && !_closed) {
				_closed = true;
				_connected = false;
				_socketService.close();
			}
		}

		/**
		 *  
		 * @return 
		 * 
		 */		
		public function get socketService():BaseSocketService
		{
			return _socketService;
		}

		/**
		 * socket是否已连接. 
		 */
		public function get connected():Boolean
		{
			return _connected;
		}

		
	}
}