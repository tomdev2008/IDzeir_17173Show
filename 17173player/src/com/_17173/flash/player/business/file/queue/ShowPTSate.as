package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	
	public class ShowPTSate extends FileState
	{
		public function ShowPTSate()
		{
			super();
		}
		
		override public function enter():void {
//			(Context.getContext(ContextEnum.UI_MANAGER) as UIManager).showPT();
			Context.getContext(ContextEnum.UI_MANAGER).showPT();
			complete();
		}
	}
}