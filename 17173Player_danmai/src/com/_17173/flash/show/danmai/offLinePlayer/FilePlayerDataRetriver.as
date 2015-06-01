package com._17173.flash.show.danmai.offLinePlayer
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.net.URLVariables;

	public class FilePlayerDataRetriver
	{
		protected static const NEW_DISPATCH_URL:String = "http://v.17173.com/api/video/vInfo/id/{0}";
		
		public function FilePlayerDataRetriver()
		{
		}
		
		public function startDispatch(cid:String, onSuccess:Function, onFail:Function):void {
			var url:String = NEW_DISPATCH_URL.replace("{0}", cid);
			var v:URLVariables = null;
			
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.data = v;
			option.format = LoaderProxyOption.FORMAT_JSON;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.manuallyResolver = JSONResolver;
			option.onSuccess = function (data:Object):void {
				if (data.success == 0 && data.hasOwnProperty("data") && data.data["code"] != "" && data.data["msg"] != "") {
					//视频状态：-1-删除，0-初始状态（未转码），1-正常，2-正在转码，3-关键字过滤，4-图片过滤，5-隐藏，6-非法，7-转码失败
					Debugger.log(Debugger.ERROR, "[FilePlayerDataRetriver]" + "errorCode:" + data.data["code"] + "   errorMsg:" + data.data["msg"]);
				} else {
					onSuccess(parseJSONToData(data));
				}
			};
			option.onFault = onFail;
			loader.load(option);
		}
		
		protected function parseJSONToData(json:Object):FilePlayerVideoData {
			var v:FilePlayerVideoData = null;
			
			if (json.success == 1) {
				v = Context.variables["PlayerFileVideoData"] as FilePlayerVideoData;
				v.title = json.data.title;
				v.aClass = json.data.bigClass;
				v.bClass = json.data.subClass;
				v.aClassName = json.data.bigClassName;
				v.bClassName = json.data.subClassName;
				v.thumbnail = json.data.picUrl;
				v.isEncrypt = json.data.isEncrypt == 1;
				//数据总共有三个层级
				//清晰度 : 
				//	 分段 : 
				//		cdn
				//
				var cdnLen:int = 0;
				var streams:Object = {};
				var totalTime:int = 0;
				var totalSize:int = 0;
				for (var key:String in json.data.splitInfo) {
					var stream:Object = {};
					var splitInfo:Array = json.data.splitInfo[key]["info"];
					totalTime = 0;
					totalSize = 0;
					var splits:Array = [];
					for (var j:int = 0; j < splitInfo.length; j++) {
						var split:Object = {};
						var cdns:Array = [];
						cdnLen = splitInfo[j].url.length;
						var temp:String = "";
						for (var i:int = 0; i < cdnLen; i ++) {
							var playUrl:String = splitInfo[j].url[i];
							if (playUrl && playUrl != "" && playUrl != temp) {
								cdns.push(playUrl);
							}
							temp = playUrl;
						}
						split["url"] = cdns;
						split["duration"] = splitInfo[j].duration;
						totalTime += int(split["duration"]);
						split["size"] = splitInfo[j].size;
						totalSize += int(split["size"]);
						//						split["host"] = splitInfo[j].save_host;
						
						splits.push(split);
					}
					stream["totalSize"] = totalSize;
					stream["totalTime"] = totalTime;
					stream["split"] = splits;
					
					streams[json.data.splitInfo[key]["def"]] = stream;
				}
				v.totalTime = totalTime;
				v.totalBytes = totalSize;
				v.info = streams;
			} else {
				Debugger.log(Debugger.ERROR, "[FilePlayerDataRetriver]" + "解析调度失败");
			}
			
			return v;
		}
		
	}
}