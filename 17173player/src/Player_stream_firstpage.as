package
{
	import com._17173.flash.player.business.stream.firstpage.StreamFirstPageJSDelegate;
	import com._17173.flash.player.business.stream.firstpage.StreamFirstPageSkinManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.watching.WatchingManager;
	
	/**
	 * 首页直播播放器 
	 * @author shunia-17173
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class Player_stream_firstpage extends Player_stream
	{
		
		private static const VR:String = "[直播首页]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_stream_firstpage()
		{
			super();
		}
		
		override protected function addEnv():void {
			super.addEnv();
			
			//版本
			_("vr", VR);
			_("vn", VN);
			_("type", PlayerType.S_SHOUYE);
		}
		
		override protected function addContext():void {
			super.addContext();
			
			_(ContextEnum.JS_DELEGATE, StreamFirstPageJSDelegate);
			_(ContextEnum.SKIN_MANAGER, StreamFirstPageSkinManager);
		}
		
		override protected function get plugins():Object {
			var p:Object = {};
			p[PluginEnum.WATCHING] = WatchingManager;
			p[PluginEnum.STREAM_MONITER] = null;
			return p;
		}
		
	}
}