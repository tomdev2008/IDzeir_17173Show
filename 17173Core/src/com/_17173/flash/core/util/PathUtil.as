package com._17173.flash.core.util
{
	/**
	 * 路径解析类
	 * 用来提供一些通用的路径解析逻辑
	 * 	相对/绝对判断
	 *  路径拼接
	 *   
	 * @author 庆峰
	 */	
	public class PathUtil
	{
		
		public static function isHttp(path:String):Boolean {
			return matchPathType(path, ["http", "https"]);
		}
		
		public static function isRtmp(path:String):Boolean {
			return matchPathType(path, ["rtmp"]);
		}
		
		public static function isFtp(path:String):Boolean {
			return matchPathType(path, ["ftp"]);
		}
		
		public static function isLocal(path:String):Boolean {
			return matchPathType(path, ["file"]);
		}
		
		/**
		 * 解析路径的类型
		 *  
		 * @param path
		 * @return http | https | rtmp | ftp | file
		 */		
		public static function resolvePathType(path:String):String {
			var split:Array = path.split("://");
			if (split.length > 0) {
				var type:String = split[0];
				return type.toLowerCase();
			}
			return "";
		}
		
		/**
		 * 以base作为基础路径,解析后面的相对路径.
		 * 
		 * 	相对路径里, ".."代表上层目录,不支持".".
		 * 
		 * 比如传入 ("http://v.17173.com", "live")
		 * 则返回 "http://v.17173.com/live"
		 * 
		 * @param base 基础路径
		 * @param paths 相对路径
		 */		
		public static function resolve(base:String, path:String):String {
			var bi:Boolean = base.lastIndexOf("/") == (base.length - 1);
			var pi:Boolean = path.indexOf("/") == 0;
			if (bi && pi) {
				base = base.substr(0, base.length - 1);
			} else if (!bi && !pi) {
				base = base + "/";
			}
			return base + path; 
			
			//另一个更完整的实现,目前还没有完美的方案
			//需要考虑不同情况下的兼容性,最大限度的提供精准实现
			var resolved:String = base;
			if (path) {
				var index:int = base.search("://");
				if (index > -1) {
					var type:String = base.substring(0, index);
					var ba:Array = base.substring(index, base.length - 1).split("/");
					var pa:Array = path.split("/");
					var result:Array = ba.concat(pa);
					resolved = type + "://" + result.join("/");
				}
			}
			return resolved;
		}
		
		private static function matchPathType(path:String, filter:Array):Boolean {
			var type:String = resolvePathType(path);
			return filter.indexOf(type) != -1;
		}
		
	}
}