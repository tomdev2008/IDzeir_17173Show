package com._17173.flash.show.base.context.net
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.show.model.CEnum;
	
	/**
	 * 服务提供类.
	 * 
	 * 可以从这儿获取到长连或者短连的代理类,用来进行数据的接收和派发.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class ServiceProvider implements IContextItem, IServiceProvider
	{
		
		private var _http:HttpService = null;
		private var _socket:SocketService = null;
		
		public function ServiceProvider()
		{
		}
		
		public function get contextName():String
		{
			return CEnum.SERVICE;
		}
		
		public function startUp(param:Object):void
		{
			_http = new HttpService();
			_socket = new SocketService();
		}
		
		public function get http():IHttpService
		{
			return _http;
		}
		
		public function get socket():ISocketService
		{
			return _socket;
		}
		
		public function set socketDomain(value:String):void
		{
			_socket.domain = value;
		}
		
		public function set socketPort(value:int):void
		{
			_socket.port = value;
		}
		
		public function set socketSecurePort(value:int):void
		{
			_socket.securePort = value;
		}
		
		
	}
}