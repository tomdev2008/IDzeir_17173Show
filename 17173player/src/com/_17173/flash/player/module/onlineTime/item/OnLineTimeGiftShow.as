package com._17173.flash.player.module.onlineTime.item
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.DefineFrameMovieClip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class OnLineTimeGiftShow extends Sprite
	{
		/**
		 *领取礼物板子
		 */
		private var _giftUI:DefineFrameMovieClip = null;
		/**
		 *展示
		 */
		private var _moneyShow:MovieClip = null;
		/**
		 *聚宝盆 
		 */		
		private var _jbp:MovieClip = null;

		public function OnLineTimeGiftShow()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			super();
			_jbp = new mc_jubaoben();
			_jbp.gotoAndStop(1);
			_jbp.mouseChildren = _jbp.mouseEnabled = false;
			_jbp.x = 9;
			_jbp.y = 52;
			this.addChild(_jbp);
			_giftUI = new DefineFrameMovieClip(new mc_giftPlay(), 6, Context.stage.frameRate);
			_giftUI.mc.sLabel.text = "恭喜你";
			this.addChild(_giftUI);
			_moneyShow = new mc_moneyShow();
			_moneyShow.x = _giftUI.width + 3;
			this.addChild(_moneyShow);
		}

		//设置奖励
		public function updateMoney(money:int):void
		{
			_moneyShow.sLabel.text = money;
		}

		public function play():void
		{
			_giftUI.loop(3,4);
		}

		public function stop():void
		{
			_giftUI.stop(1);
		}
	}
}
