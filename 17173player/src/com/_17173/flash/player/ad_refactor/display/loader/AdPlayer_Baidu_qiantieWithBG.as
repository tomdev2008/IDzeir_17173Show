package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 有背景的百度前贴广告
	 * 目的是解决：
	 * 1.播放器无法正确获取百度广告播放器中广告加载的进度，如果网络延迟，倒计时已经开始，但是百度广告未加载的时候显示的是黑屏（百度播放器会在赋值参数正确后返回“成功”，而不是真正加载广告完毕）
	 * 2.某些情况下（根据测试为周末晚上10点到12点）百度广告请求会返回“空”配置，导致百度播放器不显示任何有效广告，展现形式也是黑屏
	 * @author anqinghang
	 * 
	 */
	public class AdPlayer_Baidu_qiantieWithBG extends AdPlayer_Baidu_qiantie
	{
		private var _sp:Sprite;
		private var _pic:MovieClip;
		private var _ad:DisplayObject;
		
		public function AdPlayer_Baidu_qiantieWithBG()
		{
			super();
		}
		
		override protected function complete(result:Object):void {
			_ad = result as DisplayObject;
			
			_sp = new Sprite();
			_pic = new mc_ad_baidu_bg();
			_pic.addEventListener(MouseEvent.CLICK, bgClick);
			_sp.addChild(_pic);
			
			_sp.addChild(_ad);
//			sp.addChild(result as DisplayObject);
//			Ticker.tick(3000, 
//				function abc():void {
//					_sp.addChild(_ad);
//				}
//			);
			
			_display = _sp;
			
			Ticker.tick(500, updateTime, 0);
			super.complete(_display);
		}
		
		/**
		 * 背景点击
		 */		
		protected function bgClick(event:MouseEvent):void
		{
			Util.toUrl("http://v.17173.com/show/rec_getRecommendRoom.action?vid=bdlmhp_show");
		}
		
		override public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			
			if (_ad && _ad["content"]) {
				_ad["content"]["setSize"](_w, _h);
			}
			
			if (_pic) {
				_pic.width = _w;
				_pic.height = _h;
				
				if (_pic.width > w) {
					_pic.x = (w - _pic.width) / 2;
				} else {
					_pic.width = w;
					_pic.x = (_pic.width - w) / 2;
				}
				
				if (_pic.height > h) {
					_pic.y = (h - _pic.height) / 2;
				} else {
					_pic.height = h;
					_pic.y = (_pic.height - h) / 2;
				}
			}
		}
		
	}
}