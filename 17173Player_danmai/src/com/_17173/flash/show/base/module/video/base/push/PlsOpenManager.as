package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordType;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;

	/**
	 * 分发
	 * @author qiuyue
	 * 
	 */	
	public class PlsOpenManager
	{
		private var _s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		private var _retry:int = 0;
		private var MAX_COUNT:int = 5;
		private var succ:Function = null;
		private var fail:Function = null;
		private var url:URLVariables = null;
		
		public function PlsOpenManager() 
		{
		}
		
		private function onOpenResult(data:Object):void
		{
			_retry = 0;
			if(succ != null){
				succ();
			}
		}
		
		private function onOpenFault(data:Object):void
		{
			Debugger.log(Debugger.INFO,"onOpenFault","code = " + data.code ," msg = "+ data.msg);
			if(_retry < MAX_COUNT){
				sendMessage();
				_retry++;
			}else{
				if(fail != null){
					fail();
				}
			}
			sendError(data);
		}
		
		/**
		 *发送错误统计 
		 * @param data 错误信息
		 * 
		 */		
		private function sendError(data:Object):void{
			//发送错误统计
			var type:String = ErrorRecordType.PUSH_FENFA_ERROR;
			var info:Object = {inter:SEnum.GSLB_LIVE_URL,info:JSON.stringify(data),name:""};
			Context.getContext(CEnum.EVENT).send(SEvents.ERROR_RECORD,{code:type,info:info});
		}
		
		
		/**
		 * 
		 * @param hd 清晰度
		 * @param name 流名字
		 * @param key   gslb key
		 * @param hid   gslb hid
 		 * @param connectionURL  gslb connectionURL
		 * @param pluginVer  插件版本号
		 * @param succ   成功
		 * @param fail   失败
		 * 
		 */		
		public function open(hd:int,name:String, key:String, hid:String, connectionURL:String, pluginVer:String, succ:Function, fail:Function):void
		{
			this.succ = succ;
			this.fail = fail;
			_retry = 0;
			updateURLVariables(hd, name, key, hid, connectionURL, pluginVer);
			Ticker.tick(2000,sendMessage,1);
		}
		
		private function updateURLVariables(hd:int, name:String, key:String, hid:String, connectionURL:String, pluginVer:String):void
		{
			if(name != ""){
				url = new URLVariables();
				url["key"] = key;
				url["name"] = name;
				url["rtmp"] = connectionURL;
				url["v"] = pluginVer;
				url["hd"] = hd;
				url["hid"] = hid;
				url["t"] = Math.random();
			}
		}
		
		private function sendMessage():void{
			_s.http.getData(SEnum.PLS_OPEN, url, onOpenResult, onOpenFault, true);
		}
//		public function closeMessage(liveId:String):void
//		{
//			var url:URLVariables = new URLVariables();
//			url["liveId"] = liveId;
//			url["closeCode"] = 2;
//			_s.http.getData(SEnum.domain + "/pls_close.action", url, onCloseResult, onCloseFault);
//			
//		}
//		private function onCloseResult(data:Object):void
//		{
//			(Context.getContext(EventManager.CONTEXT_NAME) as EventManager).send(SEvents.TO_PUSH_CLOSE_SUCC,3);
//		}
//		
//		private function onCloseFault(data:Object):void
//		{
//			(Context.getContext(EventManager.CONTEXT_NAME) as EventManager).send(SEvents.TO_PUSH_CLOSE_FAIL,4);
//		}
	}

}