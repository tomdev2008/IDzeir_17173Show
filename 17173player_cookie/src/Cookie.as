package
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.debug.DebuggerOutput_console;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 与js通讯作为中转使用. 
	 * @author shunia-17173
	 */	
	[SWF(width="1", height="1")]
	public class Cookie extends StageIniator
	{
		
		private var _cookie:Cookies = null;
		private var _name:String = null;
		
		public function Cookie()
		{
			super(true);
		}
		
		override protected function init():void {
			Debugger.output = new DebuggerOutput_console();
			Debugger.source = "Cookie";
//			Debugger.log(Debugger.INFO, "[Cookie]", "version: 1.1.2");
			
			JSBridge.enabled = true;
			JSBridge.addCall("init", null, null, onCookieInit, true);
			JSBridge.addCall("set", null, null, onSetCookie, true);
			JSBridge.addCall("get", null, null, onGetCookie, true);
			JSBridge.addCall("getAll", null, null, onGetAllCookie, true);
			JSBridge.addCall("clear", null, null, onClearCookie, true); 
			JSBridge.addCall("clearAll", null, null, onClearAllCookie, true);
			
			//通知js,flash已经就绪
			var interval:uint = setInterval(function ():void {
				clearInterval(interval);
//				Debugger.log(Debugger.INFO, "[Cookie]", "初始化成功,通知js可以开始初始化");
				JSBridge.addCall("onCookieReady");
			}, 200);
		}
		
		private function onGetAllCookie():Object {
			reCheckCookie();
			return _cookie.getAll();
		}
		
		private function onClearAllCookie():Boolean {
			reCheckCookie();
			_cookie.clearAll();
			return true;
		}
		
		private function onClearCookie(key:String):Boolean {
			try {
				reCheckCookie();
				_cookie.clear(key);
				return true;
			} catch (e:Error) {
				return false;
			}
		}
		
		private function onGetCookie(key:String):* {
			reCheckCookie();
			return _cookie.get(key);
		}
		
		/**
		 * 检查当前cookie状态
		 */
		private function reCheckCookie():void
		{
			if(_cookie == null)
			{
				_cookie = new Cookies(name, "/");
			}
		}
		
		private function onSetCookie(key:String, value:*):Boolean {
//			Debugger.log(Debugger.INFO, "[Cookie]", "onSetCookie", key, value); 
			reCheckCookie();
			try {
//				Debugger.log(Debugger.INFO, "[Cookie]", "true");
				_cookie.put(key, value, true, onCookieSuccess, onCookieFailed);  
				return true;
			} catch (e:Error) {
//				Debugger.log(Debugger.INFO, "[Cookie]", "false"+e.message);
				return false;
			}
		} 
		
		private function onCookieSuccess():void {
			_cookie.close();
			_cookie = null; 
			JSBridge.addCall("onFLCookieSaved", true);
		}
		
		private function onCookieFailed():void {
			JSBridge.addCall("onFLCookieSaved", false);
		}
		
		private function onCookieInit(name:String):Boolean {
			try {
				if (!_cookie) {
//					Debugger.log(Debugger.INFO, "[Cookie]", "cookie init success");
					_cookie = new Cookies(name, "/");
				} else {
//					Debugger.log(Debugger.INFO, "[Cookie]", "cookie already exists");
				}
				_name = name;  
				return true;
			} catch (e:Error) {
				return false;
			}
		}
		
	}
}