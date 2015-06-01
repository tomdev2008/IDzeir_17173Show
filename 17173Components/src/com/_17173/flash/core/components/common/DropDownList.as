package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * 选中某一项时派发
	 */
	[Event(name="select", type="flash.events.Event")]
	/**
	 * 展开列表时派发
	 */
	[Event(name="open", type="flash.events.Event")]
	/**
	 * 合上列表时派发
	 */
	[Event(name="close", type="flash.events.Event")]
	/**
	 * 当选中的对象改变时派发
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-27  上午9:42:23
	 */
	public class DropDownList extends Sprite
	{
		private var itemMap:Vector.<DisplayObject>=new Vector.<DisplayObject>();
		private var dataMap:Vector.<Object>=new Vector.<Object>();
		
		protected var overBg:Shape;
		
		private var closed:Boolean=true;
		
		private var itemBox:Sprite=new Sprite();
		
		/**下拉列表显示宽度，默认80*/
		protected var _width:Number=80;
		
		private var _maxline:uint;
		
		private var _orientation:String="";
		
		/**下拉列表方向，值为"up"*/
		public static const UP:String="up";
		/**下拉列表方向，值为"down"*/
		public static const DOWN:String="down";
		
		private var selectedItem:DisplayObject;
		
		/**自定义的显示皮肤*/
		private var itemRender:Class;
		/**
		 * 组件默认状态下的背景 
		 */		
		protected var selectedBackground:Shape;
		
		/**
		 * 下拉列表组件 
		 * @param dir 下来方向"up"或者"down"
		 * @param maxline 保留最近数据的条数 ,默认值0为不限制
		 * @param itemRender 自定义皮肤
		 */		
		public function DropDownList(dir:String="down",maxline:uint=0,itemRender:Class=null)
		{
			super();
			this._orientation=dir;
			this._maxline=maxline;
			
			overBg=new Shape();
			selectedBackground = new Shape();
			drawBackground()
	
			overBg.visible=false;
			
			this.itemRender=itemRender==null?Label:itemRender;
			
			this.addChild(itemBox);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		/**
		 * 子类继承重绘划入背景 
		 * 
		 */		
		protected function drawBackground():void
		{			
			overBg.graphics.beginFill(0x4C118A,1);
			overBg.graphics.drawRect(0,0,_width,20);
			overBg.graphics.endFill();	
			//设置关闭时默认背景颜色
			setBackground(0x4c118a,1);
		}
		/**
		 * 组件index=0 的背景设置 
		 * @param _color
		 * @param _alpha
		 * 
		 */		
		public function setBackground(_color:int,_alpha:Number = 1):void
		{
			selectedBackground.graphics.beginFill(_color,_alpha);
			selectedBackground.graphics.drawRect(0,0,overBg.width, overBg.height);
			selectedBackground.graphics.endFill();	
		}

		protected function onAdded(event:Event):void
		{
			this.addChildAt(selectedBackground,0);
			this.addChildAt(overBg,0);
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.CLICK,clickHandler)
		}
		
		protected function overHandler(event:MouseEvent):void
		{
			var item:*=event.target;
			if(item is itemRender)
			{
				this.lockFocus(item);
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{			
			if(this.itemMap.length>1)
			{
				if(this.closed)
				{
 					buildList();
					if(this.willTrigger(Event.OPEN))
					{
						this.dispatchEvent(new Event(Event.OPEN));
					}
				}else{					
					this.closed=true;
					var item:DisplayObject=event.target as DisplayObject;
					
					if(item&&item.parent&&item.parent==itemBox)
					{
						swapLabel(itemBox.getChildIndex(item));						
					}
					
					if(this.willTrigger(Event.CLOSE))
					{
						this.dispatchEvent(new Event(Event.CLOSE));
					}
				}
			}
		}
		
		/**
		 * 指定选择的item 
		 * @param index
		 * 
		 */		
		private function swapLabel(index:int):void
		{			
			var data:Object=dataMap.splice(index,1)[0];
			var item:DisplayObject=itemMap.splice(index,1)[0];
			
			dataMap.unshift(data);
			itemMap.unshift(item);
			
			item.x=0;
			item.y=0;
			itemBox.setChildIndex(item,0);
			itemBox.removeChildren(1);
			
			this.lockFocus(item);
			if(this.willTrigger(Event.SELECT))
			{
				this.dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		/**创建下拉列表打开状态*/
		protected function buildList():void
		{
			if(dataMap.length==0)return;
			this.closed=false;
			for(var i:uint=0;i<itemMap.length;i++)
			{
				var item:DisplayObject=itemMap[i];
				if(this._orientation=="up"){
					item.y=(i)*item.height*(-1);
				}else if(this._orientation=="down"){
					item.y=(i)*item.height;
				}
				
				itemBox.addChild(item);
			}
			//trace("总数：",itemBox.numChildren)
		}
		
		/**
		 * 锁定鼠标划入背景位置 
		 * @param obj 背景块锁定到的显示对象
		 * 
		 */		
		private function lockFocus(obj:DisplayObject):void
		{
			overBg.visible=true;
			overBg.x=obj.x;
			overBg.y=obj.y;
			selectedBackground.width = overBg.width=width;
			selectedBackground.height = overBg.height=obj.height;
			selectedItem=obj;
		}
		
		protected function onRemoved(event:Event):void
		{
			this.removeChild(overBg);
			this.removeEventListener(MouseEvent.CLICK,clickHandler)
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		/**
		 * 打开下拉列表 
		 * 
		 */		
		public function open():void
		{
			if(this.itemMap.length>1)
			{
				if(this.closed)
				{
					this.buildList();
					if(this.willTrigger(Event.OPEN))
					{
						this.dispatchEvent(new Event(Event.OPEN));
					}
				}
			}
		}
		/**
		 * 关闭下拉列表 
		 * 
		 */		
		public function close():void
		{
			if(this.itemMap.length>0)
			{
				if(!this.closed)
				{
					this.closed=true;
					var item:DisplayObject=itemMap[0];
					itemBox.removeChildren(1);
					this.lockFocus(item);
					if(this.willTrigger(Event.CLOSE))
					{
						this.dispatchEvent(new Event(Event.CLOSE));
					}
				}
			}
		}
		
		/**
		 * 一次添加多个显示项 
		 * @param data 对应每个data元素，label为显示的标签，默认值未default， 调用selected返回</br>该对象,每个object将作为itemRender参数
		 * 
		 */		
		public function set dataProvider(data:*):void
		{
			itemBox.removeChildren();
			dataMap.length=0;
			itemMap.length=0;			
			
			for each(var i:Object in data)
			{
				addItem(i);
			}
			
			if(this.hasEventListener(Event.CHANGE))
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 添加一个显示项 
		 * @param data data.label为显示的标签，默认值未default，调用selected返回该对象
		 * 
		 */		
		public function addItem(data:Object):void
		{
			dataMap.unshift(data);
			
			data.maxW=_width;
			var item:DisplayObject=new itemRender(data);
			
			itemMap.unshift(item);	
			
			var overline:Boolean=false;
			//限制长度以后删除最早的数据
			if(this.isOverMaxline)
			{
				overline=true;
				dataMap.pop();
				itemMap.pop();
			}
			
			if(!this.closed)
			{	
				if(overline)itemBox.removeChildAt(this.size-1);
				this.buildList();				
				this.lockFocus(itemMap[0]);
			}else{		
				
				itemBox.removeChildren();
				itemBox.addChild(item);
				this.lockFocus(item);
			}
		}
		
		/**
		 * 下拉列表的最大显示条数，超过条数舍弃旧数据
		 */
		public function get maxline():uint
		{
			return this._maxline;
		}
		
		/**
		 * 下来列表是否超过指定长度 
		 * @return 
		 * 
		 */		
		private function get isOverMaxline():Boolean
		{
			return (this._maxline!=0&&dataMap.length>this._maxline);
		}
		
		/**
		 * 删除指定序号的下拉列表项 
		 * @param index 下拉项的序号，0--size
		 * @return 返回删除像的数据
		 * 
		 */		
		public function removeItemAt(index:uint):Object
		{
			try{
				itemMap.splice(index,1);
				var obj:Object=dataMap.splice(index,1)[0];				
				itemBox.removeChildAt(index);
				this.buildList();
			}catch(e:Error){
				//trace("超出最大索引");
				return null;
			}
			if(dataMap.length==0)
			{
				clear();
			}
			if(itemMap.length>0)
			{
				this.lockFocus(itemMap[0]);
			}
			return obj;
		}
		
		/**清楚下拉列表数据*/
		public function clear():void
		{
			itemBox.removeChildren();
			dataMap.length=0;
			itemMap.length=0;
			overBg.visible=false;
			this.selectedItem=null;
		}
		
		/**获取当前选中项的数据*/
		public function get selected():Object
		{
			return dataMap.length==0?null:dataMap[0];
		}
		
		/**
		 * 只读属性，列表展开状态 
		 * @return 
		 * 
		 */		
		public function get isOpen():Boolean
		{
			return !this.closed;
		}
		
		override public function set width(value:Number):void
		{
			this._width=value;
			this._width=Math.max(0,this._width);			
			resize();
			if(this.selectedItem)
			{
				selectedBackground.width = overBg.width=this.selectedItem.width;
			}
		}
		
		override public function get width():Number
		{
			if(dataMap.length==0)
			{
				return 0;
			}
			return _width;
		}
		
		/**下拉列表选项的个数*/		
		public function get size():uint
		{
			return dataMap.length;
		}
		
		
		/**下拉列表伸缩方向"up"或者"down"*/
		public function get orientation():String
		{
			return _orientation;
		}
		
		/**刷新label的长度*/
		private function resize():void
		{
			selectedBackground.width = overBg.width=_width;
			if(this.itemRender!=Label)return;
			for each(var i:Label in itemMap)
			{
				i.maxWidth=_width;
			}
		}
	}
}