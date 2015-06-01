package com._17173.flash.show.base.module.video.base.push
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Video;
	
	/**
	 * Video  显示容器
	 * @author qiuyue
	 * 
	 */	
	public class BaseVideo extends Sprite
	{
		public var video:Video = new Video();
		public function BaseVideo()
		{
			super();
			video.smoothing = true;
			this.addChild(video);
		}
		
		/**
		 * 拍照 
		 * @return 
		 * 
		 */		
		public function capture():BitmapData
		{
			try {
				var bm:BitmapData = new BitmapData(video.width/video.scaleX, video.height/video.scaleY);
				bm.draw(video);
				return bm;
			} catch (e : Error) {
				
			}
			return null;
		}
	}
}