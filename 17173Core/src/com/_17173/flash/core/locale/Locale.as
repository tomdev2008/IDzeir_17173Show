package com._17173.flash.core.locale
{
	import com._17173.flash.core.context.IContextItem;
	
	import flash.utils.Dictionary;
	
	/**
	 * 国际化语言文字管理类. 
	 * @author Shunia
	 */	
	public class Locale implements IContextItem, ILocale
	{
		
		public static const CONTEXT_NAME:String = "locale";
		
		public static const zh_CN:String = "zh_CN";
		public static const en_US:String = "en_US";
		
		protected var _locale:String = null;
		protected var _content:XML = null;
		
		private var _valueCache:Dictionary = null;
		
		public function Locale()
		{
		}
		
		/**
		 * 当前的国际化环境. 
		 * @return 
		 * 
		 */		
		public function get locale():String {
			return _locale;
		}
		
		/**
		 * 获取配置文件中的国际化文字. 
		 * @param key 配置文件中对应的字段定义.每个字段定义都从属于一个包定义.
		 * @param p 配置文件中的包字段定义.每个字段定义都从属于一个包定义.
		 * @param params 字段替换参数.根据params中的顺序,替换通过key和p取出来的字符串,将其中的"{object}"部分相应的替换成params中的文字.用以实现字段中间匹配数据形成最终结果的情况.
		 * @return 最终的国际化文字.
		 * 
		 */		
		public function get(key:String, p:String = "default", params:Array = null):String {
			//初始化
			var packageCache:Dictionary = null;
			if (!_valueCache.hasOwnProperty(p) || _valueCache[p] == null) {
				packageCache = new Dictionary();
			} else {
				packageCache = _valueCache[p];
			}
			var value:String = null;
			//找到原配的字符串
			if (!packageCache.hasOwnProperty(key)) {
				value = findOutKeyValue(key, p);
				packageCache[key] = value;
			} else {
				value = packageCache[key];
			}
			
			//替换
			if (params && params.length > 0) {
				for each (var param:String in params) {
					if (value.indexOf("{object}") != -1) {
						value = value.replace("{object}", param);
					}
				}
			}
			
			return value;
		}
		
		/**
		 * 从配置文件中取出相应的字符串. 
		 * @param key
		 * @param p
		 * @param params
		 * @return 
		 * 
		 */		
		protected function findOutKeyValue(key:String, p:String):String {
			var value:String = "Can not find key: [" + key + "] in package: [" + p + "] in locale: [" + _locale + "]!";
			var conf:XML = _content.p.(@name == p)[0];
			if (conf && conf.v && conf.v.length() > 0) {
				var v:XML = conf.v.(@k == key)[0];
				if (v) {
					value = v.toString();
				}
			}
			return value;
		}
		
		public function get contextName():String
		{
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void
		{
			_valueCache = new Dictionary();
			_locale = param.locale;
			_content = param.content;
		}
		
	}
}