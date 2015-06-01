package com._17173.flash.show.base.module.horn
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.components.common.VMovePane;
	import com._17173.flash.show.base.components.event.MoveEvent;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ShowMessagePanel extends Sprite
	{
		private var _messages:Array;
		private var _vMovePane:VMovePane;
		private var _button:Button;
		private var _bg:Horn;
	
		private var _closeFun:Function;
		public function ShowMessagePanel()
		{
			super();
			_messages = [];
			
			_bg = new Horn();
			_bg.x = 0;
			_bg.y = 0;
			this.addChild(_bg);
			
			_vMovePane = new VMovePane(250,43,1,4);
			_vMovePane.y = 7;
			_vMovePane.x = 43;
			_vMovePane.mouseEnabled = false;
			_vMovePane.width = 250;
			_vMovePane.height = 43;
			this.addChild(_vMovePane);
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
		
			_button = new Button(lc.get("sendHorn","horn"),false);
			_button.setSkin(new Btn_horm_bg());
			_button.width = 54;
			_button.height = 46;
			_button.x = 302;
			_button.y = 6;
			_button.addEventListener(MouseEvent.CLICK,showSendMessage);
			this.addChild(_button);
			
			
			_vMovePane.addEventListener(MoveEvent.ITEM_MOVE_END,onItemMoveEnd);
			_vMovePane.addEventListener(MoveEvent.PLAY_NEXT,onPlayNext);
			_vMovePane.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_vMovePane.addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		
		public function get closeFun():Function
		{
			return _closeFun;
		}
		
		public function set closeFun(value:Function):void
		{
			_closeFun = value;
		}

		
		private function onOver(e:MouseEvent):void{
			_vMovePane.stop();
		}
		
		private function onOut(e:MouseEvent):void{
			_vMovePane.reStart();
		}
		
		private function onItemMoveEnd(e:MoveEvent):void{
			//如果没有播放的,则一直播放最后一条
			var text:DisplayObject = e.data as DisplayObject;
			if(_vMovePane.getMoveCount()<=0){
				_vMovePane.playItem(text);
			}else{
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				textManager.returnObject(text);
				showMessage();
			}
		}
		
		
		private function showSendMessage(e:MouseEvent):void{
			if(_closeFun != null){
				_closeFun();
			}
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
			_vMovePane.start();
			if(_vMovePane.canPlayNext && _messages.length > 0){
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
				sNameE.content = sName + "：";
				sNameE.color = 0x63acff;
				sNameE.type = GraphicTextElementType.Element_TEXT;
				
				var msgE:GraphicTextElement = textManager.createElement();
				msgE.content = msgstr + "(" + time + ")";
				msgE.color = 0x63acff;
				msgE.type = GraphicTextElementType.Element_CHAT_MESSAGE;
				
				var gto:GraphicTextOption = new GraphicTextOption(true);
				gto.showLink = true;
				gto.linkColor = 0xffffff;
				gto.textWidth = 246;
				
				var isUrl:Boolean = false;
				var roomId:String = (Context.variables["showData"]).roomID;
				if(Util.validateStr(url) && url!=null &&  roomId!= msg.roomId){
					//msgE.link = url;
					isUrl = true;
					gto.unline = true;
					gto.link = url;
				}
				var text:GraphicText = textManager.createGraphicText([sNameE,msgE],gto) as GraphicText;
				
				_vMovePane.playItem(text);
			}
		}
	}
}