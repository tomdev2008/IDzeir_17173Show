package com._17173.flash.core.video
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	/**
	 * 视频支持类,提供通用视频信息的支持.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class VideoSupport
	{
		
		/**
		 * 当前Flash player的版本号. 
		 */		
		private static var _version:Number = 0;
		
		public function VideoSupport()
		{
		}
		
		/**
		 * 当前是否可用StageVideo特性. 
		 * @return 
		 * 
		 * @see flash.mdeia.StageVideo
		 * 
		 */		
		public static function supportStageVideo(stage:Stage):Boolean {
			return fpVersionSupportStageVideo() && hasStageVideo(stage);
		}
		
		/**
		 * 10.2以上的flash player版本才能支持StageVideo. 
		 * 
		 * @return 当前FP版本是否支持StageVideo
		 * 
		 */		
		public static function fpVersionSupportStageVideo():Boolean {
			if (_version == 0) {
				var versionStrs:Array = Capabilities.version.split(" ")[1].split(",");
				var versionStr:String = "";
				for (var i:int = 0; i < versionStrs.length; i ++) {
					versionStr += versionStrs[0];
					if (i == 0) {
						versionStr += ".";
					}
				}
				
				_version = Number(versionStr);
			}
			
			return _version >= 10.2;
		}
		
		/**
		 * 当前flash中是否有可用的StageVideo实例. 
		 * 
		 * @return 
		 * 
		 */		
		public static function hasStageVideo(stage:Stage):Boolean {
			return stage.stageVideos && stage.stageVideos.length > 0;
		}
		
		public static function supportH264():Boolean {
			
			return false;
		}
		
	}
}