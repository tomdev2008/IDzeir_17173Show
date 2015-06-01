package com._17173.flash.player.module.bullets.fixure
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.module.bullets.base.Bullet;
	
	import flash.events.Event;

	/**
	 *固定位置的弹幕 
	 * @author zhaoqinghao
	 * 
	 */
	public class FixureBullet extends Bullet
	{
		protected var moveTime:int = 5 * 1000;
		public function FixureBullet()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			var w:int = Context.stage.fullScreenWidth;
			//停留时间
			var t:int = w/_data.speed;
			Ticker.anim(moveTime, this).onComplete = function ():void {_d = true;};
			//			TweenLite.to(this, t, {x:-this.width, onComplete:function ():void {_d = true;}, ease:Linear.easeNone});
		}
	}
}