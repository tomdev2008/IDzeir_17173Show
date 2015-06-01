package com._17173.flash.show.base.components.common.plugbutton
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 *按钮条
	 * @author zhaoqinghao
	 * 
	 */	
	public class PlugButtonBar extends BaseContainer
	{
		private var _buttons:Dictionary = null;
		/**
		 *用于排序显示 
		 */		
		private var _btns:Array = [];
		private var _buttonCount:int = 0;
		private var _width:int = 0;
		private var _height:int = 0;
		private var _isHorizontal:Boolean = true;
		private var _space:int = 5;
		private var _eventmanager:IEventManager;
		private var _evenType:String ;
		public function PlugButtonBar(em:IEventManager,horizontal:Boolean = true, space:int = 5)
		{
			_eventmanager = em;
			_isHorizontal = horizontal;
			_space = space;
			super(null);
			this.mouseEnabled = false;
			_buttons = new Dictionary(true);
		}
		
		public function addButtons(datas:Array):void{
			for each (var data:PlugButton in datas) 
			{
				addButton(data);
			}
		}
		
		public function addButton(button:PlugButton):void{
			//已经存在同样数据button,做任何操作
			if(_buttons[button.eType])return;
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			_buttons[button.eType] = button;
			_btns.push(button);
			_buttonCount++;
			//排序
			_btns.sort(onButtonSort);
			updatePosition();
			this.addChild(button);
			//派发已添加按钮事件
			_eventmanager.send(SEvents.PLUGBUTTON_ADDED,button);
		}
		
		/**
		 *排序 
		 * @param button1
		 * @param button2
		 * 
		 */		
		protected function onButtonSort(button1:PlugButton,button2:PlugButton):int{
			var result:int = 0;
			if(button1.order < button2.order){
				result = -1;
			}else if(button1.order > button2.order){
				result = 1;
			}else{
				var idx1:int = 0;
				var idx2:int = 0;
				var len:int = _btns.length;
				for (var i:int = 0; i < len; i++) 
				{
					if(button1 === _btns[i]){
						idx1 = i;
						break;
					}
					if(button2 === _btns[i]){
						idx2 = i;
						break;
					}
				}
				if(idx1 < idx2){
					result =  -1;
				}
				else{
					result = 0;
				}
				
			}
			return result;
			
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
				var button:Button = _buttons[type];
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
			for each (var data:PlugButton in datas) 
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
		
		public function removeButtom(button:PlugButton):void{
			if(_buttons[button.eType]){
				var button:PlugButton = _buttons[button.eType];
				button.removeEventListener(MouseEvent.CLICK, onButtonClick);
				delete _buttons[button.eType];
				_btns = _btns.slice(_btns.indexOf(button),1);
				updatePosition();
				if(button && button.parent){
					button.parent.removeChild(button);
				}
				_buttonCount--;
				_eventmanager.send(SEvents.PLUGBUTTON_REMOVED,button);
			}
		}
		
		protected function onButtonClick(e:Event):void{
			var button:PlugButton = e.currentTarget as PlugButton;
			var type:String = button.eType;
			_eventmanager.send(SEvents.BOTTOM_BUTTON_CLICK,type);
			_eventmanager.send(type,button);
			e.stopImmediatePropagation();
		}
		
		protected function updatePosition():void{
			_btns  = _btns.sort(sortdata);
			var button:Button;
			if(_isHorizontal){
				var lastX:int = 0
				for each (button in _btns) 
				{
					button.x = lastX;
					button.y = 0;
					lastX += button.width + _space;
					_eventmanager.send(SEvents.PLUGBUTTON_CHANGE_POSTION,button);
				}
				this.width = lastX;
			}else{
				var lastY:int = 0
				for each (button in _btns) 
				{
					button.x = 0;
					button.y = lastY;
					lastY += button.height + _space;
					_eventmanager.send(SEvents.PLUGBUTTON_CHANGE_POSTION,button);
				}
				this.height = lastY;
			}
			
		}
		
		
		public function sendClick4Type(type:String):void{
			var button:PlugButton = _buttons[type] as PlugButton;
			if(button && button.parent){
				var type:String = button.eType;
				_eventmanager.send(type,button);
			}
		}
		
		override public function set y(value:Number):void{
			super.y = value;
			updatePosition();
		}
		
		protected function sortdata(button1:PlugButton,button2:PlugButton):int{
			var result:int = 1;
			if(button1.order > button2.order){
				result =  1;
			}else if(button1.order == button2.order){
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

