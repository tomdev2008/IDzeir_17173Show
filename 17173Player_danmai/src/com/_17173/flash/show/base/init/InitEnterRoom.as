package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.SEnum;
	
	/**
	 * 和服务器握手,通知当前用户登陆. 
	 * 
	 * @author shunia-17173
	 */	
	public class InitEnterRoom extends BaseInit
	{
		public function InitEnterRoom()
		{
			super();
			
			_name = "获取数据";
			_weight = 10;
		}
		
		override public function enter():void {
			super.enter();
			_s.socket.listen(SEnum.R_HAND.action, SEnum.R_HAND.type, onHandShakeSucc);			
			var showData:Object = Context.variables["showData"];
			this.enterRoom(showData)
		}
		
		/**
		 * 发送登陆消息.
		 *  
		 * @param showData
		 */		
		private function enterRoom(showData:Object):void {
			Debugger.log(Debugger.INFO, "[init]", "发送握手消息!");
			//handshake
			var body:Object = {};
			body["_method_"] = "Enter";
			body["type"] = 0;
			body["rid"] = showData.roomID;
			body["uid"] = showData.masterID;
			body["uname"] = "hehe";
			body["token"] = showData.token;
			body["md5"] = "RTYUI";
			body["majorType"] = Context.variables["showData"].type;
			_s.socket.send(SEnum.S_ENTER, body);
		}
		
		private function onHandShakeSucc(data:Object):void {
			Debugger.log(Debugger.INFO, "[init]", "收到服务器返回握手消息,用户进入房间");
			//此处移除监听
			_s.socket.removeListen(SEnum.R_HAND.action, SEnum.R_HAND.type, onHandShakeSucc);
			//完成
			complete();
		}
		
	}
}