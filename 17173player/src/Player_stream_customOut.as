package
{
	import com._17173.flash.player.business.CustomPlayerParamlize;
	import com._17173.flash.player.business.stream.StreamBusinessJSDelegate;
	import com._17173.flash.player.business.stream.custom.StreamCustomBusinessManager;
	import com._17173.flash.player.business.stream.custom.StreamCustomDataRetriver;
	import com._17173.flash.player.business.stream.custom.StreamCustomSkinManager;
	import com._17173.flash.player.business.stream.custom.StreamCustomUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.SocketManagerDelegate;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.watching.WatchingManager;

	/**
	 * 1.需要cid才能播放,默认是从flashvars里面获取的.js也会主动调用flash使用cid为参数进行播放.
	 * 2.功能上是根据后端请求获取模块，模块有17173logo、合作方logo、送礼（暂时为假送礼，直接跳转回主站）、弹幕、水印、侧边栏、顶部搜索栏
	 * 3.与js的接口.
	 * 4.界面上不显示进度条,没有侧边栏.
	 * 
	 * @author shunia-17173
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class Player_stream_customOut extends Player_stream_firstpage
	{
		
		private static const VR:String = "[直播企业]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_stream_customOut()
		{
			super();
		}
		
		override protected function addEnv():void {
			super.addEnv();
			
			// 是否允许使用flashvars来控制模块功能
			_("allowModuleParam", CustomPlayerParamlize.acceptFlashvars());
			
			//版本
			_("vr", VR);
			_("vn", VN);
			_("type", PlayerType.S_CUSTOM);
			
			//回链参数
			_("redirectLink", "http://v.17173.com/live/redirect/redirect.action");
			_("redirectUrl", "http://v.17173.com/live");
			_("redirectFrom", 3);
		}
		
		override protected function addContext():void {
			super.addContext();
			
			_(ContextEnum.DATA_RETRIVER, StreamCustomDataRetriver);
			_(ContextEnum.JS_DELEGATE, StreamBusinessJSDelegate);
			_(ContextEnum.SKIN_MANAGER, StreamCustomSkinManager);
			_(ContextEnum.UI_MANAGER, StreamCustomUIManager);
			_(ContextEnum.BUSINESS_MANAGER, StreamCustomBusinessManager);
			_(ContextEnum.SOCKET_MANAGER, SocketManagerDelegate);
		}
		
		override protected function get plugins():Object {
			var p:Object = {};
			p[PluginEnum.WATCHING] = WatchingManager;
			p[PluginEnum.STREAM_MONITER] = null;
			return p;
		}
		
	}
}