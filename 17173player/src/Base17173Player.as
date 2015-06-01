package
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.interactive.KeyboardManager;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Console;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.ContextMenuDelegate;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.Settings;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.stat.StatDelegate;
	
	import flash.ui.Keyboard;
	
	public class Base17173Player extends StageIniator
	{
		
		public function Base17173Player()
		{
			super(true);
		}
		
		public function set config(value:Object):void {
			Util.cloneTo(value, _("variables"));
		}
		
		override protected function init():void {
			super.init();
			Debugger.source = "播放器";
			Debugger.output = new Console();
			
			//配置参数
			addEnv();
			//配置上下文
			addContext();
			//注册自定义的context
			addCustomContext();
			//实例化当前环境中的类
			initPlayer();
			//init complete
			onInitComplete();
		}
		
		/**
		 * 添加adUrl解析
		 */		
		override protected function get acceptablURLParamsKey():Array {
			var temp:Array = super.acceptablURLParamsKey;
			temp.push("adurl");
			return temp;
		}
		
		/**
		 * 环境参数等配置
		 * 
		 * @return 
		 */		
		protected function addEnv():void {
			initUrlParameters();
		}
		
		/**
		 * 配置播放器需要的一些url相关的参数
		 * refPage：当前浏览器页的url（在无法通过js获取的时候是记载当前swf的url）
		 * url：此视频在173视频站的地址（大部分用于站外播放器）
		 * flashurl：当前播放器（swf）的地址，用户分享功能
		 */		
		protected function initUrlParameters():void {
			initRefPage();
			initUrl();
		}
		
		/**
		 * 初始化refPage参数
		 * 如果js可以获取,通过js获取;如果不能获取通过后端封装之后的获取
		 */		
		protected function initRefPage():void {
			var refPage:String = Util.refPage;
			_("refPage", refPage);
			if (!Util.validateStr(refPage)) {
				var url:String = stage.loaderInfo.url;
				var arr:Array = url.split("referer=");
				if (arr.length > 1 && Util.validateStr(arr[1])) {
					_("refPage", decodeURIComponent(arr[1]));
				}
			}
		}
		
		/**
		 * 初始化url参数
		 */		
		protected function initUrl():void {
			if (_("url")) {
				_("url", _("url").split("|")[0]);
			} else {
				_("url", _("refPage"));
			}
//			if (Util.validateObj(Context.variables, "url")) {
//				var tempU:String = Context.variables["url"];
//				_("url", tempU.split("|")[0]);
//			} else {
//				_("url", _("refPage"));
//			}
		}
		
		/**
		 * 初始化当前环境里使用的类引用.
		 * 将会按照注册时序初始化. 
		 */		
		protected function addContext():void {
			_(ContextEnum.PLUGIN_MANAGER, PluginManager, plugins);
			_(ContextEnum.KEYBOARD, KeyboardManager);
			_(ContextEnum.SETTING, Settings);
			_(ContextEnum.CONTEXT_MENU, ContextMenuDelegate);
			_(ContextEnum.STAT, StatDelegate);
//			Context.regContext(ContextEnum.PLUGIN_MANAGER, null, PluginManager, plugins);
//			//注册键盘快捷键管理
//			Context.regContext(ContextEnum.KEYBOARD, null, KeyboardManager);
//			Context.regContext(ContextEnum.SETTING, null, Settings);
//			Context.regContext(ContextEnum.CONTEXT_MENU, null, ContextMenuDelegate);
//			Context.regContext(ContextEnum.STAT, null, StatDelegate);
		}
		
		/**
		 * 注册自定义的context 
		 */		
		protected function addCustomContext():void {
			
		}
		
		/**
		 * 通过配置的类创建真实逻辑需要的实例 
		 */		
		protected function initPlayer():void {
			//实例化所有已注册的context.
			_().initAll();
		}
		
		/**
		 * 舞台初始化完成,开始启动业务逻辑 
		 */		
		protected function onInitComplete():void {
			Debugger.log(Debugger.INFO, "[player]", "播放器环境初始化结束,开始启动业务逻辑!");
			//全局计时器
			Ticker.init(_("stage"));
			//监听BI完成
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_COMPLETE, onReady);
			//启动
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_INIT_COMPLETE);
		}
		
		/**
		 * 业务逻辑已经准备好,可以启动一些额外的功能模块了.
		 *  
		 * @param data
		 */		
		protected function onReady(data:Object):void {
			var p:* = _(ContextEnum.PLUGIN_MANAGER);
			var k:* = _(ContextEnum.KEYBOARD);
			
//			k.registerKeymap(function ():void {
				//monster debugger模块
				p.getPlugin(PluginEnum.MONSTER_DEBUGGER);
//			}, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_0);
			
			k.registerKeymap(function ():void {
				_(ContextEnum.EVENT_MANAGER).send("onShowConsole");
			}, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_2);
			
			//注册快捷键
			initKeyMaps(k);
			//额外的模块
			initExtraModules(p);
		}
		
		/**
		 * 注册额外模块 
		 */		
		protected function initExtraModules(p:*):void {
			for (var i:int = 0; i < extraModules.length; i ++) {
				p.getPlugin(extraModules[i]);
			}
		}
		
		/**
		 * 额外的模块数组 
		 * @return 
		 */		
		protected function get extraModules():Array {
			return [];
		}
		
		/**
		 * 注册快捷键 
		 */		
		protected function initKeyMaps(keyboard:*):void {
		}
		
		/**
		 * 预加载的插件
		 *  
		 * @return 
		 */		
		protected function get plugins():Object {
			var p:Object = {};
			p[PluginEnum.STREAM_MONITER] = null;
			return p;
		}
		
	}
}