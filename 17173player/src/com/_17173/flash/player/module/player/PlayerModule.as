package com._17173.flash.player.module.player
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.player.context.VideoManager;
	
	public class PlayerModule extends StageIniator
	{
		
		protected var _videoManager:VideoManager = null;
		
		public function PlayerModule()
		{
			super(false);
		}
		
		/**
		 * 获取播放器里的videoManager实例
		 *  
		 * @return 
		 */		
		public function get videoManager():VideoManager {
			return _videoManager;
		}
		
	}
}