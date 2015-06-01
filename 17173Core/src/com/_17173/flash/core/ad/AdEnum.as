package com._17173.flash.core.ad
{
	import com._17173.flash.core.util.Util;
/**
 * 不同的广告种类
 * 不同的广告素材类型
 */
	public class AdEnum
	{
		
		private static const VIDEO:Array = ["mp4", "flv"];
		private static const SWF:Array = ["swf"];
		private static const IMAGE:Array = ["png", "jpg", "jpeg"];
		
		/**
		 * 大前贴 
		 */		
		public static const A1:String = "A1";
		/**
		 * 前贴 
		 */		
		public static const A2:String = "A2";
		/**
		 * 暂停 
		 */		
		public static const A3:String = "A3";
		/**
		 * 下底 
		 */		
		public static const A4:String = "A4";
		/**
		 * 挂角 
		 */		
		public static const A5:String = "A5";
		/**
		 * 闪播广告 
		 */		
		public static const A6:String = "A6";
		
		/**
		 * swf类型 
		 */		
		public static const EXTENSION_SWF:int = 0;
		/**
		 * 视频文件类型如flv和mp4等 
		 */		
		public static const EXTENSION_VIDEO:int = 1;
		/**
		 * 图片类型如png和jpg等,不支持gif 
		 */		
		public static const EXTENSION_IMAGE:int = 2;
		
		/**
		 * 验证url所指定的文件格式,通过解析url进行判定.
		 * 如果url指向的不是文件而是请求,则返回-1;
		 * 如果url不是现在所支持的类型,则返回-1;
		 * 否则返回对应的类型. 
		 */		
		public static function validateExtension(url:String):int {
			var splits:Array = url.split("?");
			if (splits && splits.length) {
				var uri:String = splits[0];
				var uris:Array = uri.split("/");
				if (uris && uris.length) {
					var fileOrDomain:String = uris[uris.length - 1];
					if (Util.validateStr(fileOrDomain)) {
						var extensions:Array = fileOrDomain.split(".");
						var ext:String = extensions[extensions.length - 1];
						if (IMAGE.indexOf(ext) > -1) {
							return 2;
						} else if (VIDEO.indexOf(ext) > -1) {
							return 1;
						} else {
							return 0;
						}
					}
				}
			}
			return 0;
		}
	}
}
