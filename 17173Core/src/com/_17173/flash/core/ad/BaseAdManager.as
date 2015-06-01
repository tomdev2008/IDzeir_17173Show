package com._17173.flash.core.ad
{
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.ad.interfaces.IAdManager;
	import com._17173.flash.core.ad.model.AdDataResolver;

	public class BaseAdManager implements IAdManager
	{
		
		/**
		 * 广告配置 
		 */		
		protected var _adConf:Object = null;
		
		public function BaseAdManager()
		{
		}
		
		public function init(config:Object, showFlag:Object):void {
			_adConf = AdDataResolver.resolve(config, showFlag);
		}
		
		public function isAdAvalible(type:String):Boolean {
			return _adConf && _adConf.hasOwnProperty(type) && _adConf[type];
		}
		
		public function getAdData(key:String):Array {
			if (_adConf) {
				return _adConf.hasOwnProperty(key) ? _adConf[key] : null;
			}
			return null;
		}
		
		public function getAd(key:String):IAdDisplay {
			if (_adConf) {
				return _adConf.hasOwnProperty(key) ? _adConf[key] : null;
			}
			return null;
		}
	}
}