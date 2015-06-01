package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.model.PlayerEvents;

	public class BusinessJSDelegate implements IContextItem, IBusinessJS
	{
		public function BusinessJSDelegate()
		{
			JSBridge.enabled = true;
			JSBridge.defaultNameSpace = _("objectName");
		}
		
		public function startUp(param:Object):void {
			listen("onUserStatus", onUserLogin);
			listen("setEnd", onEnd);
			listen("setShowErr", onShowError);
			listen("getPlayedTime", onGetPlayedTime);
			listen("setPause", onPause);
		}
		
		public function listen(funcName:String, flashCallback:Function):void {
			JSBridge.addCall(funcName, null, null, flashCallback, true);
		}
		
		public function send(funcName:String, data:Object = null, ns:String = null):void {
			JSBridge.addCall(funcName, data, ns);
		}
		
		/**
		 * 提供js错误信息
		 */
		public function showErr():void {
			send("showErr");
		}
		
		private function onShowError(code:String):void {
			var re:Object = new Object();
			var msg:String = "";
			
			switch (code) {
				case "1" : 
					break;
			}
			
			re["code"] = code;
			re["msg"] = msg;
			re["error"] = "";
			
//			Global.eventManager.send(PlayerEvents.ON_PLAYER_ERROR, re);
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ON_PLAYER_ERROR, re);
		}
		
		public function get contextName():String {
			return ContextEnum.JS_DELEGATE;
		}
		
		protected function onEnd():void {
			Debugger.log(Debugger.INFO, "JS调用播放器进行停止!");
//			Global.videoManager.stop();
			_(ContextEnum.VIDEO_MANAGER) && 
				_(ContextEnum.VIDEO_MANAGER).stop();
		}
		
		protected function onPause():void {
			Debugger.log(Debugger.INFO, "JS调用播放器进行暂停!");
			// 暂停
			_(ContextEnum.VIDEO_MANAGER) && 
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_PLAY_OR_PAUSE, false);
		}
		
		/**
		 * 获取已播放时间 
		 * @return 
		 */		
		protected function onGetPlayedTime():int {
//			return Global.videoData.playedTime;
			return _(ContextEnum.VIDEO_MANAGER).data.playedTime;
		}
		
		protected function onUserLogin(v:String):void {
			
			if(Util.validateStr(v))
			{
				Context.getContext(ContextEnum.SETTING).userLogin = true;
				Context.getContext(ContextEnum.SETTING).userID = v;
//				Global.settings.userLogin = true;
//				Global.settings.userID = v;
			}
			else
			{
//				Global.settings.userLogin = false;
				Context.getContext(ContextEnum.SETTING).userLogin = false;
			}
		}
		
	}
}