package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.interfaces.IItemRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	[Event(name="change", type="flash.events.Event")]
	
	/** 
	 * 选项卡，显示一组相同的选项卡
	 * @author idzeir
	 * 创建时间：2014-1-20 下午13:01:12
	 */
	public class TabBar extends Sprite
	{
		private var buttonBox:Sprite=new Sprite();
		
		private var _index:uint=0;
		
		private var data:Vector.<Object>=new Vector.<Object>();
		
		private var dictionary:Dictionary=new Dictionary(true);
		
		private var ItemRender:Class;		
		
		private var filtersMap:Dictionary=new Dictionary(true);
		/**
		 * 按钮间距 默认为1
		 */		
		private var _gap:Number = 1;
		
		private var _butMap:Vector.<DisplayObject>= new Vector.<DisplayObject>();
		private var _breaklines:Sprite = new Sprite();
		private var _breakCls:Class;
		
		public function TabBar(itemRender:Class=null,breakline:Class = null)
		{
			super();
			this.ItemRender=itemRender?itemRender:TabButton;
			this.addChild(buttonBox);
			this.addChild(_breaklines);
			_breakCls = breakline;
		}
		
		/**
		 * 增加一个选项卡 
		 * @param value
		 * 
		 */		
		public function addItem(value:Object):void
		{			
			var button:DisplayObject=new ItemRender();
			IItemRender(button).startUp(value);
			dictionary[button]=data.length;
			button.x=(button.width+_gap)*(buttonBox.numChildren);
			buttonBox.addChild(button);
			data.push(value);
			
			_butMap.push(button);
			
			if(!buttonBox.hasEventListener(flash.events.MouseEvent.CLICK))
			{
				buttonBox.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			buttonStaus=_index;
			vaildBreakLine();
		}
		
		private function vaildBreakLine():void
		{
			if(this._breakCls&&size>1)
			{
				//创建分割线
				while(this._breaklines.numChildren < size - 1)
				{
					var line:DisplayObject = new _breakCls();
					line.height = buttonBox.height;
					_breaklines.addChild(line);
				}
				//更新分割线位置
				for(var i:uint = 0;i<_breaklines.numChildren;i++)
				{
					var cline:DisplayObject = _breaklines.getChildAt(i);
					cline.x = _butMap[i].x + _butMap[i].width + _gap*.5 - cline.width*.5;
				}
			}
		}
		/**
		 * 按钮间距 默认为1 
		 * @param value
		 * 
		 */		
		public function set gap(value:Number):void
		{
			_gap = value;
			var xpos:Number = 0;
			for(var i:uint = 0; i<buttonBox.numChildren; i++)
			{
				buttonBox.getChildAt(i).x = xpos;
				xpos += buttonBox.getChildAt(i).width + _gap;
			}
			vaildBreakLine();
		}
		
		/**
		 * 标签的显示高度
		 * */
		public function get contentMaxHeight():Number
		{
			var maxW:Number=0;
			for(var i:uint=0;i<buttonBox.numChildren;i++)
			{
				maxW=Math.max(maxW,buttonBox.getChildAt(i).height);
			}
			return maxW
		}
		
		/**
		 * 设置TabBar的数据源 
		 * @param value  每项object 包含id,label,graphic 前两项必须
		 * 
		 */		
		public function set dataProvider(value:Vector.<Object>):void
		{
			data.length=0;
			buttonBox.removeChildren();
			for(var i:uint=0;i<value.length;i++)
			{
				addItem(value[i]);
			}
			buttonStaus=_index;
		}	
		
		protected function clickHandler(event:MouseEvent):void
		{
			var tar:DisplayObject=event.target as DisplayObject;
			if(tar is IItemRender)
			{			
				if(Sprite(tar).hasEventListener(Event.ENTER_FRAME))
				{
					Sprite(tar).removeEventListener(Event.ENTER_FRAME,showFilters);					
					delete filtersMap[Sprite(tar)]
				}
				tar.filters=[];
				
				if(this._index!=dictionary[tar])
				{
					_index=dictionary[tar];
					buttonStaus=_index;
					this.dispatchEvent(new Event(Event.CHANGE));
				}				
			}
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		/**
		 * 设置标签组的状态，指定的标签为选中状态，其它为未选中状态
		 * */
		private function set buttonStaus(value:uint):void
		{
			for(var i:uint=0;i<buttonBox.numChildren;i++)
			{
				var item:IItemRender=buttonBox.getChildAt(i) as IItemRender;
				if(i==value)
				{
					item.onSelected();
				}else{
					item.unSelected();
				}
			}
		}
		
		/**
		 * 闪烁指定的tab 
		 * @param _findex
		 * 
		 */		
		public function flash(_findex:uint):void
		{
			if(_findex>=this.buttonBox.numChildren)return;
			var target:Sprite=this.buttonBox.getChildAt(_findex) as Sprite;
			
			if(target)
			{
				filtersMap[target]={current:0,total:10,filter:new GlowFilter(0xd61ef6)};
				target.filters=[];
				this.playFilters(target);
			}
		}
		
		private function playFilters(target:Sprite):void
		{
			if(!target.hasEventListener(Event.ENTER_FRAME))
			{
				target.addEventListener(Event.ENTER_FRAME,showFilters);
			}
		}
		
		/**
		 * 闪烁动画 
		 * @param event
		 * 
		 */		
		protected function showFilters(event:Event):void
		{			
			var item:Sprite=event.currentTarget as Sprite;
			var gf:GlowFilter=filtersMap[item].filter;
			
			if(++filtersMap[item].current>filtersMap[item].total)
			{
				item.removeEventListener(Event.ENTER_FRAME,showFilters);
				gf.alpha=.6;
				gf.blurX=gf.blurY=10;
				gf.strength=2;
				item.filters=[gf];
				delete filtersMap[item]
				return;
			}
			var percent:Number=filtersMap[item].current/filtersMap[item].total;
			
			gf.alpha=percent*.6;
			gf.blurX=gf.blurY=10*percent;
			gf.strength=2*percent;
			item.filters=[gf];	
		}
		
		/**
		 * tab标签个数
		 */
		public function get size():Number
		{
			return this.data.length;
		}
		
		/**
		 * TabBar当前选中项的索引
		 */
		public function get index():uint
		{
			return _index;
		}
		
		/**
		 * 指定当前标签的索引
		 * */
		public function set index(value:uint):void
		{
			try{
				var tar:DisplayObject = this.buttonBox.getChildAt(value);
			}catch(e:Error){
				return;
			}			
			if(this._index!=dictionary[tar])
			{
				_index=dictionary[tar];
				buttonStaus=_index;
				this.dispatchEvent(new Event(Event.CHANGE));
			}				
		}
	}
}



import com._17173.flash.core.components.common.Button;
import com._17173.flash.core.components.interfaces.IItemRender;


class TabButton extends Button implements IItemRender
{
	
	public function TabButton()
	{
		super(" ");
	}
	public function startUp(value:Object):void
	{
		this.label = value.label;	
	}
	
	public function onMouseOver():void{}
	
	public function onMouseOut():void{}
	
	public function onSelected():void{}
	
	public function unSelected():void{}
}