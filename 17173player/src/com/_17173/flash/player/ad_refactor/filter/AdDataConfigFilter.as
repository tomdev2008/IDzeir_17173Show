package com._17173.flash.player.ad_refactor.filter
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.ad_refactor.interfaces.IAdFilter;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 企业版播放器可以根据后台配置,选择性过滤前贴和暂停.
	 *  
	 * @author 庆峰
	 */	
	public class AdDataConfigFilter implements IAdFilter
	{
		
		private var _filter:Object = null;
		
		public function AdDataConfigFilter()
		{
			_filter = initFilter();
		}
		
		protected function initFilter():Object {
			var o:Object = {};
			var conf:Object = _("UIModuleData") ? _("UIModuleData") : {};
			// 过滤数据源
			switch(_("type")) {
				case PlayerType.F_CUSTOM : 
					o[AdType.QIANTIE] = Util.validateObj(conf, "m10") ? conf["m10"] : true;
					o[AdType.ZANTING] = Util.validateObj(conf, "m11") ? conf["m11"] : true;
					break;
				case PlayerType.S_CUSTOM : 
					o[AdType.QIANTIE] = Util.validateObj(conf, "m10") ? conf["m10"] : true;
					o[AdType.ZANTING] = Util.validateObj(conf, "m11") ? conf["m11"] : true;
					break;
			}
			
			return o;
		}
		
		/**
		 * 当没有对应的广告类型,或者有类型并且配置为true时,说明允许该广告.
		 *  
		 * @param ad
		 * @return 
		 */		
		public function allow(ad:AdData_refactor):Boolean {
			return !_filter.hasOwnProperty(ad.type) || (_filter.hasOwnProperty(ad.type) && _filter[ad.type]);
		}
		
		/**
		 * 返回true说明广告是应该被过滤的.
		 *  
		 * @param ad
		 * @return 
		 */		
		public function filter(ad:AdData_refactor):Boolean {
			return !allow(ad);
		}
		
	}
}