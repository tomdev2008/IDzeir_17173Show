package com._17173.flash.player.ui.comps.volume
{
	import flash.display.MovieClip;

	public class VolumeSeoGame extends VolumeBarSeo
	{
		public function VolumeSeoGame()
		{
			super();
		}
		
		override protected function get btn():MovieClip {
			return new volume_seo_game_btn();
		}
		
		override protected function get defaultHor():Boolean {
			return false;
		}
		
		override protected function get side():VolumeSideSeo {
			var bar:VolumeSideSeo = new VolumeSideSeoGame();
			bar.barBGHeight = 10;
			bar.barHeight = 8;
			bar.barWidth = 120;
			bar.colorBG = 0xD5D5D5;
			bar.clolorFill = 0x0697cc;
			bar.init();
			return bar;
		}
		
		override public function changeVolumeType(isHor:Boolean):void
		{
			this.isHor = isHor;
			if(isHor)
			{
				updateHVolume();
			}
			else
			{
				updateVVolume();
			}
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