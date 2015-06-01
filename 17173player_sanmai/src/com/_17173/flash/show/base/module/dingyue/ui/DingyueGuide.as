package com._17173.flash.show.base.module.dingyue.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DingyueGuide extends Sprite
	{
		private var mc:MovieClip = null;
		private var closeBack:Function = null;
		public function DingyueGuide(cmpBack:Function)
		{
			super();
			closeBack = cmpBack;
			mc = new Mc_guide();
			this.addChild(mc);
			mc.mc_Close.addEventListener(MouseEvent.CLICK,onClose);
			mc.Btn_cloase.addEventListener(MouseEvent.CLICK,onClose);
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function onClose(e:Event):void{
			if(this.parent){
				this.parent.removeChild(this);
			}
			if(closeBack!=null){
				closeBack();
			}
		}
	}
}