package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.video.source.BaseVideoSource;
	
	public class StreamVideoSource extends BaseVideoSource
	{
		
		protected var _loadToStart:int = 15;
		
		public function StreamVideoSource(loadToStart:int)
		{
			super();
			
			_loadToStart = loadToStart;
		}
		
		override protected function configStream():void {
			super.configStream();
			
			_stream.bufferTime = _loadToStart;
		}
		
	}
}