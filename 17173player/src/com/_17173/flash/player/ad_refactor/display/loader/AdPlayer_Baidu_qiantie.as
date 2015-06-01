package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.player.model.PlayerType;

	public class AdPlayer_Baidu_qiantie extends AdPlayer_Baidu_base
	{
		public function AdPlayer_Baidu_qiantie()
		{
			super();
		}
		
		override protected function getChannel():String {
			switch (_("type")) {
				case PlayerType.F_SEO_VIDEO : 
					return "2";
					break;
				case PlayerType.F_ZHANEI : 
				case PlayerType.S_ZHANNEI : 
				case PlayerType.S_SHOUYE : 
					return "1";
					break;
			}
			return "2";
		}
		
		override public function resize(w:int, h:int):void {
			super.resize(w, h);
			if (_display && _display["content"]) {
				_display["content"]["setSize"](_w, _h);
			}
		}
		
	}
}