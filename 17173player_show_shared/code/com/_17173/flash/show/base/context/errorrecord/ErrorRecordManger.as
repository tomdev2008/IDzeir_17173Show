package com._17173.flash.show.base.context.errorrecord
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;
	
	public class ErrorRecordManger implements IErrorRecordManager, IContextItem
	{
		private const ACTION:String = "/pls_errorInfo.action?";
		public function ErrorRecordManger()
		{
		}
		
		public function record(code:String,info:Object):void
		{
			var url:String = SEnum.domain + ACTION;
			var v:URLVariables;
			if (info is URLVariables) {
				v = info as URLVariables;
			} else {
				v = new URLVariables();
				for (var key:String in info) {
					v[key] = info[key];
				}
			}
			v["code"] = code;
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.data = v;
			option.format = LoaderProxyOption.FORMAT_JSON;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.manuallyResolver = JSONResolver;
			option.onSuccess = function (data:Object):void {
				Debugger.log(Debugger.INFO, "[错误统计]", "成功 " + JSON.stringify(info));
			};
			option.onFault = function (data:Object):void {
				Debugger.log(Debugger.INFO, "[错误统计]", "失败 " + JSON.stringify(data));
			};
			loader.load(option);
		}
		
		public function get contextName():String
		{
			return "ErrorRecord";
		}
		/**
		 *解析时间过来数据 
		 * @param data
		 * 
		 */		
		private function onRecord(data:Object):void{
			var code:String;
			//如果code为空则说明该错误统计不可用
			if(data.hasOwnProperty("code")){
				code = data.code;
			}else{
				return ;
			}
			var info:Object ;
			//如果信息没有，也可以发送出去，但是没有太大意义，不能正确分析
			if(data.hasOwnProperty("info")){
				info = data.info;
			}else{
				info = {};
			}
			record(code,info);
		}
		
		public function startUp(param:Object):void
		{
		  Context.getContext(CEnum.EVENT).listen(SEvents.ERROR_RECORD,onRecord);
		}
	}
}