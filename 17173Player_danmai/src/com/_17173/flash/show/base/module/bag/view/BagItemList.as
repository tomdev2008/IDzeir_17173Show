package com._17173.flash.show.base.module.bag.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import com._17173.flash.show.base.module.bag.view.items.BagItem;
	import com._17173.flash.show.base.module.bag.view.items.IBagItemPart;
	
	/**
	 *背包列表 
	 * @author yeah
	 */	
	public class BagItemList extends Sprite
	{
		private var _pageSize:int = 6;

		/**
		 *每页个数 
		 * @return 
		 */		
		public function get pageSize():int
		{
			return _pageSize;
		}

		public function set pageSize(value:int):void
		{
			if(_pageSize == value) return;
			_pageSize = value;
		}
		
		private var _categoryId:int;

		/**
		 *背包物品分类ID 
		 */
		public function get categoryId():int
		{
			return _categoryId;
		}

		/**
		 * @private
		 */
		public function set categoryId(value:int):void
		{
			if(_categoryId == value) return;
			var len:int = numChildren;
			while(len > 0)
			{
				recycle(this.removeChildAt(0) as IBagItemPart);
				len--;
			}
			_categoryId = value;
		}
		
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		/**
		 *数据源 
		 * @param value
		 */		
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
			onRender();
		}
		
		public function BagItemList()
		{
			super();
		}
		
		/**
		 *渲染数据 
		 */		
		private function onRender():void
		{
			var i:int = 0;
			for each (var itemData:Object in data) 
			{
				var item:IBagItemPart = i < this.numChildren ? this.getChildAt(i) as IBagItemPart : createItem();
				item.data = itemData;
				updateItemPos(item.self, i);
				if(!item.self.parent)
				{
					this.addChild(item.self);
				}
				i++;
				if(i >= pageSize)
				{
					break;
				}
			}
			
			while(i < this.numChildren)
			{
				this.removeChildAt(i);
			}
		}
		
		/**
		 *更新位置 
		 * @param $item
		 * @param $index
		 */		
		private function updateItemPos($item:DisplayObject, $index:int):void
		{
			const xGap:int = 20;
			const yGap:int = pageSize == 6 ? 20 : 40;//此处需要修改
			var xIndex:int = $index % 3;
			var yIndex:int = $index / 3;
			$item.x = xIndex * ($item.width + xGap);
			$item.y = yIndex * ($item.height + yGap);
		}
		
		
		//==============================
		
		
		/**
		 *对象池 
		 */		
		private var poolDic:Dictionary = new Dictionary;
		
		/**
		 *创建item 
		 * @return 
		 */		
		private function createItem():IBagItemPart
		{
			var itemType:String = geItemType();
			var dic:Dictionary = poolDic[itemType];
			var item:*;
			if(dic)
			{
				for(item in dic) 
				{
					delete dic[item];
					break;
				}
			}
			
			if(!item)
			{
				item = new BagItem(itemType);
			}
			
			return item;
		}
		
		/**
		 *回收 
		 * @param $item
		 */		
		private function recycle($item:IBagItemPart):void
		{
			var dicID:String = $item.type;
			if(!(dicID in poolDic))
			{
				poolDic[dicID] = new Dictionary(true);
			}
			poolDic[dicID][$item] = true;
		}
		
		/**
		 *返回背包物品类型
		 * @return 
		 */		
		private function geItemType():String
		{
			var itemType:String = "";
			switch(categoryId)
			{
				case 4:
					itemType = BagItem.TYPE_BODY;
					break;
				default:
					itemType = BagItem.TYPE_HEAD_BODY;
					break;
			}
			return itemType;
		}
		
	}
}