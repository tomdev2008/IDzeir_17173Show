package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 验证是否是内部审片版本
	 */	
	public class FileCheckADis173 extends FileState
	{
		public function FileCheckADis173()
		{
			super();
		}
		
		override public function enter():void {
//			if (Context.getContext(ContextEnum.SETTING)["type"] == Settings.PLAYER_TYPE_FILE_ZHANWAI &&
			if (Context.getContext(ContextEnum.SETTING)["type"] == PlayerType.F_ZHANWAI &&
				Context.variables["debug"] && Context.variables["skipAD"] == 1) {
				transcationData["adIs173"] = true;
			} else {
				transcationData["adIs173"] = false;
			}
			Debugger.tracer(Debugger.INFO, "[AD] is 173:" + transcationData["adIs173"]);
			complete();
		}
	}
}