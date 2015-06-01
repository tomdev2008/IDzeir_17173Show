package com._17173.flash.core.stat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	/**
	 * 统计模块 
	 * @author shunia-17173
	 */	
	public class StatManager implements IStatManager
	{
		
		protected static const SDK_VER:String = "1.0.1";
		
		protected var _path:String = "";
		protected var _appkey:String = "";
		protected var _channel:String = "";
		protected var _mark:String = "";
		protected var _session:String = "";
		
		private var _os:String = "";
		private var _browser:String = "";
		
		/**
		 * @param path 统计接口路径
		 * @param appkey 统计接口唯一标示
		 * @param channel 渠道标示
		 */		
		public function StatManager(path:String, appkey:String, channel:String)
		{
			_path = path;
			_appkey = appkey;
			_channel = channel;
			init();
		}
		
		protected function init():void {
			if (Context.variables.hasOwnProperty("userMark") && Util.validateStr(Context.variables["userMark"])) {
				//从参数中取mark
				_mark = Context.variables["userMark"];
			} else {
				//从cookie中取mark
				var cookie:Cookies = new Cookies("shared", "/");
				if (cookie && cookie.get("data")) {
					var d:Array = cookie.get("data") as Array;
					if (d && d.length) {
						_mark = d[0];
					}
				}
				if (!Util.validateStr(_mark)) {
					//没有则创建
					_mark = createTimeStamp();
					cookie.put("data", [_mark], true);
				}
				//用完关掉
				cookie.close();
			}
			
			_session =  createTimeStamp() + "_" + String(int(Math.random() * 10000));
		}
		
		/**
		 * 以时间戳作为mark 
		 * @return 
		 */		
		protected function createTimeStamp():String {
			return String(new Date().time);
		}
		
		/**
		 * 处理操作系统字符串符合统计系统需求 
		 * @return 
		 */		
		protected function get os():String {
			if (Util.validateStr(_os)) return _os;
			
			//如果是windows操作系统,将windows替换为win
			var tempOS:String = Capabilities.os;
			if (tempOS.toLowerCase().indexOf("Windows".toLowerCase()) >= 0) {
				if (tempOS.match(new RegExp("Window CE|Window ME|Windows CEPC|Windows PocketPC|Windows SmartPhone|Windows Mobile", "g")).length != -1) {
					tempOS = tempOS.replace("Windows", "Win");
				}
			} else if (tempOS.toLowerCase().indexOf("Lunix".toLowerCase()) >= 0) {
				tempOS = "Linux";
			} else if (tempOS.toLowerCase().indexOf("Unix".toLowerCase()) >= 0) {
				tempOS = "Unix";
			} else if (tempOS.toLowerCase().indexOf("Mac".toLowerCase()) >= 0) {
				tempOS = "Mac OS";
			}
			_os = tempOS;
			return _os;
		}
		
		protected function get browser():String {
			if (Util.validateStr(_browser)) return _browser;
			
			var def:Array = [
				[new RegExp("PaleMoon", "g"), 'pm'],
				[new RegExp("Fennec", "g"), 'fn'],
				[new RegExp("Flock", "g"), 'fk'],
				[new RegExp("RockMelt", "g"), 'rm'],
				[new RegExp("Navigator", "g"), 'ng'],
				[new RegExp("MyIBrow", "g"), 'mb'],
				[new RegExp("CrMo|CriOS", "g"), 'cm'],
				[new RegExp("QQBrowser|TencentTraveler", "g"), 'qq'],
				[new RegExp("Maxthon", "g"), 'ma'],
				[new RegExp("360SE|360EE|360browser", "g"), '36'],
				[new RegExp("Theworld", "g"), 'th'],
				[new RegExp("SE", "g"), 'se'],
				[new RegExp("LBBROWSER", "g"), 'lb'],
				[new RegExp("Lynx", "g"), 'ln'],
				[new RegExp("CoolNovo", "g"), 'cl'],
				[new RegExp("TaoBrowser", "g"), 'tb'],
				[new RegExp("Arora", "g"), 'aa'],
				[new RegExp("Epiphany", "g"), 'ep'],
				[new RegExp("Links", "g"), 'ls'],
				[new RegExp("Camino", "g"), 'cmn'],
				[new RegExp("Konqueror", "g"), 'kq'],
				[new RegExp("Avant Browser", "g"), 'ab'],
				[new RegExp("ELinks", "g"), 'el'],
				[new RegExp("Minimo", "g"), 'mnm'],
				[new RegExp("baiduie8|baidubrowser|FlyFlow|BIDUBrowser", "g"), 'bd'],
				[new RegExp("UCBrowser|UC Browser|UCWEB|UC AppleWebKit", "g"), 'uc'],
				[new RegExp("OneBrowser", "g"), 'ob'],
				[new RegExp("iBrowser\/Mini", "g"), 'im'],
				[new RegExp("Nokia|BrowserNG|NokiaBrowser|Series60|S40OviBrowser", "g"), 'nk'],
				[new RegExp("BB10|PlayBook|Black[bB]erry", "g"), 'bb'],
				[new RegExp("Blazer", "g"), 'bz'],
				[new RegExp("Qt", "g"), 'qt'],
				[new RegExp("NetFront", "g"), 'nf'],
				[new RegExp("Silk", "g"), 'sk'],
				[new RegExp("Teleca", "g"), 'tc'],
				[new RegExp("Froyo", "g"), 'fy'],
				[new RegExp("iPhone|iPad|iPod", "g"), 'ms'],
				[new RegExp("Android", "g"), 'ad'],
				[new RegExp("MSIE 9", "g"), 'ie9'],
				[new RegExp("MSIE 8", "g"), 'ie8'],
				[new RegExp("MSIE 7", "g"), 'ie7'],
				[new RegExp("MSIE 6", "g"), 'ie6'],
				[new RegExp("MSIE 10", "g"), 'ie10'],
				[new RegExp("Opera Mini", "g"), 'opm'],
				[new RegExp("Opera", "g"), 'op'],
				[new RegExp("Firefox", "g"), 'ff'],
				[new RegExp("Chrome", "g"), 'ch'],
				[new RegExp("Safari", "g"), 'sa'],
				[new RegExp("rev:11", "g"), 'ie11'],
				[new RegExp("MSIE", "g"), 'ie']
			];
			var agent:String = JSBridge.addCall("function(){return navigator.userAgent.toString();}", null, "");
			if(agent)
			{
				for each (var m:Array in def) {
					if (m && m[0] && m[0] is RegExp) {
						if (agent.match(m[0]).length > 0) {
							_browser = m[1];
							break;
						}
					}
				}
			}
			return _browser;
		}
		
		public function stat(data:Object = null):void {
			var s:String = "?appkey=" + _appkey + "&channel=" + _channel + "&cookie_mark=" + _mark + "&sessionid=" + _session + "&";
			if (data) {
				for (var key:String in data) {
					s += (key + "=" + data[key] + "&");
				}
			}
			s += "t=" + new Date().time;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(_path + s));
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		protected function onError(event:Event):void{
			
		}
		
	}
}