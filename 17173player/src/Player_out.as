package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.player.ad_refactor.AdManager_refactor;
	import com._17173.flash.player.business.ad.AdUIManager;
	import com._17173.flash.player.business.file.FileBusinessJSDelegate;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.ContextMenuAdPlayerDelegate;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.model.Settings;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.StatDelegate;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;

	public class Player_out extends Base17173Player
	{
		private static const VT:String = "播放器";
		private static const VR:String = "";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_out()
		{
			super();
		}
		
		override protected function addEnv():void {
			super.addEnv();
			prepareConf();
		}
		
		protected function prepareConf():void {
			_("cid", "");
			_("type", PlayerType.A_OUT);
			_("vr", VR);
			_("vn", VN);
			_("vt", VT);
		}
		
		override protected function addContext():void {
//			super.addContext();
			
			_(ContextEnum.SETTING, Settings);
			_(ContextEnum.PLUGIN_MANAGER, PluginManager, plugins);
			_(ContextEnum.STAT, StatDelegate);
			_(ContextEnum.CONTEXT_MENU, ContextMenuAdPlayerDelegate);
			_(ContextEnum.JS_DELEGATE, FileBusinessJSDelegate);
			_(ContextEnum.UI_MANAGER, AdUIManager);
			_(ContextEnum.AD_MANAGER, AdManager_refactor);
		}
		
		override protected function onInitComplete():void {
			super.onInitComplete();
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_ADPALYER_COMPLET);
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_START_LOAD_AD_INFO);
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_AD_COMPLETE, onAdComplet);
		}
		
		private function onAdComplet(obj:Object):void {
			//用户播放完广告，理解为正式开始看视频
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_REAL_START, {});
		}
		
	}
}