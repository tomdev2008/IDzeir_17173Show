package com._17173.flash.player.module.md
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	
	/**
	 * Monster Debugger模块
	 *  
	 * @author shunia-17173
	 */	
	public class MD extends Sprite
	{
		public function MD()
		{
			Debugger.log(Debugger.INFO, "[MD]", "Monster Debugger模块[版本1.0.0]已经初始化");
			
			MonsterDebugger.initialize(Context.stage);
		}
		
	}
}