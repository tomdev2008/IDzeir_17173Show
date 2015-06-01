package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_guajiao;
	import com._17173.flash.player.ad_refactor.display.IAdDisplay_refactor;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 挂角广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_guajiao extends BaseAdDelegate
	{
		
		protected var _ad:IAdDisplay_refactor = null;
		
		public function AdDelegate_guajiao()
		{
			super();
		}
		
		override protected function init():void {
			if (!_ad) {
				Debugger.log(Debugger.INFO, "[ad]", "挂角初始化");
				_ad = new AdDisplay_guajiao();
			}
			_ad.data = _data;
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_SHOW_A5, _ad);
		}
		
	}
}