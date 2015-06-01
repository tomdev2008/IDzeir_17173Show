package com._17173.flash.show.base.module.gift
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.module.gift.view.GiftPaneUI;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.events.Event;
	
	public class GiftPanel extends BaseModule
	{
		private var _ui:GiftPaneUI = null;
		private var added:Boolean = false;
		private var onDataCmp:Boolean = false;
		public function GiftPanel()
		{
			super();
			_version = "0.0.7";
		}
		override protected function onAdded(event:Event):void{
			added = true;
			onShow();
		}
		
		
		
		override protected function init():void{
			this.mouseEnabled = false;
			addEventLsn();
			addServerLsn();
		}
		
		private function onShow(data:Object = null):void{
			if(added && onDataCmp){
				_ui = new GiftPaneUI();
				this.addChild(_ui);
				onInitUser();
				//初始化按钮
			}
		}
		
		private function addEventLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.listen(SEvents.GIFT_DATA_LOAD_CMP,onDataCMP);
			event.listen(SEvents.USER_CARD_SEND_GIFT,onAddUsers);
			event.listen(SEvents.ADD_TO_GIFT_SELECT_USERS,onAddUsers);
		}
		
		private function onDataCMP(data:Object = null):void{
			onDataCmp = true;
			onShow();
		}
		
		private function onInitUser():void{
			var showData:ShowData = Context.variables["showData"];
			var order:Object = showData.order;
			//如果order不存在说明不是三麦房则不添加
			if(order != null){
				if(order["1"]){
					_ui.addByInit({id:order["1"].masterId,label:Utils.formatToString(order["1"].nickName)});
				}
				if(order["2"]){
					_ui.addByInit({id:order["2"].masterId,label:Utils.formatToString(order["2"].nickName)});
				}
				if(order["3"]){
					_ui.addByInit({id:order["3"].masterId,label:Utils.formatToString(order["3"].nickName)});
				}
			}
			//单麦房自动将房主放置到送礼人
			if(showData.hasOwnProperty("roomOwnMasterID") && showData["roomOwnMasterID"] != ""){
				_ui.addByInit({id:showData["roomOwnMasterID"],label:Utils.formatToString(showData["roomOwnMasterName"])});
			}
			
		}
		
		private function onAddUsers(data:Object):void{
			_ui.addUsers(String(data));
		}
		
		private function addServerLsn():void{
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		}
		
	}
}