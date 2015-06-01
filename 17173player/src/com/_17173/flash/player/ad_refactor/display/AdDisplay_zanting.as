package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayerType;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Baidu_zanting;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Image;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_RTB;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_SWF;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 重写的暂停广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDisplay_zanting extends BaseAdDisplay_refactor
	{
		
		private static const W:int = 320;
		private static const H:int = 240;
		private static const W_BAIDU:int = 430;
		private static const H_BAIDU:int = 350;
		private static const RTB_START:String = "baiduAdStart";
		private static const RTB_END:String = "baiduAdEnd";
		private var _close:MovieClip = null;
		
		public function AdDisplay_zanting()
		{
			super();
			
			// 支持图片,swf,百度联盟
			_supportedPlayer[AdPlayerType.IMAGE] = AdPlayer_Image;
			_supportedPlayer[AdPlayerType.SWF] = AdPlayer_SWF;
			_supportedPlayer[AdPlayerType.BAIDU] = AdPlayer_Baidu_zanting;
			_supportedPlayer[AdPlayerType.RTB] = AdPlayer_RTB;
		}
		
		override protected function onRemovedFromStage(e:Event):void {
			if (AdPlayerType.validateExtension(_data.url) == AdPlayerType.RTB) {
				//通知js关闭RTB广告
				_(ContextEnum.JS_DELEGATE).send(RTB_END);
			}
			super.onRemovedFromStage(e);
		}
		
		override protected function onLoadSucc(result:Object):void {
			if (AdPlayerType.validateExtension(_data.url) == AdPlayerType.RTB) {
				_isLoading = false;
				//通知js显示RTB广告
				_(ContextEnum.JS_DELEGATE).send(RTB_START);
			} else {
				super.onLoadSucc(result);
				
				if (_close == null) {
					_close = new mc_ad_close();
					_close.x = width - _close.width;
					_close.y = 0;
					_close.addEventListener(MouseEvent.CLICK, closeClick);
					addChild(_close);
				}
			}
		}
		
		/**
		 * 根据广告类型判断当前高宽是否符合要求
		 *  
		 * @param ad
		 * @return 
		 */		
		protected function canShowForWidthAndHeight():Boolean {
			return _w >= width && _h >= height;
		}
		
		override public function get width():Number {
			return _data && _data.url == "baidu" ? 
				W_BAIDU : W;
		}
		
		override public function get height():Number {
			return _data && _data.url == "baidu" ? 
				H_BAIDU : H;
		}
		
		override protected function onClick(event:MouseEvent):void {
			if (Util.validateStr(_data.jumpTo) && _data.url != "baidu") {
				// 跳转
				Util.toUrl(_data.jumpTo);
			}
			// 统计
			AdStat.click(_data);
		}
		
		override public function resize(w:int, h:int):void {
			super.resize(w, h);
			
			if (canShowForWidthAndHeight()) {
				visible = true;
			} else {
				visible = false;
			}
		}
		
		private function closeClick(evt:MouseEvent):void {
			evt.stopPropagation();
			dispatchEvent(new Event("close"));
		}
		
	}
}