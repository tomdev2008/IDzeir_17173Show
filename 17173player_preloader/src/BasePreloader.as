package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	/**
	 * 负责对播放器文件的加载.
	 * 测速并提供码率.
	 *  
	 * @author shunia.huang
	 */	
	[SWF(backgroundColor="0xFF9900", frameRate="30")]
	public class BasePreloader extends Sprite
	{
		
		protected var _mainSwf:Object = null;
		protected var _conf:Object = null;
		protected var _loader:Loader = null;
		
		public function BasePreloader()
		{
			//检测舞台
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event = null):void {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//准备配置参数
			prepareConfig();
			//从配置参数启动加载
			if (_conf && _conf.hasOwnProperty("url")) {
				startLoad(getFlashUrl() + _conf.url);
			}
		}
		
		protected function prepareConfig():void {
			_conf = {};
			_conf.url = null;
		}
		
		protected function startLoad(url:String):void {
			if (validateStr(url)) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoaded);
				_loader.load(new URLRequest(url), new LoaderContext(true, ApplicationDomain.currentDomain));
			}
		}
		
		protected function onSwfLoaded(event:Event):void {
			_mainSwf = _loader.content;
			_mainSwf["config"] = _conf;
			addChild(_loader.content);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfLoaded);
			_loader.unload();
		}
		
		protected function getFlashUrl():String
		{
			var ref:String = stage.loaderInfo.loaderURL;
			ref = ref.split("?")[0];
			if (validateStr(ref) == false) {
				ref = "";
			} else {
				ref = ref.substring(0, ref.lastIndexOf("/") + 1);
			}
			return ref;
		}
		
		protected function validateStr(s:String):Boolean {
			return s != null && s.replace(" ", "") != "";
		}
	}
}