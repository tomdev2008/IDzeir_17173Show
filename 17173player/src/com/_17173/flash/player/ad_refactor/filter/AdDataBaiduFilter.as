package com._17173.flash.player.ad_refactor.filter
{
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.ad_refactor.interfaces.IAdFilter;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 业务上需求的除外逻辑:不同的播放器,对广告位的需求不一样,这里通过预配置将其除外.
	 *  
	 * @author 庆峰
	 */	
	public class AdDataBaiduFilter implements IAdFilter
	{
		
		private var _filter:Object = null;
		
		public function AdDataBaiduFilter()
		{
			_filter = getPosition();
		}
		
		/**
		 * 获取播放器广告位的配置 -- 排外
		 */		
		private function getPosition():Object {
			var re:Object = {};
			switch(_("type")) {
				case PlayerType.F_ZHANWAI:
					re[AdType.QIANTIE] = false;
					re[AdType.ZANTING] = false;
					break;
				case PlayerType.F_CUSTOM:
					re[AdType.QIANTIE] = false;
					re[AdType.ZANTING] = false;
					break;
				case PlayerType.S_CUSTOM:
					re[AdType.QIANTIE] = false;
					re[AdType.ZANTING] = false;
					break;
			}
			return re;
		}
		
		/**
		 * 配置为百度 并且 没有相应的广告类型配置或者配置为true,说明允许该广告.
		 *  
		 * @param ad
		 * @return 
		 */		
		public function allow(ad:AdData_refactor):Boolean {
			return !filter(ad);
		}
		
		/**
		 * 返回true说明该广告数据是应该被过滤的.
		 *  
		 * @param data
		 * @return 
		 */		
		public function filter(ad:AdData_refactor):Boolean {
			return ad.url == "baidu" && _filter.hasOwnProperty(ad.type) && !_filter[ad.type];
		}
		
	}
}