package com._17173.flash.player.ui.comps.volume
{
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class VolumeBar extends BaseVolume
	{
		private var hVolumeSide:VolumeSide;
		
		private var isHor:Boolean = true;
		
		private var timer:int = 0;
		
		public function VolumeBar()
		{
			super();
			hVolumeSide = new VolumeSide();
			addChild(hVolumeSide);
			changeVolumeType(defaultHor);
		}
		
		/**
		 * 获取默认的布局
		 */		
		protected function get defaultHor():Boolean {
			return true;
		}
		
		public function changeVolumeType(isHor:Boolean):void
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
		
		private function updateHVolume():void
		{
			hVolumeSide.x = 23;
			hVolumeSide.y = 5;
			hVolumeSide.rotation = 0;
			hVolumeSide.visible = true;
			
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,show);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,hide);
			hVolumeSide.removeEventListener(MouseEvent.MOUSE_OVER,show);
			hVolumeSide.removeEventListener(MouseEvent.MOUSE_OUT,hide);
		}
		
		
		private function updateVVolume():void
		{
			hVolumeSide.x = 5;
			hVolumeSide.y = -16;
			hVolumeSide.rotation = 270;
			hVolumeSide.visible = false;
			
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,show);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,hide);
			hVolumeSide.removeEventListener(MouseEvent.MOUSE_OVER,show);
			hVolumeSide.removeEventListener(MouseEvent.MOUSE_OUT,hide);
			
			_btn.addEventListener(MouseEvent.MOUSE_OVER,show);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,hide);
			hVolumeSide.addEventListener(MouseEvent.MOUSE_OVER,show);
			hVolumeSide.addEventListener(MouseEvent.MOUSE_OUT,hide);
		}
		
		
		private function show(e:MouseEvent):void
		{
			if(!isHor)
			{
				clearTimeout(timer);
				hVolumeSide.visible = true;
				hVolumeSide.showBac(hVolumeSide.visible);
			}
			
		}
		
		private function hide(e:MouseEvent):void
		{	
			if(!isHor)
			{
				clearTimeout(timer);
				timer = setTimeout(timeOut,1500);
			}
		}
		
		private function timeOut():void
		{
			if(!isHor)
			{
				hVolumeSide.visible = false;
				hVolumeSide.btnMoseUp();
			}
		}
		
		override public function get height():Number {
			return hVolumeSide.height;
		}
		
		override public function get width():Number {
			if (isHor) {
				return super.width;
			} else {
				return hVolumeSide.buttonWidth;
			}
		}
	}
}