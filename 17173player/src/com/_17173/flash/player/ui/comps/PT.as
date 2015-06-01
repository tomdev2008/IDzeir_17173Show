package com._17173.flash.player.ui.comps
{
	
	import com._17173.flash.player.ui.BasePT;
	
	import flash.display.MovieClip;
	
	/**
	 * 品推界面
	 *  
	 * @author shunia-17173
	 */	
	public class PT extends BasePT
	{
		public function PT()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			_pt = pt;
			_pt.gotoAndStop(1);
			addChild(_pt);
			
			_ptw = _pt.width;
			_pth = _pt.height;
		}
		
		protected function get pt():MovieClip {
			return new mc_pt();
		}
		
	}
}