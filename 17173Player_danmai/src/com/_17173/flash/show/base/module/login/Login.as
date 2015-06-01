package com._17173.flash.show.base.module.login
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.bottombar.view.LoginPanel;
	import com._17173.flash.show.model.CEnum;
	
	public class Login extends BaseModule
	{
		public function Login()
		{
			super();
//			Context.getContext(CEnum.EVENT).listen(SEvents.LOGINPANEL_SHOW,onShowLogin);
//			Context.getContext(CEnum.EVENT).listen(SEvents.LOGINPANEL_HIDE,hideLogin);
		}
		private var _loginPanel:LoginPanel = null;
		
		private function onShowLogin(data:Object = null):void{
			showHideLogin(1);
		}
		
		private function hideLogin(data:Object = null):void{
			showHideLogin(2);
		}
		
		/**
		 *打开关闭登录界面 
		 * state  0 自动；1打开；2关闭；  
		 */		
		public function showHideLogin(state:int = 0):void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			//通知js 通知js进行登录初始化准备
			JSBridge.addCall("showFlash.onLoginInit");
			if(state == 0){
				if(_loginPanel == null){
					_loginPanel = new LoginPanel();
				}
				if(_loginPanel.parent){
					_loginPanel.hide();
				}else{
					ui.popupAlertPanel(_loginPanel);
				}
			}else if(state == 1){
				if(_loginPanel == null){
					_loginPanel = new LoginPanel();
				}
				if(_loginPanel.parent == null){
					ui.popupAlertPanel(_loginPanel);
				}
			}else if(state == 0){
				if(_loginPanel && _loginPanel.parent){
					_loginPanel.hide();
				}
			}
			
		}
	}
}