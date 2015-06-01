package com._17173.flash.player.module.player
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.stream.StreamVideoManager;
	
	public class StreamPlayer extends PlayerModule
	{
		public function StreamPlayer()
		{
			super();
			
			Debugger.log(Debugger.INFO, "[video]", "直播核心模块[版本:" + "1.0.7" + "]初始化!");
			
			_videoManager = new StreamVideoManager();
		}
	}
}