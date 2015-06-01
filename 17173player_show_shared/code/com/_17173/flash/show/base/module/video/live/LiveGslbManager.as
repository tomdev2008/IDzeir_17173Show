package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordType;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	
	/**
	 * 拉流调度管理类 
	 * @author qiuyue
	 * 
	 */	
	public class LiveGslbManager
	{
		private var _retry:int = 0;
		private var MAX_COUNT:int = 20;
		private var _s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		private var url:URLVariables = null;
		private var object:Object = {};
		private var succ:Function = null;
		private var fail:Function = null;
		private var isOptimize:Boolean = true;
		
		public function LiveGslbManager() 
		{
		
		}
		
		public function live(cId:String, ckey:String, name:String ,cdntype:String, succ:Function, fail:Function) : void 
		{
			this.succ = succ;
			this.fail = fail;
			object = new Object();
			url = new URLVariables();
			url["cid"] = cId;
			url["ckey"] = ckey;
			url["ver"] = 2.0;
			url["prot"] = 3;
			url["sip"] = "";
			url["name"] = name;
			url["cdntype"] = cdntype;
			url["t"] =  Math.random();
			url["btype"] = 1;
			isBestGslb(true);
			_s.http.getData(SEnum.GSLB_LIVE_URL, url, onOptLiveResult, onOptLiveFault, true);
			_retry = 0;
		}
		
		private function isBestGslb(isOptimize:Boolean):void
		{
			this.isOptimize = isOptimize;
			url["optimal"] = (isOptimize?1:0);
		}
		
		
		/**
		 *发送错误统计 
		 * @param data 错误信息
		 * 
		 */		
		private function sendError(data:Object):void{
			//发送错误统计
			var type:String = ErrorRecordType.LIVE_GSLB_ERROR
			var info:Object = {inter:SEnum.GSLB_LIVE_URL,info:JSON.stringify(data),name:""};
			Context.getContext(CEnum.EVENT).send(SEvents.ERROR_RECORD,{code:type,info:info});
		}
		
		/**
		 * 第三方属性 
		 * @param data
		 * 
		 */		
		private function updateData(data:Object):void{
			var ip:String = data.ip;
			var port:String = data.port;
			var key:String = data.key;
			if(port == ""){
				if(ip.indexOf("rtmp://") != -1){
					object.connectionURL = ip;
					object.streamName = key;
				}else{
					object.connectionURL = null;
					object.streamName = ip + port +key;
				}
			}else{
				var portPart:String = "";
				var array:Array = port.split("|");
				if(array.length > 0){
					portPart = array[0];
				}
				object.connectionURL = null;
				object.streamName = ip + portPart +key;
			}
			Debugger.log(Debugger.INFO,"[拉流]","connectionURL:"+object.connectionURL);
			Debugger.log(Debugger.INFO,"[拉流]","streamName:"+object.streamName);
		}
		
		private function onOptLiveResult(data:Object) : void
		{
			_retry = 0;
			updateData(data);
//			_liveVideoData.connectionURL = data.ip;
//			_liveVideoData.streamName = (data.url as String).replace(data.ip,"");
//			_liveVideoData.connectionURL = null;
//			_liveVideoData.streamName = data.url;
			Debugger.log(Debugger.INFO,"LiveScheduler:成功 data.ip = "+  data.ip +"    data.url="+object.streamName);
			if(succ != null){
				object.optimal = isOptimize?1:0;
				succ(object);
			}
		}
		
		private function onOptLiveFault(data:Object) : void
		{
			if(_retry < MAX_COUNT){
				isBestGslb(false);
				_s.http.getData(SEnum.GSLB_LIVE_URL,url,onOptLiveResult, onOptLiveFault,true);
				_retry++;
				Debugger.log(Debugger.INFO,"拉流尝试"+_retry +"  cId= "+object.cId +"  ckey" + object.ckey);
			}else{
				if(fail != null){
					fail();
				}
			}
			if(_retry == 1){
				sendError(data);
			}
		}
		
	}
	
}

