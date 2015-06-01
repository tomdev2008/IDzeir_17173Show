package com._17173.flash.show.base.module.topbar.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TopBarUI extends SkinComponent
	{
		
		private var _iconEye:MovieClip = null;
		private var _nameLabel:TextField = null;
		private var _countLabel:TextField = null;
		private var _globalPane:CenterGlobalPane;
		/**
		 *显示数据 
		 */		
		private var _messages:Array = null;
		private var rs:IResourceManager = null;
		private var lobbyButton:Button;
		public function TopBarUI()
		{
			rs = Context.getContext(CEnum.SOURCE) as IResourceManager;
			super();			
		}
		
		override protected function onInit():void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			this.mouseEnabled = false;
			super.onInit();
			_messages = [];
			
			setSkin_Bg(new Bg_topbar());
			
			this.width = 1920;
			this.height = 41;
			
			
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;;
			textFormat.color = 0xE0E9F3;
			
			//名字label
			_nameLabel = new TextField();
			_nameLabel.x = 3;
			_nameLabel.y = 5;
			_nameLabel.width = 220;
			_nameLabel.height = 25;
			_nameLabel.mouseEnabled = false;
			_nameLabel.selectable = false;
			
			_iconEye = new Icon_eye();
			_iconEye.mouseEnabled = false;
			_iconEye.mouseChildren = false;
			_iconEye.x = 52;
			_iconEye.y = 13;
			this.addChild(_iconEye);			
			
		
			_nameLabel.defaultTextFormat = textFormat;
			_nameLabel.setTextFormat(textFormat);
			this.addChild(_nameLabel);
			//房间人数
			
			_countLabel = new TextField();
			_countLabel.x = 73;
			_countLabel.y = 5;
			_countLabel.width = 50;
			_countLabel.height = 25;
			_countLabel.mouseEnabled = false;
			_countLabel.selectable = false;
			textFormat.color = 0xE0E9F3;
			_countLabel.defaultTextFormat = textFormat;
			_countLabel.setTextFormat(textFormat);
			this.addChild(_countLabel);
			
			
			_globalPane = new CenterGlobalPane(2000);
			_globalPane.x = 0;
			_globalPane.y = -3;
			this.addChild(_globalPane);
		}
		
		
		override protected function onShow():void{
		}
		
		override protected function onHide():void{
		}
		
		
		/**
		 *更新容器位置 
		 * 
		 */		
		override protected function onRePosition():void{
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize();
			//判断当前窗口是否大于最小宽度
//			if(Context.stage.stageWidth >= limitWidth){
//				this.width = Context.stage.stageWidth;
//			}else{
//				this.width = limitWidth;
//			}
			this.width = Context.stage.stageWidth;
			_globalPane.width = this.width - 50;
		}

		
		public function updateName(name:String):void{
			_nameLabel.htmlText =   name ;
			_nameLabel.width = _nameLabel.textWidth + 8;
			_iconEye.x = _nameLabel.x + _nameLabel.width + 0;
			_countLabel.x = _iconEye.x +_iconEye.width + 2;
			_globalPane.offextX = _countLabel.x + _countLabel.textWidth + 30;
		}
		
		public function updateCount(count:int):void{
			_countLabel.htmlText = "<font color='#E1D361'>" +count+"</font>人";
		}
		
		private function onExitClick(e:MouseEvent):void{
			Util.toUrl(SEnum.domain);
		}
		
		private function onLobbyClick(e:MouseEvent):void
		{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LOBBY_SWITCH);
		}
		
		/**
		 *添加大数据 
		 * @param msg
		 * 
		 */		
		public function addGiftMessage(msg:Object):void{
			_globalPane.addMessage(msg);
		}
		
	}
}