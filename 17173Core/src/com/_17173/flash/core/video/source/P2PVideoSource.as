package com._17173.flash.core.video.source
{
	import flash.net.NetStream;
	
	/**
	 * 使用P2P技术进行流视频播放.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class P2PVideoSource extends StreamingVideoSource
	{
		public function P2PVideoSource()
		{
			super();
		}
		
		override protected function initStream():void {
			_stream = new NetStream(_connection, NetStream.DIRECT_CONNECTIONS);
		}
		
	}
}