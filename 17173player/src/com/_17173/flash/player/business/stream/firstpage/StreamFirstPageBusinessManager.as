package com._17173.flash.player.business.stream.firstpage
{
	import com._17173.flash.player.business.stream.StreamBusinessManager;
	
	public class StreamFirstPageBusinessManager extends StreamBusinessManager
	{
		public function StreamFirstPageBusinessManager()
		{
			super();
		}
		
		override protected function onVideoFinished(data:Object=null):void {
			super.onVideoFinished(data);
		}
		
	}
}