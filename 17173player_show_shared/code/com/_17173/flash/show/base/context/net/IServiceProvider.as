package com._17173.flash.show.base.context.net
{
	public interface IServiceProvider
	{
		
		function set socketDomain(value:String):void;
		
		function set socketPort(value:int):void;
		
		function set socketSecurePort(value:int):void;
		
		function get socket():ISocketService;
		
		function get http():IHttpService;
		
	}
}