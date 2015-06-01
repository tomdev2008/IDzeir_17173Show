package com._17173.flash.core.video.source
{
	public class VideoSourceInfo
	{
		
		public static const CONNECTED:String = "视频流已连接";
		public static const META_DATA:String = "视频元数据已获取";
		public static const START:String = "视频文件数据开始加载";
		public static const PAUSE:String = "视频暂停";
		public static const RESUME:String = "视频恢复播放";
		public static const SEEK:String = "视频正在快进/退";
		public static const SEEK_START:String = "视频开始快进/退";
		public static const FINISHED:String = "视频播放结束";
		public static const BUFFER_FULL:String = "视频缓冲区已满";
		public static const BUFFER_EMPTY:String = "视频缓冲区为空";
		public static const STREAM_NOT_FOUND:String = "视频文件/流未找到";
		public static const STOP:String = "视频播放停止";
		public static const BUFFER_FLUSH:String = "文件/流停止加载,并且缓冲区接下来会被清空";
		public static const DIMONSION_CHANGE:String = "视频高宽改变";
		
		public static const P2P_SUCCESS:String = "p2pConSuccess";
		public static const P2P_FAILED:String = "p2pConFailed";
		public static const P2P_CLOSED:String = "p2pConClosed";
		public static const P2P_REJECTED:String = "p2pConRejected";
		
		public static const FAULT:String = "视频文件/流错误";
		
		
		public static const PUBLISH:String = "视频开始推流";
		public static const CONNECTED_CLOSE:String = "视频流已断开";
		
		public static const CONNECTED_FAILED:String = "CONNECTED_FAILED";
		public static const CONNECTED_REJECTED:String = "CONNECTED_REJECTED";

	}
}