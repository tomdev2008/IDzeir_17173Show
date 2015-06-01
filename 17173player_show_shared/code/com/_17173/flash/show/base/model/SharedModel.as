package com._17173.flash.show.base.model
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;

	/**
	 * 共享数据层.
	 *  
	 * @author 庆峰
	 */	
	public class SharedModel
	{
		
		private static var _domain:String = null;
		private static var _home:String = null;
		
		/**
		 * 获取当前域.
		 *  
		 * @return 
		 */		
		public static function get domain():String {
			if (!Util.validateStr(_domain)) {
				var d:Object = Context.variables["domainObject"];
				_domain = "http://" + d.portal;
				
				Debugger.log(Debugger.INFO, "[shared]", "当前接口地址： " + _domain);
			}
			return _domain;
		}
		
		/**
		 * 获取跳转首页的链接
		 * 默认情况下同domain 
		 * 
		 * @return 
		 */		
		public static function get home():String {
			if (!Util.validateStr(_home)) {
				var d:Object = Context.variables["domainObject"];
				_home = "http://" + d.portal;
				
				Debugger.log(Debugger.INFO, "[shared]", "当前首页地址： " + _home);
			}
			return _home;
		}
		
		/**
		 * 返回swf发布的版本
		 * */
		public static function get version():String
		{
			var d:Object = Context.variables["domainObject"];
			var swfVersion:String = d["swfVersion"];
			return swfVersion ? swfVersion : String(new Date().time);
		}
		
		/**
		 * 素材目录
		 *  
		 * @return 
		 */		
		public static function get assetsDir():String {
			return "assets/"
		}
		
		/**
		 * UI素材目录
		 *  
		 * @return 
		 */		
		public static function get assetsUIDir():String {
			return assetsDir + "ui/";
		}
		
		/**
		 * 图片素材目录
		 *  
		 * @return 
		 */		
		public static function get assetsImgDir():String {
			return assetsDir + "image/";
		}
		
	}
}