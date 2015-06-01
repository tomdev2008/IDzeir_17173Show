package com._17173.flash.player.module.extrarecommand
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;
	
	/**
	 * 直播下底推荐位
	 *  
	 * @author shunia-17173
	 */	
	public class ToolRC extends Sprite
	{
		
		public function ToolRC()
		{
			super();
			
			var ver:String = "1.0.1";
			Debugger.log(Debugger.INFO, "[toolrc]", "直播推荐位模块[版本:" + ver + "]初始化!");
			
			var s:ISkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
			var extraBar:ISkinObject = s.getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			extraBar.call("addItem", new ToolRCView());
		}
		
	}
}