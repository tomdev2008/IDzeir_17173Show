package com._17173.flash.core.socket
{
	public interface ISocketManager
	{
		/**
		 * socket启动连接
		 */		
		function startConnect():void;
		/**
		 * socket监听
		 */		
		function listen(type:Object, callback:Function):void;
		/**
		 * socket派发事件
		 */		
		function send(service:Object, body:Object):void;
	}
}