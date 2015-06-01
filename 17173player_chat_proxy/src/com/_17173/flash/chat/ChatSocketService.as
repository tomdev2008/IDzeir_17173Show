package com._17173.flash.chat
{
	import com._17173.flash.core.net.socket.BaseSocketService;
	
	import flash.events.ProgressEvent;
	
	/**
	 * 解析服务器端的数据,并打包交给serializer们进行处理. 
	 * @author shunia-17173
	 */	
	public class ChatSocketService extends BaseSocketService
	{
		public function ChatSocketService()
		{
			super();
		}
		
		override protected function onSocketData(e:ProgressEvent):void {
			if (_onDataArrive == null) return;
			//resolve data into package
		}
		
	}
}