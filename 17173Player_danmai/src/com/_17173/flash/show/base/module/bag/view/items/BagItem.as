package com._17173.flash.show.base.module.bag.view.items
{
	/**
	 *背包item 
	 * @author yeah
	 */	
	public class BagItem extends BagItemPart
	{
		public function BagItem($type:String = TYPE_HEAD_BODY)
		{
			super();
			this.type = $type;
		}
		
		private var _type:String = null;

		override public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			if(_type == value) return;
			_type = value;
			addParts(getParts());
		}
		
		
		/**
		 *添加部件 
		 * @param $parts				部件列表
		 * @param $cleanOld		清理旧的部件
		 */		
		private function addParts($parts:Vector.<IBagItemPart>, $cleanOld:Boolean = true):void
		{
			if($cleanOld)
			{
				while(this.numChildren > 0)
				{
					this.removeChildAt(0);
				}
			}
			_height = 0;
			for each (var item:IBagItemPart in $parts) 
			{
				if(item.autoAlign)
				{
					item.self.y = _height;
					_height += item.self.height;
				}
				this.addChild(item.self);
			}
			
			_height += 10;
		}
		
		override protected function onRender():void
		{
			var len:int = numChildren;
			var item:IBagItemPart;
			for (var i:int = 0; i < len; i++) 
			{
				item = this.getChildAt(i) as IBagItemPart;
				if(!item) continue;
				item.data = data;
			}
			
			drawBorder(width, height, data.expireSoon == 1 ? 0xffcc00:0xd956b5);
		}
		
		/**
		 *画背景 
		 * @param $w
		 * @param $h
		 */		
		protected function drawBorder($w:int, $h:int, $color:uint):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, $color);
			this.graphics.drawRect(0, 0, $w, $h);
		}
		
		
		/**
		 *仅含有body 
		 */		
		public static const TYPE_BODY:String = "body";
		
		/**
		 *含有head和body 
		 */		
		public static const TYPE_HEAD_BODY:String = "head_body";
		
		/**
		 *获取部件列表 
		 */		
		private function getParts():Vector.<IBagItemPart>
		{
			var vect:Vector.<IBagItemPart> = new Vector.<IBagItemPart>();
			switch(type)
			{
				case TYPE_BODY:
					vect.push(new BagItemBody());
					vect.push(new BagItemIcon());
					break;
				case TYPE_HEAD_BODY:
					vect.push(new BagItemHead());
					vect.push(new BagItemBody());
					vect.push(new BagItemIcon());
					break;
			}
			return vect;
		}
		
		private var _height:Number = 0;
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function get width():Number
		{
			return 160;
		}
	}
}