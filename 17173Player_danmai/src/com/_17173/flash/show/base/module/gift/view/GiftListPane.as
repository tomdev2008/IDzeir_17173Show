package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	import com._17173.flash.show.base.module.gift.data.GiftInfo;
	import com._17173.flash.show.base.module.gift.data.GiftTypeInfo;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *礼物list面板 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GiftListPane extends Sprite
	{
		/**
		 *总共数量 
		 */		
		private var _ttCount:int = 0;
		/**
		 *当前页 
		 */		
		private var _currentPage:int = -1;
		/**
		 *总页数 
		 */		
		private var _pageLimit:int = 0;
		private var _items:Vector.<GiftItem> = null;
		private var _showItems:Array = null;
		private var _selectItem:GiftItem = null;
		private const ROWCOUNT:int = 1;
		private const COLCOUNT:int = 10;
		private const ROWSP:int = 50;
		private const COLSP:int = 50;
		private var _pageBar:GiftPageBar = null;
		private var _currentGiftType:int = 0;
		private var _giftTypes:Array;
		private var _giftTypeBtns:Array;
		private var _leftBtn:Button;
		private var _rightBtn:Button;
		private var _currentSelectBtn:GiftTypeButton;
		private var _tmpe_ActType:String = "1702";
		public function GiftListPane()
		{
			super();
			this.mouseEnabled = false;
			initItemBg();
			initTypes();
			initData();
			initPage();
		}

		public function get selectItem():GiftItem
		{
			return _selectItem;
		}

		public function set selectItem(value:GiftItem):void
		{
			_selectItem = value;
		}
		/**
		 *初始化礼物类型 
		 * 
		 */		
		private function initTypes():void{
			_giftTypes = GiftInfo.getInstance().types4Nor;
			_giftTypeBtns = [];
			var len:int = _giftTypes.length;
			var skins:Array = [new Btn_Gift_select_bg(),new Btn_Gift_select_bg(),new Btn_Gift_select_bg()];
			var labs:Array = ["普通","幸运","特殊"];
			for (var i:int = 0; i < len; i++) 
			{
				var info:GiftTypeInfo = _giftTypes[i];
				var gbtn:GiftTypeButton = new GiftTypeButton(info);
				_giftTypeBtns[i] = gbtn;
				gbtn.setSkin(skins[i]);
				gbtn.label = "<font color='#FFCC01' size='14'>"+labs[i] + "</font>";
				gbtn.width = 36;
				gbtn.height = 18;
				gbtn.x = i * 40 + 190 ;
				gbtn.y = - 30;
				gbtn.addEventListener(MouseEvent.CLICK,onTypeClick);
				this.addChild(gbtn);
			}
			_currentGiftType = _giftTypes[0].id;
			_currentSelectBtn = _giftTypeBtns[0];
			_currentSelectBtn.selected = true;
		}
		
		protected function onTypeClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//改变数据;
			_currentSelectBtn.selected = false;
			_currentSelectBtn = (event.target as GiftTypeButton);
			_currentSelectBtn.selected = true;
			_currentGiftType = _currentSelectBtn.typeInfo.id;
			cleartData();
			initData();
			initPage();		
		}
		
		private function initPagebar():void{
			if(_pageBar){
				_pageBar.parent.removeChild(_pageBar);
			}
			_pageBar = new GiftPageBar();
			_pageBar.x= 0;
			_pageBar.y = 42;
			_pageBar.addEventListener(GiftPageBar.CHANGE_PAGE,onPageChange);
			this.addChild(_pageBar);
			
			_leftBtn = new Button("");
			_leftBtn.setSkin(new Skin_button_Left());
			_leftBtn.width = 16;
			_leftBtn.height = 27;
			_leftBtn.x = -17;
			_leftBtn.y = 8;
			_leftBtn.addEventListener(MouseEvent.CLICK,onLeft);
			this.addChild(_leftBtn);
			
			_rightBtn = new Button("");
			_rightBtn.setSkin(new Skin_button_Right());
			_rightBtn.width = 16;
			_rightBtn.height = 27;
			_rightBtn.x = COLSP * 10 + 0;
			_rightBtn.y = 8;
			_rightBtn.addEventListener(MouseEvent.CLICK,onRight);
			this.addChild(_rightBtn);
			
		}
		
		protected function onRight(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var cp:int = _pageBar.currentPage+1;
			if(cp >= _pageLimit){
				_pageBar.currentPage = 0;
			}else{
				_pageBar.currentPage = cp;
			}
			changePage(_pageBar.currentPage);
			
		}
		
		protected function onLeft(event:MouseEvent):void
		{
			var cp:int = _pageBar.currentPage-1;
			if(cp == -1){
				_pageBar.currentPage = _pageLimit-1;
			}else{
				_pageBar.currentPage = cp;
			}
			// TODO Auto-generated method stub
			changePage(_pageBar.currentPage);
		}		
		
		protected function onPageChange(event:Event):void
		{
			changePage(_pageBar.currentPage);
		}
		
		protected function cleartData():void{
			if(_showItems){
				var len:int = _showItems.length;
				for (var i:int = 0; i < len; i++) 
				{
					var gift:GiftItem = _showItems[i] as GiftItem;
					if(gift.parent){
						gift.parent.removeChild(gift);
					}
				}
				_showItems = [];
			}
			_items = null;
		}
		
		/**
		 *初始化数据 
		 * 
		 */
		private function initData():void{
			_items = new Vector.<GiftItem>();
			if(_currentGiftType == 0){
				
			}
			var datas:Array =  GiftInfo.getInstance().getGiftsByType(_currentGiftType+"");
			var datas1:Array = (GiftInfo.getInstance().getGiftsByType(_tmpe_ActType+""));
			if(_currentGiftType == 0){
				datas = datas1.concat(datas);
			}
			var len:int = datas.length;
			var item:GiftItem;
			for (var i:int = 0; i < len; i++) 
			{
				item = new GiftItem(datas[i]);
				_items[_items.length] = item;
			}
			if(datas.length > 0){
				selectItem = _items[0];
				selectItem.changeSelect(true);
				onSelectItem(null);
			}
		}
		
		private function initItemBg():void{
			var ibg:MovieClip;
			for (var i:int = 0; i < ROWCOUNT; i++) 
			{
				for (var j:int = 0; j < COLCOUNT; j++) 
				{
					ibg = new Gift_Item_bg1();
					ibg.x = j * COLSP;
					ibg.y = i * ROWSP;
					this.addChild(ibg);
				}
			}
		}
		/**
		 *初始化页面 
		 * 
		 */		
		private function initPage():void{
			initPagebar();
			_showItems = [];
			_ttCount = _items.length;
			_pageLimit = Math.ceil(_ttCount/(COLCOUNT * ROWCOUNT));
			_pageBar.updatePage(_pageLimit);
			_pageBar.x = (388 - _pageBar.width)/2;
			changePage(0);
		}
		
		/**
		 *清理显示数据 
		 * 
		 */		
		private function clearShow():void{
			var len:int = _showItems.length;
			for (var i:int = 0; i < len; i++) 
			{
				var item:GiftItem = _showItems[i] as GiftItem;
				item.removeEventListener(MouseEvent.CLICK,onSelectItem)
				this.removeChild(item);
			}
			_showItems = [];
		}
		/**
		 *换页 
		 * @param page
		 * 
		 */		
		private function changePage(page:int):void{
			if(page >=0 && page < _pageLimit){
				_currentPage = page;
				clearShow();
				updatePageInfo();
				showCurrentPage();
			}
		}
		/**
		 *展示当前页数据 
		 * 
		 */		
		private function showCurrentPage():void{
			var begin:int = _currentPage * (ROWCOUNT * COLCOUNT);
			var end:int = ROWCOUNT * COLCOUNT;
			if(_ttCount < begin + end){
				end = (_ttCount - begin);
			}
			var item:GiftItem;
			var count:int = 0;
			for (var i:int = begin; i < begin+end; i++) 
			{
				item = _items[i];
				item.x = count%COLCOUNT * COLSP;
				item.y = Math.floor((count)/COLCOUNT) * ROWSP;
				item.addEventListener(MouseEvent.CLICK,onSelectItem);
				//tooltip
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.registerTip(item,getTipString(item.giftData));
				this.addChild(item);
				_showItems[_showItems.length] = item;
				count++;
			}
		}
		/**
		 *获取tip 
		 * @param data
		 * @return 
		 * 
		 */		
		private function getTipString(data:GiftData):String{
			var htmlString:String = "";
			htmlString = "<font color='#F8F8F8'>"+data.name+ "</font><br>";
			htmlString += "<font color='#F8F8F8'>价格："+data.price+ " 乐币</font><br>";
			htmlString += "<font color='#F8F8F8'>价值：￥"+(data.price/100)+ "</font><br>";
			if(data.luckNum != null){
				htmlString += "<font color='#F8F8F8'>主播可收到："+ (data.price * .2)+ " 乐豆</font><br>";
				htmlString += "<font color='#F8F8F8'>最高可获得："+data.luckNum+ " 倍奖金</font><br>";
			}
			if(data.name == "大烟花")
				htmlString += "<font color='#F8F8F8'>本房间内所有注册用户均可分得乐豆!</font><br>";
			else if(data.name == "小烟花")
				htmlString += "<font color='#F8F8F8'>本房间艺人与管理均可分得乐豆!</font><br>";
			return htmlString;
		}
		/**
		 *更新分页信息 
		 * 
		 */		
		private function updatePageInfo():void{
		}
		/**
		 *监听按钮点击 
		 * 
		 */		
		
		private function onLeftClick(e:Event):void{
			if(_currentPage > 0){
				changePage(--_currentPage);
			}
		}
		
		private function onRightClick(e:Event):void{
			if(_currentPage < (_pageLimit - 1)){
				changePage(++_currentPage);
			}
		}
		
		private function onSelectItem(e:Event= null):void{
			if(e!=null){
				clearSelect();
				_selectItem = e.currentTarget as GiftItem;
				_selectItem.changeSelect(true);
			
			//新手引导
			(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.TASK_GIFT_CHOSE);
			}
			
			var obj:Object = null;
			if(_selectItem.giftData.type == 1502){
				obj = {id:"",label:""}
				obj.enb = 1;
				if(_selectItem.giftData.name == "小烟花"){
					obj.label = "艺人和房间管理";
				}
				else{
					obj.label = "房间内注册用户";
				}
			}
			
			(Context.getContext(CEnum.EVENT) as EventManager).send("userchange_gmi",obj);
		}
		
		public function clearSelect():void{
			if(_selectItem){
				_selectItem.changeSelect(false);
			}
		}
		
		public function showGift():void{
			this.visible = true;
		}
		
		public function hideGift():void{
			this.visible = false;
		}
	}
}