package com._17173.flash.show.base.context.net
{
	
	/**
	 * Socket接口类.
	 *  
	 * @author shunia-17173
	 */	
	public interface ISocketService
	{
		
		/**
		 * 连接socket.
		 *  
		 * @param onConnected 成功连接后的回调
		 * @param onError 连接失败后的回调
		 */		
		function connect(onConnected:Function, onError:Function):void;
		/**
		 * 关闭socket 
		 */		
		function close():void;
		/**
		 * 像已经连接的socket发送数据.
		 *  
		 * @param service 定义在SEnum中的Object格式的接口.包含action和type属性,用来定义一个消息的类型.
		 * @param body 数据体,k-v形式的object
		 */		
		function send(service:Object, body:Object):void;
		/**
		 * 监听指定的消息类型的数据.
		 *  
		 * @param action
		 * @param type
		 * @param callback 监听到后的回调方法,需要提供一个参数接收数据.
		 */		
		function listen(action:int, type:int, callback:Function):void;
		/**
		 * 移除已经监听的消息.
		 *  
		 * @param action
		 * @param type
		 * @param callback
		 */		
		function removeListen(action:int, type:int, callback:Function):void;
		/**
		 * 销毁socket连接之后不能再进行重连 
		 * 
		 */		
		function destroy(info:*=null):void;
	}
}