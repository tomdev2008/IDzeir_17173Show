package com._17173.flash.player.module.player
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.file.FileVideoManager;
	
	public class FilePlayer extends PlayerModule
	{
		public function FilePlayer()
		{
			super();
			
			Debugger.log(Debugger.INFO, "[video]", "点播核心模块[版本:" + "1.1.1" + "]初始化!");
			
			_videoManager = new FileVideoManager();
		}
		
	}
}