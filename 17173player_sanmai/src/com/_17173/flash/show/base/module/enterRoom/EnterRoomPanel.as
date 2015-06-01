package com._17173.flash.show.base.module.enterRoom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SError;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * 进入房间 
	 * @author qiuyue
	 * 
	 */	
	public class EnterRoomPanel extends BasePanel
	{
		private var _s:IServiceProvider = null;
		private var _e:IEventManager = null;
		/**
		 * 进入房间界面的父类 
		 */		
		private var _sprite:Sprite = null;
		/**
		 * 进入房间错误界面父类 
		 */		
		private var _errorSprite:Sprite=  null;
		
		/**
		 * 密码 
		 */		
		private var _pwdText:TextField = null;
		/**
		 * 密码低栏 
		 */		
		private var _pwdInfo:TextField = null;
		/**
		 * 错误消息 
		 */		
		private var _errorText:TextField = null;
		public function EnterRoomPanel()
		{
			super();
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			//this.closeBtn.visible = false;
			
			this.setSkin_Bg(new EnterRoomBg());
			this.setSkin_Close(null);
			this.showCloseBtn = false;
		}
		
		/**
		 * 密码方式进入房间 
		 * 
		 */		
		private function createPwd():void{
			var pwdBG:EnterRoomPwdBg = new EnterRoomPwdBg();
			_sprite.addChild(pwdBG);
			pwdBG.x = 50;
			pwdBG.y = 120;
			
			var lock:Lock = new Lock();
			_sprite.addChild(lock);
			lock.x = 61;
			lock.y = 128;
			
			var returnText:TextField = createText(Context.getContext(CEnum.LOCALE).get("return", "openModule"), 303, 219, 0x8B7D98, 14,true);
			returnText.addEventListener(MouseEvent.CLICK,returnMain);
			
			
			createText(Context.getContext(CEnum.LOCALE).get("pwdTitle", "openModule"), 16, 7, 0x9774c6, 16);
			
			
			var btn:Button = new Button(Context.getContext(CEnum.LOCALE).get("pwdBtn", "openModule"),false);
			btn.setSkin(new Button_SendBg());
			btn.addEventListener(MouseEvent.CLICK,sendPwd);
			btn.width = 67;
			btn.height = 35;
			_sprite.addChild(btn);
			btn.x = 287;
			btn.y = 120;
			
			_pwdInfo = createText(Context.getContext(CEnum.LOCALE).get("pwdInfo", "openModule"), 83, 125, 0x9774c6, 14);
			
			_errorText = createText(Context.getContext(CEnum.LOCALE).get("pwdFail", "openModule"), 50, 159, 0xD200FF, 12);
			_errorText.visible = false;
			
			_pwdText = new TextField;
			
			_pwdText.maxChars = 10;
			_pwdText.displayAsPassword = true;
			_pwdText.restrict ="A-Za-z0-9";
			_pwdText.x = 83;
			_pwdText.y = 129;
			_pwdText.width = 130;
			_pwdText.height = 30;
			_pwdText.type = TextFieldType.INPUT;
			_pwdText.addEventListener(FocusEvent.FOCUS_IN,focusHandler);
			_pwdText.addEventListener(FocusEvent.FOCUS_OUT,focusHandler);
			_sprite.addChild(_pwdText);
			
		}
		
		protected function focusHandler(event:FocusEvent):void
		{
			switch(event.type)
			{
				case FocusEvent.FOCUS_IN:
					_pwdInfo.visible = false;
					break;
				case FocusEvent.FOCUS_OUT:
					if(_pwdText.text == ""){
						_pwdInfo.visible = true;
					}
					break;
			}
		}
		
		/**
		 * 創建界面 
		 * 
		 */		
		public function createPanel():void{
			if(Context.variables.showData.limit != 0){
				this.width = 402;
				this.height = 260;
				_sprite = new Sprite();
				if(!this.contains(_sprite)){
					this.addChild(_sprite);
				}
				this._sprite.removeChildren();
				
				if(Context.variables.showData.limit == 1){
					createPrice();
				}
				if(Context.variables.showData.limit == 2){
					createPwd();
					Context.stage.focus = _pwdText;
					_pwdText.addEventListener(KeyboardEvent.KEY_UP,enter);
				}
			}
		}
		
		/**
		 * 创建金币方式进入界面 
		 * 
		 */		
		private function createPrice():void{
			
			createText(Context.getContext(CEnum.LOCALE).get("roomNotice", "openModule"), 16, 7, 0x9774c6, 16);
			var array:Array = new Array();
			array.push("<font color='#E0D170'>100</font>");
			var str:String = "<font color='#9774c6'>"+Context.getContext(CEnum.LOCALE).get("priceText", "openModule", array)+"</font>";
			createText(str , 85, 87, 0x9774c6, 16);
			var returnText:TextField = createText(Context.getContext(CEnum.LOCALE).get("return", "openModule"), 302, 219, 0x8B7D98, 14,true);
			returnText.addEventListener(MouseEvent.CLICK,returnMain);
			var btn:Button = new Button(Context.getContext(CEnum.LOCALE).get("priceBtn", "openModule"),false);
			btn.setSkin(new Button_SendBg());
			btn.addEventListener(MouseEvent.CLICK,sendPrice);
			btn.width = 140;
			btn.height = 35;
			_sprite.addChild(btn);
			btn.x = 131;
			btn.y = 145;
		}
		/**
		 * 返回大厅 
		 * @param e
		 * 
		 */		
		private function returnMain(e:MouseEvent):void{
			Util.toUrl(SEnum.domain, "_self");
		}
		
		/**
		 * 发送密码消息 
		 * @param e
		 * 
		 */		
		private function sendPwd(e:MouseEvent = null):void{
			var url:URLVariables = new URLVariables();
			url["roomId"] = Context.variables.showData.roomID;
			url["type"] = Context.variables.showData.limit;
			url["pwd"] = _pwdText.text;
			url["result"] = "json";
			sendMessage(url);
		}
		
		private function enter(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER){
				if(Context.variables.showData.limit == 1){
					sendPrice();
				}
				if(Context.variables.showData.limit == 2){
					sendPwd();
				}
			}
		}
		
		/**
		 * 发送消息 
		 * @param url
		 * 
		 */		
		private function sendMessage(url:URLVariables):void{
			_s.http.getData(SEnum.domain + "/fd_enter.action",url,priceSucc,priceFail, true);
		}
		
		/**
		 * 发送金币消息 
		 * @param e
		 * 
		 */		
		private function sendPrice(e:MouseEvent = null):void{
			var url:URLVariables = new URLVariables();
			url["roomId"] = Context.variables.showData.roomID;
			url["type"] = Context.variables.showData.limit;
			url["result"] = "json";
			sendMessage(url);
		}
		
		/**
		 * 创建Error界面 
		 * 
		 */		
		private function createError():void{
			if(!_errorSprite){
				_errorSprite = new Sprite();
				var format:TextFormat = new TextFormat();
				format = FontUtil.DEFAULT_FORMAT;
				format.size = 16;
				format.color = 0xD200FF;
				var textField:TextField = new TextField();
				textField.defaultTextFormat = format;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
				_errorSprite.addChild(textField);
				textField.x = 120;
				textField.y = 100;
				textField.text = Context.getContext(CEnum.LOCALE).get("failPrice", "openModule");
				var btn:Button = new Button(Context.getContext(CEnum.LOCALE).get("payBtn", "openModule"),false);
				btn.setSkin(new Button_SendBg())
				btn.addEventListener(MouseEvent.CLICK,pay);
				btn.width = 140;
				btn.height = 35;
				_errorSprite.addChild(btn);
				btn.x = 131;
				btn.y = 145;
			}
			if(!this.contains(_errorSprite)){
				this.addChild(_errorSprite);
			}
		}
		
		/**
		 * 充值 
		 * @param e
		 * 
		 */		
		private function pay(e:MouseEvent):void{
			Util.toUrl(SEnum.URL_MONEY);
		}
		
		/**
		 * 进入房间成功 
		 * @param data
		 * 
		 */		
		private function priceSucc(data:Object):void{
			Debugger.log(Debugger.INFO,"进入房间成功");
			(Context.getContext(CEnum.UI) as UIManager).removePanel(this);
			_e.send(SEvents.ENTER_ROOM_SUCC);
			if(_pwdText){
				_pwdText.removeEventListener(KeyboardEvent.KEY_UP,enter);
			}
		}
		 
		/**
		 * 进入房间失败
		 * @param data
		 * 
		 */	
		private function priceFail(data:Object):void{
			Debugger.log(Debugger.INFO,"进入房间失败 code  = "+ data.code);
			if(Context.variables.showData.limit == 2){
				Context.stage.focus = _pwdText;
			}
			if(data.code == "200000"){
				createError();
				_sprite.visible = false;
				_errorSprite.visible =true;
				
			}else{
				SError.handleServerError(data);
				if(Context.variables.showData.limit == 2){
					if(_errorText){
						_errorText.visible = true;
					}
					
				}else{
					if(_errorText){
						_errorText.visible = false;
					}
				}
			}
		}
		
		/**
		 * 创建文本 
		 * @param text  文字
		 * @param _x  x坐标
		 * @param _y  y坐标
		 * @param color 颜色
		 * @param size 大小
		 * @return  TextField
		 * 
		 */		
		private function createText(text:String,_x:int,_y:int,color:uint,size:int,underLine:Boolean = false):TextField{
			var _titleTextField:TextField = new TextField();
			var format:TextFormat = FontUtil.DEFAULT_FORMAT;
			format.color = color;
			format.size = size;
			format.underline = underLine;
			_titleTextField.defaultTextFormat = format;
			_titleTextField.autoSize = TextFieldAutoSize.LEFT;
			_titleTextField.htmlText = text;
			_titleTextField.x = _x;
			_titleTextField.selectable = false;
			_titleTextField.y = _y;
			_sprite.addChild(_titleTextField);
			return _titleTextField;
		}
	}
}