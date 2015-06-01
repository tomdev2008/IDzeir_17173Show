package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_xiadi;
	import com._17173.flash.player.ad_refactor.display.IAdDisplay_refactor;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 下底广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_xiadi extends BaseAdDelegate
	{
		
		protected var _ad:IAdDisplay_refactor = null;
		
		public function AdDelegate_xiadi()
		{
			super();
		}
		
		override protected function init():void {
			if (!_ad) {
				Debugger.log(Debugger.INFO, "[ad]", "下底初始化");
				_ad = new AdDisplay_xiadi();
			}
			_ad.data = _data;
			
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_SHOW_A4, _ad);
		}
		
	}
}