package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.show.base.components.common.HMovePane;
	import com._17173.flash.show.base.components.event.MoveEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;

	/**
	 *显示广播 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomShowMessage extends Sprite
	{
		
		private var _showSendBtn:Button = null;
		private var _iconSound:MovieClip = null;
		private var _movePane:HMovePane = null;
		private var _closeCallBack:Function = null;
		private var _messages:Array;

		public function BottomShowMessage()
		{
			super();
			init();
			mouseEnabled = false;
			_messages = [];
		}
		
		private function init():void{
			this.graphics.beginFill(0x18033C);
			this.graphics.drawRect(0,-5,430,40);
			this.graphics.endFill();
			
			_iconSound = new Bottom_IconSound();
			_iconSound.y = 2;
			_iconSound.mouseEnabled = false;
			_iconSound.mouseChildren = false;
			this.addChild(_iconSound);
			
			_movePane = new HMovePane(320,50,1,50);
			_movePane.y = -3;
			_movePane.x = _iconSound.width + 6;
			_movePane.mouseEnabled = false;
			_movePane.width = 312;
			_movePane.height = 23;
			this.addChild(_movePane);
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			_showSendBtn = new Button(lc.get("send_guangbobtn","bottom"));
			_showSendBtn.x = 363;
			_showSendBtn.y = 2;
			_showSendBtn.width = 57;
			_showSendBtn.height = 23;
			_showSendBtn.addEventListener(MouseEvent.CLICK,onShowClick);
			this.addChild(_showSendBtn);
			_movePane.addEventListener(MoveEvent.ITEM_MOVE_END,onItemMoveEnd);
			_movePane.addEventListener(MoveEvent.PLAY_NEXT,onPlayNext);
			_movePane.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_movePane.addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		
		private function onOver(e:MouseEvent):void{
			_movePane.stop();
		}
		
		private function onOut(e:MouseEvent):void{
			_movePane.reStart();
		}
		
		/**
		 *新消息 
		 * @param data 消息
		 * @param type 是否优先显示
		 * 
		 */			
		public function addMessage(data:*,type:int = 0):void{
			if(type != 0){
				_messages.unshift(data);
			}else{
				_messages.push(data);
			}
			showMessage();
		}
		
		private function onPlayNext(e:Event):void{
			showMessage();
		}
		
		private function showMessage():void{
			_movePane.start();
			if(_movePane.canPlayNext && _messages.length > 0){
				//创建显示对象
				var msg:Object = _messages.shift();
				//赋值显示消息
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				var sName:String = msg.sName;
				var sNo:String = msg.sNo;
				var msgstr:String = msg.msg;
				var time:String = msg.time;
				var url:String = msg.url;
				
				var sNameE:GraphicTextElement = textManager.createElement();
				sNameE.content = sName + "("+sNo+")：";
				sNameE.color = 0x63acff;
				sNameE.type = GraphicTextElementType.Element_CHAT_MESSAGE;
				
				var msgE:GraphicTextElement = textManager.createElement();
				msgE.content = msgstr + "(" + time + ")";
				msgE.color = 0x63acff;
				msgE.type = GraphicTextElementType.Element_CHAT_MESSAGE;
				
				var isUrl:Boolean = false;
				var roomId:String = (Context.variables["showData"] as ShowData).roomID;
				if(Util.validateStr(url) && url!=null &&  roomId!= msg.roomId){
					msgE.link = url;
					isUrl = true;
				}
				var text:DisplayObject = textManager.createGraphicText([sNameE,msgE]);
				
				if(isUrl){
					(text as GraphicText).showLink = true;
				}
				_movePane.playItem(text);
			}
		}
		
		
		private function onItemMoveEnd(e:MoveEvent):void{
			//如果没有播放的,则一直播放最后一条
			var text:DisplayObject = e.data as DisplayObject;
			if(_movePane.getMoveCount()<=0){
				_movePane.playItem(text);
			}else{
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				textManager.returnObject(text);
				showMessage();
			}
		}
		
		private function onShowClick(e:Event):void{
			if(_closeCallBack != null){
				_closeCallBack();
			}
		}
		
		public function get closeCallBack():Function
		{
			return _closeCallBack;
		}
		
		public function set closeCallBack(value:Function):void
		{
			_closeCallBack = value;
		}
	}
}