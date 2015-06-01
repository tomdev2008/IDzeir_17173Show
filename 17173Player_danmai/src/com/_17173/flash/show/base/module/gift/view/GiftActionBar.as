package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.DefaultTextField;
	import com._17173.flash.core.components.common.DropDownList;
	import com._17173.flash.core.components.common.List;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.chat.HistoryItemRender;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class GiftActionBar extends BaseContainer
	{
		private var _giftListPane:GiftListPane = null;
		private const USER_SELECT_LIMIT:int = 10;
		private var _downList:DropDownList = null;
		private var _countInput:TextField = null;
		private var _sendBtn:Button = null;
		private var _moneyBtn:Button = null;
		private var _numberList:List = null;
		private var cbg:MovieClip = null;
		private var _showCountBtn:Button = null;
		private var _showSendBtn:Button = null;
		private var _otherSelect:Boolean = false;
		public function GiftActionBar(giftlistPane:GiftListPane)
		{
			_giftListPane = giftlistPane;
			super(null);
			initBar();
			initNumBerList();
			initLsn();
		}
		/**
		 *可选用户列表 
		 */		
		private var _selectUsers:Array;
		private function initBar():void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			_selectUsers = [];
			var tmpTf:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.size = 12;
			textFormat.font = FontUtil.f;
			tmpTf = new DefaultTextField(lc.get("get_label","gift"));
			tmpTf.x = 6;
			tmpTf.y = 0;
			tmpTf.alpha = .6;
			tmpTf.width = 20;
			tmpTf.height = 20;
			tmpTf.mouseEnabled = false;
			tmpTf.multiline = false;
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.setTextFormat(textFormat);
			tmpTf.type = TextFieldType.INPUT;
			this.addChild(tmpTf);
			
			//送礼人背景框
			var tmc:MovieClip = new MemberList_bg();
			tmc.x = 25;
			tmc.width = 99;
			tmc.y = 0;
			this.addChild(tmc)
//			var tmp:Shape = new Shape();
//			tmp.graphics.beginFill(0x4c118a,.01);
//			tmp.graphics.drawRect(0,0,75,22);
//			tmp.graphics.endFill();
//			tmp.x = 25;
//			tmp.y = 0;
//			this.addChild(tmp)
			
			var dorpbackground:Shape=new Shape();
			this.addChild(dorpbackground);
			_downList = new GiftDownList(DropDownList.UP, 6,HistoryItemRender);
			_downList.width = 99;
			_downList.x = 25;
			_downList.y = 0;
			this.addChild(_downList);
			var corrd:DisplayObjectContainer=this;
			_downList.addEventListener(Event.OPEN,function():void
			{
				var rect:Rectangle;
				rect=_downList.getBounds(corrd);
				//trace(this,"open",rect);
				dorpbackground.graphics.clear();				
				dorpbackground.graphics.beginFill(0x380066,.85);
				dorpbackground.graphics.drawRect(rect.left,rect.top,rect.width,rect.height);
			});
			_downList.addEventListener(Event.CLOSE,function():void
			{
				dorpbackground.graphics.clear();
			});
			
			_showSendBtn = new Button();
			_showSendBtn.setSkin(new Btn_Pselect_bg());
			_showSendBtn.x = _downList.x + 99;
			_showSendBtn.y = 0;
			_showSendBtn.width = 11;
			_showSendBtn.height = 21;
			this.addChild(_showSendBtn);
			
			_countInput = new TextField();
			textFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.size = 10;
			textFormat.font = FontUtil.f;
			
		
			
			_countInput = new DefaultTextField("1");
			_countInput.restrict = "0-9";
			_countInput.x = _downList.x + 116;
			_countInput.y = 0;
			_countInput.width = 30;
			_countInput.height = 20;
			_countInput.maxChars = 5;
			_countInput.multiline = false;
			_countInput.defaultTextFormat = textFormat;
			_countInput.setTextFormat(textFormat);
			_countInput.type = TextFieldType.INPUT;
			_countInput.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			
			
			var tmc1:MovieClip = new MemberList_bg();
			tmc1.x = _countInput.x;
			tmc1.width = 30;
			tmc1.y = 0;
			this.addChild(tmc1)
			
			this.addChild(_countInput);
			
			
			_showCountBtn = new Button();
			_showCountBtn.setSkin(new Btn_Pselect_bg());
			_showCountBtn.x = _countInput.x + _countInput.width;
			_showCountBtn.y = 0;
			_showCountBtn.width = 11;
			_showCountBtn.height = 21;
			this.addChild(_showCountBtn);
			
			_sendBtn = new Button();
			_sendBtn.setSkin(new Skin_gift_send());
			_sendBtn.x = _showCountBtn.x + _showCountBtn.width + 6;
			_sendBtn.y = -5;
			_sendBtn.label = "<font color='#FFFF00' size='18'>赠送</font>";
			_sendBtn.width = 84;
			_sendBtn.height = 33;
			this.addChild(_sendBtn);
			ui.registerTip(_sendBtn,lc.get("sendgift_tip","bottom"));
			
			_moneyBtn = new Button();
			_moneyBtn.setSkin(new Skin_gift_money())
			_moneyBtn.x = _sendBtn.x + _sendBtn.width + 6;
			_moneyBtn.label = "<font color='#FFCC66' size='12'>充值</font>";
			_moneyBtn.y = -1;
			_moneyBtn.width = 50;
			_moneyBtn.height = 21;
			this.addChild(_moneyBtn);
			ui.registerTip(_moneyBtn,lc.get("money_tip","bottom"));
			
		}
		
		private function initLsn():void{
			_countInput.addEventListener(FocusEvent.FOCUS_IN,onFoucusIn);
			_showCountBtn.addEventListener(MouseEvent.CLICK,onShowCountClick);
			_showSendBtn.addEventListener(MouseEvent.CLICK,onShowCountClick1);
			_sendBtn.addEventListener(MouseEvent.CLICK,onSendClick);
			_moneyBtn.addEventListener(MouseEvent.CLICK,onMoneyClick);
			_numberList.addEventListener(Event.SELECT,onNumlistSelect);
			Context.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		private function onFoucusIn(e:Event):void{
			_countInput.addEventListener(FocusEvent.FOCUS_OUT,onFoucusOut);
		}
		private function onFoucusOut(e:Event):void{
			_countInput.removeEventListener(FocusEvent.FOCUS_OUT,onFoucusOut);
			checkValue();
		}
		private function checkValue():void{
			var count:int = int(_countInput.text);
		}
		
		private function onShowCountClick(e:Event):void{
			_numberList.visible = !_numberList.visible;
			cbg.visible = _numberList.visible
		}
		
		private function onShowCountClick1(e:Event):void{
			if(_downList.isOpen == false){
				_downList.open();
			}else{
				_downList.close();
			}
		}
		
		private function onMoneyClick(e:Event):void{
			Utils.toUrlAppedTime(SEnum.URL_MONEY);
		}
		
		
		private function onNumlistSelect(e:Event):void{
			_numberList.visible = false;
			cbg.visible = _numberList.visible;
			var obj:Object = _numberList.selected;
			_countInput.text = obj.data;
		}
		
		private function onSendClick(e:Event):void{
			
			
			//			if(_sending == true) return;
			//判断是否登录
			var showdata:Object = Context.variables["showData"];
			if(showdata.masterID !=null && int(showdata.masterID) > 0){
				
			}else{
				//打开登录
				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.LOGINPANEL_SHOW);
				return;
			}
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var uid:String;
			//是否选择用户
			if(_downList.selected){
				var data1:Object = _downList.selected;
				uid = data1.id;
			}else{
				ui.popupAlert(local.get("system_title","components"),local.get("needRsId","gift"),-1,Alert.BTN_OK);
				return;
			}
			var count:int = int(_countInput.text);
			//数量是否大于0
			if(count <= 0){
				ui.popupAlert(local.get("system_title","components"),local.get("needCount","gift"),-1,Alert.BTN_OK);
				return;
			}
			var giftItem:GiftItem = _giftListPane.selectItem;
			//选择礼物
			if(!giftItem){
				ui.popupAlert(local.get("system_title","components"),local.get("needGift","gift"),-1,Alert.BTN_OK);
				return;
			}
			var server:Object = Context.getContext(CEnum.SERVICE);
			if(uid == ""){
				uid = Context.variables["showData"]["roomOwnMasterID"];
			}
			//提交数据
			var data:Object = {};
			data.receiverId = uid;
			data.count = count;
			data.giftId = giftItem.giftData.id;
			data.result = "json";
			data.chatIp = showdata.socketDomain;
			data.roomId = (Context.variables["showData"]).roomID;
			server.http.getData(SEnum.SEND_GIFT,data,onSecc,onFail);
		}
		private function onSecc(obj:Object):void{

		}
		
		private function onFail(obj:Object):void{
		}
		
		public function addUsers(uid:String):void{
			var userdata:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(uid);
			if(userdata == null){
				return;
			}
			for (var i:int = 0; i < _selectUsers.length; i++) 
			{
				if(uid == _selectUsers[i].id){
					_selectUsers.splice(i,1);
					break;
				}
			}
			var data:Object = {};
			data.id = uid;
			data.label = Utils.formatToString(userdata.name);
			if(_otherSelect){
				_selectUsers.splice(_selectUsers.length - 1,0,data);
			}else{
				changeDownListEab(true);
				_selectUsers[_selectUsers.length] = data;
			}
			
			if(_selectUsers.length > USER_SELECT_LIMIT){
				_selectUsers.shift();
			}
			
			_downList.dataProvider = _selectUsers;
		}
		
		public function addByInit(obj:Object):void{
			for (var i:int = 0; i < _selectUsers.length; i++) 
			{
				if(obj.label == _selectUsers[i].label){
					return;
				}
			}
			if(obj.enb == 1){
				changeDownListEab(false);
			}else{
				changeDownListEab(true);
			}
			_selectUsers[_selectUsers.length] = obj;
			_downList.dataProvider = _selectUsers;
		}
		
		
		public function changeDownListEab(enb:Boolean):void{
			_otherSelect = !enb;
			_downList.mouseEnabled = _downList.mouseChildren = enb;
			_showSendBtn.mouseEnabled = enb;
		}
		
		public function clearOtherUser():void{
			var data:Object;
			var checked:Boolean = false;
			for (var i:int = 0; i < _selectUsers.length; i++) 
			{
				data = _selectUsers[i];
				if(data && (data.id == null || data.id == "")){
					_selectUsers.splice(i,1);
					checked = true;
					i--;
				}
			}
			if(checked){
				_downList.dataProvider = _selectUsers;
			}
		}
		
		/**
		 *如果点击了屏幕 则关闭 
		 * @param e
		 * 
		 */		
		private function onStageClick(e:Event):void{
			if(e.target === _showCountBtn){
				if(_downList.isOpen){
					if(!Utils.checkIsChild(e.target as DisplayObject,_downList)){
						_downList.close();
					}
				}
			}
			else if(e.target === _showSendBtn){
				if(_numberList.visible){
					if(!Utils.checkIsChild(e.target as DisplayObject,_numberList)){
						_numberList.visible = false;
						cbg.visible = _numberList.visible;
					}
				}
			}else{
				if(_downList.isOpen == true){
					if(!Utils.checkIsChild(e.target as DisplayObject,_downList)){
						_downList.close();
					}
				}
				if(_numberList.visible == true){
					if(!Utils.checkIsChild(e.target as DisplayObject,_numberList)){
						_numberList.visible = false;
						cbg.visible = _numberList.visible;
					}
				}
			}
			
		}
		
		private function initNumBerList():void{
			_numberList = new List(0,false,NumListItemRender);
			_numberList.mouseEnabled = false;
			_numberList.width  = 80;
			var datas:Array = [1,5,10,11,99,333,521,999,1314];
			var array:Array = [1,5,10,11,"<font color='#0DEBD5'>"+99+"</font>","<font color='#0DEBD5'>"+333+"</font>","<font color='#0DEBD5'>"+521+"</font>","<font color='#0DEBD5'>"+999+"</font>","<font color='#0DEBD5'>"+1314+"</font>"];
			var array1:Array = ["我的唯一","我的心意","完整的爱","一心一意","<font color='#0DEBD5'>爱你久久</font>","<font color='#0DEBD5'>亲亲你</font>","<font color='#0DEBD5'>我爱你</font>","<font color='#0DEBD5'>天长地久</font>","<font color='#0DEBD5'>一生一世</font>"];
			var len:int = array.length;
			for (var i:int = 0; i < array.length; i++) 
			{
				var obj:Object = {num:array[i] + "",data:datas[i],txt:array1[i]};
				_numberList.addItem(obj);
			}
			_numberList.y =  8 - 219;
			_numberList.x = _countInput.x - 80;
			cbg = new GIft_countBg();
			cbg.height = 210;
			cbg.x =  _countInput.x - 81;
			cbg.width = 122;
			cbg.y = 7 - 219;
			_numberList.visible = false;
			cbg.visible = false;
			this.addChild(cbg);
			this.addChild(_numberList);
		}
		
		private function onFocusOut(e:Event):void{
			var num:int = int(_countInput.text);
			if(num <= 0){
				_countInput.text = "1";
			}
		}
	}
}