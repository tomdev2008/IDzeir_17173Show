package com._17173.flash.core.util
{
	import flash.system.Capabilities;

	public class SystemUtil
	{
		
		private static var _browser:Object = null;
		private static var _flash:Object = null;
		private static var _system:Object = null;
		
		public function SystemUtil()
		{
		}
		
		/**
		 * 浏览器信息
		 * 
		 * 返回的object为空或者提供两个属性: 
		 * 	name 完整的浏览器名称
		 *  nameShort 缩写的两个字符的小写浏览器名称
		 *  
		 * @return 
		 */		
		public static function get browser():Object {
			if (_browser == null) {
				if (!JSBridge.enabled) return {};
				
				_browser = {};
				
				var def:Array = [
					[new RegExp("PaleMoon", "g"), 'PaleMoon', 'pm'],
					[new RegExp("Fennec", "g"), "Fennec", 'fn'],
					[new RegExp("Flock", "g"), "Flock", 'fk'],
					[new RegExp("RockMelt", "g"), "RockMelt", 'rm'],
					[new RegExp("Navigator", "g"), "Navigator", 'ng'],
					[new RegExp("MyIBrow", "g"), "MyIBrow", 'mb'],
					[new RegExp("CrMo|CriOS", "g"), "CrMo|CriOS", 'cm'],
					[new RegExp("QQBrowser|TencentTraveler", "g"), "QQBrowser|TencentTraveler", 'qq'],
					[new RegExp("Maxthon", "g"), "Maxthon", 'ma'],
					[new RegExp("360SE", "g"), "360SE", '36'],
					[new RegExp("360EE", "g"), "360EE", '36'],
					[new RegExp("360browser", "g"), "360browser", '36'],
					[new RegExp("Theworld", "g"), "Theworld", 'th'],
					[new RegExp("SE", "g"), "SE", 'se'],
					[new RegExp("LBBROWSER", "g"), "LBBROWSER", 'lb'],
					[new RegExp("Lynx", "g"), "Lynx", 'ln'],
					[new RegExp("CoolNovo", "g"), "CoolNovo", 'cl'],
					[new RegExp("TaoBrowser", "g"), "TaoBrowser", 'tb'],
					[new RegExp("Arora", "g"), "Arora", 'aa'],
					[new RegExp("Epiphany", "g"), "Epiphany", 'ep'],
					[new RegExp("Links", "g"), "Links", 'ls'],
					[new RegExp("Camino", "g"), "Camino", 'cmn'],
					[new RegExp("Konqueror", "g"), "Konqueror", 'kq'],
					[new RegExp("Avant Browser", "g"), "Avant Browser", 'ab'],
					[new RegExp("ELinks", "g"), "ELinks", 'el'],
					[new RegExp("Minimo", "g"), "Minimo", 'mnm'],
					[new RegExp("baiduie8|baidubrowser|FlyFlow|BIDUBrowser", "g"), "Baidu", 'bd'],
					[new RegExp("UCBrowser|UC Browser|UCWEB|UC AppleWebKit", "g"), "UC", 'uc'],
					[new RegExp("OneBrowser", "g"), "OneBrowser", 'ob'],
					[new RegExp("iBrowser\/Mini", "g"), "IBrowser Mini", 'im'],
					[new RegExp("Nokia|BrowserNG|NokiaBrowser|Series60|S40OviBrowser", "g"), 'nk'],
					[new RegExp("BB10|PlayBook|Black[bB]erry", "g"), 'bb'],
					[new RegExp("Blazer", "g"), "Blazer", 'bz'],
					[new RegExp("Qt", "g"), "Qt", 'qt'],
					[new RegExp("NetFront", "g"), "NetFront", 'nf'],
					[new RegExp("Silk", "g"), "Silk", 'sk'],
					[new RegExp("Teleca", "g"), "Teleca", 'tc'],
					[new RegExp("Froyo", "g"), "Froyo", 'fy'],
					[new RegExp("iPhone|iPad|iPod", "g"), "iPhone|iPad|iPod", 'ms'],
					[new RegExp("Android", "g"), "Android", 'ad'],
					[new RegExp("MSIE 9", "g"), "MSIE 9", 'ie9'],
					[new RegExp("MSIE 8", "g"), "MSIE 8", 'ie8'],
					[new RegExp("MSIE 7", "g"), "MSIE 7", 'ie7'],
					[new RegExp("MSIE 6", "g"), "MSIE 6", 'ie6'],
					[new RegExp("MSIE 10", "g"), "MSIE 10", 'ie10'],
					[new RegExp("rev:11", "g"), "MSIE 11", 'ie11'],
					[new RegExp("Opera Mini", "g"), "Opera Mini", 'opm'],
					[new RegExp("Opera", "g"), "Opera", 'op'],
					[new RegExp("Firefox", "g"), "Firefox", 'ff'],
					[new RegExp("Chrome", "g"), "Chrome", 'ch'],
					[new RegExp("Safari", "g"), "Safari", 'sa'],
					[new RegExp("MSIE", "g"), "MSIE", 'ie'],
				];
				var agent:String = JSBridge.addCall("function(){return navigator.userAgent.toString();}", null, "");
				if(agent) {
					for each (var m:Array in def) {
						if (agent.match(m[0]).length > 0) {
							_browser["name"] = m[1];
							_browser["nameShort"] = m[2];
							break;
						}
					}
				}
			}
			
			return _browser;
		}
		
		/**
		 * Flash信息
		 * 提供如下字段:
		 * 	debugger 是否调试版播放器
		 * 	version 播放器版本
		 * 	version 简写的播放器版本
		 *  
		 * @return 
		 */		
		public static function get flash():Object {
			if (_flash == null) {
				_flash = {};
				//是否debugger版本播放器
				_flash["debugger"] = Capabilities.isDebugger;
				//flashplayer版本号
				_flash["version"] = Capabilities.version;
				var ver:String = Capabilities.version;
				var fp:String = ver.substr(0, 3);
				var arr:Array = ver.substr(4, ver.length).split(",");
				//缩短的flashplayer版本号,如: "WIN-11.8"
				_flash["versionShort"] = fp + "-" + (arr.length > 1 ? arr[0] + "." + arr[1] : arr[0]);
			}
			
			return _flash;
		}
		
		/**
		 * 系统信息
		 * 提供如下字段:
		 * 	os 完整的操作系统名称
		 * 	osShort 简写的操作系统名称
		 * 	dpi 操作系统的dpi
		 * 	resolution 操作系统的分辨率 
		 * 
		 * @return 
		 */		
		public static function get system():Object {
			if (_system == null) {
				_system = {};
				_system["os"] = Capabilities.os;
				_system["osShort"] = Capabilities.os.split(" ")[0];
				_system["language"] = Capabilities.language;
				_system["dpi"] = Capabilities.screenDPI;
				_system["resolution"] = Capabilities.screenResolutionX + "*" + Capabilities.screenResolutionY;
			}
			
			return _system;
		}
		
	}
}