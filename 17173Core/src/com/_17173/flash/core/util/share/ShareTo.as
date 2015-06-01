package com._17173.flash.core.util.share
{
	import com._17173.flash.core.util.Util;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ShareTo
	{
		
		public static function t(params:ShareToParams):void {
			var vars:URLVariables = new URLVariables();
			var obj:Object = params.toObject();
			for (var key:String in obj) {
				if (obj[key] != null) {
					vars[key] = obj[key];
				}
			}
			var req:URLRequest = new URLRequest(params.baseURL);
			req.data = vars;
			req.method = URLRequestMethod.GET;
//			navigateToURL(req, params.newPage ? "_blank" : "_parent");
			var url:String = params.baseURL;
			if (url.indexOf("?") == -1) {
				url += "?";
			} else {
				url += "&";
			}
			Util.toUrl(url + vars.toString(), params.newPage ? "_blank" : "_parent");
		}
		
	}
}