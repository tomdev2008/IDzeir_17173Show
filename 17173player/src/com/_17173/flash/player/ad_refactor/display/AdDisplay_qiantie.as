package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayerType;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Baidu_qiantieWithBG;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Image;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_SWF;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Video;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AdDisplay_qiantie extends BaseAdDisplay_refactor
	{
		
		private var _time:int = 0;
		
		private var _adTime:AdTimeComp = null;
		
		public function AdDisplay_qiantie()
		{
			super();
			
			_supportedPlayer[AdPlayerType.SWF] = AdPlayer_SWF;
			_supportedPlayer[AdPlayerType.IMAGE] = AdPlayer_Image;
			_supportedPlayer[AdPlayerType.VIDEO] = AdPlayer_Video;
//			if (_("type") == PlayerType.F_ZHANEI || _("type") == PlayerType.F_SEO_GAME || _("type") == PlayerType.F_SEO_VIDEO || _("type") == PlayerType.S_ZHANNEI) {
//				_supportedPlayer[AdPlayerType.BAIDU] = AdPlayer_Baidu_qiantieWithBG;
//			} else {
//				_supportedPlayer[AdPlayerType.BAIDU] = AdPlayer_Baidu_qiantie;
//			}
			//AdPlayer_Baidu_qiantieWithBG为有兜底背景的百度前贴（点播站内、两个seo、直播首页和站内使用）
			_supportedPlayer[AdPlayerType.BAIDU] = AdPlayer_Baidu_qiantieWithBG;
			
			_adTime = new AdTimeComp();
			addChild(_adTime);
		}
		
		override protected function onRemovedFromStage(e:Event):void {
			Ticker.stop(updateTime);
			
			super.onRemovedFromStage(e);
		}
		
		override protected function start():void {
			_time = _data.totalTime;
			_adTime.time = _time;
			
			super.start();
		}
		
		override protected function onLoadSucc(result:Object):void {
			super.onLoadSucc(result);
			
			// 这里单独处理一下,因为视频的声音控制要用到netStream
			_adTime.soundUI = _player.soundTarget;
			
			Ticker.tick(500, updateTime, 0);
		}
		
		protected function updateTime():void {
			var t:int = _player.getTime() / 1000;
			if (t >= _data.time) {
				complete(null);
			} else {
				_adTime.time = _time - t;
			}
		}
		
		override protected function onClick(event:MouseEvent):void {
			if (Util.validateStr(_data.jumpTo) && _data.url != "baidu") {
				// 跳转
				Util.toUrl(_data.jumpTo);
			}
			// 统计
			AdStat.click(_data);
		}
		
		override protected function complete(result:Object):void {
			Ticker.stop(updateTime);
			super.complete(result);
		}
		
		override public function resize(w:int, h:int):void {
			graphics.clear();
			graphics.beginFill(0, 1);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			if (_adTime) {
				_adTime.x = w - _adTime.width;
				_adTime.y = 0;
			}
			
			super.resize(w, h);
			
			if (_player && _player.display) {
				_player.display.x = (_w - _player.width) / 2;
				_player.display.y = (_h - _player.height) / 2;
			}
		}
		
	}
}