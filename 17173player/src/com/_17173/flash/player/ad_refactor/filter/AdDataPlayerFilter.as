package com._17173.flash.player.ad_refactor.filter
{
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.ad_refactor.interfaces.IAdFilter;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 独占或者排除的广告位过滤器.
	 *  
	 * @author 庆峰
	 */	
	public class AdDataPlayerFilter implements IAdFilter
	{
		
		private var _filter:Array = null;
		
		public function AdDataPlayerFilter()
		{
			_filter = initFilter();
		}
		
		/**
		 * 过滤数据源 -- 全部 
		 * @return 
		 */		
		private function initFilter():Array {
			switch (_("type")) {
				case PlayerType.F_ZHANEI : 
				case PlayerType.F_SEO_GAME:
				case PlayerType.F_SEO_VIDEO:
					return [
						AdType.DAQIANTIE, 
						AdType.QIANTIE, 
						AdType.ZANTING, 
						AdType.ZANTING_BANNER, 
						AdType.XIADI, 
						AdType.GUAJIAO, 
						AdType.SHANBO
					];
					break;
				case PlayerType.F_ZHANWAI : 
					return [AdType.DAQIANTIE, AdType.QIANTIE, AdType.ZANTING];
					break;
				case PlayerType.F_CUSTOM : 
					return [AdType.QIANTIE, AdType.ZANTING];
					break;
				case PlayerType.S_SHOUYE : 
					return [AdType.QIANTIE, AdType.ZANTING];
					break;
				case PlayerType.S_ZHANNEI:
				case PlayerType.A_PAD:
					return [AdType.DAQIANTIE, AdType.QIANTIE, AdType.ZANTING, AdType.SHANBO];
					break;
				case PlayerType.S_CUSTOM:
					return [AdType.QIANTIE, AdType.ZANTING];
					break;
				case PlayerType.A_OUT:
					return [AdType.DAQIANTIE, AdType.QIANTIE, AdType.ZANTING];
					break;
			}
			return [];
		}
		
		public function allow(ad:AdData_refactor):Boolean {
			return _filter.indexOf(ad.type) != -1;
		}
		
		/**
		 * 返回true表示应该被过滤.
		 *  
		 * @param ad
		 * @return 
		 */		
		public function filter(ad:AdData_refactor):Boolean {
			return !allow(ad);
		}
		
	}
}