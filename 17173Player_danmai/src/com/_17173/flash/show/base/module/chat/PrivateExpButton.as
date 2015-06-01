package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 *
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 3, 2014||4:54:04 PM
	 */
	public class PrivateExpButton extends Button
	{
		private var _priClose:DisplayObject;
		private var _priOpen:DisplayObject;
		/**
		 * 当前状态 false 为展开 
		 */		
		private var _status:Boolean = false;
		
		private var _e:IEventManager;
		
		private var _bg:DisplayObject;
		private var _unReadBut:Sprite;
		
		private var _txt:TextField;
		
		private var _unreadTotal:int = 0;
		
		public function PrivateExpButton(label:String="<font size='12' color='#ffffff'>私聊</font>", isSelected:Boolean=false)
		{
			super(label, isSelected);
			
			this.mouseChildren = false;
			_priClose = new PrivClose1_8();
			_priOpen = new PrivOpen1_8();
			
			this.setSkin(_priClose);
			this.setSize(50,20);
			
			_unReadBut = new Sprite();
			_unReadBut.visible = false;
			this.addChild(_unReadBut);	
			_txt = new TextField();
			_txt.autoSize = "left";
			_txt.defaultTextFormat = new TextFormat(FontUtil.f,9);
			_unReadBut.addChild(_txt);
			
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
		}
		
		override protected function onOver(e:Event):void
		{
			super.onOver(e);
			this._labelTxt.textColor = 0xFFFFCC;
		}
		
		override protected function onOut(e:Event):void
		{
			super.onOut(e);
			this._labelTxt.textColor = 0xFFFFFF;
		}
		
		override protected function onRePostionLabel():void{
			if(_labelTxt){
				_labelTxt.x = (width - (_labelTxt.width))/2 - 4;
				_labelTxt.y = (height - (_labelTxt.height))/2-1;
			}
		}
		
		override protected function onMouseDown(e:Event):void{
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_status = !_status;
			if(!_status)
			{
				this.setSkin(_priClose);
				_e.remove(SEvents.HISTORY_TOTAL,historyToal);
				_unReadBut.visible = false;
				_txt.htmlText = "";
				_unreadTotal = 0;
				_e.send(SEvents.SWITCH_PRI_CHAT,false);
			}else{
				this.setSkin(_priOpen);
				_e.listen(SEvents.HISTORY_TOTAL,historyToal);
				_e.send(SEvents.SWITCH_PRI_CHAT,true);
			}		
			this.setSize(50,20);
		}
		
		private function historyToal(value:int):void
		{
			var s:String = "";
			_unreadTotal++
			if(_unreadTotal>9)
			{
				s = "9+"
			}else{
				s = _unreadTotal.toString();
			}
			_unReadBut.visible = true;
			_txt.htmlText = "<font color='#FFCC00' size='9'>"+s+"</font>";	
			_unReadBut.graphics.clear();
			_unReadBut.graphics.beginFill(0xF42166);
			_unReadBut.graphics.drawRoundRect(0,0,12,12,5);
			_unReadBut.graphics.endFill();			
			_unReadBut.x = this.width - 3;
			_unReadBut.y = -3;	
			_txt.x = 12 - _txt.width>>1;
			_txt.y = 12 - _txt.height>>1;
		}
		
	}
}