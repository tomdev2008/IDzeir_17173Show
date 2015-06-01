package com._17173.flash.show.base.module.bag.view
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.CheckBox;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.bag.view.items.BagItem;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 *背包主面板 
	 * @author yeah
	 */	
	public class BagPane extends BagPopPane
	{
		
		/**
		 *上一页按钮 
		 */		
		private var preBtn:Button;
		
		/**
		 *下一页按钮 
		 */		
		private var nextBtn:Button;
		
		/**
		 *tabbar 
		 */		
		private var tabBar:BagTabBar;
		
		/**
		 *单选框 
		 */		
		private var checkBox:CheckBox;
		
		/**
		 *背包列表 
		 */		
		private var list:BagItemList;
		
		/**
		 *list为空的时候的背景 
		 */		
		private var emptyBG:DisplayObject;
		
		public function BagPane()
		{
			super();
			
			attachSkin(new BagBG());
			addCloseBtn(630, 70);
			
			/**上一页*/
			preBtn = createBtn(49, 299, new BagPreBtn(), function ($e:MouseEvent):void
			{
				turnPage(-1);
			});
			
			/**下一页*/
			nextBtn = createBtn(645, 299, new BagNextBtn(), function ($e:MouseEvent):void
			{
				turnPage(1);
			});
			
			/**tabbar*/
			tabBar = new BagTabBar(tabSelected);
			tabBar.x = 98;
			tabBar.y = 92;
			this.addChild(tabBar);
			
			/**自动续费单选框*/
			checkBox = new CheckBox((Context.getContext(CEnum.LOCALE) as ILocale).get("checkbox","bag"), 0xED0967);
			checkBox.setSkin(new BagCheckBoxSkin());
			checkBox.x = 561;
			checkBox.y = 94;
//			checkBox.tabEnabled = true;
			checkBox.addEventListener(MouseEvent.CLICK, changeAutoRenew);
			this.addChild(checkBox);
			
			emptyBG = new BagListEmpty();
			emptyBG.x = 160;
			emptyBG.y = 270;
			this.addChild(emptyBG);
			
			list = new BagItemList();
			list.x = 106;
//			list.y = 137;
			list.y = 147;
			this.addChild(list);
		}
		
		/**
		 *变更自动续费勾选状态 
		 * @param event
		 */		
		private function changeAutoRenew(event:MouseEvent):void
		{
			checkBox.selected = checkBox.selected;
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BAG_MALL_SWITCHAUTORENEW, {autoReNew:checkBox.selected ? 1 : 0});
			
//			(Context.getContext(CEnum.UI) as IUIManager).popupAlert("提示",(Context.getContext(CEnum.LOCALE) as ILocale).get("checkbox","bag"), -1, Alert.BTN_OK);
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert("	提示", "每天23:00-24:00为即将到期商品自动续费时间，此期间修改自动续费功能可能不成功。", -1, Alert.BTN_OK);
		}
		
		/**
		 *tab页选择 
		 * @param $data
		 */		
		private function tabSelected($data:Object):void
		{
			pageIndex = 1;
			maxPage = 1;
			list.pageSize = $data.id == 4 ? 9 : 6;
			list.categoryId = $data.id;
			requestBagData();
		}
		
		/**
		 *更新tabs 
		 * @param $data
		 */		
		public function updateTabs($data:Object):void
		{
			tabBar.data = $data;
			tabBar.selectedIndex = 0;
		}
		
		/**
		 *请求背包数据 
		 */		
		private function requestBagData():void
		{
			var cid:int = list.categoryId;
			var pagesize:int = getPageSize(cid);
			var page:int = (pageIndex - 1) * pagesize;
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BAG_UPDATE, {type:cid, page:page, pageSize:pagesize});
		}
		
		/**
		 *根据分类获取每页个数 
		 * @param $cid
		 * @return 
		 */		
		private function getPageSize($cid:int):int
		{
			var ps:int = list.pageSize;
			switch($cid)
			{
				case 4:				//特殊处理靓号（靓号是每页9个，但是每页要加上一个默认）
				case 8:				//特殊处理入场特效（入场特效是每页6个，但是每页要加上一个默认）
					ps -= 1;
					break;
			}
			return ps;
		}
		
		/***当前页*/		
		private var pageIndex:int = 1;
		/***当前最大页数*/		
		private var maxPage:int = 0;
		/**
		 * 翻页
		 * @param $offset 1下一页 -1 上一页
		 */		
		private function turnPage($offset:int):void
		{
			pageIndex += $offset;
			if(pageIndex < 1)
			{
				pageIndex = 1;
				return;
			}
			else if(pageIndex > maxPage)
			{
				pageIndex = maxPage;
				return;
			}
			requestBagData();
		}
		
		/**
		 *更新列表 
		 * @param $data
		 */		
		public function updateList($data:Object):void
		{
			checkBox.selected = ($data.isAutoRenew == 1);
			maxPage = $data.pageTotal;
			pageIndex = $data.page;
			var showList:Boolean = $data.list.length > 0;
			emptyBG.visible = !showList;
			list.visible = showList;
			if(!showList) return;
			list.data = $data.list;
		}
		
		/**
		 *更新使用状态 
		 * @param $data
		 */		
		public function updateUseState($data:Object):void
		{
			var item:BagItem;
			for (var i:int = 0; i < list.numChildren; i++) 
			{
				item = list.getChildAt(i) as BagItem;
				if(item && item.data.id == $data.gId)
				{
					item.data.inUse = 1;
				}
				else
				{
					item.data.inUse = 0;
				}
				item.data = item.data;
			}
		}
		
		/**
		 *更新单个物品
		 * @param $data
		 */		
		public function updateItemDate($data:Object):void
		{
			var item:BagItem;
			for (var i:int = 0; i < list.numChildren; i++) 
			{
				item = list.getChildAt(i) as BagItem;
				if(item.data.id == $data.gId)
				{
					item.data.endTime = (Context.getContext(CEnum.LOCALE) as ILocale).get("validateDate","bag").replace("@", $data.endTime);
					item.data.inUse = 1;			//手动续费后 自动变为使用状态，比较奇怪的新需求
					item.data.expireSoon = 0;	//即将过期标志
					item.data = item.data;
				}
				else if(item.data.inUse == 1)
				{
					item.data.inUse = 0;
					item.data = item.data;
				}
			}
			
//			var item:BagItem = getItemByID($data.gId);
//			if(!item) return;
//			item.data.endTime = (Context.getContext(CEnum.LOCALE) as ILocale).get("validateDate","bag").replace("@", $data.endTime);
//			item.data.expireSoon = 0;	//即将过期标志
//			item.data = item.data;
		}
		
		/**
		 *根据id获取item显示对象 
		 * @param $id
		 * @return 
		 */		
		private function getItemByID($id:int):BagItem
		{
			var item:BagItem;
			for (var i:int = 0; i < list.numChildren; i++) 
			{
				item = list.getChildAt(i) as BagItem;
				if(item && item.data.id == $id)
				{
					break;
				}
			}
			return item;
		}

		/**
		 *创建按钮 
		 * @param $x
		 * @param $y
		 * @param $skin
		 * @param $clickFunc
		 * @return 
		 */		
		private function createBtn($x:int, $y:int, $skin:DisplayObject, $clickFunc:Function = null):Button
		{
			var btn:Button = new Button();
			btn.setSkin($skin);
			btn.x = $x;
			btn. y = $y;
			if($clickFunc != null)
			{
				btn.addEventListener(MouseEvent.CLICK, $clickFunc);
			}
			this.addChild(btn);
			return btn;
		}
	}
}