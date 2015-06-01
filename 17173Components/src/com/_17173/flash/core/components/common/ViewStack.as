package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	[Event(name="change", type="flash.events.Event")]
	
	/** 
	 *  上下堆叠的容器，一次只能显示一个子对象
	 * @author idzeir
	 * 创建时间：2014-1-21 下午13:01:12
	 */
	public class ViewStack extends Sprite
	{
		private var contentMap:Vector.<ViewItem>=new Vector.<ViewItem>();
		private var _dataProvider:Vector.<Object>=new Vector.<Object>();
		
		private var selectedIndex:int=0;
		private var selectedItem:Object;
		
		public function ViewStack()
		{
			super();
		}
		
		/**
		 * 添加一个显示项 
		 * @param id 显示的唯一编号，不能重复
		 * @param label 标签名称
		 * @param graphic 显示项的内容
		 * 
		 */		
		public function addItem(id:String,label:String="",graphic:DisplayObject=null):void
		{
			var index:int=indexOf(id);
			if(index==-1)
			{				
				var viewItem:ViewItem=new ViewItem(id,label,graphic);
				if(contentMap.length==0)
				{
					selectedIndex=0;
					selectedItem=viewItem.object;
					if(graphic)
					{						
						this.addChild(graphic);
					}
				}
				contentMap.push(viewItem);
				return;
			}
			throw new Error("id 冲突");
		}
		
		/**
		 * 获取全部显示数据
		 */
		public function get dataProvider():Vector.<Object>
		{
			_dataProvider.length=0;
			
			for (var i:uint=0;i<contentMap.length;i++)
			{
				_dataProvider.push(contentMap[i].object);
			}
			
			return _dataProvider;
		}
		
		private function getItem(id:String):ViewItem
		{
			var index:int=indexOf(id);
			if(index==-1)
			{
				return null;
			}
			return contentMap[index];
		}
		
		/**
		 * 暂时不用，没有实现
		 */
		private function removeItem(id:String):DisplayObject
		{
			return null;
			var index:int=indexOf(id);
			if(index==-1)
			{
				return null;
			}
			return contentMap.splice(index,1)[0].grapgic;
		}
		
		private function indexOf(id:String):int
		{
			for(var i:uint=0;i<contentMap.length;i++)
			{
				if(contentMap[i].id==id)
				{
					return i;
				}
			}
			return -1;
		}		
		
		/**
		 * 显示跳转到指定id的页显示 
		 * @param id 显示页面绑定id
		 * 
		 */		
		public function switchView(id:String):void
		{			
			var viewItem:ViewItem=getItem(id);
			if(viewItem&&selectedItem&&viewItem.id!=selectedItem.id)
			{	
				this.removeChildren();
				this.addChild(viewItem.graphic);
				selectedIndex=indexOf(id);
				selectedItem=viewItem.object;
			}
		}
		
		/**
		 * 跳转到第value页显示 
		 * @param value
		 * 
		 */		
		public function set index(value:int):void
		{			
			try{				
				selectedItem=contentMap[value];
				selectedIndex=value;
			}catch(e:Error){
				throw new Error("索引不正确");
				return;
			}
			this.removeChildren();
			this.addChild(selectedItem.graphic)
		}
		
		/**
		 * 当前显示页的索引
		 */
		public function get index():int
		{
			return selectedIndex;
		}
		
		/**
		 * 获取当前显示项的数据
		 */
		public function get selected():Object
		{
			return this.selectedItem;
		}
		
		public function get contentMaxWidth():Number
		{
			var maxW:Number=0;
			for(var i:uint=0;i<contentMap.length;i++)
			{
				maxW=Math.max(maxW,contentMap[i].graphic.width);
			}
			return maxW
		}
	}
}


import flash.display.DisplayObject;

class ViewItem{
	
	public var id:String="";
	public var label:String="";
	public var graphic:DisplayObject=null;
	private var _obj:Object={};
	
	public function ViewItem(id:String,label:String="",graphic:DisplayObject=null):void
	{
		this.id=id;
		this.label=label;
		this.graphic=graphic;
		_obj.id=id;
		_obj.label=label;
		_obj.graphic=graphic;
	}
	
	public function get object():Object
	{
		return _obj;
	}
}