package com._17173.flash.show.base.module.video.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordType;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;
	
	/**
	 * 推流调度类 
	 * @author qiuyue
	 * 
	 */	
	public class PushGslbManager
	{
		private var obj:Object = {};
		private var succ:Function = null;
		private var fail:Function = null;
		private var MAX_COUNT:int = 20;
		private var retry:int = 0;
		private var url:URLVariables = new URLVariables();
		private var _s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		public function PushGslbManager() 
		{
			
		}
		
		private function onPubResult(data:Object) : void
		{
			if (data.code == "000000" && analyseAddr(data.data.addr,data.key))
			{
				obj.hid = data.data.hid;
				if(succ != null){
					succ(obj);
				}
			} 
		}
		
		private function onPubFault(data:Object) : void
		{
			retry++;	
			if(retry<= MAX_COUNT){
				sendMessage();
			}else{
				retry = 0;
			}
			Debugger.log(Debugger.INFO,"PushGslbManager code="+data.code);
			if(fail != null){
				fail();
			}
			if(retry == 1){
				sendError(data);
			}
			
		}
		
		/**
		 *发送错误统计 
		 * @param data 错误信息
		 * 
		 */		
		private function sendError(data:Object):void{
			//发送错误统计
			var type:String = ErrorRecordType.PUSH_GSLB_ERROR
			var info:Object = {inter:SEnum.GSLB_PUSH_URL,info:JSON.stringify(data),name:""};
			Context.getContext(CEnum.EVENT).send(SEvents.ERROR_RECORD,{code:type,info:info});
		}
		
		private function analyseAddr(addr:String,key:String):Boolean {
			var reg:RegExp = new RegExp("(.+:[0-9]{1,4}/)(.+)/(.+)");
			var keyArr:Array = addr.match(reg);
			if (keyArr.length > 2) {
				obj.connectionURL = keyArr[1] + keyArr[2];
				obj.streamName = keyArr[3];
				obj.key = key;
				obj.rtmpFullyUri = addr;
				Debugger.log(Debugger.INFO,"[推流]", "connectionURL："+ obj.connectionURL);
				Debugger.log(Debugger.INFO,"[推流]", "streamName："+ obj.streamName);
				return true;
			}
			return false;
		}
		
		private function sendMessage():void{
			_s.http.getData(SEnum.GSLB_PUSH_URL,url, onPubResult, onPubFault, true);
		}
		/**
		 *  
		 * @param name 流名
 		 * @param pushY 节点 默认为“”
		 * @param pushN  节点 默认为“”
		 * @param succ  gslb 调度成功
		 * @param fail	gslb 调度失败
		 * 
		 */		
		public function push(name:String, pushY:String, pushN:String,succ:Function,fail:Function):void 
		{
			retry = 0;
			obj = new Object();
			this.succ = succ;
			this.fail = fail;
			url = new URLVariables();
			url["type"] = "liveroom";
			url["ver"] = "2.0";	
			url["name"] = name;
			url["optimal"] = 1;
			url["sip"] = "";
			url["y"] = pushY;
			url["n"] = pushN;
			url["t"] = Math.random();
			url["btype"] = 1;
			sendMessage();
		}
	}

}