package com._17173.flash.show.base.module.roomset.component
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.module.roomset.common.ButtonBindData;
	import com._17173.flash.show.base.module.roomset.view.OpertView;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class OpertList extends Sprite
	{
		private var _measuredWidth:int = 155;//默认宽度
		private var _measuredHight:int = 100;// 默认高度
		
		private var _buttons:Dictionary = null;
		/**
		 *用于排序显示 
		 */		
		private var _itemArray:Array = [];
		
		public function OpertList()
		{
			super();
			this.mouseEnabled = false;
			_buttons = new Dictionary(true);
		}

		public function get measuredHight():int
		{
			return _measuredHight;
		}

		public function get measuredWidth():int
		{
			return _measuredWidth;
		}

		public function addButtons(datas:Array):void{
			for each (var data:ButtonBindData in datas) 
			{
				addButton(data);
			}
		}
		
		public function addButton(data:ButtonBindData):void{
			//已经存在同样数据button,做任何操作
			if(_buttons[data.type])return;
			var button:OpertItem = new OpertItem();
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			button.data = data;
			_buttons[data.type] = button;
			_itemArray.push(button);
			
			updateDisplayList();			
			this.addChild(button);
		}
		
		/**
		 *更新按钮文本 
		 * @param type 按钮type
		 * @param newLabel 新文本
		 * @param newType 是否需要新type
		 * 
		 */		
		public function updateLabel(type:String, newLabel:String):void{
			if(_buttons[type]){
				var button:OpertItem = _buttons[type];
				button.label = newLabel;
				updateDisplayList();
			}
		}
		/**
		 *移除按钮 
		 * @param datas
		 * 
		 */		
		public function removeButtons(datas:Array):void{
			for each (var data:ButtonBindData in datas) 
			{
				removeButtom(data);
			}
		}
		
		/**
		 *移除所有按钮 
		 * 
		 */		
		public function removeAllButton():void{
			if(_buttons == null) return;
			for (var key:String in _buttons) 
			{
				removeButtom(_buttons[key].data);
			}
			
		}
		
		public function removeButtom(data:ButtonBindData):void{
			if(_buttons[data.type]){
				var button:OpertItem = _buttons[data.type];
				button.removeEventListener(MouseEvent.CLICK, onButtonClick);
				delete _buttons[data.type];
				_itemArray = _itemArray.slice(_itemArray.indexOf(button),1);
				updateDisplayList();
				if(button && button.parent){
					button.parent.removeChild(button);
				}
			}
		}
		
		protected function onButtonClick(e:Event):void{
			var button:OpertItem = e.currentTarget as OpertItem;
			var type:String = button.data.type;
			var iEvent:IEventManager = Context.getContext(CEnum.EVENT);
			var pot:Point = this.parent.globalToLocal(button.localToGlobal(new Point(0,0)));
			iEvent.send(type,[pot,(this.parent as OpertView).panelCn]);
			e.stopImmediatePropagation();
		}
		
		/**
		 * 更新列表
		 * */
		protected function updateDisplayList():void{
			_itemArray  = _itemArray.sort(sortdata);
			_itemArray.forEach(function measured(opi:OpertItem,index:Number,array:Array):void
			{
				_measuredWidth = _measuredWidth<opi.measuredWidth?opi.measuredWidth:_measuredWidth;
			},null);
			
			var vy:int = 0;
			for each (var button:OpertItem in _itemArray) 
			{
				button.measuredWidth = _measuredWidth;
				button.updateDisplayList();
				button.x = 0;
				button.y = vy;
				vy += button.measuredHight;
			}
			_measuredHight = _measuredHight<vy?vy:_measuredHight;
			
			this.graphics.clear();
			this.graphics.beginFill(0,.8);
			this.graphics.drawRect(0,0,_measuredWidth,_measuredHight);
			this.graphics.endFill();
		}
		
		
		public function sendClick4Type(type:String):void{
			var button:OpertItem = _buttons[type] as OpertItem;
			if(button && button.parent){
				var type:String = button.data.type;
				var iEvent:IEventManager = Context.getContext(CEnum.EVENT);
				var pot:Point = this.parent.globalToLocal(button.localToGlobal(new Point(0,0)));
				iEvent.send(type,[pot,(this.parent as OpertView).panelCn]);
			}
		}
		
		protected function sortdata(button1:OpertItem,button2:OpertItem):int{
			var result:int = 1;
			if(button1.data.order > button2.data.order){
				result =  1;
			}else if(button1.data.order == button2.data.order){
				//判断添加先后顺序
				var b1Idx:int = _itemArray.indexOf(button1);
				var b2Idx:int = _itemArray.indexOf(button2);
				if(b1Idx < b2Idx){
					result = -1;
				}else{
					result = 1;
				}
			}else{
				result = -1;
			}
			return result;
		}
	}
}