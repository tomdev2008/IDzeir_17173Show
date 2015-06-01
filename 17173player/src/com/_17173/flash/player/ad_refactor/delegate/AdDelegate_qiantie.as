package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_qiantie;
	import com._17173.flash.player.ad_refactor.display.IAdDisplay_refactor;
	import com._17173.flash.player.ad_refactor.interfaces.IAdData;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 前贴片广告逻辑代理类,支持两种形式,百度和普通前贴.普通前贴又支持三种素材:图片,swf,视频文件(仅限flash播放器支持的格式和编码).
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_qiantie extends BaseAdDelegate
	{
		
		private var _ad:IAdDisplay_refactor = null;
		private var _ads:Array = null;
		
		public function AdDelegate_qiantie()
		{
		}
		
		override protected function init():void {
			_ad = null;
			Debugger.log(Debugger.INFO, "[ad]", "前贴初始化");
			if (_data is Array) {
				_ads = _data as Array;
			} else {
				_ads = [_data];
			}
			
			start();
		}
		
		protected function start():void {
//			var a:AdA2 = new AdA2();
//			a.data = _ads;
//			_(ContextEnum.UI_MANAGER).getLayer("adpopup").popdown(a.display, new Point(0, 0));
//			
//			return;
			if (_ads.length) {
				var d:IAdData = _ads.shift();
				if (!_ad) {
					_ad = new AdDisplay_qiantie();
					_ad.onComplete = onAdComplete;
					_ad.onError = onAdError;
					if (!_("pad")) {
						_(ContextEnum.UI_MANAGER).getLayer("adpopup").popdown(_ad.display, new Point(0, 0));
					} else {
						_("adpopup").popdown(_ad.display, new Point(0, 0));
					}
				}
				_ad.data = d;
			} else {
				complete();
			}
		}
		
		override protected function complete(result:Object=null):void {
			super.complete(result);
			
			clear();
		}
		
		private function onAdComplete(e:Event = null):void {
			start();
		}
		
		private function onAdError(e:Object = null):void {
			clear();
			
			error(e);
		}
		
		private function clear():void {
			_ad.display.removeEventListener("adComplete", onAdComplete);
			_ad.display.removeEventListener("onAdError", onAdError);
			if (!_("pad")) {
				_(ContextEnum.UI_MANAGER).hideErrorPanel();
				_(ContextEnum.UI_MANAGER).getLayer("adpopup").closePopup(_ad.display);
			} else {
				_("adpopup").closePopup(_ad.display);
			}
			_ad.dispose();
			_ad = null;
			_ads = null;
		}
		
	}
}