package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_zanting;
	import com._17173.flash.player.ad_refactor.display.IAdDisplay_refactor;
	import com._17173.flash.player.ad_refactor.interfaces.IAdData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 暂停广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_zanting extends BaseAdDelegate
	{
		
		private static const W:int = 320;
		private static const H:int = 240;
		private static const W_BAIDU:int = 430;
		private static const H_BAIDU:int = 350;
		
		/**
		 * 暂停广告实例的引用 
		 */		
		private var _ad:IAdDisplay_refactor = null;
		
		public function AdDelegate_zanting()
		{
			super();
			// 监听暂停事件
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_PLAY_OR_PAUSE, onSwitch);
			// 恢复播放去掉广告显示
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.VIDEO_RESUME, hide);
		}
		
		override protected function init():void {
			Debugger.log(Debugger.INFO, "[ad]", "暂停初始化");
		}
		
		/**
		 * 播放或者暂停
		 *  
		 * @param isPlay
		 */		
		protected function onSwitch(isPlaying:Boolean):void {
			if (isPlaying) {
				hide();
			} else {
				show();
			}
		}
		
		private function show():void {
			if (!_ad) {
				// 决定使用哪个广告类来展示
//				_ad = _data.url == "baidu" ? new AdA3_baidu() : new AdA3();
				_ad = new AdDisplay_zanting();
				_ad.display.addEventListener("close", hide);
			}
			// 大小合适才能展现
			if (canShowForWidthAndHeight(_data as IAdData)) {
				_ad.data = _data;
				_(ContextEnum.UI_MANAGER).popup(_ad.display);
			}
		}
		
		/**
		 * 根据广告类型判断当前高宽是否符合要求
		 *  
		 * @param ad
		 * @return 
		 */		
		protected function canShowForWidthAndHeight(ad:IAdData):Boolean {
			return ad.url == "baidu" ? 
				(_(ContextEnum.UI_MANAGER).avalibleVideoWidth >= W_BAIDU && _(ContextEnum.UI_MANAGER).avalibleVideoHeight >= H_BAIDU) : 
				(_(ContextEnum.UI_MANAGER).avalibleVideoWidth >= W && _(ContextEnum.UI_MANAGER).avalibleVideoHeight >= H);
		}
		
		private function hide(v:Object = null):void {
			if (_ad) {
				_(ContextEnum.UI_MANAGER).closePopup(_ad.display);
			}
		}
		
	}
}