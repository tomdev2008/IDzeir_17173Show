package com._17173.flash.show.base.module.rank.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 *排行榜 view（显示列表） 
	 * @author Administrator
	 */	
	public class RankList extends Sprite
	{
		
		private var _gap:int = 2;

		/**
		 *间距 
		 * @return 
		 */		
		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			if(value == _gap) return;
			_gap = value;
		}
		
		private var _itemRenderer:Class;

		/**
		 *渲染器 
		 * @return 
		 */		
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:Class):void
		{
			if(_itemRenderer == value) return;
			if(dic)
			{
				dic = null;
			}
			_itemRenderer = value;
		}
		
		private var _data:Object;
		/**
		 *数据源 
		 * @return 
		 */		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
//			if(_data == value) return;
			_data = value;
			updateDisplayList();
		}
		
		
		public function RankList()
		{
			super();
		}

		/**
		 *开始渲染 
		 */		
		private function updateDisplayList():void
		{
			if(!data)
			{
				while(this.numChildren > 0)
				{
					this.removeChildAt(0);
				}
				return;
			}
			
			var pos:int;
			var i:int = 0;
			for each (var itemData:Object in data) 
			{
				var item:DisplayObject = 	getItem(i);
				
				if(item.hasOwnProperty("index"))
				{
					item["index"] = i;
				}
				
				if(item.hasOwnProperty("data"))
				{
					item["data"] = itemData;
				}
				
				item.y = pos;
				pos += item.height + gap;
				
				if(!item.parent)
				{
					this.addChild(item);
				}
				
				i++;
				
			}
			
			while(i < this.numChildren)
			{
				this.removeChildAt(i);
			}
		}
		
		/**
		 *获取制定索引的item 
		 * @param $index 制定位置索引
		 * @return 
		 */		
		private function getItem($index:int):DisplayObject
		{
			return DisplayObject($index < numChildren ? this.getChildAt($index) : createInstance(itemRenderer));
		}
		

		/**
		 *对象池字典 
		 */		
		private var dic:Dictionary;
		
		/**
		 *创建实例 
		 * @return 
		 */		
		private function createInstance($class:Class):Object
		{
			var instance:Object;
			if(dic)
			{
				for(instance in dic)
				{
					delete dic[instance];
					break;
				}
			}
			
			if(!instance && $class)
			{
				instance = new $class();
			}
			return instance;
		}
		
		/**
		 *回收 
		 * @param $item
		 * @return 
		 */		
		private function recycle($item:Object):Object
		{
			if(!dic)
			{
				dic = new Dictionary(true);
			}
			dic[$item];
			return $item;
		}
		
		
	}
}