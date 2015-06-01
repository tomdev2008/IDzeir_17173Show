package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * 百度广告加载器
	 *  
	 * @author 庆峰
	 */	
	public class AdPlayer_Baidu_base extends BaseAdPlayer
	{
		
		protected var _time:Number = 0;
		protected var _loader:Loader = null;
		protected var _params:Object = null;
		
		public function AdPlayer_Baidu_base()
		{
			super();
		}
		
		override protected function init():void {
			_params = {};
			_params.channel = getChannel();
			_params.client = getClient();
			_params.url = getUrl();
			
			loadAsset();
		}
		
		protected function loadAsset():void {
			if (!_loader) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.INIT, initBaiduAd);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBaiduLoaded);
			}
			_loader.load(new URLRequest("http://cpro.baidu.com/cpro/ui/baiduLoader_as3.swf"));
			complete(_loader);
		}
		
		override protected function complete(result:Object):void {
			_display = result as DisplayObject;
			Ticker.tick(500, updateTime, 0);
			super.complete(result);
		}
		
		protected function onBaiduLoaded(event:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, initBaiduAd);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, error);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBaiduLoaded);
			resize(_w, _h);
		}
		
		protected function updateTime():void {
			_time += 500;
		}
		
		override public function getTime():Number {
			return _time;
		}
		
		/**
		 * 根据百度的api要求初始化百度广告
		 *  
		 * @param loader
		 */		
		protected function initBaiduAd(e:Object):void {
			var param:Object = initBaiduAdConfig();
			_loader["content"]["requestAdData"](baiduAdCallback, param);
//			
//			complete(loader);
		}
		
		protected function baiduAdCallback():void {
			// override
		}
		
		/**
		 * 初始化百度广告配置
		 *  
		 * @return 
		 */		
		protected function initBaiduAdConfig():Object {
			var param:Object = {};
			
			param.cpro_channel = _params.channel;
			param.cpro_client = _params.client;
			param.cpro_filters = ["多玩","178","爱拍","太平洋游戏网","yy","房事","情趣","房-事","成人","早泄","生殖器","又粗又大","性福","威猛","阳萎","狂插","不射","性高潮","夜夜尖叫","早泄","意外怀孕","阴道","性","人流","包皮","公关"];
			param.cpro_url = _params.url;
			param.cpro_template = "baiduxml_tiepian_400_300";
			param.cpro_w = _(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			param.cpro_h = _(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			param.cpro_plan = 4;
			param.cpro_cad = 1;
			
			return param;
		}
		
		protected function getChannel():String {
			return "";
		}
		
		protected function getClient():String {
			switch (_("type")) {
				case PlayerType.F_ZHANEI : 
				case PlayerType.S_ZHANNEI : 
				case PlayerType.S_SHOUYE : 
					return "43067007_3_tp_cpr";
					break;
				case PlayerType.F_SEO_VIDEO :
				case PlayerType.F_SEO_GAME :
					return "43067007_4_tp_cpr";
					break;
			}
			return "43067007_3_tp_cpr";
		}
		
		protected function getUrl():String {
			var temp:String = _("refPage");
//			var re:String = "17173.tv.sohu.com";
			var re:String = "v.17173.com";
			if (Util.validateStr(temp) && temp.indexOf("http://") != -1) {
				re = temp;
			}
			return re;
		}
		
		override public function dispose():void {
			_loader.unloadAndStop();
			_loader = null;
			_time = 0;
			Ticker.stop(updateTime);
			super.dispose();
		}
		
		override public function get width():int {
			return _w;
		}
		
		override public function get height():int {
			return _h;
		}
		
	}
}