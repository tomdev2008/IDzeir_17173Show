package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.file.FileBusinessJSDelegate;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.business.file.FileUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.file.FileBackRecommend;
	
	import flash.display.StageDisplayState;
	
	public class FileCustomerUIManager extends FileUIManager
	{
		public function FileCustomerUIManager()
		{
			super();
		}
		
		override protected function onShowBackRecommand(data:Object):void {
//			if(Global.settings.params.hasOwnProperty("skipBR") && Global.settings.params["skipBR"])
			if (Context.variables.hasOwnProperty("skipBR") && Context.variables["skipBR"])
			{
				Debugger.log(Debugger.INFO, "内部版本，跳过后推!");
				return;
			}
			
			var uiModule:Object = Context.variables["UIModuleData"];
			if (uiModule && !uiModule[FileCustomerDataRetriver.M9]) {
				Debugger.log(Debugger.INFO, "未配置后推!");
				return;
			}
			
			var js:FileBusinessJSDelegate = Context.getContext(ContextEnum.JS_DELEGATE) as FileBusinessJSDelegate;
			var showFlag:Boolean = js.getPlayNextState();
			if(showFlag)
			{
//				Global.settings.params["showBackRec"] = true;
				Context.variables["showBackRec"] = true;
				if (_backRec == null) {
					_backRec = new FileBackRecommend();
				}
				_backRecLayer.clear();
				_backRecLayer.addChild(_backRec);
			} else {
				//如果在连播状态下，全屏有的浏览器不会自动退出
//				if(Global.settings.isFullScreen)
				if(Context.getContext(ContextEnum.SETTING).isFullScreen)
				{
					Context.stage.displayState = StageDisplayState.NORMAL;
				}
			}
		}
	}
}