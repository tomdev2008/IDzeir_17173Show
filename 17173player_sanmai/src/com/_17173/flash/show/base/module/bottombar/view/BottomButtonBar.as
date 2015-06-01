package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.components.base.BaseContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import com._17173.flash.show.model.CEnum;

	/**
	 *按钮条
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomButtonBar extends BaseContainer
	{
		private var _buttons:Dictionary = null;
		/**
		 *用于排序显示 
		 */		
		private var _btns:Array = [];
		private var _buttonCount:int = 0;
		private var _width:int = 0;
		private var _height:int = 0;
		public function BottomButtonBar()
		{
			super();
			this.mouseEnabled = false;
			_buttons = new Dictionary(true);
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
			var button:BottomButton = new BottomButton(data);
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			_buttons[data.type] = button;
			_btns.push(button);
			_buttonCount++;
			updatePosition();
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
				var button:BottomButton = _buttons[type];
				button.label = newLabel;
				updatePosition();
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
				var button:BottomButton = _buttons[data.type];
				button.removeEventListener(MouseEvent.CLICK, onButtonClick);
				delete _buttons[data.type];
				_btns = _btns.slice(_btns.indexOf(button),1);
				updatePosition();
				if(button && button.parent){
					button.parent.removeChild(button);
				}
				_buttonCount--;
			}
		}
		
		protected function onButtonClick(e:Event):void{
			var button:BottomButton = e.currentTarget as BottomButton;
			var type:String = button.data.type;
			var iEvent:IEventManager = Context.getContext(CEnum.EVENT);
			var pot:Point = this.parent.globalToLocal(button.localToGlobal(new Point(0,0)));
			iEvent.send(type,[pot,(this.parent as BottomBarUI).panelCn]);
			e.stopImmediatePropagation();
		}
		
		protected function updatePosition():void{
			_btns  = _btns.sort(sortdata);
			var lastx:int = 0
			for each (var button:BottomButton in _btns) 
			{
				button.x = lastx;
				button.y = (height - button.height) / 2;
				lastx += button.width + 5;
			}
			this.width = lastx;
		}
		
		
		public function sendClick4Type(type:String):void{
			var button:BottomButton = _buttons[type] as BottomButton;
			if(button && button.parent){
				var type:String = button.data.type;
				var iEvent:IEventManager = Context.getContext(CEnum.EVENT);
				var pot:Point = this.parent.globalToLocal(button.localToGlobal(new Point(0,0)));
				iEvent.send(type,[pot,(this.parent as BottomBarUI).panelCn]);
			}
		}
		
		protected function sortdata(button1:BottomButton,button2:BottomButton):int{
			var result:int = 1;
			if(button1.data.order > button2.data.order){
				result =  1;
			}else if(button1.data.order == button2.data.order){
				//判断添加先后顺序
				var b1Idx:int = _btns.indexOf(button1);
				var b2Idx:int = _btns.indexOf(button2);
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