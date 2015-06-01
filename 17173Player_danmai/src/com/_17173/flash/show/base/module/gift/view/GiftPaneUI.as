package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GiftPaneUI extends SkinComponent
	{
		/**
		 *标题 
		 */		
		private var _title:TextField = null;
		private var _giftListPane:GiftListPane = null;
		private var _actionBar:GiftActionBar = null;
		public function GiftPaneUI()
		{
			this.mouseEnabled = false;
			super();
			(Context.getContext(CEnum.EVENT)).listen("userchange_gmi",addOtherUser);
		}
		
		override protected function onInit():void{
			super.onInit();
			initTitle();
			initList();
			initBottomBar();
			initSourceData();
		}
		
		protected function initSourceData():void{
			this.setSkin_Bg(new Bg_Gift());
			this.width = 568;
			this.height = 154;
//			giftBgaddEventListener(MouseEvent.CLICK,hideList);
		}
		
		private function initTitle():void{
			_title = new TextField();
			_title.setTextFormat(FontUtil.DEFAULT_FORMAT);
			_title.defaultTextFormat = FontUtil.DEFAULT_FORMAT;
			_title.x = 230;
			_title.y = 15;
			_title.mouseEnabled = false;
			_title.htmlText = "<font size='16' color='#FFFFFF'></font>";
			this.addChild(_title);
		}
		
		private function btnHideList(e:MouseEvent = null):void{
			_title.y = 2;
		}
		
		private function btnShowList(e:MouseEvent = null):void{
			_title.y = 189;
		}
		
		private function initList():void{
			_giftListPane = new GiftListPane();
			_giftListPane.x = 35;
			_giftListPane.y = 55;
			this.addChild(_giftListPane);
		}
		
		private function initBottomBar():void{
			_actionBar = new GiftActionBar(_giftListPane);
			_actionBar.x = 113;
			_actionBar.y = 118;
			this.addChild(_actionBar);
		}
		
		private var count:int = 0;
		
		
		
		private function initShowData():void{
			var showData:Object = Context.variables["showData"];
			var order:Object = showData.order;
//			if(order["3"] !=null)
		}
		
		public function addUsers(uid:String):void{
			_actionBar.addUsers(uid)
		}
		
		public function addByInit(obj:Object):void{
			_actionBar.addByInit(obj);
		}
		
		/**
		 *添加大小烟花赠送 
		 * @param obj
		 * 
		 */		
		public function addOtherUser(obj:Object):void{
			clearOtherUesr();
			if(obj == null){
				_actionBar.changeDownListEab(true);
			}else{
				_actionBar.addByInit(obj);
			}
		}
		
		
		private function clearOtherUesr():void{
			_actionBar.clearOtherUser();
		}
	}
}