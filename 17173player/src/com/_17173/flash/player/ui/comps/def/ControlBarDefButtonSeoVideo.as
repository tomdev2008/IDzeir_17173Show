package com._17173.flash.player.ui.comps.def
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.Sprite;
	
	public class ControlBarDefButtonSeoVideo extends Sprite
	{
		private var _e:IEventManager;
		
		public function ControlBarDefButtonSeoVideo()
		{
			super();
			
			init();
			addEventListeners();
		}
		
		private function init():void
		{
			_e = (Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager);
		}
		
		private function addEventListeners():void {
			_e.listen(PlayerEvents.BI_GET_VIDEO_INFO, resetDef);
		}
		
		private function resetDef(data:Object):void {
			var videoData:FileVideoData = data as FileVideoData;
			var allDef:String = videoData.getAllDef();
			var autoDef:String = Util.getAutoDef(1);//根据要求，默认标清
			Debugger.log(Debugger.INFO, "[defButton]清晰度状态" + "  all:" + allDef + "   autoDef:" + autoDef);
			var def:String = "";
			
			if (Context.variables.hasOwnProperty("def") && Context.variables["def"] && allDef.search(Context.variables["def"]) != -1) {
				//如果flashvars里面有设置，那么使用flashvars的
				def = Context.variables["def"];
				Debugger.log(Debugger.INFO, "[defButton] use flashvars");
			} else {
				def = videoData.defaultDef;
				if(allDef.search(autoDef) != -1)
				{
					def = autoDef;
					Debugger.log(Debugger.INFO, "[defButton] use auto:" + def);
				}
				else
				{
					def = videoData.defaultDef;
					Debugger.log(Debugger.INFO, "[defButton] use def:" + def);
				}
			}
			videoData.defaultDef = def;
			Context.getContext(ContextEnum.SETTING)["def"] = def;
		}
		
	}
}