package com._17173.flash.show.base.module.horn
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.module.horn.view.HornShowPane;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class HornPanel extends Sprite
	{
		
		/**
		 *显示广播面板 
		 */		
		private var _showPane:HornShowPane;
		
		/**
		 *发送消息面板 
		 */		
		private var _sendMessage:SendMessagePanel;
		
		public function HornPanel()
		{
			super();
			_sendMessage = new SendMessagePanel();
			_sendMessage.visible = false;
			this.addChild(_sendMessage);
			
			_showPane = new HornShowPane();
			_showPane.y = _sendMessage.height;
			_showPane.addEventListener("openSendPane", openSendPane);
			this.addChild(_showPane);
		}

		/**
		 *大开发送面板 
		 * @param event
		 */		
		private function openSendPane(event:Event):void
		{
			//检测是否登录，如果登录则显示发送消息，如果未登录则弹出登录框;
			var showdata:Object = Context.variables["showData"];
			if(showdata.masterID !=null && int(showdata.masterID) > 0)
			{
				_sendMessage.visible = !_sendMessage.visible;
			}
			else
			{
				Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
			}
		}
		
		private var _size:int;
		/**
		 *设置尺寸 
		 * @param value
		 */		
		public function set size(value:int):void
		{
			if(_size == value) return;
			_size = value;
			if(_showPane)
			{
				_showPane.resize(_size);
			}
			if(_sendMessage)
			{
				_sendMessage.x = _size - _sendMessage.width;
			}
		}

		/**
		 *添加消息 
		 */		
		public function addMessage(msg:Object):void{
			_showPane.addMessage(msg);
		}
	}
}