package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.module.PluginEnum;

	public class ShowRecState extends FileState
	{
		public function ShowRecState()
		{
			super();
		}
		
		override public function enter():void {
			if (Context.stage.stageWidth >= PlayerScope.PLAYER_WIDTH_6 && Context.stage.stageHeight >= PlayerScope.PALYER_HEIGHT_4) {
				var showRec:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.SHOW_REC);
			}
			complete();
		}
	}
}