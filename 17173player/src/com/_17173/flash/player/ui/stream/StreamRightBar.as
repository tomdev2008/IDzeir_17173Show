package com._17173.flash.player.ui.stream
{
	import com._17173.flash.player.ui.comps.BaseRightBar;
	import com._17173.flash.player.ui.file.ShareCompoment;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class StreamRightBar extends BaseRightBar
	{
		
		private var _share:MovieClip = null;
		private var _comp:ShareCompoment = null;
		
		public function StreamRightBar()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			//分享
			_share = new mc_rightbar_share();
			_share.addEventListener("onShare", onShare);
			_con.addChild(_share);
		}
		
		protected function onShare(event:Event):void {
			if(!_comp) {
				_comp = new ShareCompoment();
			}
			_comp.showShare();
		}
		
	}
}