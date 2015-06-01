package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.SError;
	import com._17173.flash.show.model.ShowData;
	
	/**
	 * 初始化聊天服务器(socket长连接).
	 *  
	 * @author shunia-17173
	 */	
	public class InitSocket extends BaseInit
	{
		public function InitSocket()
		{
			super();
			
			_name = "建立连接";
			_weight = 20;
		}
		
		override public function enter():void {
			super.enter();
			
			Debugger.log(Debugger.INFO, "[init]", "socket服务器开始连接!");
			
			var showData:ShowData = Context.variables["showData"];
			//启动连接
			_s.socketDomain = showData.socketDomain;
			_s.socketPort = showData.socketPort;
			_s.socketSecurePort = showData.socketPort;
			_s.socket.connect(onConnect, onSocketError);
		}
		
		/**
		 * socket链接成功 
		 */		
		private function onConnect():void {
			Debugger.log(Debugger.INFO, "[init]", "socket服务器连接成功!");
			//完成
			complete();
		}
		
		/**
		 * socket数据错误.
		 *  
		 * @param data
		 */		
		private function onSocketError(data:Object):void {
			Debugger.log(Debugger.ERROR, "[init]", "服务器返回错误消息!"+JSON.stringify(data));
			
			data.code = data.retcode;
			data.msg = data.retmsg;
			SError.handleServerError(data);
			
//			complete();
		}
		
	}
}