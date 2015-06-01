package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.IModuleManager;
	import com._17173.flash.show.base.context.resource.ResourceManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.base.model.SharedModel;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	
	/**
	 * 取配置.
	 * 包含版本控制等参数.
	 *  
	 * @author shunia-17173
	 */	
	public class InitConfig extends BaseInit
	{
		public function InitConfig()
		{
			super();
			
			_name = "配置文件";
			_weight = 20;
		}
		
		override public function enter():void {
			super.enter();
			
			Debugger.log(Debugger.INFO, "[init]", "配置文件开始加载!");
			
			//全局配置
			_s.http.getFile(Context.variables["ref"] + "/assets/conf.json"+"?t="+SharedModel.version, onConfLoaded, onConfLoadFail);
		}
		
		/**
		 * 全局配置加载完成.
		 *  
		 * @param data
		 */		
		protected function onConfLoaded(data:Object):void {
			Debugger.log(Debugger.INFO, "[init]", "配置文件加载并解析完成!");
			
			var conf:Object = JSON.parse(String(data));
			Context.variables["conf"] = conf;
			
			var m:IModuleManager = Context.getContext(CEnum.MODULE) as IModuleManager;
			m.config = conf.modules;
			
			var resour:ResourceManager = Context.getContext(CEnum.SOURCE) as ResourceManager;
			resour.setupGC(conf.resource);
			
			//初始化聊天工厂数据，从SmilePanelDelegate时序提前
			(Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).initFactory(conf.smileres,Utils.getURLGraphic);
			
//			new SceneDelegate(conf.scene, function ():void {
				loadLocale();
//			});
		}
		
		private function loadLocale():void {
			Debugger.log(Debugger.INFO, "[init]", "语言包开始加载!");
			//语言文件
			_s.http.getFile(Context.variables["ref"] + "/assets/locale/zh_CN/Main.xml"+"?t="+SharedModel.version, onLocaleLoaded, onLocaleFail);
		}
		
		/**
		 * 语言文字加载完成.
		 *  
		 * @param data
		 */		
		protected function onLocaleLoaded(data:String):void {
			var content:XML = XML(data);
			var locale:Locale = new Locale();
			locale.startUp({"locale":"zh_CN", "content":content});
			
			//强制注入为语言包
			Context.injectContext(CEnum.LOCALE, locale);
			
			Debugger.log(Debugger.INFO, "[init]", "语言包加载并解析完成!");
			
			complete();
		}
		
		private function onLocaleFail(data:Object):void {
			Debugger.log(Debugger.ERROR, "[init]", "语言包加载失败!");
		}
		
		protected function onConfLoadFail(err:Object):void {
			Debugger.log(Debugger.ERROR, "[init]", "配置文件加载错误!");
		}
		
	}
}