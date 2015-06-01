package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_zantingbanner;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.geom.Point;
	
	/**
	 * 暂停banner广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_zantingbanner extends BaseAdDelegate
	{
		
		protected var _ad:IAdDisplay = null;
		
		public function AdDelegate_zantingbanner()
		{
			super();
		}
		
		override protected function init():void {
			Debugger.log(Debugger.INFO, "[ad]", "暂停下底初始化");
			// 监听暂停事件
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_PLAY_OR_PAUSE, onSwitch);
			// 恢复播放广告显示
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.VIDEO_RESUME, show);
		}
		
		/**
		 * 播放或者暂停,反向展现广告
		 *  
		 * @param isPlay
		 */		
		protected function onSwitch(isPlaying:Boolean):void {
			if (isPlaying) {
				show();
			} else {
				hide();
			}
		}
		
		private function show(e:Object = null):void {
			// hack point
			var p:Point = new Point();
			if (!_ad) {
				// 决定使用哪个广告类来展示
				_ad = new AdDisplay_zantingbanner(p);
				_ad.display.addEventListener("close", hide);
			}
			
			_ad.data = [_data];
			// 动态位置暂时没有好的管理办法,所以只能hack一个pointc传进去,在广告被resize的时候,修改它的值
			_(ContextEnum.UI_MANAGER).popup(_ad.display, p);
		}
		
		private function hide(v:Object = null):void {
			if (_ad) {
				_(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.UI_PLAY_OR_PAUSE, onSwitch);
				_(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.VIDEO_RESUME, hide);
				
				_ad.dispose();
				_ad = null;
			}
		}
		
	}
}