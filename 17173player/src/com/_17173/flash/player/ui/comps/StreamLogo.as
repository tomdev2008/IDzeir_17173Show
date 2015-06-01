package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.events.MouseEvent;

	/**
	 * 直播播放器控制栏右侧logo,用来跳转到大首页.
	 *  
	 * @author 庆峰
	 */	
	public class StreamLogo extends Logo
	{
		
		private var _vid:String = null;
		
		public function StreamLogo()
		{
			super();
		}
		
		override protected function onClick(event:MouseEvent):void {
			if (!_vid) {
				_vid = genVid();
			}
			Util.toUrl(url + "?vid=" + _vid);
		}
		
		protected function genVid():String {
			if (_("type") == PlayerType.S_CUSTOM && _("redirectVid")) {
				return _("redirectVid");
			} else {
				return "video_zz";
			}
		}
		
	}
}