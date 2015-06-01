package com._17173.flash.show.base.module.leftbar.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.utils.LoginUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class LoginReg extends Sprite
	{
		public function LoginReg()
		{
			super();
			init();
		}
		
		private function init():void{
			this.graphics.drawRect(0,0,48,50);
			
			var btn:Button = new Button("登录");
			btn.setSkin(new Skin_Btn_Login());
			btn.addEventListener(MouseEvent.CLICK,onLogin);
			this.addChild(btn);
			
			var btn1:Button = new Button("注册");
			btn1.y = 25;
			btn1.setSkin(new Skin_bg_reg());
			btn1.addEventListener(MouseEvent.CLICK,onRegs);
			this.addChild(btn1);
		}
		
		protected function onRegs(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//跳转注册 并注册完返回首页
			Util.toUrl(LoginUtil.getRegUrl());
		}
		
		protected function onLogin(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
		}
	}
}