package
{
	import com._17173.flash.player.business.file.out.FileOutBusinessManager;
	import com._17173.flash.player.business.file.out.FileOutSkinManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.comps.SkinsEnum;

	/**
	 * 站外点播播放器
	 *  
	 * @author shunia-17173
	 */	
	public class Player_file_out extends Player_file
	{
		
		private static const VR:String = "[点播站外]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_file_out()
		{
			super();
		}
		
		override protected function addContext():void {
			super.addContext();
			
			_(ContextEnum.SKIN_MANAGER, FileOutSkinManager);
			_(ContextEnum.BUSINESS_MANAGER, FileOutBusinessManager);
		}
		
		override protected function prepareConf():void {
			super.prepareConf();
			
//			Context.variables["type"] = Settings.PLAYER_TYPE_FILE_ZHANWAI;
			_("type", PlayerType.F_ZHANWAI);
			_("vr", VR);
			_("vn", VN);
			
			if (_("autoplay")) {
				_("showFP", false);//Preview页
			} else {
				_("showFP", true);//Preview页
			}
			if (_("debug") == 1) {
				if (_("skipAD") == 1) {
					_("skipPT", true);//品推
					_("skipPW", true);//密码验证
					_("showFP", false);//Preview页
					_("skipRB", true);//rightbar
					_("skipOTP", true);//外链播放器的topbar
					_("skipBR", true);//后推
					_("excludeSkins", [SkinsEnum.OUT_TOP_BAR, SkinsEnum.RIGHT_BAR]);
				}
			}
			_("backFullscreen", true);
		}
		
		override protected function get extraModules():Array {
			return [];
		}
		
	}
}