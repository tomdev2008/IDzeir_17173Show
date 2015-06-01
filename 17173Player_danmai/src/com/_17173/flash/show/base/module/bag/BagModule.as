package com._17173.flash.show.base.module.bag
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.bag.view.BagAlert;
	import com._17173.flash.show.base.module.bag.view.BagPane;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SError;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 *背包 
	 * @author yeah
	 */	
	public class BagModule extends BaseModule
	{
		
		/**
		 *背包主面板 
		 */		
		private var bagPane:BagPane;
		
		/**
		 *按钮容器 
		 */		
		private var btnContainer:Sprite;
		
		public function BagModule()
		{
			super();
			
			btnContainer = new Sprite();
			
			var btnbg:DisplayObject = new BagBtnBG();
			btnContainer.addChild(btnbg);
			
			var btn:Button = new Button()
			btn.setSkin(new ShopBtnSkin());
			btn.x = 6;
			btn.y = -3;
			btn.addEventListener(MouseEvent.CLICK, openShop);
			btnContainer.addChild(btn);
			
			btn = new Button();
			btn.setSkin(new BagBtnSkin());
			btn.x = 91;
			btn.y = 0;
			btn.addEventListener(MouseEvent.CLICK, openBag);
			btnContainer.addChild(btn);
			
			btnbg = new BagBtnFrontBG();
			btnbg.x = 8;
			btnbg.y = 27;
			btnContainer.addChild(btnbg);
			
			this.addChild(btnContainer);
		}

		/**
		 *打开商店 
		 * @param event
		 */		
		private function openShop(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(SEnum.MALL_HOME));
		}
		
		/**
		 *请求背包基础信息
		 * @param event
		 */		
		private function openBag(event:MouseEvent):void
		{
			if(isLogin())
			{
				showMoneyNotEnough = true;
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BAG_GET_INFO);
			}
			else
			{
				Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
			}
		}
		
		/**
		 *是否处于登陆状态 
		 */		
		private function isLogin():Boolean
		{
			var showdata:Object = Context.variables["showData"];
			return (showdata && showdata.masterID !=null && int(showdata.masterID) > 0);
		}
		
		/**
		 *更新背包基础信息 （一级分类信息）
		 * @param $data
		 */		
		public function updateBagInfo($data:Object):void
		{
			if(!$data) return;
			if(!bagPane)
			{
				bagPane = new BagPane();
			}
			bagPane.updateTabs($data);
			bagPane.open();
		}
		
		/**
		 *是否弹出余额不足弹窗 
		 */		
		private var showMoneyNotEnough:Boolean = false;
		/**
		 *更新背包数据 
		 * @param $data
		 */		
		public function updateBagList($data:Object):void
		{
			if(showMoneyNotEnough)
			{
				if($data.moneyNotEnough == 1)
				{
					showMoneyNotEnoughHandler();
				}
				showMoneyNotEnough = false;
			}
			
			if(bagPane && bagPane.isOpen)
			{
				bagPane.updateList($data);
			}
		}
		
		/**
		 *更新物品使用状态
		 * @param $data
		 */		
		public function updateItemUseState($data:Object):void
		{
			bagPane.updateUseState($data);
		}
		
		private var local:ILocale;
		/**
		 *更新物品有效期 
		 * @param $data
		 */		
		public function updateItemDate($data:Object):void
		{
			if(!local)
			{
				local = Context.getContext(CEnum.LOCALE) as ILocale;
			}
			
			if($data.hasOwnProperty("endTime"))
			{
				bagPane.updateItemDate($data);
				onAlert(local.get("renewSucc1","bag"), local.get("renewSucc2","bag").replace("@", $data.endTime), null);
			}
			else if($data.hasOwnProperty("code"))
			{
				if($data.code == "000002")
				{
					onAlert(local.get("renewfail1","bag"), local.get("renewfail2","bag"), gotoRecharge);
				}
				else
				{
					SError.handleServerError($data);
				}
			}
		}
		
		/**
		 *去充值 
		 */		
		private function gotoRecharge():void
		{
			Utils.toUrlAppedTime(SEnum.URL_MONEY);
		}
		
		/**
		 *更新自动续费状态 
		 * @param $data
		 */		
		public function updateAutoReNew($data:Object):void
		{
			//此处不做处理
		}
		
		/**
		 *弹出余额不足弹窗 
		 */		
		private function showMoneyNotEnoughHandler():void
		{
			//暂时不做
		}
		
		/**
		 *弹窗 
		 */		
		private var alert:BagAlert;
		
		/**
		 *弹出提示框 
		 * @param $data
		 * 
		 */		
		private function onAlert($str1:String, $str2:String, $callBack:Function = null):void
		{
			if(!alert)
			{
				alert = new BagAlert();
			}
			alert.callBack = $callBack;
			alert.addText($str1, "#ffcc00", 16);
			alert.addText($str2, "#ffffff", 14, true);
			alert.open();
		}
	}
}