package com._17173.flash.show.base.module.stat.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.SystemUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.system.Security;
	
	public class StatUtil
	{
		
		private static var _markInited:Boolean = false;
		private static var _seqInited:Boolean = false;
		private static var _mark:String = "";
		private static var _session:String = "";
		private static var _seq:String = "";
		private static var _channel:String = "";
		private static var _markIsLoad:Boolean;//用户唯一标示是否在请求中
		
		private static var USER_MARK_URL:String = "http://v.17173.com/live/cookie/setCookie.action";
		
		public function StatUtil()
		{
		}
		
		public static function get userMark():String {
			if (_mark == "" && !_markIsLoad) {
				getMarkByServicex();
			}
			return _mark;
		}
		
		public static function get session():String {
			createMarkAndSession();
			return _session;
		}
		
		public static function initUserMark():void {
			var cookie:Cookies = new Cookies("shared", "/");
			if (cookie && cookie.get("userMark")) {
				var d:Array = cookie.get("userMark") as Array;
				if (d && d.length) {
					_mark = d[0];
				}
			}
			if (_mark == "") {
				getMarkByServicex();
			}
		}
		
		protected static function getMarkByServicex():void {
			if (_markIsLoad) {
				return;
			}
			_markIsLoad = true;
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(
				USER_MARK_URL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onGetDataSucess, onGetDataFault);
			loader.load(loaderOption);
			
			function onGetDataSucess(data:Object):void {
				if (data.hasOwnProperty("obj") && data["obj"].hasOwnProperty("unique") && data["obj"]["unique"].hasOwnProperty("value")) {
					_markInited = true;
					_mark = data["obj"]["unique"]["value"];
					var cookie:Cookies = new Cookies("shared", "/");
					cookie.put("userMark", [_mark], true);
					cookie.close();
				} else {
					onGetDataFault(null);
				}
			}
			
			function onGetDataFault(data:Object):void {
				_markInited = true;
				//没有则创建
				_mark = createTimeStamp();
			}
		}
		
		protected static function createMarkAndSession():void {
			_session = createTimeStamp() + "_" + String(int(Math.random() * 10000));
		}
		
		public static function get seq():String {
			getKeysFromBrowserCookie();
			return _seq;
		}
		
		public static function get channel():String {
			getKeysFromBrowserCookie();
			return _channel;
		}
		
		private static var _is_first:String="1";
		public static function get isFirst():String
		{
			return _is_first;
		}
		
		/**
		 * 从浏览器cookie里获取用户唯一标示和渠道id 
		 */		
		protected static function getKeysFromBrowserCookie():void {
			if (_seqInited) return;
			
			if (JSBridge.enabled) {
				_seqInited = true;
				var cookie:String = JSBridge.addCall("function () { return document.cookie; }", null, "");
				Debugger.log(Debugger.INFO, "[ST]","cooike: "+cookie);
				if (Util.validateStr(cookie)) {
					var keys:Array = cookie.split(";");
					for each (var pair:Object in keys) 
					{
						var pairs:Array = pair.split("=");
						if (pairs && pairs.length == 2) {
							var k:String = Util.trimStr(pairs[0]);
							if (k == "channel")
							{
								_channel = pairs[1];
							}
							else if (k == "show_17173_unique")
							{
								_seq = pairs[1];
							}else if(k == "is_first")
							{
								if(pairs[1] == "0")
									_is_first = "0";
							}
						}
					}
				}
			}
		}
		
		/**
		 * 以时间戳作为mark 
		 * @return 
		 */		
		protected static function createTimeStamp():String {
			return String(new Date().time);
		}
		
		public static function get lang():String {
			return "zh_cn";
		}
		
		public static function get os():String {
			return SystemUtil.system["osShort"];
		}
		
		public static function get browser():String {
			return parseNullToString(SystemUtil.browser["nameShort"]);
		}
		
		public static function get flashVer():String {
			return SystemUtil.flash["versionShort"];
		}
		
		public static function get resolution():String {
			return SystemUtil.system["resolution"];
		}
		
		public static function get playerVer():String {
			if (Context.variables.hasOwnProperty("vn") && Context.variables["vn"]) {
				//点直播用vn参数
				return Context.variables["vn"];
			} else {
				//秀场用version参数
				return Context.variables["version"];
			}
		}
		
		public static function get playerType():String {
			return Context.variables["type"];
		}
		
		public static function get userID():String {
			return Context.variables["userId"] ? Context.variables["userId"] : "";
		}
		
		
		public static function get refPage():String {
//			return Context.variables["refPage"];
//			return encodeURIComponent(Context.variables["refPage"]);
			var url:String = encodeURIComponent(Util.refPage);
			if (url == "null") {
				url = encodeURIComponent(Context.variables["ref"]);
			}
			if (url && url != "" && url != "null") {
				return url;
			} else {
				return encodeURIComponent(Security.pageDomain);
			}
//			var v:URLVariables = new URLVariables("url=" + Context.variables["refPage"]);
//			return v.toString().replace("url=", "");
		}
		
		public static function get cid():String {
			return Context.variables["cid"];
		}
		
		/**
		 * 目前只有直播企业版会有这个参数
		 */		
		public static function get playerChannel():String {
			var temp:String = "";
			if (Context.variables.hasOwnProperty("redirectVid") && Context.variables["redirectVid"]) {
				temp = Context.variables["redirectVid"];
			}
			return temp;
		}
		
		private static function parseNullToString(n:String):String {
			if (!n) {
				return "";
			} else {
				return n;
			}
		}
		
	}
}