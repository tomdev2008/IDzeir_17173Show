package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.util.time.Ticker;
	/**
	 * 强行显示pt显示一秒state
	 */
	public class PTDelayeState extends FileState
	{
		public function PTDelayeState()
		{
			super();
		}
		
		override public function enter():void {
			Ticker.tick(1000, onPTDelayed);
		}
		
		/**
		 * 保证品推显示超过1秒
		 * 整个打断播放流程开始业务逻辑从这里开始
		 */	
		protected function onPTDelayed():void {
			transcationData["isPTDelayed"] = true;
			Ticker.stop(onPTDelayed);
			complete();
		}
	}
}