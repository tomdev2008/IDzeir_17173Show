package com._17173.flash.show.base
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.KeyboardManager;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordManger;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.module.IModuleManager;
	import com._17173.flash.show.base.context.module.ModuleManager;
	import com._17173.flash.show.base.context.net.ServiceProvider;
	import com._17173.flash.show.base.context.resource.ResourceManager;
	import com._17173.flash.show.base.context.text.GraphicTextManager;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.init.MCfg;
	import com._17173.flash.show.base.module.animation.AnimationFactory;
	import com._17173.flash.show.base.utils.ContextMenuUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.PEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class BaseShowStage extends StageIniator
	{
		
		/*
		* 版本号
		*/
		protected var _version:String = null;
		
		public function BaseShowStage()
		{
			super(true);
		}
		
		override protected function init():void {
			super.init();
			
			Debugger.source = "娱乐";
			
			Context.variables["version"] = _version;
			
			//socket发送数据时不压缩
			Context.variables["writeCompress"] = false;
			
			//秀场的播放器类型,暂时单三麦都是f11,统计使用
			Context.variables["type"] = "f11";
			
			JSBridge.addCall("function () {return window.domain;}", null, "", function (domain:Object):void {
				if (domain) {
					Context.variables["domainObject"] = domain;
				}
			});
			
			Debugger.log(Debugger.INFO, "[app]", "应用初始化, " + Context.variables["version"]);
			
			//注册context
			addContext();
			//初始化所有的context
			Context.initAll();
			//初始化所有的delegate
			addDelegate();
			//init plugin
			(Context.getContext(CEnum.PLUGIN) as PluginManager).initAll();
			//基本初始化完成
			initComplete();
		}
		
		protected function addContext():void {
			//注册插件管理器
			Context.regContext(CEnum.PLUGIN, null, PluginManager, plugins);
			//注册键盘快捷键管理
			Context.regContext(CEnum.KEYBOARD, null, KeyboardManager);
			//注册层级管理 层级管理器的父级为入口文件
			Context.regContext(CEnum.UI, null, UIManager, this);
			//注册数据连接服务
			Context.regContext(CEnum.SERVICE, null, ServiceProvider);
			//注册资源管理
			Context.regContext(CEnum.SOURCE, null, ResourceManager);
			//注册用户数据
			Context.regContext(CEnum.USER, null, User);
			//注册用户数据
			Context.regContext(CEnum.GRAPHIC_TEXT, null, GraphicTextManager);
			//注册模块管理类
			Context.regContext(CEnum.MODULE, null, ModuleManager);
			//注册错误处理管理
			Context.regContext(CEnum.ERROR_RECORD, null, ErrorRecordManger);
			//动画工厂
			Context.regContext(CEnum.ANIMATIONFACTORY,null,AnimationFactory);
		}
		
		/**
		 * 注册Delegate类 
		 */		
		protected function addDelegate():void {
			var m:IModuleManager = Context.getContext(CEnum.MODULE) as IModuleManager;
			
			for (var k:String in delegates) {
				m.regDelegate(k, delegates[k],true);
			}
			
			for (k in subDelegates) {
				m.regDelegate(k, subDelegates[k]);
			}
		}
		
		protected function get delegates():Object {
			var d:Object = {};
			return d;
		}
		
		
		protected function get subDelegates():Object{
			var d:Object = {};
			return d;
		}
		
		protected function get plugins():Object {
			var p:Object = {};
			p[PEnum.MONSTER_DEBUGGER] = null;
			return p;
		}
		
		protected function initComplete():void {
			Debugger.log(Debugger.INFO, "[app]", "框架初始化结束");
			//菜单栏
			this.contextMenu = ContextMenuUtil.getContextMenu();
			
			Debugger.log(Debugger.INFO, "[app]", "启动业务模块加载");
			//初始化业务
			new MCfg();
			
			//发出应用初始化结束的消息
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.APP_INIT);
		}
	}
}