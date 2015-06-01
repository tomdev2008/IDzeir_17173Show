package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.CustomPlayerParamlize;

	public class FileCustomerDataRetriver extends FileDataRetriver
	{
		private static const GET_CONFIG:String = "http://v.17173.com/live/player/videoConfig.action";
		
		/**
		 * 顶部搜索栏
		 */		
		public static const M1:String = "m1";
		/**
		 * 17173logo
		 */		
		public static const M2:String = "m2";
		/**
		 * 合作logo
		 */		
		public static const M3:String = "m3";
		/**
		 * 侧边栏-评论
		 */		
		public static const M4:String = "m4";
		/**
		 * 侧边栏-移动版
		 */		
		public static const M5:String = "m5";
		/**
		 * 侧边栏-分享
		 */		
		public static const M6:String = "m6";
		/**
		 * 侧边栏-录制
		 */		
		public static const M7:String = "m7";
		/**
		 * 视频标题
		 */		
		public static const M8:String = "m8";
		/**
		 * 后推
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
		 * 秀场推广位
		 */		
		public static const M14:String = "m14";
		/**
		 * 点击播放
		 */		
		public static const M15:String = "m15";
		/**
		 * 自动播放
		 */		
		public static const M16:String = "m16";
		
		public function FileCustomerDataRetriver()
		{
			super();
		}
		
		/**
		 * 获取自定义功能配置
		 *  
		 * @param onSuccess
		 * @param onFail
		 */		
		public function getConfig(onSuccess:Function, onFail:Function = null):void {
			var ref:String = Context.variables["refPage"];
//			ref = "http://v.17173.com/jiong";
			Debugger.log(Debugger.INFO, "[fileOut]","ref:" + ref);
			if (Util.validateStr(ref) == false) {
				Debugger.log(Debugger.INFO, "[fileOut]","从url中获取");
				var url:String = Context.stage.loaderInfo.loaderURL;
				var arr:Array = url.split("referer=");
				if (arr.length > 1 && Util.validateStr(arr[1])) {
					ref = arr[1];
					Debugger.log(Debugger.INFO, "[fileOut]","ref from: loadUrl:" +ref);
				} else {
					if (Util.validateObj(Context.stage.loaderInfo.parameters, "cid")) {
						arr = Context.stage.loaderInfo.parameters["cid"].split("referer=");
						if (arr.length > 1 && Util.validateStr(arr[1])) {
							ref = arr[1];
							Debugger.log(Debugger.INFO, "[fileOut]","ref from par:" +ref);
						}
					}
				}
			}
			if (ref.indexOf("http://") == -1) {
				//后端需要有http头
				ref = "http://" + ref;
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
				onFail(resolveConfig(null));
			}
			packupLoader(u, r, LoaderProxyOption.FORMAT_VARIABLES, null, null, null, fail);
		}
		
		/**
		 * 解析UImodule
		 * @param value
		 * @return 
		 */		
		private static function resolveConfig(value:Object):Object {
			// 解析flashvars参数或者请求参数
			var re:Object = CustomPlayerParamlize.resolve(
				(value && value.hasOwnProperty("data")) ? value["data"] : null);
			_("UIModuleData", re);
			_("backFullscreen", Util.validateObj(re, M13) ? re[M13] : true);
			return re;
			
//			var re:Object = {};
			if (!value) {
				re[M1] = true;
				re[M2] = true;
				re[M3] = false;
//				re["otherLogo"] = "http://pic4.nipic.com/20090824/1982774_174239281260_2.jpg";
//				re["j"] = "v.17173.com";
				re["otherLogo"] = "";
				re["j"] = "";
				re[M4] = true;
				re[M5] = true;
				re[M6] = true;
				re[M7] = true;
				re[M8] = true;
				re[M9] = true;
				re[M10] = true;
				re[M11] = true;
				re[M12] = true;
				re[M13] = false;
				re[M14] = false;
				re[M15] = true;
				re[M16] = false;
				
//				re[M14] = true;
//				re[M15] = true;
//				re[M16] = false;
			} else if (value.hasOwnProperty("data")) {
				value = value.data;
				if (Util.validateObj(value, M1) && Util.validateObj(value[M1], "visible")) {
					re[M1] = value[M1]["visible"];
				}
				if (Util.validateObj(value, M2) && Util.validateObj(value[M2], "visible")) {
					re[M2] = value[M2]["visible"];
				}
				if (Util.validateObj(value, M3) && Util.validateObj(value[M3], "visible")) {
					re[M3] = value[M3]["visible"];
					
					if (Util.validateObj(value[M3], "url")) {
						re["otherLogo"] = value[M3]["url"];
					}
					if (Util.validateObj(value[M3], "j")) {
						re["j"] = value[M3]["j"];
					}
				}
				if (Util.validateObj(value, M4) && Util.validateObj(value[M4], "visible")) {
					re[M4] = value[M4]["visible"];
				}
				if (Util.validateObj(value, M5) && Util.validateObj(value[M5], "visible")) {
					re[M5] = value[M5]["visible"];
				}
				if (Util.validateObj(value, M6) && Util.validateObj(value[M6], "visible")) {
					re[M6] = value[M6]["visible"];
				}
				if (Util.validateObj(value, M7) && Util.validateObj(value[M7], "visible")) {
					re[M7] = value[M7]["visible"];
				}
				if (Util.validateObj(value, M8) && Util.validateObj(value[M8], "visible")) {
					re[M8] = value[M8]["visible"];
				}
				if (Util.validateObj(value, M9) && Util.validateObj(value[M9], "visible")) {
					re[M9] = value[M9]["visible"];
				}
				if (Util.validateObj(value, M10) && Util.validateObj(value[M10], "visible")) {
					re[M10] = value[M10]["visible"];
				}
				if (Util.validateObj(value, M11) && Util.validateObj(value[M11], "visible")) {
					re[M11] = value[M11]["visible"];
				}
				if (Util.validateObj(value, M12) && Util.validateObj(value[M12], "visible")) {
					re[M12] = value[M12]["visible"];
				}
				if (Util.validateObj(value, M13) && Util.validateObj(value[M13], "visible")) {
					re[M13] = value[M13]["visible"];
				}
				if (Util.validateObj(value, M14) && Util.validateObj(value[M14], "visible")) {
					re[M14] = value[M14]["visible"];
				}
				if (Util.validateObj(value, M15) && Util.validateObj(value[M15], "visible")) {
					re[M15] = value[M15]["visible"];
				}
				if (Util.validateObj(value, M16) && Util.validateObj(value[M16], "visible")) {
					re[M16] = value[M16]["visible"];
				}
			}
			Context.variables["UIModuleData"] = re;
			
			Context.variables["backFullscreen"] = Util.validateObj(re, M13) ? re[M13] : true;
			return re;
		}
	}
}