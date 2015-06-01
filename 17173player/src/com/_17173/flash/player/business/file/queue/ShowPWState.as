package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	public class ShowPWState extends FileState
	{
		public function ShowPWState()
		{
			super();
		}
		
		override public function enter():void {
			if (Util.validateObj(transcationData, "error")) {
				complete();
			} else {
				if (Util.validateObj(transcationData, "videoData") && transcationData["videoData"]) {
					var obj:Object = Context.variables;
//					if (Global.settings.debug && Global.settings.params["skipPW"]) {
					if (Context.variables["debug"] && Context.variables["skipPW"]) {
						Debugger.tracer(Debugger.INFO, "跳过密码");
						passWordSuccess(null);
					} else if (!transcationData["videoData"]["isEncrypt"]) {
						Debugger.tracer(Debugger.INFO, "不需要密码");
						passWordSuccess(null);
					} else {
						Debugger.tracer(Debugger.INFO, "验证密码");
						var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
						e.send(PlayerEvents.UI_HIDE_PT);
						e.send(PlayerEvents.SHOW_PASS_WORD);
						e.listen(PlayerEvents.HIDE_PASS_WORD, passWordSuccess);
					}
				} else {
					complete();
				}
			}
		}
		
		/**
		 * 密码验证完成
		 */		
		private function passWordSuccess(data:Object):void {
			Debugger.tracer(Debugger.INFO, "密码验证完成");
			transcationData["isPwValidated"] = true;
			complete();
		}
		
	}
}