package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	import com._17173.flash.show.base.module.gift.data.GiftInfo;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		private const ROWCOUNT:int = 4;
		private const COLCOUNT:int = 5;
		private const ROWSP:int = 39;
		private const COLSP:int = 40;
		private var _pageLabel:TextField = null;
		private var _btnLeft:Button = null;
		private var _btnRight:Button = null;
		public function GiftListPane()
		{
			super();
			this.mouseEnabled = false;
			initItemBg();
			initData();
			initPage();
			initLsn();
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
		 *初始化数据 
		 * 
		 */
		private function initData():void{
			_items = new Vector.<GiftItem>();
			var datas:Array =  GiftInfo.getInstance().getAllGiftData();
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
			}
			onSelectItem();
		}
		
		private function initItemBg():void{
			var ibg:MovieClip;
			for (var i:int = 0; i < ROWCOUNT; i++) 
			{
				for (var j:int = 0; j < COLCOUNT; j++) 
				{
					ibg = new gift_item_bg();
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
			_showItems = [];
			_ttCount = _items.length;
			_pageLimit = Math.ceil(_ttCount/(COLCOUNT * ROWCOUNT));
			
			_btnLeft = new Button();
			_btnLeft.setSkin(new gift_left_bg());
			_btnLeft.x = 74;
			_btnLeft.y = 152;
			this.addChild(_btnLeft);
			
			_btnRight =new Button();
			_btnRight.setSkin(new gift_right_bg());
			_btnRight.x = _btnLeft.x + 37;
			_btnRight.y = 152;
			this.addChild(_btnRight);
			
			_pageLabel = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.size = 12;
			textFormat.font = FontUtil.f;
			_pageLabel = new TextField();
			_pageLabel.x = _btnLeft.x + 20;
			_pageLabel.y = 154;
			_pageLabel.width = 80;
			_pageLabel.text = "0";
			_pageLabel.height = 25;
			_pageLabel.width = 18;
			_pageLabel.height = 20;
			_pageLabel.defaultTextFormat = textFormat;
			_pageLabel.setTextFormat(textFormat);
			_pageLabel.selectable = false;
			_pageLabel.mouseEnabled = false;
			_pageLabel.multiline = false;
			this.addChild(_pageLabel);
			
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
			return htmlString;
		}
		/**
		 *更新分页信息 
		 * 
		 */		
		private function updatePageInfo():void{
			_pageLabel.text = (_currentPage+1) + "";
			if(_pageLimit == 1){
				_btnLeft.visible = false;
				_btnRight.visible = false;
			}else{
				_btnLeft.visible = true;
				_btnRight.visible = true;
			}
		}
		
		
		/**
		 *监听按钮点击 
		 * 
		 */		
		private function initLsn():void{
			_btnLeft.addEventListener(MouseEvent.CLICK,onLeftClick);
			_btnRight.addEventListener(MouseEvent.CLICK,onRightClick);
		}
		
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
			}
			var obj:Object = null;
			if(_selectItem.giftData.type == 1502){
				obj = {id:"",label:""}
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