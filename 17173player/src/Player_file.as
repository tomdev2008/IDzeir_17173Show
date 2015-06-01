package
{
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ad_refactor.AdManager_refactor;
	import com._17173.flash.player.business.file.FileBusinessJSDelegate;
	import com._17173.flash.player.business.file.FileBusinessManager;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.business.file.FileSkinManager;
	import com._17173.flash.player.business.file.FileUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	
	/**
	 * 站内点播播放器
	 * 
	 * @author shunia.huang
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class Player_file extends Base17173Player
	{
		
		private static const VT:String = "17173播放器";
		private static const VR:String = "[点播站内]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_file()
		{
			super();
		}
		
		override protected function addEnv():void {
			super.addEnv();
			prepareConf();
		}
		
		protected function prepareConf():void {
			var b64:String = null;
			// 老的Flvid和新的cid合并为cid
			// cid默认是base64过的,所以使用的时候需要解开
			if (_("cid")) {
				b64 = _("cid");
				_("cid", Base64.decodeStr(_("cid")));
			} else if (_("Flvid")) {
				b64 = Base64.encodeStr(_("Flvid"));
				_("cid", _("Flvid"));
			}
			// 如果有cid就设置播放器外链地址,否则设置为默认的主页
			if (b64) {
				_("flashURL", "http://f.v.17173cdn.com/player_f2/" + b64 + ".swf");
			} else {
				_("flashURL", "http://v.17173.com");
			}
			//是否为直播
			_("lv", false);
			//是否使用p2p
			_("pr", false);
			//点播播放器类型
			_("type", PlayerType.F_ZHANEI);
			_("vr", VR);
			_("vn", VN);
			_("vt", VT)
			// 是否自动播放
			_("autoplay", _("autoplay") && _("autoplay") == 1);
			// 视频播放时间起始点
			_("t") || (_("t", Util.getValueFromUrl(_("refPage"), "t")));
		}
		
		override protected function addContext():void {
			super.addContext();
			
//			_(ContextEnum.AD_MANAGER, AdManager);
			_(ContextEnum.AD_MANAGER, AdManager_refactor);
			_(ContextEnum.DATA_RETRIVER, FileDataRetriver);
			_(ContextEnum.JS_DELEGATE, FileBusinessJSDelegate);
			_(ContextEnum.SKIN_MANAGER, FileSkinManager);
			_(ContextEnum.UI_MANAGER, FileUIManager);
			_(ContextEnum.BUSINESS_MANAGER, FileBusinessManager);
		}
		
		override protected function onInitComplete():void {
			super.onInitComplete();
			// 暂时冻结键盘事件,因为这个时候广告还没播完,另外视频也可能还没加载
			_(ContextEnum.KEYBOARD).enable = false;
		}
		
//		override protected function get extraModules():Array {
//			return [PluginEnum.LIVE_REC];
//		}
		
	}
}