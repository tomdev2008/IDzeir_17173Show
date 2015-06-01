package  com._17173.flash.show.base.module.ad.base
{
	import com._17173.flash.core.util.Util;

	public class AdPlayerType
	{
		
		private static const VIDEOS:Array = ["mp4", "flv"];
		private static const SWFS:Array = ["swf"];
		private static const IMAGES:Array = ["png", "jpg", "jpeg"];
		
		/**
		 * swf类型 
		 */		
		public static const SWF:int = 0;
		/**
		 * 视频文件类型如flv和mp4等 
		 */		
		public static const VIDEO:int = 1;
		/**
		 * 图片类型如png和jpg等,不支持gif 
		 */		
		public static const IMAGE:int = 2;
		/**
		 * 百度广告也算一种特殊情况 
		 */		
		public static const BAIDU:int = 3;
		
		/**
		 * 验证url所指定的文件格式,通过解析url进行判定.
		 * 如果url指向的不是文件而是请求,则返回-1;
		 * 如果url不是现在所支持的类型,则返回-1;
		 * 否则返回对应的类型. 
		 */		
		public static function validateExtension(url:String):int {
			if (url == "baidu") return BAIDU;
			
			var splits:Array = url.split("?");
			if (splits && splits.length) {
				var uri:String = splits[0];
				var uris:Array = uri.split("/");
				if (uris && uris.length) {
					var fileOrDomain:String = uris[uris.length - 1];
					if (Util.validateStr(fileOrDomain)) {
						var extensions:Array = fileOrDomain.split(".");
						var ext:String = extensions[extensions.length - 1];
						if (IMAGES.indexOf(ext) > -1) {
							return IMAGE;
						} else if (VIDEOS.indexOf(ext) > -1) {
							return VIDEO;
						} else {
							return SWF;
						}
					}
				}
			}
			return IMAGE;
		}
		
	}
}