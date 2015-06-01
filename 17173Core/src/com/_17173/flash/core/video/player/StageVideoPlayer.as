package com._17173.flash.core.video.player
{
	import flash.geom.Rectangle;
	import flash.media.StageVideo;

	/**
	 * 使用StageVideo类进行播放.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class StageVideoPlayer extends BaseVideoPlayer
	{
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		public function StageVideoPlayer(videos:Vector.<StageVideo>)
		{
			super();
			
			_video = videos[0];
		}
		
		override public function center(w:int, h:int):void {
			_tw = w;
			_th = h;
			_x = (_tw - stageVideo.viewPort.width) / 2;
			_y = (_th - stageVideo.viewPort.height) / 2;
			
			updateVideo();
		}
		
		override protected function updateVideo():void {
			if (stageVideo == null) return;
			
			var newRect:Rectangle = stageVideo.viewPort.clone();
			newRect.width = _aw;
			newRect.height = _ah;
			newRect.x = _x;
			newRect.y = _y;
			stageVideo.viewPort = newRect;
		}
		
		public function get stageVideo():StageVideo {
			return _video as StageVideo;
		}
		
		override public function get height():Number {
			return stageVideo.viewPort.height;
		}
		
		override public function get width():Number {
			return stageVideo.viewPort.width;
		}
		
		override public function set width(value:Number):void {
			_aw = value;
			updateVideo();
		}
		
		override public function set height(value:Number):void {
			_ah = value;
			updateVideo();
		}
		
		override public function set x(value:Number):void {
			_x = value;
			updateVideo();
		}
		
		override public function get x():Number {
			return _x;
		}
		
		override public function set y(value:Number):void {
			_y = value;
			updateVideo();
		}
		
		override public function get y():Number {
			return _y;
		}
		
	}
}