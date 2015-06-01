package com._17173.flash.core.net.socket
{
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		
		/**
		 * socket连接成功 
		 */		
		public static const SOCKET_CONNECTED:String = "socketConnected";
		/**
		 * socket正在发送数据 
		 */		
		public static const SOCKET_SENDING:String = "socketSending";
		/**
		 * socket接受到了数据 
		 */		
		public static const SOCKET_RECEIVED:String = "socketReceived";
		/**
		 * socket关闭 
		 */		
		public static const SOCKET_CLOSED:String = "socketClosed";
		
		/**
		 * 发送或者接收到的数据类型 
		 */		
		public var serviceType:int = -1;
		/**
		 * 发送或者接收到的数据 
		 */		
		public var serviceData:Object = null;
		
		public function SocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}