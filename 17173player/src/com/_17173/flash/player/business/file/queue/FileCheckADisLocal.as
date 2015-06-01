package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	
	/**
	 * 是否是本地运行
	 */	
	public class FileCheckADisLocal extends FileState
	{
		public function FileCheckADisLocal()
		{
			super();
		}
		
		override public function enter():void {
			transcationData["adIsLocal"] = Context.variables["ref"].indexOf("file:") != -1;
			transcationData["adIsLocal"] = false;
			Debugger.tracer(Debugger.INFO, "[AD] is Local:" + transcationData["adIsLocal"]);
			complete();
		}
	}
	
}