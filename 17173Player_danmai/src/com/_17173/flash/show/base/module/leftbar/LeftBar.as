package com._17173.flash.show.base.module.leftbar
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.plugbutton.IconAlignType;
	import com._17173.flash.show.base.components.common.plugbutton.MenuButton;
	import com._17173.flash.show.base.components.common.plugbutton.PlugButton;
	import com._17173.flash.show.base.components.common.plugbutton.PlugButtonBar;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.module.bottombar.view.UserInfoPanel;
	import com._17173.flash.show.base.module.leftbar.ui.HeadBtn;
	import com._17173.flash.show.base.module.leftbar.ui.LoginReg;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LeftBar extends BaseModule
	{
		private var backHome:MenuButton;
		private var headBtn:HeadBtn;
		private var userLift:MenuButton;
		private var mnPic:MenuButton;
		private var loginReg:LoginReg;
		private var dating:MenuButton;
		private var plugBtns:PlugButtonBar;
		private var actBtns:PlugButtonBar;
		private var bars:VGroup;
		private var _bg:MovieClip;
		private var _userInfoPanel:UserInfoPanel = null;
		
		public function LeftBar()
		{
			super();
			initMenu();
		}
		
		
		private function initMenu():void{
			//背景
			_bg = new LeftBar_bg();
			this.addChild(_bg);
			
			//返回首页功能按钮
			backHome = new MenuButton("showye","首 页",new Icon_mic(),IconAlignType.TOP);
			backHome.width = 48;
			backHome.height = 57;
			backHome.x = 2;
			backHome.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(backHome);
//			var link:MovieClip = new Bg_line();
//			link.y = 58;
//			this.addChild(link);
			bars = new VGroup();
			bars.gap = 5;
			bars.x = 2;
			bars.y = 58;
			this.addChild(bars);
			
			
			//用户信息
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var showData:Object = Context.variables["showData"];
			if(showData.masterID !=null && int(showData.masterID) > 0){ //登录显示头像
				headBtn = new HeadBtn();
				headBtn.user = user.me;
				headBtn.height = 60;
				headBtn.addEventListener(MouseEvent.CLICK,onClick);
				bars.addChild(headBtn);
			}else{  //未登录显示登录注册
				loginReg = new LoginReg();
				bars.addChild(loginReg);
			}
			//大厅功能
			dating = new MenuButton(SEvents.LOBBY_SWITCH,"直播大厅",new Icon_tv(),IconAlignType.TOP);
			dating.addEventListener(MouseEvent.CLICK,onClick);
			bars.addChild(dating);
			
			userLift = new MenuButton(SEvents.OPEN_USER_LIST,"用户列表",new Icon_mb(),IconAlignType.TOP);
			userLift.addEventListener(MouseEvent.CLICK,onClick);
			bars.addChild(userLift);
			
			plugBtns =  new PlugButtonBar(Context.getContext(CEnum.EVENT),false,0);
			bars.addChild(plugBtns);
			
			
			mnPic = new MenuButton(SEvents.OPEN_MN_PIC,"美女图片",new Icon_mn(),IconAlignType.TOP);
			mnPic.order = 100;
			plugBtns.addButton(mnPic);
			plugBtns.update();
			
			//添加空余
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xff000000,.01);
			sp.graphics.drawRect(0,0,48,48);
			sp.graphics.endFill();
			bars.addChild(sp);
			
			actBtns = new PlugButtonBar(Context.getContext(CEnum.EVENT),false,5);
			bars.addChild(actBtns);
			
			Context.stage.addEventListener(Event.RESIZE, onStageResize);
			
			
			var downPc:PlugButton = new PlugButton("downpc");
			downPc.setSkin(new Skin_Btn_downpc());
			actBtns.addButton(downPc);
			actBtns.update();
			bars.update();
			
			
//			Ticker.tick(3000,test);
			addLsn();
		}
		
		
		private function addLsn():void{
			var e:IEventManager = (Context.getContext(CEnum.EVENT) as IEventManager);
			e.listen(SEvents.OPEN_MN_PIC,onMvPic);
			e.listen("showye",showYe);
			e.listen("downpc",downPc);
		}
		
		private function downPc(e:Object):void
		{
			// TODO Auto Generated method stub
			Util.toUrl("http://v.17173.com/show/client");
		}
		
		private function onClick(e:Event):void{
			var btn:DisplayObject = e.currentTarget as DisplayObject;
			if(btn is PlugButton){
				var button:PlugButton = e.currentTarget as PlugButton;
				var type:String = button.eType;
				Context.getContext(CEnum.EVENT).send(SEvents.BOTTOM_BUTTON_CLICK,type);
				Context.getContext(CEnum.EVENT).send(type,button);
				e.stopImmediatePropagation();
				e.stopPropagation();
				closeSelfItem();
			}else{
				if(btn === backHome){
					Util.toUrl(SEnum.domain);
				}
				if(btn === headBtn){
					Context.getContext(CEnum.EVENT).send(SEvents.BOTTOM_BUTTON_CLICK,SEvents.USERINFO_CLICK);
					Context.getContext(CEnum.EVENT).send(SEvents.USERINFO_CLICK,button);
					showHideUserInfo();
				}
			}
			testSend();
		}
		
		private function showYe(data:Object):void{
			Util.toUrl(SEnum.home);
		}
		/**
		 *点击美女图片 
		 * @param data
		 * 
		 */		
		private function onMvPic(data:Object):void{
			Utils.toUrlAppedViD(SEnum.LINK_TO_818);
		}
		
		private function testSend():void{
//			Context.getContext(CEnum.EVENT).send(SEvents.SCENE_EFFECT,{});
//			Context.getContext(CEnum.EVENT).send(SEvents.GIFT_BIG_ENTER,new UserData());
		}
		
		private function closeSelfItem():void{
			if(_userInfoPanel && _userInfoPanel.parent){
				_userInfoPanel.hide();
			}
		}
		
		private function test():void{
			Context.getContext(CEnum.EVENT).send(SEvents.ADD_BOTTOM_BUTTON,new MenuButton("wefwef"+int(Math.random()*34),"系统设置",new Icon_mb(),IconAlignType.TOP));
			Ticker.tick(3000,test);
		}
		
		protected function onStageResize(event:Event):void
		{
			// TODO Auto-generated method stub
			_bg.height = Context.stage.stageHeight;
			bars.update();
		}		
		
		public function addButton(data:Object,isMenu:Boolean = true):void{
			try{
				if(isMenu){
					plugBtns.addButton(data as PlugButton);
					plugBtns.update();
				}else{
					actBtns.addButton(data as PlugButton);
					actBtns.update();
				}
					bars.update();
				
			}catch(e:Error){
				
			}
		}
		
		/**
		 *打开关闭用户信息 
		 * 
		 */		
		public function showHideUserInfo():void{
			if(_userInfoPanel == null){
				_userInfoPanel = new UserInfoPanel();
			}
			if(_userInfoPanel.parent){
				TweenLite.to(_userInfoPanel,.3,{x:-_userInfoPanel.width,onComplete:function():void{_userInfoPanel.hide();}});
			}else{
//				(Context.getContext(CEnum.UI) as IUIManager).popupPanel(_userInfoPanel);
				_userInfoPanel.x = -_userInfoPanel.width;
				_userInfoPanel.y = 50;
				this.addChildAt(_userInfoPanel,0);
				TweenLite.to(_userInfoPanel,.3,{x:50});
			}
		}
		
		
	}
}