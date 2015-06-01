package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.DropDownList;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
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

		//private var clearButton:ChatToolButton;

		//private var scrollButton:ChatToolButton;

		//private var closePriChat:ChatToolButton;

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

		//历史聊天记录箭头按钮
		private var arrow:Button;

		private var upArrow:MovieClip;

		private var downArrow:MovieClip;

		private var flyButton:FlyButton;

		private var flyTool:FlyTool;

		private var iserver:IServiceProvider;

		public function ChatToolBar()
		{
			this.historyUser = new Vector.<Object>();
			super();
			ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			iserver = (Context.getContext(CEnum.SERVICE) as IServiceProvider);
			
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
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
			}				
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
			content.gap = 4;
			
			upArrow = new HistoryUpArrow1_8();
			downArrow = new HistoryDownArrow1_8();
			
			this.createChatTool();

			this.createInTxt();			

			this.addChild(content);

			this.addEventListener(MouseEvent.CLICK, clickHandler);

			ievent = Context.getContext(CEnum.EVENT) as IEventManager;
			
			_chatNotify = new ChatNotify();
			ievent.listen(SEvents.CHAT_NOTIFY,showNotify);
			
			flyTool = new FlyTool();
			flyTool.addEventListener(FlyEvent.FLY_SEND,function(e:FlyEvent):void
			{
				sendFlyScreen(e.flyId);
			});
		}
		
		/**
		 * 更新飞屏配置数据 
		 * @param value
		 * 
		 */		
		public function updateFlyFromData(value:Object):void
		{
//			Debugger.log(Debugger.INFO,"[FlyScreen]",JSON.stringify(value));
//			var debugD:Array = JSON.parse(value as String) as Array;
			//测试数据
			/*var debug:Array = ["http://p3.v.17173cdn.com/tfrquk/YWxqaGBf/show/20150115/193848/b1c498b5-b892-446e-8f78-99b3b92e1b8b.png","http://p2.v.17173cdn.com/tfrquk/YWxqaGBf/show/20150115/193856/ac1587da-3855-4413-9cb0-3fe46c90ce1b.png","http://p3.v.17173cdn.com/tfrquk/YWxqaGBf/show/20150115/193902/f69aeca7-d094-4d55-8112-3b7f5995fa0a.png"];
			value[0].flyResPreviewPath = debug[0];
			value[1].flyResPreviewPath = debug[1];
			value[2].flyResPreviewPath = debug[2];*/
			
			flyTool.updateFromData(value as Array);
		}
		
		private function showNotify(value:*):void
		{
			if(value.hasOwnProperty("result"))
			{
				_chatNotify.titleStr = value["result"];
				if(!this.contains(_chatNotify))
				{
					this.addChild(_chatNotify);
				}
				_chatNotify.visible = true;
			}
			
			var fousRect:Rectangle = sendButton.getBounds(this);	
			var dstPos:Number = fousRect.left+fousRect.width*.5 - _chatNotify.width + 20;
			_chatNotify.x = dstPos + _chatNotify.width*.5;
			_chatNotify.y = _chatNotify.height*.5 - 10;
			_chatNotify.scaleX = _chatNotify.scaleY = .5;
			
			TweenMax.killChildTweensOf(_chatNotify);
			Ticker.stop(disappearNotify);
			
			TweenMax.to(_chatNotify,.2,{scaleX:1,scaleY:1,x:dstPos,y:-10});
			Ticker.tick(5000,disappearNotify);
			
			if(Utils.validate(value,"chatMsg"))
			{
				this.inTextBar.text = unescape(value["chatMsg"]);				
			}
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
			hGroup.graphics.lineStyle(1, 0x2c035d,0);
			hGroup.graphics.beginFill(0x31023D);
			hGroup.graphics.drawRect(0, 0, 360, 56);
			hGroup.graphics.endFill();

			hGroup.graphics.beginFill(0x1B0537);
			hGroup.graphics.drawRect(5, 5, 350, 46)

			inTextBar = new InTextBar(ilocal.get("chat", "inputText"));
			inTextBar.smileDir = 1;
			inTextBar.focus = this;
			inTextBar.inTxt.wordWrap = true;
			inTextBar.inTxt.width = 216;
			inTextBar.inTxt.height = 46;
			inTextBar.smileFace.y = 15;
			inTextBar.update();
			inTextBar.backgroundColor = 0x1B0537;

			var box:HGroup = new HGroup();
			box.gap = 3;
			box.valign = HGroup.MIDDLE;
			box.addChild(inTextBar);

			sendButton = new Button("<font color='#FFFF99'>"+ilocal.get("send", "chatPanel")+"</font>", false);
			sendButton.setSkin(new SendChatBg1_8());
			sendButton.width = 54;
			sendButton.height = 46;
			box.addChild(sendButton);
			
			flyButton = new FlyButton("<font color='#FFFF99'>"+ilocal.get("fly", "chatPanel")+"</font>");
			flyButton.setSkin(new FlyBg1_8());
			flyButton.width = 54;
			flyButton.height = 46;
			box.addChild(flyButton);	
			
			hGroup.addChild(box);
			content.addChild(hGroup);
		}
		
		public function set hidenTool(bool:Boolean):void
		{
			topline.visible = bool;
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
			dorplist.setBackground(0x31023D, .91);
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
					arrow.setSkin(downArrow);
				});
			dorplist.addEventListener(Event.CLOSE, function():void
				{
					dorpbackground.graphics.clear();
					arrow.setSkin(upArrow);
				});
			dorplist.width = 60;
			
			arrow = new Button();
			
			this.addHistoryUser({name:ilocal.get("all", "chatPanel"), label:ilocal.get("all", "chatPanel"), id:0, data:{}});
			//历史记录和箭头容器
			var dp:HGroup = new HGroup();
			dp.gap = 0;
			dp.valign = HGroup.MIDDLE;
			dp.addChild(dorplist);			
			arrow.setSkin(upArrow);
			arrow.height = downArrow.height = upArrow.height = dorplist.height;
			arrow.mouseEnabled = false;
			arrow.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				if(!dorplist.isOpen)
				{
					dorplist.open();
					arrow.setSkin(downArrow);
				}else{
					dorplist.close();
					arrow.setSkin(upArrow);
				}
				e.stopPropagation();
			});
			
			dp.addChild(arrow);
			
			topline.addChild(dp);
			topline.addRawChildAt(new PrivateExpButton(),topline.numChildren,360 - 55);
			//dorplist.opaqueBackground=0x4C118A;

			topline.addChild(new StaticTxt(ilocal.get("say", "chatPanel")));
			checkBox = new PriCheckBox();
			checkBox.disabled = true;
			topline.addChild(checkBox);
			topline.addChild(new StaticTxt(ilocal.get("isWhisper", "chatPanel")));

			//clearButton = new ChatToolButton(ilocal.get("clear", "chatPanel"));
			//topline.addChild(clearButton);
			//scrollButton = new ChatToolButton(ilocal.get("noScroll", "chatPanel"));
			//topline.addChild(scrollButton);
			//closePriChat = new ChatToolButton(ilocal.get("noPriChat", "chatPanel"));
			//topline.addChild(closePriChat);
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
			flyButton.disabled = checkBox.selected;
		}

		protected function clickHandler(event:MouseEvent):void
		{
			var tar:* = event.target;
			switch(tar)
			{
				case this.checkBox:
					//Debugger.tracer("复选",this.checkBox.selected);
					flyButton.disabled = checkBox.selected;
					break;
				/*case this.clearButton:
					ievent.send(SEvents.CLEAR_CHAT_MSG);
					break;
				case this.closePriChat:
					this.changePrivateChatStatus();
					break;
				case this.scrollButton:
					scrolling = !scrolling;
					ievent.send(SEvents.LOCK_CHAT_SCROLL);
					this.scrollButton.label = ilocal.get(!scrolling ? "canScroll" : "noScroll", "chatPanel");
					break*/
				case this.sendButton:
					sendMsg();
					break;
				case this.flyButton:
					if(!flyButton.disabled)
					{
						event.stopImmediatePropagation();
						event.stopPropagation();
						this.flyTool.fixedPoint(2,this.sendButton.getBounds(this).top - this.flyTool.height - 8);
						this.flyTool.toggleAppearIn(this);
						this.ievent.send(SEvents.CLOSE_SMILE_PANEL);
					}					
					break;
			}
		}

		/*private function changePrivateChatStatus():void
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
		}*/

		private function sendMsg(hasFly:Boolean = false,flyid:* = null):void
		{
			var msg:String = this.inTextBar.text;
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
			//登录验证
			if(!iuser.me.isLogin)
			{
				ievent.send(SEvents.LOGINPANEL_SHOW);
				return;
			}
			var showData:ShowData = (Context.variables["showData"] as ShowData);
			//私聊权限验证
			var iAuthority:IAuthorityData = iuser.validateAuthority(iuser.me, AuthorityStaitc.THING_1);
			if(checkBox.selected && !showData.userPrivateChatStatus)
			{
				ievent.send(SEvents.ON_CHAT_ERROR_MESSAGE, ilocal.get("noPriWarning", "chatPanel"));
				return;
			}
			var _len:uint = this.inTextBar.length;
			
			if(_len == 0){
				showNotify({result:this.ilocal.get("empytError","chatPanel")})
				return;
			}
			
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
			
			iserver.socket.send(chatType, msgVo);			
			inTextBar.clear();			
			//统计艺人发言
			if(iuser.me.broker)
			{
				var isprivate:int = (type == 1 ? 1 : 0);
				ievent.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.SPEAK_WEB, "data":{"is_private":isprivate,"other_uid":iuser.me.masterNo,"nickname":encodeURI(iuser.me.name)}});
			}
		}
		/**
		 * 发送飞屏 
		 * @param flyid 飞屏id
		 * 
		 */		
		private function sendFlyScreen(flyid:* = null):void
		{
			//验证发送飞屏
			if(!this.inTextBar.isEmpty&&!this.checkBox.selected)
			{
				var flyData:Object = {};
				flyData.msg = escape(inTextBar.text);
				flyData.flyId = flyid;
				flyData.receiverId = this.dorplist.selected.data.id;
				flyData.receiverName = this.dorplist.selected.data.name;
				flyData.roomId = (Context.variables["showData"] as ShowData).roomID;
				iserver.http.getData(SEnum.SEND_FLY_SCREEN,flyData,function(value:*):void{},function(value:*):void
				{
					Debugger.log(Debugger.ERROR,"[flyScreen]","发送飞屏失败"+JSON.stringify(value));
					if(value&&value["code"]=="000014")
					{
						inTextBar.text = unescape(value["msg"]);
					}
				});
				inTextBar.clear();
			}else{
				if(this.inTextBar.isEmpty)
				{
					showNotify({result:this.ilocal.get("flyEmpty","chatPanel")});
				}else{
					showNotify({result:this.ilocal.get("flyDisabled","chatPanel")})
				}
			}
		}

		public function set isPrivate(bool:Boolean):void
		{
			this.checkBox.selected = bool;
			this.flyButton.disabled = this.checkBox.selected;
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
			
			this.arrow.mouseEnabled = this.historyUser.length>1;
			this.dorplist.dataProvider = this.historyUser;
			if(this.checkBox)
				this.checkBox.disabled = false;
		}
		
		public function preSizeAction():void
		{
			this.flyTool.disappear();
		}
	}
}

import com._17173.flash.core.components.common.Button;
import com._17173.flash.core.context.Context;
import com._17173.flash.core.locale.ILocale;
import com._17173.flash.show.base.context.layer.IUIManager;
import com._17173.flash.show.base.utils.FontUtil;
import com._17173.flash.show.model.CEnum;

import flash.text.TextField;
import flash.text.TextFormat;

class FlyButton extends Button
{
	private var _ui:IUIManager;
	
	public function FlyButton(t:String)
	{
		super(t);		
		_ui = (Context.getContext(CEnum.UI) as IUIManager);
		disabled = false;
	}
	
	override public function set disabled(bool:Boolean):void
	{
		super.disabled = bool;
		this.mouseEnabled = true;
		_ui.destroyTip(this);
		var _tips:String = "";
		if (!bool)
		{
			_tips = (Context.getContext(CEnum.LOCALE) as ILocale).get("flylimit", "chatPanel");
		}
		else
		{
			_tips = (Context.getContext(CEnum.LOCALE) as ILocale).get("flyDisabled", "chatPanel")
		}
		_ui.registerTip(this, _tips);
	}
}



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