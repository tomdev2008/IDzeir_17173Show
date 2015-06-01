package com._17173.flash.player.ui.comps.volume
{
	import flash.display.MovieClip;

	/**
	 * seo 视频游戏  声音组件
	 * @author anqinghang
	 * 
	 */	
	public class VolumeSeoVideo extends VolumeBarSeo
	{
		public function VolumeSeoVideo()
		{
			super();
//			this.opaqueBackground = 0xff00ff;
		}
		
		override protected function get btn():MovieClip {
			return new volume_seo_video_btn();
		}
		
		override protected function get defaultHor():Boolean {
			return false;
		}
		
		override protected function get side():VolumeSideSeo {
			var bar:VolumeSideSeo = new VolumeSideSeo();
			bar.barBGHeight = 10;
			bar.barHeight = 8;
			bar.barWidth = 120;
			bar.colorBG = 0xD5D5D5;
			bar.clolorFill = 0xd83727;
			bar.init();
			return bar;
		}
		
		override public function get height():Number {
			if (_btn && hVolumeSide) {
				return _btn.height > hVolumeSide.height ? _btn.height : hVolumeSide.height;
			} else {
				if (_btn) {
					return _btn.height;
				} else {
					return hVolumeSide.height;
				}
			}
		}
		
		override public function get width():Number {
			if (defaultHor) {
				return super.width;
			} else {
				return _btn.width > hVolumeSide.buttonWidth ? _btn.width : hVolumeSide.buttonWidth;
			}
		}
		
	}
}