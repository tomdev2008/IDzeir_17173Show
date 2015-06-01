package com._17173.flash.core.video.player
{
	import flash.media.Video;

	/**
	 * 使用Video类进行播放.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class VideoPlayer extends BaseVideoPlayer
	{
		
		public function VideoPlayer()
		{
			super();
			
			var vi:Video = new Video();
			vi.smoothing = true;
			_video = vi;
		}
		
		override protected function updateVideo():void {
			if (v == null) return;
			
			v.width = _aw;
			v.height = _ah;
			v.x = (_tw - _aw) / 2;
			v.y = (_th - _ah) / 2;
		}
		
		protected function get v():Video {
			return _video as Video;
		}
		
		override public function get width():Number {
			return v.width;
		}
		
		override public function get height():Number {
			return v.height;
		}
		
		override public function set width(value:Number):void {
			v.width = value;
		}
		
		override public function set height(value:Number):void {
			v.height = value;
		}
		
		override public function set x(value:Number):void {
			v.x = value;
		}
		
		override public function get x():Number {
			return v.x;
		}
		
		override public function set y(value:Number):void {
			v.y = value;
		}
		
		override public function get y():Number {
			return v.y;
		}
		
	}
}