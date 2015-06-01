package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.DataRetriver;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.backRecommend.data.BackRecItemData;
	
	import flash.net.URLVariables;
	
	/**
	 * 点播视频数据接口集合. 
	 * @author shunia-17173
	 */	
	public class FileDataRetriver extends DataRetriver
	{
		
		/**
		 * 点播配置文件 
		 */		
		protected static const DISPATCH_URL_CONFIG:String = "http://v.17173.com/v/config.json";
		protected static const OLD_DISPATCH_URL:String = "http://17173.tv.sohu.com/port/pconfig_r.php";
//		protected static const NEW_DISPATCH_URL:String = "http://v.17173.com/api/video/cdnInfo/id/{0}";
		protected static const NEW_DISPATCH_URL:String = "http://v.17173.com/api/video/vInfo/id/{0}";
//		protected static const NEW_DISPATCH_URL:String = "assets/j.json";
		protected static const MOREPATH_URL:String = "http://v.17173.com/api/video/moreVideo/id/{0}";
		protected static const PLAY_RECORD_URL:String = "http://v.17173.com/japi/video/pushPlayRecord";
		protected static const CHECK_PASSWORD_URL:String = "http://v.17173.com/api/Video/VerifyPasswd/id/{0}/passwd/";
		protected static const ADD_PALY_NULBER_URL:String = "http://v.17173.com/api/video/addPlayNum/id/{0}";
		public static const VIDEO_SERACH_RUL:String = "http://v.17173.com/so-index.html?key=";
		public static const VIDEO_SERACH_LIST_URL:String = "http://v.17173.com/list/index/bc/";//更多**时用的连接
		public static const GET_LIVE_URL:String = "http://v.17173.com/live/index/recommendLive.action?gameId=";//获取当前是否有对应的直播
		
		/**
		 * 客户端url地址
		 */		
		public static const CLIENT_17173_URL:String = "http://v.17173.com/vtool/";
		
		public function FileDataRetriver()
		{
			super();
		}
		
		/**
		 * 启动调度. 
		 * @param cid
		 * @param callback
		 */		
		override public function startDispatch(cid:String, onSuccess:Function, onFail:Function):void {
			startNewDispatch(
				cid, 
				onSuccess, 
				function (data:Object):void {
					if (onFail != null) {
						onFail(
							PlayerErrors.packUpError(PlayerErrors.VIDEO_DISPATCH_URL_RETRIVE_FAIL, 
								Util.validateObj(data, "msg") ? data.msg : String(data) + "->" + Util.validateObj(data, "requestURL") ? data["requestURL"] : String(data))
//								data.hasOwnProperty("msg") ? data.msg : data + "->" + data["requestURL"])
						);
					}
				}
			);
		}
		
		/**
		 * 新版v.17173.com调度 
		 * @param cid
		 * @param callback
		 */		
		protected function startNewDispatch(cid:String, callback:Function, onFail:Function):void {
			this.packupLoader(NEW_DISPATCH_URL.replace("{0}", cid), 
				function (data:Object):void
				{
					if (data.success == 0 && data.hasOwnProperty("data") && data.data["code"] != "" && data.data["msg"] != "") {
						//视频状态：-1-删除，0-初始状态（未转码），1-正常，2-正在转码，3-关键字过滤，4-图片过滤，5-隐藏，6-非法，7-转码失败
						var error:Object = PlayerErrors.packUpError(PlayerErrors.VIDEO_DELETE_OR_HIDE, data.data["code"] + " " + data.data["msg"]);
//						Global.eventManager.send(PlayerEvents.ON_PLAYER_ERROR, error);
						(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.ON_PLAYER_ERROR, error);
					} else {
						callback(parseJSONToData1(data));
					}
				}, 
				LoaderProxyOption.FORMAT_JSON, 
				null, 
				JSONResolver, validate, onFail);
		}
		
		/**
		 * 老版线上调度 
		 * @param cid
		 * @param callback
		 */		
//		protected function startOldDispatch(cid:String, callback:Function):void {
////			VideoDataRetriver.packUpLoader(
////				OLD_DISPATCH_URL + "?id=" + cid, 
////				LoaderProxyOption.FORMAT_VARIABLES, 
////				null, 
////				callback, 
////				parseXMLToData, 
////				XMLResolver);
//			
//			this.packupLoader(OLD_DISPATCH_URL + "?id=" + cid, 
//				function (data:Object):void
//				{
//					callback(parseXMLToData(data as XML));
//				}, 
//				LoaderProxyOption.FORMAT_VARIABLES, 
//				null, 
//				XMLResolver, validate, errorBack);
//		}
//		
//		/**
//		 * 原线上数据格式解析XML为视频数据. 
//		 * @param xml
//		 * @return 
//		 */		
//		protected function parseXMLToData(xml:XML):VideoData {
//			var v:VideoData = new VideoData();
//			
//			var item:XML = xml.item[0];
//			Global.settings.pageURL = String(item.Link);
//			
//			Global.settings.title = String(item.Flvtitle);
//			v.aClass = String(item.bclass);
//			v.bClass = String(item.sclass);
//			v.totalTime = int(item.Alltime);
//			v.connectionURL = null;
//			
//			v.useP2P = Global.settings.useP2P;
//			v.isStream = Global.settings.isStream;
//			
//			var len:int = item.Allnumber;
//			if (len > 1) {
//				var streams:Array = [];
//				var md5:Array = String(item.MD5).split("||");
//				var md5_1:Array = String(item.MD51).split("||");
//				var md5_2:Array = String(item.MD52).split("||");
//				var splitedLen:Array = String(item.Splittime).split(",");
//				for (var i:int = 0; i < len; i ++) {
//					streams.push({"time":splitedLen[i], "streamNames":
//						[md5[i], md5_1[i], md5_2[i]]});
//				}
//				//				v.streams = streams;
//			} else {
//				v.streamName = String(item.MD5);
//			}
//			
//			return v;
//		}
		
		protected function parseJSONToData1(json:Object):FileVideoData {
			var v:FileVideoData = null;
			
			if (json.success == 1) {
				Context.variables["url"] = json.data.pageUrl;
				
//				v = Global.videoData as FileVideoData;
				v = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data as FileVideoData;
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
				var error:Object = PlayerErrors.packUpError(PlayerErrors.VIDEO_DISPATCH_URL_RETRIVE_FAIL);
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.ON_PLAYER_ERROR, error);
//				Global.eventManager.send(PlayerEvents.ON_PLAYER_ERROR, error);
			}
			
			return v;
		}
		
		private function validate(data:Object):Boolean
		{
			if (data && data.hasOwnProperty("success")) {
//				if (data.success == 1 && (data.data.playUrl as Array).length > 0) {
				if (data.success == 1) {
					//成功
					return true;
				} else if (data.success == 0 && data.hasOwnProperty("data") && data.data.hasOwnProperty("code") && data.data["code"] != "" && data.data.hasOwnProperty("msg") && data.data["msg"] != ""){
					return true;
				}
			}
			return false;
		}
		
		override public function reqForMore(id:String, callback:Function):void
		{
			var _moreInfo:Array = null;
			var _moreLabel:String = "";
			var _moreUrl:String = "";
			var url:String = getMoreUrl(id);
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				url, 
				LoaderProxyOption.FORMAT_JSON, 
				LoaderProxyOption.TYPE_FILE_LOADER, 
				function parseJSONToData(json:Object):void 
				{
					_moreInfo = new Array();
					if(json.hasOwnProperty("success") && json["success"] == 1)
					{
						if(json.hasOwnProperty("data") && json["data"].hasOwnProperty("content"))
						{
							var tempObj:Object = json["data"]["content"];
							//重新对返回数据进行排序，按照返回的顺序显示
							var tempArr:Array = new Array();
							for (var it:String in tempObj) {
								tempArr.push(it as Number);
							}
							tempArr.sort(sortOnID);
							for (var i:int = 0; i < tempArr.length; i++) {
								var itemData:BackRecItemData = new BackRecItemData(tempArr[i], tempObj[tempArr[i]]);
								_moreInfo.push(itemData);
							}
						}
						if(json.hasOwnProperty("data") && json["data"].hasOwnProperty("moreUrl"))
						{
							for(var item2:Object in json["data"]["moreUrl"])
							{
								_moreLabel = String(item2);
								_moreUrl = json["data"]["moreUrl"][_moreLabel];
							}
						}
						callback.call(null, _moreInfo, _moreLabel, _moreUrl);
					}
				}
			);
			option.manuallyResolver = JSONResolver;
			loader.load(option);
		}
		
		private function sortOnID(a:String, b:String):Number {
			var aN:Number = Number(a);
			var bN:Number = Number(b);
			if (aN > bN) {
				return 1;
			} else {
				return -1
			}
			return 0;
		}
		
		/**
		 * 获取后推地址url
		 */		
		protected function getMoreUrl(id:String):String {
			return MOREPATH_URL.replace("{0}", id);
		}
		
		/**
		 * 发送播放记录 
		 */		
		public function sendPlayRecord():void {
//			var videoData:IVideoData = Global.videoData;
			var videoData:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			var isplayed:int = (videoData.playedTime) > (videoData.totalTime - 10) ? 1 : 0;
			var time:int =videoData.playedTime;
			var v:URLVariables = new URLVariables(
//				"uid=" + Global.settings.userID + 
				"uid=" + Context.getContext(ContextEnum.SETTING).userID + 
				"&videoid=" + videoData["cid"] + 
				"&playtime=" + time + 
				"&isplayed=" + isplayed);
			this.packupLoader(PLAY_RECORD_URL, null, LoaderProxyOption.FORMAT_VARIABLES, v, null, sendPlayRecordvalidate);
			Debugger.log(Debugger.INFO, "发送记录到服务器:", " time:" +　time);
		}
		
		public function addPlayNumber(cid:String):void
		{
			this.packupLoader(getAddPlayNumberUrl(cid), null,  LoaderProxyOption.FORMAT_VARIABLES, null, null, addPlayNumberValidate);
		}
		
		protected function getAddPlayNumberUrl(cid:String):String {
			return ADD_PALY_NULBER_URL.replace("{0}", cid);
		}
		
		public function checkPW(cid:String, pw:String, callBack:Function):void
		{
			this.packupLoader(
				CHECK_PASSWORD_URL.replace("{0}", cid) + pw, 
				function (data:Object):void
				{
					callBack(data);
				},
				LoaderProxyOption.FORMAT_JSON, null, null, pwValidate);
		}
		
		private function pwValidate(data:Object):Boolean
		{
			if (data && data.hasOwnProperty("success")) {
				return true;
			}
			return false;
		}
		
		private function sendPlayRecordvalidate(data:Object):Boolean
		{
			if (data && data.hasOwnProperty("status")) {
				return true;
			}
			return false;
		}
		
		private function addPlayNumberValidate(data:Object):Boolean
		{
			if (data && data.hasOwnProperty("success")) {
				if(data["success"] == 1)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			return false;
		}
		
	}
}