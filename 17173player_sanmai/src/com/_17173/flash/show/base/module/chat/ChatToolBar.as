package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.DropDownList;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-14  下午3:17:57
	 */
	public class ChatToolBar extends Sprite
	{

		private var checkBox:PriCheckBox;

		private var clearButton:Smbutton;

		private var scrollButton:Smbutton;

		private var closePriChat:Smbutton;

		private var sendButton:Button;

		private var inTextBar:InTextBar;

		private var content:VGroup;

		private var dorplist:DropDownList;

		private var ievent:IEventManager;

		private var historyUser:Vector.<Object>;

		private var topline:HGroup;

		private var ilocal:ILocale;
		
		private var _chatNotify:ChatNotify;

		/**
		 * 是否滚屏
		 */
		private var scrolling:Boolean = true;

		public function ChatToolBar()
		{
			this.historyUser = new Vector.<Object>();
			super();
			ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			addChildren()
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		protected function onAdded(event:Event):void
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyUp);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}

		protected function onStageClick(event:MouseEvent):void
		{
			if(this.dorplist.isOpen)
			{
				if(!this.dorplist.getBounds(stage).contains(event.stageX, event.stageY))
				{
					this.dorplist.close();
				}
			}
		}

		protected function onRemoved(event:Event):void
		{
			if(stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}

		protected function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER && this.stage.focus && this.contains(this.stage.focus))
			{
				this.sendButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		private function addChildren():void
		{
			content = new VGroup();
			content.gap = -2;
			this.createChatTool();

			this.createInTxt();

			this.addChild(content);

			this.addEventListener(MouseEvent.CLICK, clickHandler);

			ievent = Context.getContext(CEnum.EVENT) as IEventManager;
			
			_chatNotify = new ChatNotify();
			ievent.listen(SEvents.CHAT_NOTIFY,showNotify);
		}
		
		private function showNotify(value:String):void
		{
			_chatNotify.titleStr = value;
			if(!this.contains(_chatNotify))
			{
				this.addChild(_chatNotify);
			}
			_chatNotify.visible = true;
			var fousRect:Rectangle = sendButton.getBounds(this);	
			var dstPos:Number = fousRect.left+fousRect.width*.5 - _chatNotify.width + 20;
			_chatNotify.x = dstPos + _chatNotify.width*.5;
			_chatNotify.y = _chatNotify.height*.5;
			_chatNotify.scaleX = _chatNotify.scaleY = .5;
			
			TweenMax.killChildTweensOf(_chatNotify);
			Ticker.stop(disappearNotify);
			
			TweenMax.to(_chatNotify,.2,{scaleX:1,scaleY:1,x:dstPos,y:0});
			Ticker.tick(5000,disappearNotify);
		}
		
		private function disappearNotify():void
		{
			if(this.contains(_chatNotify))
			{
				this.removeChild(_chatNotify);				
			}
			_chatNotify.visible = false;
		}

		public function expand(bool:Boolean):void
		{
			this.topline.visible = bool;
		}

		protected function createInTxt():void
		{
			var hGroup:HGroup = new HGroup();
			hGroup.top = 4;
			hGroup.valign = HGroup.MIDDLE;
			hGroup.left = 6;
			hGroup.graphics.lineStyle(1, 0x2c035d);
			hGroup.graphics.beginFill(0x280358);
			hGroup.graphics.drawRect(0, 0, 360, 37);
			hGroup.graphics.endFill();

			hGroup.graphics.beginFill(0x1B0537);
			hGroup.graphics.drawRect(6, 5, 350, 28)

			inTextBar = new InTextBar(ilocal.get("chat", "inputText"));
			inTextBar.focus = this;

			var box:HGroup = new HGroup();
			box.valign = HGroup.MIDDLE;
			box.addChild(inTextBar);

			sendButton = new Button(ilocal.get("send", "chatPanel"), false);
			sendButton.setSkin(new ChatButtonBg());
			sendButton.width = 54;
			sendButton.height = 28;
			box.addChild(sendButton);
			//inTextBar.y = 2;
			hGroup.addChild(box);
			content.addChild(hGroup);
		}

		public function focus_in():void
		{
			ievent.send(SEvents.EXPAND_CHAT_PANEL);
			if(!stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
		}

		public function focus_out():void
		{
			ievent.send(SEvents.EXPAND_CHAT_PANEL);
			if(stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
		}

		protected function createChatTool():void
		{
			topline = new HGroup();
			topline.valign = HGroup.MIDDLE;
			topline.left = 15;
			topline.addChild(new StaticTxt(ilocal.get("to", "chatPanel")));

			var dorpbackground:Shape = new Shape();
			dorplist = new DropDownList("up", 6, HistoryItemRender);
			dorplist.setBackground(0x4C118A, 1);
			var corrd:DisplayObjectContainer = this;
			var rect:Rectangle;
			dorplist.addEventListener(Event.SELECT, onSelected);

			dorplist.addEventListener(Event.CHANGE, function():void
				{
					if(dorplist.isOpen)
					{
						rect = dorplist.getBounds(corrd);
						//trace(this,"open",rect);
						dorpbackground.graphics.clear();
						dorpbackground.graphics.beginFill(0x380066 /*0x4C118A*/, .85);
						dorpbackground.graphics.drawRect(rect.left, rect.top, rect.width, rect.height);
					}
				});

			dorplist.addEventListener(Event.OPEN, function():void
				{
					rect = dorplist.getBounds(corrd);
					//trace(this,"open",rect);
					dorpbackground.graphics.clear();
					dorpbackground.graphics.beginFill(0x380066 /*0x4C118A*/, .85);
					dorpbackground.graphics.drawRect(rect.left, rect.top, rect.width, rect.height);
				});
			dorplist.addEventListener(Event.CLOSE, function():void
				{
					dorpbackground.graphics.clear();
				});
			dorplist.width = 73;
			this.addHistoryUser({name:ilocal.get("all", "chatPanel"), label:ilocal.get("all", "chatPanel"), id:0, data:{}});
			topline.addChild(dorplist);
			//dorplist.opaqueBackground=0x4C118A;

			topline.addChild(new StaticTxt(ilocal.get("say", "chatPanel")));
			checkBox = new PriCheckBox();
			checkBox.disabled = true;
			topline.addChild(checkBox);
			topline.addChild(new StaticTxt(ilocal.get("isWhisper", "chatPanel")));

			clearButton = new Smbutton(ilocal.get("clear", "chatPanel"));
			topline.addChild(clearButton);
			scrollButton = new Smbutton(ilocal.get("noScroll", "chatPanel"));
			topline.addChild(scrollButton);
			closePriChat = new Smbutton(ilocal.get("noPriChat", "chatPanel"));
			topline.addChild(closePriChat);
			content.addChild(topline);
			this.addChild(dorpbackground);
		}

		protected function onSelected(event:Event = null):void
		{
			this.checkBox.disabled = (this.dorplist.selected.id == 0);
			if(this.checkBox.selected)
			{
				this.checkBox.selected = !(this.dorplist.selected.id == 0);
			}
		}

		protected function clickHandler(event:MouseEvent):void
		{
			var tar:* = event.target;
			switch(tar)
			{
				case this.checkBox:
					//Debugger.tracer("复选",this.checkBox.selected);
					break;
				case this.clearButton:
					ievent.send(SEvents.CLEAR_CHAT_MSG);
					break;
				case this.closePriChat:
					this.changePrivateChatStatus();
					break;
				case this.scrollButton:
					scrolling = !scrolling;
					ievent.send(SEvents.LOCK_CHAT_SCROLL);
					this.scrollButton.label = ilocal.get(!scrolling ? "canScroll" : "noScroll", "chatPanel");
					break
				case this.sendButton:
					sendMsg();
					break;
			}
		}

		private function changePrivateChatStatus():void
		{
			var _s:IServiceProvider = (Context.getContext(CEnum.SERVICE) as IServiceProvider);
			var data:Object = {};
			data.privateChat = uint(!(Context.variables["showData"] as ShowData).userPrivateChatStatus);
			data.flag = data.privateChat;
			_s.http.postData(SEnum.USER_CLOSE_PRIVATE_CHAT + "?flag=" + data.flag, null);
			_s.socket.listen(SEnum.R_CLOSE_PRIVATE_CHAT.action, SEnum.R_CLOSE_PRIVATE_CHAT.type, chatStatusChanage)
		}

		private function chatStatusChanage(value:*):void
		{
			if(!(value is String) && value.hasOwnProperty("ct"))
			{

				if((Context.getContext(CEnum.USER) as IUser).me.id == value.ct.userId)
				{
					var isAllowed:Boolean = (Context.variables["showData"] as ShowData).userPrivateChatStatus = Boolean(value.ct.privateChat);
					this.closePriChat.label = ilocal.get(isAllowed ? "noPriChat" : "yesPriChat", "chatPanel");
				}
			}
		}

		private function sendMsg():void
		{
			var msg:String = this.inTextBar.text;
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);

			var iAuthority:IAuthorityData = iuser.validateAuthority(iuser.me, AuthorityStaitc.THING_1);

			if(checkBox.selected && !(Context.variables["showData"] as ShowData).userPrivateChatStatus)
			{
				ievent.send(SEvents.ON_CHAT_ERROR_MESSAGE, ilocal.get("noPriWarning", "chatPanel"));
				return;
			}
			var _len:uint = this.inTextBar.length;

			var msgVo:Object = {};
			var type:uint = this.dorplist.selected.id == 0 ? 0 : 1;
			var isPrvChat:Boolean = this.checkBox.selected;

			//如果是公共私聊
			if(type && isPrvChat)
			{
				type = 2;
			}
			//2：私聊，1：公共私聊, 0:公聊
			var _method_:String = ['SendPubMsg', 'SendPrvMsg', 'SendPrvMsg'][type];
			msgVo._method_ = _method_;
			//服务器会进行unescape处理，不加服务器会报解码错误
			msgVo.ct = escape(this.inTextBar.text);
			msgVo.checksum = "";
			if(type > 0)
			{
				msgVo.toMasterId = this.dorplist.selected.data.id;
				msgVo.toMasterNick = this.dorplist.selected.data.name;
				msgVo.pub = type == 1 ? 1 : 0;
			}
			var chatType:Object = [SEnum.S_CHAT_PUBLIC, SEnum.S_CHAT_PUBLIC_PRI, SEnum.S_CHAT_PRIVATE][type];
			(Context.getContext(CEnum.SERVICE) as IServiceProvider).socket.send(chatType, msgVo);
			inTextBar.clear();
		}

		public function set isPrivate(bool:Boolean):void
		{
			this.checkBox.selected = bool;
		}

		public function addHistoryUser(value:Object):void
		{
			if(this.historyUser.length > 0)
			{
				for(var i:uint = 0; i < this.historyUser.length; i++)
				{
					if(value.id == this.historyUser[i].id)
					{
						this.historyUser.splice(i, 1);
					}
				}
			}

			this.historyUser.push({label:value.name, id:value.id, data:value});
			if(this.historyUser.length >= this.dorplist.maxline)
			{
				this.historyUser.splice(1, 1);
			}
			this.dorplist.dataProvider = this.historyUser;
			if(this.checkBox)
				this.checkBox.disabled = false;
		}
	}
}

import com._17173.flash.core.components.common.Button;
import com._17173.flash.show.base.utils.FontUtil;

import flash.text.TextField;
import flash.text.TextFormat;

class StaticTxt extends TextField
{
	public function StaticTxt(arg:String = "")
	{
		var tf:TextFormat = new TextFormat(FontUtil.f);
		this.defaultTextFormat = tf;
		this.mouseEnabled = false;
		this.textColor = 0xD0CFCF;
		autoSize = "left";
		this.text = arg;
	}
}


class Smbutton extends Button
{
	public function Smbutton(_slabel:String = "")
	{
		super(_slabel);
		this.setSkin(new Button_NormalBg_s_1_8());
		this.label = _slabel;
		width = 45;
		height = 20;
		this.buttonMode = true;
	}

	override public function set label(value:String):void
	{
		super.label = "<font size='12' color='#d0cfcf'>" + value + "</font>";
		width = 45;
		height = 20;
		this.onRePostionLabel();
	}
}