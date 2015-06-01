package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.business.file.out.FileSeoVideoSkinManager;
	import com._17173.flash.player.business.file.seo.FileSeoVideoDataRetriver;
	import com._17173.flash.player.business.file.seo.FileSeoVideoUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.ContextMenuSeoVideoDelegate;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * SEO 视频游戏站播放器
	 * @author anqinghang
	 * 
	 */	
	public class Player_seo_video extends Player_file
	{
		public function Player_seo_video()
		{
			super();
		}
		
		override protected function addContext():void {
			super.addContext();
			_(ContextEnum.CONTEXT_MENU, ContextMenuSeoVideoDelegate);
			Context.regContext(ContextEnum.UI_MANAGER, null, FileSeoVideoUIManager);
			Context.regContext(ContextEnum.DATA_RETRIVER, null, FileSeoVideoDataRetriver);
			Context.regContext(ContextEnum.SKIN_MANAGER, null, FileSeoVideoSkinManager);
		}
		
		override protected function prepareConf():void {
			super.prepareConf();
			
			Context.variables["type"] = PlayerType.F_SEO_VIDEO;
			Context.variables["vr"] = "[站内点播]";
			Context.variables["vn"] = "2015.03.20 10:00";
		}
		
		override protected function get extraModules():Array {
			return [];
		}
		
	}
}