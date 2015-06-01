package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.IModuleManager;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.CEnum;

	/**
	 * 初始化业务模块.
	 *  
	 * @author shunia-17173
	 */	
	public class InitModules extends BaseInit
	{
		public function InitModules()
		{
			super();
			
			_name = "模块加载";
			_weight = 20;
		}
		
		override public function enter():void {
			super.enter();
			
			Debugger.log(Debugger.INFO, "[init]", "业务模块开始初始化!");
			
			var m:IModuleManager = Context.getContext(CEnum.MODULE) as IModuleManager;
			m.initMain();
			m.initAllSub();
			
			Debugger.log(Debugger.INFO, "[init]", "业务模块初始化完成!");
			
			complete();
		}
		
		
	}
}