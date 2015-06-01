package
{
	import com._17173.flash.player.ad_refactor.AdManager_refactor;
	import com._17173.flash.player.business.stream.StreamBusinessJSDelegate;
	import com._17173.flash.player.business.stream.StreamBusinessManager;
	import com._17173.flash.player.business.stream.StreamDataRetriver;
	import com._17173.flash.player.business.stream.StreamSkinManager;
	import com._17173.flash.player.business.stream.StreamUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.watching.WatchingManager;
	
	/**
	 * 1.需要cid才能播放,默认是从flashvars里面获取的.js也会主动调用flash使用cid为参数进行播放.
	 * 2.功能上有送礼,弹幕,观看人数
	 * 3.与js的接口.
	 * 4.界面上不显示进度条,没有侧边栏.
	 * @author shunia-17173
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class Player_stream extends Base17173Player
	{
		
		private static const VR:String = "[直播站内]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_stream()
		{
			super();
		}
		
		override protected function addEnv():void {
			super.addEnv();
			
			//是否为直播
			_("lv", true);
			//是否使用p2p
			_("pr", true);
			//自动开始播放
			_("autoplay", true);
			//版本
			_("vr", VR);
			_("vn", VN);
			_("type", PlayerType.S_ZHANNEI);
			// 站外链接,分享用
			_("url") ? 
				_("flashURL", "http://v.17173.com/live/player/Player_stream_customOut.swf&url=" + _("url")) : 
				_("flashURL", "http://v.17173.com");
		}
		
		override protected function addContext():void {
			super.addContext();
			
			_(ContextEnum.AD_MANAGER, AdManager_refactor);
			_(ContextEnum.DATA_RETRIVER, StreamDataRetriver);
			_(ContextEnum.JS_DELEGATE, StreamBusinessJSDelegate);
			_(ContextEnum.SKIN_MANAGER, StreamSkinManager);
			_(ContextEnum.UI_MANAGER, StreamUIManager);
			_(ContextEnum.BUSINESS_MANAGER, StreamBusinessManager);
		}
		
		override protected function get plugins():Object {
			var p:Object = super.plugins;
			p[PluginEnum.WATCHING] = WatchingManager;
			//礼物模块
			p[PluginEnum.GIFT] = null;
			//弹幕模块
			p[PluginEnum.BULLETS] = null;
			//直播时长
			p[PluginEnum.ONLINETIME] = null;
			//用户信息
			p[PluginEnum.USERINFO] = null;
			return p;
		}
		
	}
}