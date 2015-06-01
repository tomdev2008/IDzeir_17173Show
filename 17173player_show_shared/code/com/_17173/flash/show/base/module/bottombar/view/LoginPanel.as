package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.show.base.module.bottombar.view.login.LoginNormalPane;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *登录 
	 * @author zhaoqinghao
	 * 
	 */	
	public class LoginPanel extends BasePanel
	{
		private var _loginLabel:TextField = null;
		private var _loginLine:MovieClip = null;
		private var _loginNormal:LoginNormalPane = null;
		private var _titleLine:MovieClip = null;
		public function LoginPanel()
		{
			super();
			this.width = 615;
			this.height = 300;
			this.mouseEnabled = false;
			initLine();
		}
		
		override protected function onInit():void{
			super.onInit();
			initLogo();
			initChangeLogin();
			setSkin_Bg(new Login_Bg());
			setSkin_Close(new Login_Close_MC());
			this.skinVo.updateSkinState("hideLine");
		}
		
		
		override protected function onRePosition():void{
			super.onRePosition();
			_titleLine.width  = this.width;
		}
		
		protected function initLine():void{
			_titleLine = new Line_Normal();
			_titleLine.x = 1;
			_titleLine.y = 70;
			_titleLine.mouseEnabled = false;
			this.addChild(_titleLine);
		}
		
		private function initLogo():void{
			var logo:MovieClip = new Logo_video();
			logo.x = 52;
			logo.y = 41;
			logo.mouseEnabled = false;
			this.addChild(logo);
		}
		/**
		 *登录方式 
		 * 
		 */		
		private function initChangeLogin():void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x9774C6;
			textFormat.font = FontUtil.f;
			//登录方式，普通
			_loginLabel = new TextField();
			_loginLabel.x = 550;
			_loginLabel.y = 44;
			_loginLabel.text = "通行证";
			_loginLabel.selectable = false;
			_loginLabel.setTextFormat(textFormat);
			_loginLabel.defaultTextFormat = textFormat;
			this.addChild(_loginLabel);
			
			_loginLine = new Login_Line();
			_loginLine.x = 551;
			_loginLine.y = 69;
			_loginLine.mouseEnabled = false;
			this.addChild(_loginLine);
			
			_loginNormal = new LoginNormalPane();
			_loginNormal.x = 40;
			_loginNormal.y = 100;
			_loginNormal.updateBack = changeHeightBg;
			this.addChild(_loginNormal);
		}
		
		public function changeHeightBg(h:int):void{
			this.height = 300 + h;
			this.y = (Context.stage.stageHeight - height)/2;
		}
	}
}