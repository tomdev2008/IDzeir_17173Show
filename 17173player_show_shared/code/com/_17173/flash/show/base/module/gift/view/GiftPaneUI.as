package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.DefaultTextField;
	import com._17173.flash.core.components.common.DropDownList;
	import com._17173.flash.core.components.common.List;
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.chat.HistoryItemRender;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class GiftPaneUI extends SkinComponent
	{
		/**
		 *标题 
		 */		
		private var _title:TextField = null;
		private var _giftListPane:GiftListPane = null;
		private var _downList:DropDownList = null;
		private var _countInput:TextField = null;
		private var _sendBtn:Button = null;
		private var _moneyBtn:Button = null;
		private var _numberList:List = null;
		private var _showCountBtn:Button = null;
		private var _sending:Boolean = false;
		private const USER_SELECT_LIMIT:int = 10;
		private var giftBg:gift_list_bg1;
		private var isHide:Boolean = true;
		/**
		 *可选用户列表 
		 */		
		private var _selectUsers:Array;
		public function GiftPaneUI()
		{
			this.mouseEnabled = false;
			this.width = 220;
			this.height = 260;
			super();
		}
		
		override protected function onInit():void{
			super.onInit();
			initTitle();
			initList();
			initNumBerList();
			initBottomBar();
			initSourceData();
		}
		
		protected function initSourceData():void{
			giftBg = new gift_list_bg1();
			giftBg.hideGift.btn.addEventListener(MouseEvent.CLICK,btnHideList);
			giftBg.showGift.btn.addEventListener(MouseEvent.CLICK,btnShowList);
			giftBg.hideGift.visible =false;
//			giftBgaddEventListener(MouseEvent.CLICK,hideList);
			setSkin_Bg(giftBg); 
		}
		
		override protected function onRePosition():void{
			_title.x = (this.width - _title.width)/2;
			if(isHide){
				_title.y = 2;
			}else{
				_title.y = 189;
			}
		
		}
		
		override protected function onShow():void{
			_sending = false;
			super.onShow();
			initLsn();
		}
		
		
		private function initTitle():void{
			_title = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = FontUtil.f;
			textFormat.color = 0xFFFFFF;
			textFormat.size = 16;
			_title = new TextField();
			_title.width = 80;
			_title.text = "礼物";
			_title.y = -10;
			_title.width = _title.textWidth + 16;
			_title.height = _title.textHeight + 12;
			_title.selectable = false;
			_title.defaultTextFormat = textFormat;
			_title.setTextFormat(textFormat);
			_title.multiline = false;
			_title.mouseEnabled = false;
			this.addChild(_title);
		}
		
		private function btnHideList(e:MouseEvent = null):void{
			giftBg.showGift.visible = true;
			giftBg.hideGift.visible = false;
			_title.y = 2;
			_giftListPane.showGift();
			isHide = true;
		}
		
		private function btnShowList(e:MouseEvent = null):void{
			giftBg.showGift.visible = false;
			giftBg.hideGift.visible = true;
			_title.y = 189;
			_giftListPane.hideGift();
			isHide = false;
		}
		
		private function initList():void{
			_giftListPane = new GiftListPane();
			_giftListPane.x = 16;
			_giftListPane.y = 43;
			this.addChild(_giftListPane);
		}
		
		private function initNumBerList():void{
			_numberList = new List(0,false,NumListItemRender);
			_numberList.mouseEnabled = false;
			_numberList.width  = 80;
			var array:Array = [1,5,30,99,300,999,9999];
			var len:int = array.length;
			for (var i:int = 0; i < array.length; i++) 
			{
				var obj:Object = {label:array[i] + "",data:array[i]};
				_numberList.addItem(obj);
			}
			_numberList.y =  238 - 150;
			_numberList.x = 129 - 25;
			_numberList.visible = false;
			this.addChild(_numberList);
		}
		
		private function initBottomBar():void{
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
			tmpTf.y = 230;
			tmpTf.alpha = .6;
			tmpTf.width = 20;
			tmpTf.height = 20;
			tmpTf.mouseEnabled = false;
			tmpTf.multiline = false;
			tmpTf.defaultTextFormat = textFormat;
			tmpTf.setTextFormat(textFormat);
			tmpTf.type = TextFieldType.INPUT;
			this.addChild(tmpTf);
			
			var tmp:Shape = new Shape();
			tmp.graphics.beginFill(0x4c118a,1);
			tmp.graphics.drawRect(0,0,75,22);
			tmp.graphics.endFill();
			tmp.x = 25;
			tmp.y = 230;
			this.addChild(tmp)
			
			var dorpbackground:Shape=new Shape();
			this.addChild(dorpbackground);
			_downList = new DropDownList(DropDownList.UP, 6,HistoryItemRender);
			_downList.width = 75;
			_downList.x = 25;
			_downList.y = 230;
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
			
			_countInput = new TextField();
			textFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.size = 10;
			textFormat.font = FontUtil.f;
			
			var tmp1:Shape = new Shape();
			tmp1.graphics.beginFill(0x000000,1);
			tmp1.graphics.drawRect(0,0,28,22);
			tmp1.graphics.endFill();
			tmp1.x = 105;
			tmp1.y = 230;
			this.addChild(tmp1)
				
			_countInput = new DefaultTextField("1");
			_countInput.restrict = "0-9";
			_countInput.x = 105;
			_countInput.y = 230;
			_countInput.width = 28;
			_countInput.height = 20;
			_countInput.maxChars = 5;
			_countInput.multiline = false;
			_countInput.defaultTextFormat = textFormat;
			_countInput.setTextFormat(textFormat);
			_countInput.type = TextFieldType.INPUT;
			_countInput.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			
			this.addChild(_countInput);
			
			
			_showCountBtn = new Button();
			_showCountBtn.setSkin(new gift_selectCount_btn());
			_showCountBtn.x = 131;
			_showCountBtn.y = 231;
			_showCountBtn.width = 11;
			_showCountBtn.height = 22;
			this.addChild(_showCountBtn);
			
			_sendBtn = new Button("<font size='12'>"+lc.get("zsend_label","gift")+"</font>");
			_sendBtn.setSkin(new Button_SendBg);
			_sendBtn.x = 147;
			_sendBtn.y = 230;
			_sendBtn.width = 32;
			_sendBtn.height = 22;
			this.addChild(_sendBtn);
			ui.registerTip(_sendBtn,lc.get("sendgift_tip","bottom"));
			
			_moneyBtn = new Button("<font size='12' color='#a39ab1'>"+lc.get("money_label","components")+"</font>");
			_moneyBtn.setSkin(new Button_ChangeBg())
			_moneyBtn.x = 186;
			_moneyBtn.y = 229;
			_moneyBtn.width = 32;
			_moneyBtn.height = 24;
			this.addChild(_moneyBtn);
			ui.registerTip(_moneyBtn,lc.get("money_tip","bottom"));
			
		}
		
		private function onFocusOut(e:Event):void{
			var num:int = int(_countInput.text);
			if(num <= 0){
				_countInput.text = "1";
			}
		}
		
		private function initLsn():void{
			_countInput.addEventListener(FocusEvent.FOCUS_IN,onFoucusIn);
			_showCountBtn.addEventListener(MouseEvent.CLICK,onShowCountClick);
			_sendBtn.addEventListener(MouseEvent.CLICK,onSendClick);
			_moneyBtn.addEventListener(MouseEvent.CLICK,onMoneyClick);
			_numberList.addEventListener(Event.SELECT,onNumlistSelect);
			Context.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		private function onShowCountClick(e:Event):void{
			_numberList.visible = !_numberList.visible;
		}
		
		private var count:int = 0;
		private function onSendClick(e:Event):void{
			
			
//			if(_sending == true) return;
			//判断是否登录
			var showdata:ShowData = Context.variables["showData"] as ShowData;
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
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//提交数据
			var data:Object = {};
			data.receiverId = uid;
			data.count = count;
			data.giftId = giftItem.giftData.id;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.SEND_GIFT,data,onSecc,onFail);
			_sending = true;
			btnHideList();
		}
		
		/**
		 *如果点击了屏幕 则关闭 
		 * @param e
		 * 
		 */		
		private function onStageClick(e:Event):void{
			if(e.target === _showCountBtn) return;
			if(_numberList.visible == true){
				if(!Utils.checkIsChild(e.target as DisplayObject,_numberList)){
					_numberList.visible = false;
				}
			}
			if(_downList.isOpen == false){
				if(!Utils.checkIsChild(e.target as DisplayObject,_downList)){
					_downList.close();
				}
			}
		}
		
		private function onMoneyClick(e:Event):void{
			Util.toUrl(SEnum.URL_MONEY);
		}
		
		
		private function onNumlistSelect(e:Event):void{
			_numberList.visible = false;
			var obj:Object = _numberList.selected;
			_countInput.text = obj.data;
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
		
		private function onSecc(obj:Object):void{
			_sending = false;
		}
		
		private function onFail(obj:Object):void{
			_sending = false;
		}
		
		private function initShowData():void{
			var showData:ShowData = Context.variables["showData"] as ShowData;
			var order:Object = showData.order;
//			if(order["3"] !=null)
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
			_selectUsers[_selectUsers.length] = data;
			if(_selectUsers.length > USER_SELECT_LIMIT){
				_selectUsers.shift();
			}
			_downList.dataProvider = _selectUsers;
			
			btnHideList();
		}
		
		public function addByInit(obj:Object):void{
			_selectUsers.push(obj);
			_downList.dataProvider = _selectUsers;
		}
		
	}
}