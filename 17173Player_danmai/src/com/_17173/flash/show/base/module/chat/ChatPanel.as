package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.chat.vo.ChatInfoVo;
	import com._17173.flash.show.base.module.chat.vo.ErrorInfoVo;
	import com._17173.flash.show.base.module.chat.vo.FireWorksHitVo;
	import com._17173.flash.show.base.module.chat.vo.FireWorksVo;
	import com._17173.flash.show.base.module.chat.vo.ForbidChatVo;
	import com._17173.flash.show.base.module.chat.vo.GiftHistoryVo;
	import com._17173.flash.show.base.module.chat.vo.GiftInfoVo;
	import com._17173.flash.show.base.module.chat.vo.IBaseChatVo;
	import com._17173.flash.show.base.module.chat.vo.InfoVo;
	import com._17173.flash.show.base.module.chat.vo.KickIPVo;
	import com._17173.flash.show.base.module.chat.vo.KickUserVo;
	import com._17173.flash.show.base.module.chat.vo.LuckGiftVo;
	import com._17173.flash.show.base.module.chat.vo.MuteVideoVo;
	import com._17173.flash.show.base.module.chat.vo.PublicChatStatusVo;
	import com._17173.flash.show.base.module.chat.vo.ShowUserChangeVo;
	import com._17173.flash.show.base.module.chat.vo.SysInfoVo;
	import com._17173.flash.show.base.module.chat.vo.UpgradeManagerVo;
	import com._17173.flash.show.base.module.chat.vo.UserEntryExitVo;
	import com._17173.flash.show.base.module.chat.vo.UserLevelUpVo;
	import com._17173.flash.show.base.module.chat.vo.VideoStatusVo;
	import com._17173.flash.show.base.module.gamelink.GameLinkPanel;
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GroupElement;
	import flash.utils.Dictionary;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-13  上午10:10:21
	 */
	public class ChatPanel extends BaseModule
	{

		private var pubGraphicText:GraphicText;

		private var priGraphicText:GraphicText;

		private var textFor:ElementFormat;

		private var left:Number = 8;

		private var tab:ChatTabContainer;

		private var _textManager:IGraphicTextManager;

		private var chatBar:ChatToolBar;

		private var priView:ChatMsgPanel;

		private var pubView:ChatMsgPanel;

		private var gameLink:GameLinkPanel;
		/**
		 *聊天面板展开收起按钮
		 */
		private var ecb:ExpandChatButton;

		private var toolBarBg:DisplayObject;

		private var ico:ArrowIco;
		/**
		 * 消息处理缓存池
		 */
		private var _msgMap:Dictionary = new Dictionary(true);

		private var _ibaseVo:IBaseChatVo;

		private var hashMap:Array = [];

		/**
		 * 新增参数
		 */		
		private var _chatBgOffset:Number=103; //聊天背景
		private var _viewHight:Number = 500; //聊天文字面板
		private var _viewMaxHight:Number = 500; // 聊天面板最大高度
		private var _viewMinHight:Number = 200;//聊天面板最先高度

		private const SCENE_HIEHT:Number=980;

		private var chatBox:ChatVBox;
		/**
		 * 送礼记录面板
		 */		
		private var giftView:ChatGiftInfoPanel;

		public function ChatPanel()
		{
			super();
			_version = "1.8.2";
			this.addChildren();
			Context.stage.addEventListener(Event.RESIZE, onStageResize);
		}

		protected function onStageResize(event:Event = null):void {
			//缩放前先去掉多余面板
			this.chatBar.preSizeAction();
			
			_viewHight = Math.round(Context.stage.stageHeight * (_viewMaxHight/SCENE_HIEHT));

			if(_viewHight > _viewMaxHight)
				_viewHight=_viewMaxHight;
			else if(_viewHight < _viewMinHight)
				_viewHight = _viewMinHight;
			//派发大小变化事件
			var em:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			em.send(SEvents.CHAT_RESIZE);
			GuideTaskVO.chatHeight = _viewHight;

			updateChatView();
		}

		override protected function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);			

			while(this.hashMap.length > 0)
			{
				var o:Object = this.hashMap.shift();
				if(o.index == 0)
				{
					this.pubGraphicText.addElement(o.ele);
				}
				else
				{
					this.priGraphicText.addElement(o.ele);
				}
			}
			onStageResize();

			(Context.getContext(CEnum.EVENT) as IEventManager).listen(SEvents.GO_TO_CHAT_VIEW,function():void
			{
				if(tab.selectedIndex!=0)
				{
					tab.goto(0);
				}
			});
		}

		private function addChildren():void
		{
			this.createTab();

			this.createChatBar();

			this.graphics.beginFill(0x22022A, .8);
			this.graphics.drawRect(0, 0, 360, _chatBgOffset+ _viewHight);
			this.graphics.endFill();

			toolBarBg = new ChatBarBg1_8();
			toolBarBg.y = _chatBgOffset+ _viewHight - toolBarBg.height - 46;
			this.addChildAt(toolBarBg, 0);

		/*ico = new ArrowIco();
		//聊天收齐功能
		ecb = new ExpandChatButton();
		ecb.width = 24;
		ecb.height = 37;
		ecb.icon = ico;
		ecb.y = this.chatBar.y + this.chatBar.height - ecb.height - 1;
		ecb.x =  toolBarBg.width + toolBarBg.x + 5;

		ecb.addEventListener(MouseEvent.CLICK, function():void
		{
			expand();
		})
		this.addChild(ecb);*/

			//======测试代码
		/*var creatInfo:Function = function():Object
		{
			var gp:Vector.<Object> = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.graphicMap;
			var len:uint = 99//Math.ceil(Math.random()*20)+2;
			var info:String = "年睡得好";
			for(var i:uint = 0;i<len;i++)
			{
				info+=gp[Math.floor(Math.random()*gp.length)].tag;
			}
			var me:IUserData = (Context.getContext(CEnum.USER) as IUser).me
			return {"userInfo":{userId:me.id},"ct":info,"action":uint(Math.random()*3),"masterId":me.id,"userId":me.id};
		}
		Ticker.tick(500,function():void
		{
			showChatMsg(creatInfo());
		},20);*/
		}

		private function createChatBar():void
		{
			chatBar = new ChatToolBar();			
			this.addChild(chatBar);
			chatBar.y = _chatBgOffset+ _viewHight - chatBar.height+8;
		}

		private function createTab():void
		{
			tab = new ChatTabContainer();
			tab.addEventListener(Event.CHANGE,function():void
			{
				chatBar.hidenTool = tab.selectedIndex == 0;
				tab.hidenNotice = tab.selectedIndex == 0;
				tab.redraw();
			});
			pubView = new ChatMsgPanel();

			_textManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;

			pubGraphicText = _textManager.createGraphicText(null, new GraphicTextOption(true, 37)) as GraphicText;
			pubGraphicText.leading = 7;
			pubGraphicText.x = 2;
			pubGraphicText.textWidth = 330;
			pubView._iText = pubGraphicText;
			pubView.addChild(pubGraphicText);

			priView = new ChatMsgPanel();
			priGraphicText = _textManager.createGraphicText(null, new GraphicTextOption(true, 37)) as GraphicText;
			priGraphicText.leading = 7;
			priGraphicText.x = 2;
			priGraphicText.textWidth = 330;
			priView._iText = priGraphicText;
			priView.addChild(priGraphicText);

			pubView.setSize(360 - 2*left, _viewHight*.5);
			priView.setSize(360 - 2*left, _viewHight*.5);

			gameLink = new GameLinkPanel();
			gameLink.setSize(360 - left * 2, 230);

			pubView.x = priView.x = gameLink.x = left;
			chatBox = new ChatVBox();
			chatBox.setUp(pubView,priView);
			chatBox.height = _viewHight - tab.noticeHeight;

			tab.addItem("chatBox","聊天",chatBox);
			//tab.addItem("pubMsg", Context.getContext(CEnum.LOCALE).get("pubChatTab", "chatPanel"), pubView);
			//tab.addItem("priMsg", Context.getContext(CEnum.LOCALE).get("priChatTab", "chatPanel"), priView);

			giftView = new ChatGiftInfoPanel();
			giftView.setSize(360, _viewHight * .5);

			tab.addItem("giftInfo","送礼记录",giftView);

			tab.addItem("gamelink", "游戏", gameLink);

			this.addChild(tab);			
		}

		/**
		 * 根据用户列表位置进行调整新的位置
		 * @param _templete
		 * @return
		 *
		 */		
		/*public function updatePos(value:Object):void
		{
			this.x = value.x + value.width + 10;
		}*/

		private function getMsgVo(_templete:Class):IBaseChatVo
		{
			if(!this._msgMap.hasOwnProperty(_templete))
			{
				this._msgMap[_templete] = new _templete();
			}

			var ibase:IBaseChatVo = this._msgMap[_templete] as IBaseChatVo;
			ibase.reset();

			return ibase;
		}
		/**
		 * 更新飞屏数据 
		 * @param value
		 * 
		 */		
		public function onFlyScreenData(value:*):void
		{
			this.chatBar.updateFlyFromData(value);
		}
		
		public function showRoomNotice(value:String,link:String= ""):void
		{
			tab.notice(value,link);
			updateChatView();
		}
		/**
		 * 更新聊天面板高度
		 *
		 */		
		private function updateChatView():void
		{
			var _h:Number = _viewHight - tab.noticeHeight - 10;
			trace(this.tab.selectedIndex,tab.noticeHeight);
			chatBox.height = this.tab.selectedIndex == 0 ?_h:_viewHight - tab.noticeTxtRawHeight - 15;
			gameLink.height = _viewHight - 10;
			giftView.setSize(360,_viewHight - 10);
			giftView.update();
			gameLink.update();

			//chatBox.contentHeight = _h;

			this.graphics.clear();
			this.graphics.beginFill(0x22022a, .8);
			this.graphics.drawRect(0, 0, 360, _chatBgOffset+ _viewHight);
			this.graphics.endFill();

			chatBar.y = _chatBgOffset+ _viewHight - chatBar.height+8;

			toolBarBg.y = _chatBgOffset+ _viewHight - toolBarBg.height - 46;
		}

		/**
		 * 幸运礼物消息
		 * @param value
		 *
		 */		
		public function luckGiftback(value:Object):void
		{
			if(value.hasOwnProperty("ct"))
			{
				var lucks:Object = value["ct"];
				_ibaseVo = getMsgVo(LuckGiftVo);
				(_ibaseVo as LuckGiftVo).opName=lucks.nickName;
				(_ibaseVo as LuckGiftVo).userId=lucks.userId;
				(_ibaseVo as LuckGiftVo).giftUrl=lucks["giftDyEffect"]!=""?lucks["giftDyEffect"]:lucks.giftIcon;
				(_ibaseVo as LuckGiftVo).giftName=lucks.giftName;
				(_ibaseVo as LuckGiftVo).price = lucks.giftPrice;
				(_ibaseVo as LuckGiftVo).ttPl = lucks.totalGiftCount;
				(_ibaseVo as LuckGiftVo).ttCount = lucks.hitGiftCount;
				(_ibaseVo as LuckGiftVo).totalReturnGiftCount = lucks.totalReturnGiftCount;
				//(_ibaseVo as LuckGiftVo).hitResult = lucks.hitResult;
				output(0, _ibaseVo, value);

				//私聊
				var me1:IUserData = (Context.getContext(CEnum.USER)).me as IUserData;
				if(lucks.userId == me1.id){
					_ibaseVo = getMsgVo(LuckGiftVo);
					(_ibaseVo as LuckGiftVo).opName=lucks.nickName;
					(_ibaseVo as LuckGiftVo).userId=lucks.userId;
					(_ibaseVo as LuckGiftVo).giftUrl=lucks["giftDyEffect"]!=""?lucks["giftDyEffect"]:lucks.giftIcon;
					(_ibaseVo as LuckGiftVo).giftName=lucks.giftName;
					(_ibaseVo as LuckGiftVo).price = lucks.giftPrice;
					(_ibaseVo as LuckGiftVo).ttPl = lucks.totalGiftCount;
					(_ibaseVo as LuckGiftVo).ttCount = lucks.hitGiftCount;
					(_ibaseVo as LuckGiftVo).totalReturnGiftCount = lucks.totalReturnGiftCount;
					(_ibaseVo as LuckGiftVo).hitResult = lucks.hitResult;
					output(1, _ibaseVo, value);
				}
			}			
		}

		/**
		 * 烟花奖励
		 * @param value
		 */	
		public function onFireworksHit(value:Object):void
		{
			var obj:Object = value["ct"];
			if(obj["toUserId"] == (Context.getContext(CEnum.USER) as IUser).me.id)
			{
				_ibaseVo = getMsgVo(FireWorksHitVo);
				(_ibaseVo as FireWorksHitVo).hit = {"userName":obj["userName"],"userId":obj["userId"],"userNo":obj["userNo"],"giftCount":obj["giftCount"],"giftName":obj["giftName"],"inCome":obj["income"]};
				output(1, _ibaseVo, value);
			}
		}

		/**
		 * 烟花消息
		 * @param value
		 *
		 */		
		public function onFireworks(value:Object):void
		{
			_ibaseVo = getMsgVo(FireWorksVo);
			(_ibaseVo as FireWorksVo).gift = value as MessageVo;
			output(0, _ibaseVo, value);
		}

		public function showMsg(value:*, type:uint = 0):void
		{
			var toUser:IUserData;
			var opUser:IUserData;
			switch(type)
			{
				case ChatMessageType.SYS_INFO:
					//服务器没给时间戳
					_ibaseVo = getMsgVo(SysInfoVo);
					var info:String = Utils.formatToString(unescape(value.ct.mes));					
					(_ibaseVo as SysInfoVo).type = value.type;
					(_ibaseVo as SysInfoVo).link = value.ct["link"]?value.ct["link"]:(value.ct["links"]?value.ct["links"]:"");
					//系统公告						
					var broad:Number = value.ct["broad"];
					if (broad != 1)
					{
						(_ibaseVo as SysInfoVo).info = info;
						output(0, _ibaseVo, value);
					}
					if (broad != 0)
					{
						_ibaseVo = getMsgVo(SysInfoVo);
						(_ibaseVo as SysInfoVo).type = value.type;
						(_ibaseVo as SysInfoVo).link = value.ct["link"]?value.ct["link"]:(value.ct["links"]?value.ct["links"]:"");
						(_ibaseVo as SysInfoVo).info = info;
						output(1, _ibaseVo, value);
					}					

					break;
				case ChatMessageType.GIFT_INFO:
					_ibaseVo = getMsgVo(GiftInfoVo);
					var _gift:MessageVo = value as MessageVo;
					(_ibaseVo as GiftInfoVo).gift = _gift;
					output(0, _ibaseVo, value);
					//送礼记录
					_ibaseVo = getMsgVo(GiftHistoryVo);
					(_ibaseVo as GiftHistoryVo).gift = _gift;


					if(_gift.showCenter == 1)
					{
						_ibaseVo = getMsgVo(GiftHistoryVo);
						(_ibaseVo as GiftHistoryVo).gift = _gift;
						(_ibaseVo as GiftHistoryVo).isExpensive = true;
						output(3,_ibaseVo,value);
					}else{
						output(2,_ibaseVo,value);
					}
					break;
				case ChatMessageType.KICK_USER:
					_ibaseVo = getMsgVo(KickUserVo);
					toUser = (Context.getContext(CEnum.USER) as IUser).getUser(value["toUser"]["userId"]);
					opUser = (Context.getContext(CEnum.USER) as IUser).getUser(value["opUser"]["userId"]);
					(_ibaseVo as KickUserVo).toUser = toUser?toUser:(Context.getContext(CEnum.USER) as IUser).createUserFromData(value["toUser"]);
					(_ibaseVo as KickUserVo).opUser = opUser;
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.CHAT_PUBLIC_CHANGE:
					_ibaseVo = getMsgVo(PublicChatStatusVo);
					(_ibaseVo as PublicChatStatusVo).isAllow = value.bool;
					(_ibaseVo as PublicChatStatusVo).opUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.data.userId);
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.SHOW_STATUS:
					_ibaseVo = getMsgVo(VideoStatusVo);
					(_ibaseVo as VideoStatusVo).data = value.data;
					(_ibaseVo as VideoStatusVo).isBegin = value.bool;
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.IN_OUT_MIC_LIST:
					//_ibaseVo=getMsgVo(MicListStatusVo);
					//(_ibaseVo as MicListStatusVo).data=value.data;
					//(_ibaseVo as MicListStatusVo).isEntry=value.bool;
					//output(0,_ibaseVo);
					break;
				case ChatMessageType.SHOW_USER_CHANGE:
					_ibaseVo = getMsgVo(ShowUserChangeVo);
					(_ibaseVo as ShowUserChangeVo).data = value;
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.FORBID_USER_CHAT:

					if(value.data["toUser"])
					{
						_ibaseVo = getMsgVo(ForbidChatVo);
						toUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.data["toUser"]["userId"]);
						opUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.data["opUser"]["userId"]);
						(_ibaseVo as ForbidChatVo).toUser = toUser;
						(_ibaseVo as ForbidChatVo).opUser = opUser;
						(_ibaseVo as ForbidChatVo).isForbid = value.bool
						output(0, _ibaseVo, value);
					}

					break;
				case ChatMessageType.UPGRADE_USER:
					_ibaseVo = getMsgVo(UpgradeManagerVo);
					if(Utils.validate(value.data, "toUser"))
					{
						toUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.data["toUser"]["userId"]);
					}
					if(Utils.validate(value.data, "opUser"))
					{
						opUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.data["opUser"]["userId"]);
					}
					(_ibaseVo as UpgradeManagerVo).toUser = toUser;
					(_ibaseVo as UpgradeManagerVo).opUser = opUser;
					(_ibaseVo as UpgradeManagerVo).isUpgrade = value.bool;
					(_ibaseVo as UpgradeManagerVo).type = value.data.role;
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.USER_ENTRY_EXIT:
					_ibaseVo = getMsgVo(UserEntryExitVo);
					opUser = (_ibaseVo as UserEntryExitVo).user = value.data;
					(_ibaseVo as UserEntryExitVo).isEntry = value.bool;
					if(opUser.hidden && !value.bool)
					{
						_ibaseVo = null;
						opUser = null;
						return;
					}
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.ERROR:
					_ibaseVo = getMsgVo(ErrorInfoVo);
					//本地时间
					(_ibaseVo as ErrorInfoVo).info = value;
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.USER_LEVEL_UP:

					var type:uint = value["type"];
					if(type != 2 && type != 3)
					{
						return;
					}
					var level:uint = value["level"];

					_ibaseVo = getMsgVo(UserLevelUpVo);
					(_ibaseVo as UserLevelUpVo).user = value.userInfo;
					(_ibaseVo as UserLevelUpVo).uName = (value.userInfo as IUserData).name;
					(_ibaseVo as UserLevelUpVo).type = type;
					(_ibaseVo as UserLevelUpVo).level = level;
					(_ibaseVo as UserLevelUpVo).isMe = false;
					output(0, _ibaseVo, value);
					if((Context.getContext(CEnum.USER) as IUser).me.id == value["userId"])
					{
						_ibaseVo = getMsgVo(UserLevelUpVo);
						(_ibaseVo as UserLevelUpVo).user = value.userInfo;
						(_ibaseVo as UserLevelUpVo).uName = (value.userInfo as IUserData).name;
						(_ibaseVo as UserLevelUpVo).type = type;
						(_ibaseVo as UserLevelUpVo).level = level;
						(_ibaseVo as UserLevelUpVo).isMe = true;
						output(1, _ibaseVo, value);
					}
					break;
				case ChatMessageType.CLOSE_MIC_SOUND:
					_ibaseVo = getMsgVo(MuteVideoVo);
					toUser = (Context.getContext(CEnum.USER) as IUser).createUserFromData(value.toUser);
					opUser = (Context.getContext(CEnum.USER) as IUser).createUserFromData(value.opUser);
					(_ibaseVo as MuteVideoVo).toUser = toUser;
					(_ibaseVo as MuteVideoVo).opUser = opUser;
					(_ibaseVo as MuteVideoVo).isMute = value.isMute;
					(_ibaseVo as MuteVideoVo).order = value["order"];
					output(0, _ibaseVo, value);
					break;
				case ChatMessageType.IP_KICK:
					_ibaseVo = getMsgVo(KickIPVo);
					toUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.ct["targetUserId"]);
					opUser = (Context.getContext(CEnum.USER) as IUser).getUser(value.ct["currentUserId"]);;
					if(toUser&&opUser)
					{
						(_ibaseVo as KickIPVo).toUser = toUser;
						(_ibaseVo as KickIPVo).opUser = opUser;
						output(0, _ibaseVo, value);	
					}else{
						Debugger.log(Debugger.INFO,"[Chat]","封IP未找到管理员或被封用户");
					}									
					break;
				case ChatMessageType.MESSAGE_INFO:					
					_ibaseVo = getMsgVo(InfoVo);
					if(Utils.validate(value,"info"))
					{
						(_ibaseVo as InfoVo).info = value["info"];

						if(Utils.validate(value,"color"))
						{
							(_ibaseVo as InfoVo).color = value["color"];
						}
						//默认公聊显示
						var isPri:uint = value["isPrivate"]?uint(value["isPrivate"]):0;
						output(isPri, _ibaseVo, value);	
					}										
					break;
			}
			_ibaseVo = null;
		}

		public function showChatMsg(value:* = null):void
		{

			var gp:Vector.<ContentElement> = new Vector.<ContentElement>();
			//_textManager.factory.getElements(value.ct);
			var user:IUser = (Context.getContext(CEnum.USER) as IUser);

			var opUser:IUserData = user.getUser(value["userInfo"]["masterId"])?user.getUser(value["userInfo"]["masterId"]):user.addUserFromData(value["userInfo"]);
			var toUser:IUserData;
			if(value["toUserInfo"])
			{
				toUser = user.getUser(value["toUserInfo"]["masterId"])?user.getUser(value["toUserInfo"]["masterId"]):user.addUserFromData(value["toUserInfo"]);
			}
			_ibaseVo = getMsgVo(ChatInfoVo);
			(_ibaseVo as ChatInfoVo).opUser = opUser;
			(_ibaseVo as ChatInfoVo).toUser = toUser;
			(_ibaseVo as ChatInfoVo).info = Utils.formatToString(value.ct);
			(_ibaseVo as ChatInfoVo).action = value.action;

			if(value.action != "2")
			{
				output(0, _ibaseVo, value);
			}
			else
			{

				if(!(Context.getContext(CEnum.USER) as IUser).privateChatFilterDic.hasOwnProperty(opUser.id))
				{
					output(1, _ibaseVo, value);
				}
			}

		}

		/**
		 * 公私聊统一入口
		 * @param _index 0为公聊，1为私聊,2为礼物记录
		 * @param e
		 * @param data 原始数据，用于打印时间戳,默认为系统当前时间
		 *
		 */
		private function output(_index:uint, e:IBaseChatVo, data:* = null):void
		{
			if(Utils.validate(data, "timestamp"))
			{
				e.time = data["timestamp"];
			}
			var ele:GroupElement = e.elements;
			if(!ele)
			{
				return;
			}
			switch(_index)
			{
				case 0:
					if(!this.pubGraphicText)
					{
						this.hashMap.push({"index":_index, "ele":ele});
						return;
					}
					this.pubGraphicText.addElement(ele);
					this.pubView.update();
					break;
				case 1:
					if(!this.priGraphicText)
					{
						this.hashMap.push({"index":_index, "ele":ele});
						return;
					}
					if(!this.chatBox.status)
					{
						(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.HISTORY_TOTAL,9);
					}
					this.priGraphicText.addElement(ele);
					this.priView.update();
					break;
				case 2:
					this.giftView.appendElement(ele);
					break;
				case 3:
					this.giftView.addExpensive(ele);
					break;
			}
			//控制tabBar闪烁
			if(this.tab.selectedIndex != _index)
			{
				//this.tab.flash(_index);
			}
			ele = null;
		}

		public function set historyUser(value:Object):void
		{
			if((Context.getContext(CEnum.USER) as IUser).me.id == value.id)
			{
				return;
			}
			this.chatBar.addHistoryUser(value);
		}

		/**
		 * 清除聊天记录
		 *
		 */
		public function clearHistoryMsg(index:int = -1):void
		{
			if(index == 0)
			{
				this.pubGraphicText.clear();
				this.pubView.resize();
			}
			else if(index == 1)
			{
				this.priGraphicText.clear();
				this.priView.resize();
			}else{
				this.pubGraphicText.clear();
				this.pubView.resize();
				this.priGraphicText.clear();
				this.priView.resize();
			}
		}

		public function onPublicChatTo(user:IUserData):void
		{
			if(user.id == (Context.getContext(CEnum.USER) as IUser).me.id)
			{
				return;
			}
			this.historyUser = user;
			this.chatBar.isPrivate = false;
		}

		public function onPrivateChatTo(user:IUserData):void
		{
			if(user.id == (Context.getContext(CEnum.USER) as IUser).me.id)
			{
				return;
			}			
			this.historyUser = user;
			this.chatBar.isPrivate = true;
		}

		public function lock(value:int):void
		{
			if(value==0){
				this.pubView.lock = this.pubGraphicText.locked = !this.pubView.lock;
			}
			if(value==1){
				this.priView.lock = this.priGraphicText.locked = !this.priView.lock;
			}
		}

		public function expand(inner:Boolean = true):void
		{
			return;
			if(!inner && ico.scaleY == 1)
			{
				return;
			}
			ico.scaleY *= -1;
			var bool:Boolean = (ico.scaleY == 1)
			if(!bool)
			{
				this.graphics.clear();
			}
			else
			{
				this.graphics.beginFill(0x000000, .65);
				this.graphics.drawRect(0, 0, 360, _chatBgOffset+ _viewHight);
				this.graphics.endFill();

			}
			this.chatBar.expand(bool);
			this.tab.visible = bool;
			this.toolBarBg.visible = bool;
		}
	}
}


