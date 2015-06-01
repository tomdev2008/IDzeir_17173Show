package com._17173.flash.show.base.module.bottombar.view.login
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.CheckBox;
	import com._17173.flash.core.components.common.DefaultTextField;
	import com._17173.flash.core.components.common.LinkText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.LoginUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	/**
	 *普通登录板子 
	 * @author zhaoqinghao
	 * 
	 */	
	public class LoginNormalPane extends BaseContainer
	{
		private var _loginBtn:Button = null;
		private var _registerBtn:Button = null;
		private var _nameInput:DefaultTextField = null;
		private var _passwordInput:DefaultTextField = null;
		private var _getBackLabel:TextField = null;
		private var _autoLoginCheckBox:CheckBox = null;
		private var _links:Array = null;
		private var _showErrorTf:TextField = null;
		private var _bottomSp:Sprite = null;
		private var _valPane:ValedatePane = null;
		public var updateBack:Function = null;
		private var _linkPane:LoginLinkPane = null;
		public function LoginNormalPane()
		{
			super();
			init();
		}
		
		private function init():void{
			_linkPane = new LoginLinkPane();
			_links = [];
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			var txtbg:MovieClip = new Login_Input_Bg();
			txtbg.x = 0;
			txtbg.mouseChildren = false;
			this.addChild(txtbg);
			
			txtbg = new Login_Input_Bg();
			txtbg.y = 55;
			txtbg.mouseChildren = false;
			this.addChild(txtbg);
			//用户名icon
			var icon:MovieClip = new Login_IconPp();
			icon.x = 10;
			icon.y = 10;
			icon.mouseEnabled = false;
			this.addChild(icon);
			
			icon = new Login_IconLock();
			icon.x = 10;
			icon.y = 68;
			icon.mouseEnabled = false;
			this.addChild(icon);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x9774C6;
			textFormat.size = 14;
			textFormat.font = FontUtil.f;
			
			_nameInput = new DefaultTextField(lc.get("login_name_def","bottom"));
			_nameInput.x = 35;
			_nameInput.y = 5;
			_nameInput.width = 250;
			_nameInput.height = 30;
			_nameInput.multiline = false;
			_nameInput.defaultTextFormat = textFormat;
			_nameInput.setTextFormat(textFormat);
			_nameInput.tabEnabled = true;
			_nameInput.tabIndex = 0;
			this.addChild(_nameInput);
			
			textFormat = new TextFormat();
			textFormat.color = 0x9774C6;
			textFormat.size = 14;
			textFormat.font = FontUtil.f;
			_passwordInput = new DefaultTextField(lc.get("login_pwd_def","bottom"));
			_passwordInput.x = 35;
			_passwordInput.y = 60;
			_passwordInput.width = 250;
			_passwordInput.height = 30;
			_passwordInput.showPassWord = true;
			_passwordInput.multiline = false;
			_passwordInput.tabEnabled = true;
			_passwordInput.tabIndex = 1;
			_passwordInput.defaultTextFormat = textFormat;
			_passwordInput.setTextFormat(textFormat);
			_passwordInput.type = TextFieldType.INPUT;
			this.addChild(_passwordInput);
			
			textFormat = new TextFormat();
			textFormat.color = 0xFF0000;
			textFormat.size = 12;
			textFormat.font = FontUtil.f;
			_showErrorTf = new TextField();
			_showErrorTf.setTextFormat(textFormat);
			_showErrorTf.defaultTextFormat = textFormat;
			_showErrorTf.width = 260;
			_showErrorTf.x = 0;
			_showErrorTf.mouseEnabled = false;
			_showErrorTf.y = 100;
			_showErrorTf.visible = false;
			this.addChild(_showErrorTf);
			
			_bottomSp = new Sprite();
			_bottomSp.mouseEnabled = false;
			_bottomSp.x = 0;
			_bottomSp.y = 110;
			this.addChild(_bottomSp);
			
			_valPane = new ValedatePane();
			_valPane.y = 110;
			
			_autoLoginCheckBox = new CheckBox(lc.get("login_auto_label","bottom"),0x8B7D98);
			_autoLoginCheckBox.x = 0;
			_autoLoginCheckBox.y = 0;
			_autoLoginCheckBox.tabEnabled = false;
			_bottomSp.addChild(_autoLoginCheckBox);
			_autoLoginCheckBox.selected = true;
			
			//找回密码
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.size = 12;
			_getBackLabel = new TextField();
			_getBackLabel.x = _autoLoginCheckBox.x + 235;
			_getBackLabel.y = -4;
			_getBackLabel.width = 80;
			_getBackLabel.text = lc.get("login_forget_labe","bottom");
			_getBackLabel.height = 25;
			_getBackLabel.width = _getBackLabel.textWidth + 4;
			_getBackLabel.height = _getBackLabel.textHeight + 4;
			_getBackLabel.selectable = false;
			_getBackLabel.tabEnabled = false;
			_getBackLabel.defaultTextFormat = textFormat;
			_getBackLabel.setTextFormat(textFormat);
			_getBackLabel.multiline = false;
			//点击弹出找回密码
			var forget:LinkText = new LinkText(_getBackLabel);
			forget.tabEnabled = false;
			forget.addEventListener(MouseEvent.CLICK,onForgetClick);
			ui.registerTip(forget,lc.get("for_get_tip","bottom"));
			_bottomSp.addChild(forget);
			
			_loginBtn = new Button(lc.get("login_login_labe","bottom"));
			_loginBtn.setSkin(new Skin_login_bg())
			_loginBtn.width = 130;
			_loginBtn.height = 35;
			_loginBtn.x = 0;
			_loginBtn.y = 25;
			_loginBtn.tabEnabled = false;
			_loginBtn.tabIndex = 2;
			_loginBtn.addEventListener(MouseEvent.CLICK,onLoginClick);
//			ui.registerTip(_loginBtn,lc.get("login_tip","common"));
			_bottomSp.addChild(_loginBtn);
			
			_registerBtn = new Button("<font color='#8b7d98'>"+lc.get("login_reg_labe","bottom")+"</font>");
			_registerBtn.setSkin(new Skin_login_sb())
			_registerBtn.width = 130;
			_registerBtn.height = 35;
			_registerBtn.x = 170;
			_registerBtn.y = 25;
			_registerBtn.tabIndex = 3;
			_registerBtn.tabEnabled = false;
			_registerBtn.addEventListener(MouseEvent.CLICK,onRegisterClick);
//			ui.registerTip(_registerBtn,lc.get("register_tip","bottom"));
			_bottomSp.addChild(_registerBtn);
			
			//初始化快捷链接 //以后可使用文件配置
			JSBridge.addCall("loginStart", null, null, rLoginStrart,true);
			JSBridge.addCall("loginFailure", null, null, rLoginFailure,true);
			JSBridge.addCall("showCheckNum", null, null, onUrlBack,true);
			
			_linkPane.x = 382;
			this.addChild(_linkPane);
		}
		private function onFocusIn(e:FocusEvent):void{
			_nameInput.tabIndex = _passwordInput.tabIndex+1;
		}
		private function onFocusIn1(e:FocusEvent):void{
			_passwordInput.tabIndex = _nameInput.tabIndex+1;
		}
		
		private function onPwdOut(e:FocusEvent):void{
			var pwd:String = _passwordInput.text;
			if(pwd.length == 0){
				return;
			}
			JSBridge.addCall("showFlash.setPwd",pwd);
		}
		
		private function onNameOut(e:FocusEvent):void{
			var name:String = _nameInput.text;
			if(name.length == 0){
				return;
			}
			JSBridge.addCall("showFlash.setName",name);
		}
		override protected function onShow():void{
			_nameInput.tabIndex = 1;
			_passwordInput.tabIndex = 2;
			_passwordInput.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			_passwordInput.addEventListener(FocusEvent.FOCUS_OUT,onPwdOut);
			_nameInput.addEventListener(FocusEvent.FOCUS_IN,onFocusIn1);
			_nameInput.addEventListener(FocusEvent.FOCUS_OUT,onNameOut);
			Context.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			super.onShow();
		}
		
		override protected function onHide():void{
			_passwordInput.removeEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			_nameInput.removeEventListener(FocusEvent.FOCUS_IN,onFocusIn1);
			Context.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			_passwordInput.removeEventListener(FocusEvent.FOCUS_OUT,onPwdOut);
			_nameInput.removeEventListener(FocusEvent.FOCUS_OUT,onNameOut);
			super.onHide();
		}
		
		private function onKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER){
				onLoginClick();
			}
		}
		
		private function onLoginClick(e:Event = null):void{
//			testLogin();
//			return;
			
			var name:String = _nameInput.text;
			var pwd:String = _passwordInput.text;
			var auto:Boolean = _autoLoginCheckBox.selected;
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var val:String = "";
			if(name.length == 0){
				//提示用户名密码不能为空
//				ui.popupAlert(local.get("system_title","components"),local.get("login_name_null","bottom"),Alert.ICON_STATE_FAIL,Alert.BTN_OK);
				return;
			}
			if(pwd.length == 0){
				//提示用户名密码不能为空
//				ui.popupAlert(local.get("system_title","components"),local.get("login_pwd_null","bottom"),Alert.ICON_STATE_FAIL,Alert.BTN_OK);
				return;
			}
			if(_valPane && this.contains(_valPane)){
				val = _valPane.code;
				if( val == null || val == "" ){
					
					return;
				}
			}
			//调用js 传参数
			var data:Object = new Object();
			data.userName = name;
			data.pwd = pwd;
			data.persistent = auto;
			data.checkNum = val;
			JSBridge.addCall("showFlash.login",data);
			Debugger.log(Debugger.INFO, "[js]", "调用登录js");
		}
		
		
		private function testLogin():void{
			_showErrorTf.text = "wefewfewfewfewfewf";
			_showErrorTf.visible = true;
			updateBottomPos();
//			onUrlBack(["https://passport.17173.com/captcha/","https://passport.17173.com/captcha?refresh=1"],"fwefewf");
		}
		/**
		 *登录中 
		 * @param param
		 * 
		 */		
		private function rLoginStrart(param:Object = null):void{
			Debugger.log(Debugger.INFO, "[js]", "登录中（js回调）  loginStart param" + param);
			//load;
		}
		
		/**
		 *登录失败 
		 * @param param
		 * 
		 */		
		private function rLoginFailure(param:Object):void{
			Debugger.log(Debugger.INFO, "[js]", "登录中（js回调）loginFailure  param" + param);
//			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
//			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
//			ui.popupAlert(local.get("system_title","components"),param as String,-1,Alert.BTN_OK);
			_showErrorTf.text = param as String;
			_showErrorTf.visible = true;
			updateBottomPos();
		}
		/**
		 *显示验证码 
		 * @param param
		 * 
		 */		
		private function onUrlBack(url:Array = null,msg:String = null):void{
			Debugger.log(Debugger.INFO, "[Login]", "验证码:",url[0],url[1]);
			_valPane.load(url[0],url[1]);
			if(msg !=null){
				_showErrorTf.text = msg as String;
				_showErrorTf.visible = true;
			}
			showValePanel();
		}
		
		private function onRegisterClick(e:Event):void{
			//跳转注册 并注册完返回首页
			Util.toUrl(LoginUtil.getRegUrl());
		}
		
		private function onForgetClick(e:Event):void{
			//跳转找回
			Util.toUrl(SEnum.URL_FORGET);
		}
		
		private function showValePanel():void{
			this.addChild(_valPane);
			updateBottomPos();
		}
		private function updateBottomPos():void{
			var tmpY:int = 110;
			if(_showErrorTf.visible){
				tmpY = 125;
			}
			if(this.contains(_valPane)){
				_valPane.y = 110;
				tmpY += 50;
			}
			_showErrorTf.y = tmpY - 25;
			_bottomSp.y = tmpY;
			updateBack(tmpY - 110);
		}
	}
}