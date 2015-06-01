package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.player.model.PlayerType;

	public class AdPlayer_Baidu_zanting extends AdPlayer_Baidu_base
	{
		public function AdPlayer_Baidu_zanting()
		{
			super();
		}
		
		override protected function initBaiduAdConfig():Object {
			var o:Object = super.initBaiduAdConfig();
			o.cpro_w = 430;
			o.cpro_h = 350;
			return o;
		}
		
		override protected function getChannel():String {
			switch (_("type")) {
				case PlayerType.F_SEO_VIDEO : 
					return "3";
					break;
				case PlayerType.F_ZHANEI : 
				case PlayerType.S_ZHANNEI : 
				case PlayerType.S_SHOUYE : 
					return "2";
					break;
			}
			return "3";
		}
		
		override public function get width():int {
			return 430;
		}
		
		override public function get height():int {
			return 350;
		}
		
	}
}