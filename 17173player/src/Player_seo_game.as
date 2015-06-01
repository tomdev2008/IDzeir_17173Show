package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.business.file.out.FileSeoGameSkinManager;
	import com._17173.flash.player.business.file.seo.FileSeoGameDataRetriver;
	import com._17173.flash.player.business.file.seo.FileSeoGameUiManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;

	public class Player_seo_game extends Player_seo_video
	{
		public function Player_seo_game()
		{
			super();
		}
		
		override protected function addContext():void {
			super.addContext();
			Context.regContext(ContextEnum.SKIN_MANAGER, null, FileSeoGameSkinManager);
			Context.regContext(ContextEnum.UI_MANAGER, null, FileSeoGameUiManager);
			Context.regContext(ContextEnum.DATA_RETRIVER, null, FileSeoGameDataRetriver);
		}
		
		override protected function prepareConf():void {
			super.prepareConf();
			
			Context.variables["type"] = PlayerType.F_SEO_GAME;
			Context.variables["vt"] = "[V+视频游戏]";
			Context.variables["vr"] = "";
			Context.variables["vn"] = "2015.03.20 10:00";
		}
		
	}
}