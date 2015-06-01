package com._17173.flash.show.base.module.bag.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 *背包tabbar 
	 * @author yeah
	 */	
	public class BagTabBar extends Sprite
	{
		
		/**
		 *tabbar选择回调函数 
		 */		
		private var tabSelectedFunc:Function;
		
		public function BagTabBar($callBack:Function)
		{
			super();
			
			this.tabSelectedFunc = $callBack;
			
			createChildren();
		}

		/**
		 *创建子显示对象s 
		 */		
		private function createChildren():void
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			this.graphics.lineStyle(1, 0x7a0059);
			this.graphics.moveTo(0, 28);
			this.graphics.lineTo(534, 28);
		}
		
		/**
		 *点击 
		 * @param event
		 */		
		private function onClick(event:MouseEvent):void
		{
			var btn:BagTabBtn = event.target as BagTabBtn;
			if(!btn) return;
			selectedIndex = this.getChildIndex(btn);
		}		
		
		private var _data:Object;

		/**
		 * 数据源
		 * @return 
		 */		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
			onRender();
		}
		
		/**
		 *渲染 
		 */		
		private function onRender():void
		{
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			const GAP:int = 10;
			var pos:int = 0;
			for each (var itemData:Object in data)
			{
				var btn:BagTabBtn = new BagTabBtn();
				btn.data = itemData;
				btn.x = pos;
				this.addChild(btn);
				pos = btn.x + btn.width + GAP; 
			}
			
//			if(numChildren > 0)
//			{
//				selectedIndex = 0;
//			}
		}
		
		private var _selectedIndex:int = -1;

		/**
		 *tab页选择 
		 * @return 
		 */		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(value < 0)
			{
				value = 0;
			}
			else if(value >= numChildren)
			{
				value = numChildren -1;
			}
//			if(_selectedIndex == value) return;
			_selectedIndex = value;
			selectedBtn = this.getChildAt(_selectedIndex) as BagTabBtn;
		}

		
		private var _selectedBtn:BagTabBtn;

		/**
		 *当前选中的btn 
		 * @param value
		 */		
		protected function set selectedBtn(value:BagTabBtn):void
		{
			if(_selectedBtn == value) return;
			if(_selectedBtn)
			{
				_selectedBtn.selected = false;
			}
			_selectedBtn = value;
			if(_selectedBtn)
			{
				_selectedBtn.selected = true;
			}
			
			if(tabSelectedFunc != null)
			{
				tabSelectedFunc.call(null, _selectedBtn ? _selectedBtn.data : null);
			}
		}
	}
}

//===========================

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


class BagTabBtn extends Sprite
{
	
	/**文本*/
	private var tf:TextField;
	
	public function BagTabBtn()
	{
		super();
		mouseChildren = false;
		buttonMode = true;
		useHandCursor = true;
		
		var f:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 14);
		f.align = TextFormatAlign.CENTER;
		tf = new TextField();
		tf.defaultTextFormat = f;
		tf.width = 60;
		tf.height = 23;
		this.addChild(tf);
	}
	
	private var _data:Object;

	/**
	 *数据源 
	 */
	public function get data():Object
	{
		return _data;
	}

	/**
	 * @private
	 */
	public function set data(value:Object):void
	{
		if(value == data) return;
		_data = value;
		updateColor();
	}
	
	private var _selected:Boolean = false;

	public function get selected():Boolean
	{
		return _selected;
	}

	public function set selected(value:Boolean):void
	{
		if(_selected == value) return;
		_selected = value;
		updateColor();
	}
	
	/**
	 *更新颜色 
	 */	
	private function updateColor():void
	{
		const color:String = selected ? "#FFCC00" : "#DA1B66";
		tf.htmlText = "<font color='" + color + "'>"+ data.name +"</font>";
		this.graphics.clear();		
		if(!selected) return;
		this.graphics.lineStyle(2.5, 0xffcc00);
		this.graphics.moveTo(0, 25);
		this.graphics.lineTo(tf.width, 25);
	}
	
	
}