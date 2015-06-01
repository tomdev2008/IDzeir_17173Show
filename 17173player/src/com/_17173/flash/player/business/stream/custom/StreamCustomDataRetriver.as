package com._17173.flash.player.business.stream.custom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.CustomPlayerParamlize;
	import com._17173.flash.player.business.stream.StreamDataRetriver;

	/**
	 * 直播ui模块解析
	 * m1:17173Logo
	 * m2:合作Logo
	 * m3:水印
	 * m4:顶部搜索
	 * m5:播主房间
	 * m6:更多直播
	 * m7:弹幕
	 * m8:送礼 
	 * m9:分享
	 * m10:前贴
	 * m11:暂停
	 * m12:真全屏
	 * m13:假全屏
	 * m14:视频标题
	 * m15:后推
	 * m16:竞猜
	 * m17:秀场推广位
	 * @author 安庆航
	 */	
	public class StreamCustomDataRetriver extends StreamDataRetriver
	{
		
		private static const GET_CONFIG:String = "http://v.17173.com/live/player/config.action";
		
		private static const GET_CID:String = "http://v.17173.com/live/l_jsonData.action";
		
		private static const GET_TOKEN:String = "http://v.17173.com/live/token/create.action";
		
		/**
		 * 17173logo
		 */		
		public static const M1:String = "m1";
		/**
		 * 合作Logo
		 */		
		public static const M2:String = "m2";
		/**
		 * 水印 
		 */		
		public static const M3:String = "m3";
		/**
		 * 顶部搜索
		 */		
		public static const M4:String = "m4";
		/**
		 * 播主房间
		 */		
		public static const M5:String = "m5";
		/**
		 * 更多
		 */		
		public static const M6:String = "m6";
		/**
		 * 弹幕 
		 */		
		public static const M7:String = "m7";
		/**
		 * 送礼 
		 */		
		public static const M8:String = "m8";
		/**
		 * 分享 
		 */		
		public static const M9:String = "m9";
		/**
		 * 前贴广告
		 */		
		public static const M10:String = "m10";
		/**
		 * 暂停广告
		 */		
		public static const M11:String = "m11";
		/**
		 * 真全屏
		 */		
		public static const M12:String = "m12";
		/**
		 * 回链全屏
		 */		
		public static const M13:String = "m13";
		/**
		 * 视频标题
		 */		
		public static const M14:String = "m14";
		/**
		 * 后推
		 */		
		public static const M15:String = "m15";
		/**
		 * 竞猜
		 */		
		public static const M16:String = "m16";
		/**
		 * 秀场推广位
		 */		
		public static const M17:String = "m17";
		
		public function StreamCustomDataRetriver() {
			super();
		}
		
		/**
		 * 获取自定义功能配置
		 *  
		 * @param onSuccess
		 * @param onFail
		 */		
		public function getConfig(onSuccess:Function, onFail:Function = null):void {
			Debugger.log(Debugger.INFO, "[uiModule]", "getConfig");
			var ref:String = Context.variables["refPage"];
//			ref = "bssl-178.com.cn";
			if (Util.validateStr(ref) == false) {
				var url:String = Context.stage.loaderInfo.loaderURL;
				var arr:Array = url.split("referer=");
				if (arr.length > 1 && Util.validateStr(arr[1])) {
					ref = arr[1];
				}
			}
			var u:String = GET_CONFIG + "?user_url=" + ref + "&";
			var r:Function = function (data:Object):void {
				Debugger.log(Debugger.INFO, "[uiModule]", "getConfig 成功");
				if (validateResult(data)) {
					onSuccess(resolveConfig(data.obj));
				}
			};
			var fail:Function = function (data:Object):void {
				Debugger.log(Debugger.INFO, "[uiModule]", "getConfig 失败");
				onFail(resolveConfig(data ? data.obj : null));
			}
			packupLoader(u, r, LoaderProxyOption.FORMAT_VARIABLES, null, null, null, fail);
		}
		
		/**
		 * 获取视频id
		 *  
		 * @param roomID
		 * @param onSuccess
		 * @param onFail
		 */		
		public function getCID(roomID:String, onSuccess:Function, onFail:Function = null):void {
			var u:String = GET_CID + "?liveRoomId=" + roomID + "&";
			packupLoader(u, function (data:Object):void {
				if (validateResult(data)) {
					onSuccess(data.obj);
				}
			}, LoaderProxyOption.FORMAT_VARIABLES, null, null, null, onFail);
		}
		
		/**
		 * 获取聊天token
		 *  
		 * @param roomID
		 * @param uid
		 * @param onSuccess
		 * @param onFail
		 */		
		public function getToken(roomID:String, uid:String, onSuccess:Function, onFail:Function = null):void {
			var u:String = GET_TOKEN + 
				"?rId=" + roomID + 
				"&userId=" + uid + 
				"&type=" + Context.variables["redirectFrom"] + 
				"&vid=" + Context.variables["redirectVid"] + 
				"&";
			packupLoader(u, function (data:Object):void {
				if (validateResult(data)) {
					onSuccess(data.obj);
				}
			}, LoaderProxyOption.FORMAT_VARIABLES, null, null, null, onFail);
		}
		
		/**
		 * 解析UImodule
		 * @param value
		 * @return 
		 */		
		private static function resolveConfig(value:Object):Object {
			//先解渠道号
			if (Util.validateObj(value, "cnum")) {
				_("redirectVid", value.cnum.cnum);
			}
			// 解析flashvars参数或者请求参数
			var re:Object = CustomPlayerParamlize.resolve(
				(value && value.hasOwnProperty("data")) ? value["data"] : null);
			_("UIModuleData", re);
			_("backFullscreen", Util.validateObj(re, M13) ? re[M13] : true);
			return re;
			
			if (Util.validateObj(value, "data")) {
				value = value.data;
				if (Util.validateObj(value, M1) && Util.validateObj(value[M1], "visible")) {
					re.m1 = value[M1]["visible"];
				}
				if (Util.validateObj(value, M2) && Util.validateObj(value[M2], "visible")) {
					re.m2 = value[M2]["visible"];
					
					if (Util.validateObj(value[M2], "url")) {
						re.otherLogo = value[M2]["url"];
					}
					if (Util.validateObj(value[M2], "j")) {
						re.j = value[M2]["j"];
					}
				}
				if (Util.validateObj(value, M3) && Util.validateObj(value[M3], "visible")) {
					re.m3 = value[M3]["visible"];
				}
				if (Util.validateObj(value, M4) && Util.validateObj(value[M4], "visible")) {
					re.m4 = value[M4]["visible"];
				}
				if (Util.validateObj(value, M5) && Util.validateObj(value[M5], "visible")) {
					re.m5 = value[M5]["visible"];
				}
				if (Util.validateObj(value, M6) && Util.validateObj(value[M6], "visible")) {
					re.m6 = value[M6]["visible"];
				}
				if (Util.validateObj(value, M7) && Util.validateObj(value[M7], "visible")) {
					re.m7 = value[M7]["visible"];
				}
				if (Util.validateObj(value, M8) && Util.validateObj(value[M8], "visible")) {
					re.m8 = value[M8]["visible"];
				}
				if (Util.validateObj(value, M9) && Util.validateObj(value[M9], "visible")) {
					re.m9 = value[M9]["visible"];
				}
				if (Util.validateObj(value, M10) && Util.validateObj(value[M10], "visible")) {
					re.m10 = value[M10]["visible"];
				}
				if (Util.validateObj(value, M11) && Util.validateObj(value[M11], "visible")) {
					re.m11 = value[M11]["visible"];
				}
				if (Util.validateObj(value, M12) && Util.validateObj(value[M12], "visible")) {
					re.m12 = value[M12]["visible"];
				}
				if (Util.validateObj(value, M13) && Util.validateObj(value[M13], "visible")) {
					re.m13 = value[M13]["visible"];
				}
				if (Util.validateObj(value, M14) && Util.validateObj(value[M14], "visible")) {
					re.m14 = value[M14]["visible"];
				}
				if (Util.validateObj(value, M15) && Util.validateObj(value[M15], "visible")) {
					re.m15 = value[M15]["visible"];
				}
				if (Util.validateObj(value, M16) && Util.validateObj(value[M16], "visible")) {
					re.m16 = value[M16]["visible"];
				}
				if (Util.validateObj(value, M17) && Util.validateObj(value[M17], "visible")) {
					re.m17 = value[M17]["visible"];
				}
//				re.m2 = true;
//				re.otherLogo = "http://p3.v.17173cdn.com/tfrquk/YWxqaGBf/live/20140729/162316/624e0ce9-237a-4217-87a8-7d3a68c5641b.png";
//				re.m17 = true;
//				re.m12 = true;
//				re.m13 = false;
			} else {
				re.m1 = true;
				re.m2 = false;
				re.otherLogo = "";
//				re.m2 = true;
//				re.otherLogo = "http://p3.v.17173cdn.com/tfrquk/YWxqaGBf/live/20140729/162316/624e0ce9-237a-4217-87a8-7d3a68c5641b.png";
//				re.j = "";
				re.m3 = true;
				re.m4 = true;
				re.m5 = true;
				re.m6 = true;
				re.m7 = true;
				re.m8 = true;
				re.m9 = true;
				re.m10 = true;
				re.m11 = true;
				re.m12 = false;
				re.m13 = true;
				re.m14 = true;
				re.m15 = true;
				re.m16 = false;
				re.m17 = false;
			}
			
			Context.variables["UIModuleData"] = re;
			
			Context.variables["backFullscreen"] = Util.validateObj(re, M13) ? re[M13] : true;
			return re;
		}
	}
}