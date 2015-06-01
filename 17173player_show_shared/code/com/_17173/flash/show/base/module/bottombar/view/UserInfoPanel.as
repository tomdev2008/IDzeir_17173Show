package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 *用户信息板 
	 * @author zhaoqinghao
	 * 
	 */	
	public class UserInfoPanel extends SkinComponent
	{
		
		private var _changeNameBtn:Button = null;
		/**
		 *充值 
		 */		
		private var _rechargeBtn:Button = null;
		/**
		 *兑换 
		 */		
		private var _exchangeBtn:Button = null;
		/**
		 *用户中心 
		 */		
		private var _userCenter:OnlyLabelButton = null;
		private var _changeFace:OnlyLabelButton = null;
		private var _logout:OnlyLabelButton = null;
		private var _nameInput:TextField = null;
		private var _leMoneyLabel:TextField = null;
		private var _leDouLabel:TextField = null;
		private var _loadData:Boolean = false;
		private var _needRcLabel:TextField = null;
		private var _needMcLabel:TextField = null;
		private var _tmpName:String = null;
		/**
		 *艺人等级 
		 */		
		private var _yyLevel:MovieClip = null;
		/**
		 *财富等级 
		 */		
		private var _moneyLevel:MovieClip = null;
		private const NAME_LIMIT:int = 16;
		/**
		 *处于特殊状态，不能自动关闭界面 
		 */		
		private var noClose:Boolean = false;
		private var _starLvl:Sprite;
		private var _richLvl:Sprite;
		/**
		 *下一等级icon 
		 */		
		private var _starNextLvl:Sprite;
		private var _richNextLvl:Sprite;
		public function UserInfoPanel()
		{
			super();
			setSkin_Bg(new Bottom_UserInfoBg1());
		}
		
		override protected function onInit():void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			super.onInit();
			
			this.width = 310;
			this.height = 300;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.font = FontUtil.f;
			textFormat.size = 14;
			var tmpTf:TextField = new TextField();
			tmpTf.x = 18;
			tmpTf.y = 17;
			tmpTf.text = "我的昵称：";
			tmpTf.width = 75;
			tmpTf.height = 25;
			tmpTf.setTextFormat(textFormat);
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.mouseEnabled = false;
			this.addChild(tmpTf);
			
			
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.font = FontUtil.f;
			textFormat.size = 14;
			
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.font = FontUtil.f;
			textFormat.size = 14;
			tmpTf = new TextField();
			tmpTf.x = 18;
			tmpTf.y = 65;
			tmpTf.text = "财富等级：";
			tmpTf.width = 75;
			tmpTf.height = 25;
			tmpTf.setTextFormat(textFormat);
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.mouseEnabled = false;
			this.addChild(tmpTf);
			
			
			tmpTf = new TextField();
			tmpTf.x = 129;
			tmpTf.y = 65;
			tmpTf.text = "距";
			tmpTf.width = 75;
			tmpTf.height = 25;
			tmpTf.setTextFormat(textFormat);
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.mouseEnabled = false;
			this.addChild(tmpTf);
			
			_needRcLabel = new TextField();
			_needRcLabel.x = 184;
			_needRcLabel.y = 65;
			_needRcLabel.text = "dddddddddddddd";
			_needRcLabel.width = 120;
			_needRcLabel.height = 25;
			_needRcLabel.setTextFormat(textFormat);
			_needRcLabel.defaultTextFormat = textFormat;
			_needRcLabel.mouseEnabled = false;
			this.addChild(_needRcLabel);
			
			tmpTf = new TextField();
			tmpTf.x = 18;
			tmpTf.y = 102;
			tmpTf.text = "艺人等级：";
			tmpTf.width = 75;
			tmpTf.height = 25;
			tmpTf.setTextFormat(textFormat);
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.mouseEnabled = false;
			this.addChild(tmpTf);
			
			tmpTf = new TextField();
			tmpTf.x = 129;
			tmpTf.y = 102;
			tmpTf.text = "距";
			tmpTf.width = 75;
			tmpTf.height = 25;
			tmpTf.setTextFormat(textFormat);
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.mouseEnabled = false;
			this.addChild(tmpTf);
			
			_needMcLabel = new TextField();
			_needMcLabel.x = 184;
			_needMcLabel.y = 102;
			_needMcLabel.text = "33333333333";
			_needMcLabel.width = 120;
			_needMcLabel.height = 25;
			_needMcLabel.setTextFormat(textFormat);
			_needMcLabel.defaultTextFormat = textFormat;
			_needMcLabel.mouseEnabled = false;
			this.addChild(_needMcLabel);
			
			
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.font = FontUtil.f;
			textFormat.size = 14;
			_leMoneyLabel = new TextField();
			_leMoneyLabel.x = 18;
			_leMoneyLabel.y = 160;
			_leMoneyLabel.width = 190;
			_leMoneyLabel.height = 25;
			_leMoneyLabel.name = "账户乐币：";
			_leMoneyLabel.setTextFormat(textFormat);
			_leMoneyLabel.defaultTextFormat = textFormat;
			_leMoneyLabel.mouseEnabled = false;
			this.addChild(_leMoneyLabel);
			
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.font = FontUtil.f;
			textFormat.size = 14;
			_leDouLabel = new TextField();
			_leDouLabel.x = 18;
			_leDouLabel.y = 200;
			_leDouLabel.name = "账户乐豆：";
			_leDouLabel.width = 190;
			_leDouLabel.height = 25;
			_leDouLabel.setTextFormat(textFormat);
			_leDouLabel.defaultTextFormat = textFormat;
			_leDouLabel.mouseEnabled = false;
			this.addChild(_leDouLabel);
			
			
			
			//名字框背景
			var bg:MovieClip =new Login_Input_Bg();
			bg.x = 91;
			bg.y = 14;
			bg.width = 120;
			bg.height = 30;
			bg.mouseEnabled = false;
			this.addChild(bg);
			
			textFormat = new TextFormat();
			textFormat.color = 0x9774C6;
			textFormat.size = 14;
			textFormat.font = FontUtil.f;
			_nameInput = new TextField();
			_nameInput.x = bg.x + 4;
			_nameInput.y = bg.y + 3;
			_nameInput.width = 115;
			_nameInput.height = 25;
			_nameInput.text = "";
			_nameInput.multiline = false;
			_nameInput.defaultTextFormat = textFormat;
			_nameInput.setTextFormat(textFormat);
			_nameInput.type = TextFieldType.INPUT;
			this.addChild(_nameInput);
			
			
			_changeNameBtn = new Button("<font color='#8b7d98'>确 定</font>");
			_changeNameBtn.setSkin(new Button_ChangeBg());
			_changeNameBtn.x = 235;
			_changeNameBtn.y = 14;
			_changeNameBtn.width = 60;
			_changeNameBtn.height = 30;
			this.addChild(_changeNameBtn);
//			ui.registerTip(_changeNameBtn,lc.get("chengName_tip","bottom"))
			
			_rechargeBtn = new Button("充 值");
			_rechargeBtn.setSkin(new Button_ChongzhiBg())
			_rechargeBtn.x = 235;
			_rechargeBtn.y = 151;
			_rechargeBtn.width = 60;
			_rechargeBtn.height = 30;
			this.addChild(_rechargeBtn);
//			ui.registerTip(_rechargeBtn,lc.get("money_tip","bottom"))
				
			_exchangeBtn = new Button("兑 换");
			_exchangeBtn.setSkin(new Button_ChongzhiBg())
			_exchangeBtn.x = 235;
			_exchangeBtn.y = 193;
			_exchangeBtn.width = 60;
			_exchangeBtn.height = 30;
			this.addChild(_exchangeBtn);
//			ui.registerTip(_exchangeBtn,lc.get("duihuan_tip","bottom"))
			
			_userCenter = new OnlyLabelButton("个人中心");
			_userCenter.x = 11;
			_userCenter.y = 260;
			_userCenter.width = 63;
			_userCenter.height = 21;
			this.addChild(_userCenter);
			ui.registerTip(_userCenter,lc.get("userCenter_tip","bottom"))
			
			_changeFace = new OnlyLabelButton("修改头像");
			_changeFace.x = 94;
			_changeFace.y = 260;
			_changeFace.width = 63;
			_changeFace.height = 21;
			this.addChild(_changeFace);
			ui.registerTip(_changeFace,lc.get("faceChange_tip","bottom"))
			
			_logout = new OnlyLabelButton("退出");
			_logout.x = 237;
			_logout.y = 260;
			_logout.width = 63;
			_logout.height = 21;
			this.addChild(_logout);
			ui.registerTip(_logout,lc.get("logout_tip","bottom"))
			//监听登出错误
			JSBridge.addCall("logoutFailure", null, null, rLogoutFailure,true);
			
			loadIcon();
		}
		
		private function loadIcon():void{
			var user:IUserData = (Context.getContext(CEnum.USER) as IUser).me;
			var path:String = "assets/img/level/cflv"+user.richLevel+".png";
			if(_richLvl && _richLvl.parent){
				_richLvl.parent.removeChild(_richLvl);
			}
			_richLvl = Utils.getURLGraphic(path, true, 30, 16) as Sprite;
			_richLvl.x = 92;
			_richLvl.y = 70;
			this.addChild(_richLvl);
			
			
			path = "assets/img/level/lv"+user.starLevel+".png"
			if(_starLvl && _starLvl.parent){
				_starLvl.parent.removeChild(_starLvl);
			}
			_starLvl = Utils.getURLGraphic(path, true, 30, 16) as Sprite;
			_starLvl.x = 92;
			_starLvl.y = 105;
			this.addChild(_starLvl);
			//加载下个等级
			
			path = "assets/img/level/cflv"+user.nextFanLevel+".png"
			if(_richNextLvl && _richNextLvl.parent){
				_richNextLvl.parent.removeChild(_richNextLvl);
			}
			_richNextLvl = Utils.getURLGraphic(path, true, 30, 16) as Sprite;
			_richNextLvl.x = 152;
			_richNextLvl.y = 70;
			this.addChild(_richNextLvl);
			
			path = "assets/img/level/lv"+user.nextMasterLevel+".png"
			if(_starNextLvl && _starNextLvl.parent){
				_starNextLvl.parent.removeChild(_starNextLvl);
			}
			_starNextLvl = Utils.getURLGraphic(path, true, 30, 16) as Sprite;
			_starNextLvl.x = 152;
			_starNextLvl.y = 105;
			this.addChild(_starNextLvl);
			
		
		}
		
		override protected function onShow():void{
			super.onShow();
			updateInfo();
			loadMeInfo();
			_changeNameBtn.addEventListener(MouseEvent.CLICK,onClick);
			_rechargeBtn.addEventListener(MouseEvent.CLICK,onClick);
			_exchangeBtn.addEventListener(MouseEvent.CLICK,onClick);
			_userCenter.addEventListener(MouseEvent.CLICK,onClick);
			_changeFace.addEventListener(MouseEvent.CLICK,onClick);
			_logout.addEventListener(MouseEvent.CLICK,onClick);
			Context.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		override protected function onHide():void{
			super.onHide();
			//每次打开页面从新请求自己数据
			_changeNameBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_rechargeBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_exchangeBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_userCenter.removeEventListener(MouseEvent.CLICK,onClick);
			_changeFace.removeEventListener(MouseEvent.CLICK,onClick);
			_logout.removeEventListener(MouseEvent.CLICK,onClick);
			Context.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
		}
		/**
		 *如果点击了屏幕 则关闭 
		 * @param e
		 * 
		 */		
		private function onStageClick(e:Event):void{
			if(!Utils.checkIsChild(e.target as DisplayObject,this) && !noClose){
				hide();
			}
		}
		
		private function loadMeInfo():void{
			if(_loadData == false){
				_loadData = true;
				var server:IServiceProvider = Context.getContext(CEnum.SERVICE);
				server.http.getData(
					SEnum.GET_USER, 
					null, 
					onUserDataBack,onUserDataFail);
			}
		}
		private function onUserDataFail(data:Object):void{
			_loadData = false;
		}
		private function onUserDataBack(data:Object):void{
			_loadData = false;
			IUser(Context.getContext(CEnum.USER)).addUserFromData(data);
			updateInfo();
		}
		
		private function onClick(e:Event):void{
			var button:Button = e.currentTarget as Button;
			switch(button)
			{
				case _changeNameBtn://修改名字
				{
					onChangeName();
					break;
				}
				case _rechargeBtn://充值
				{
					Util.toUrl(SEnum.URL_MONEY);
					break;
				}
				case _exchangeBtn://兑换
				{
					Util.toUrl(SEnum.URL_EXCHANGE);
//					
					break;
				}
				case _userCenter://用户中心
				{
					Util.toUrl(SEnum.URL_UCENTER);
					
					break;
				}
				case _changeFace://修改头像
				{
					Util.toUrl(SEnum.URL_CHANGEFACE);
					break;
				}
				case _logout:
				{
					hide();
					//注销登录
					JSBridge.addCall("showFlash.loginOut");
					Debugger.log(Debugger.INFO, "[js]", "调用登录js:","showFlash.loginOut");
					break;
				}
			}
		}
		
		override protected function onUpdate():void{
			updateInfo();
		}
		/**
		 *点击修改名字 
		 * 
		 */		
		private function onChangeName():void{
			var name:String = _nameInput.text;
			if(Utils.checkStrLength(name) > NAME_LIMIT){
				noClose = true;
				var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.popupAlert(local.get("system_title","components"),local.get("name_limit","bottom"),-1,Alert.BTN_OK,changeStatus,changeStatus);
			}else{
				var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
				//提交数据
				var data:Object = {};
				data.name = name;
				_tmpName = name;
				data.result = "json";
				data.roomId = (Context.variables["showData"] as ShowData).roomID;
				server.http.getData(SEnum.RENAME,data,onSecc);
			}
		}
		
		private function changeStatus():void{
			noClose = false;
		}
		
		private function onSecc(obj:Object):void{
			//发送事件通知名字改变
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			user.addUserFromData({userName:_tmpName,userId:user.me.id});
//			//更新用户名字
//			updateInfo();
		}
		
		/**
		 *登出失败 
		 * @param param
		 * 
		 */		
		private function rLogoutFailure(param:Object = null):void{
			Debugger.log(Debugger.INFO, "[js]", "登出失败（js回调） param" + param);
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			ui.popupAlert(local.get("system_title","components"),param as String,-1,Alert.BTN_OK);
		}
		
		
		/**
		 *用户信息更新 
		 * 
		 */		
		private function updateInfo():void{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var ud:IUserData = user.me as IUserData;
			_nameInput.text = ud.name;
			//更新财富等级艺人等级
			var money:int = ud.jinbi;
			var dou:int = ud.jindou;
			var nRich:String = ud.fanOffset;
			var nStar:String = ud.masterOffset;
			_leMoneyLabel.htmlText = "账户乐币：<font size='14' color='#E0D269'>" + money + "</font>乐币";
			_leDouLabel.htmlText = "账户乐豆：<font size='14' color='#E0D269'>" + dou + "</font>乐豆";
			loadIcon();
			//生成还差多少升级
			_needRcLabel.htmlText = "差 <font size='14' color='#E0D269'>" + nRich + "</font> 乐币";
			_needMcLabel.htmlText = "差 <font size='14' color='#E0D269'>" + nStar + "</font> 乐豆";
		}
	}
}