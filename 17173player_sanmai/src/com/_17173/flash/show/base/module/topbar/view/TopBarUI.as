package com._17173.flash.show.base.module.topbar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.components.common.HMovePane;
	import com._17173.flash.core.components.common.SkinComponent;
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
		
		private var _exitButton:Button = null;
		private var _iconEye:MovieClip = null;
		private var _nameLabel:TextField = null;
		private var _countLabel:TextField = null;
		private var _hMovePane:HMovePane = null;
		private var _line:MovieClip = null;
		private var _moveBg:MovieClip = null;
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
			
			setSkin_Bg(new TopBar_Bg());
			
			this.width = 1920;
			this.height = 41;
			
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xE0E9F3;
			textFormat.font = FontUtil.f;
			
			//退出按钮
			_exitButton = new Button();
//			_exitButton = new Button("",false,new SourceData_Button(new TopBar_ExitButoon()));
			_exitButton.setSkin(new TopBar_ExitButoon())
			_exitButton.x = 0;
			_exitButton.y = 0;
			ui.registerTip(_exitButton,lc.get("top_exit_tip","bottom"));
			
			var homeIcon:MovieClip = new TopBar_Home();
			homeIcon.x = 15;
			homeIcon.y = 10;
			homeIcon.mouseEnabled = false;
			_exitButton.addChild(homeIcon);
			this.addChild(_exitButton);
			
			
			_line = new Line_Normal();
			_line.mouseEnabled = false;
			_line.x = _exitButton.width;
			this.addChild(_line);
			
			lobbyButton = new Button();
			lobbyButton.setSkin(new TopBar_ExitButoon());
			lobbyButton.x = _line.x+_line.height;
			ui.registerTip(lobbyButton,lc.get("top_openLobby","bottom"));
			this.addChild(lobbyButton);
			var lobbyIcon:MovieClip = new TopBar_Lobby();
			lobbyIcon.x = 15;
			lobbyIcon.y = 10;
			lobbyIcon.mouseEnabled = false;
			lobbyButton.addChild(lobbyIcon);
			
			var offsetX:Number = lobbyButton.width;
			
			_iconEye = new TopBar_IconEye();
			_iconEye.mouseEnabled = false;
			_iconEye.mouseChildren = false;
			_iconEye.x = 63+offsetX;
			_iconEye.y = 24;
			this.addChild(_iconEye);			
			
			//名字label
			_nameLabel = new TextField();
			_nameLabel.x = 61+offsetX;
			_nameLabel.y = 2;
			_nameLabel.width = 220;
			_nameLabel.height = 25;
			_nameLabel.mouseEnabled = false;
			_nameLabel.selectable = false;
		
			_nameLabel.defaultTextFormat = textFormat;
			_nameLabel.setTextFormat(textFormat);
			this.addChild(_nameLabel);
			//房间人数
			
			_countLabel = new TextField();
			_countLabel.x = 79+offsetX;
			_countLabel.y = 19;
			_countLabel.width = 220;
			_countLabel.height = 25;
			_countLabel.mouseEnabled = false;
			_countLabel.selectable = false;
			textFormat.color = 0xA8A3AB;
			_countLabel.defaultTextFormat = textFormat;
			_countLabel.setTextFormat(textFormat);
			this.addChild(_countLabel);
			
//			_moveBg = new TopBar_MoveBg();
//			_moveBg.x= (this.width - _moveBg.width)/2;
//			_moveBg.x = Math.max(300,_moveBg.x);
//			this.addChild(_moveBg);
			
//			_hMovePane = new HMovePane(_moveBg.width - 30,40,70,500);
//			_hMovePane.x = _moveBg.x + 15;
//			_hMovePane.y = 0;
//			_hMovePane.visible = false;
//			this.addChild(_hMovePane);
		}
		
		
		override protected function onShow():void{
//			_hMovePane.start();
			_exitButton.addEventListener(MouseEvent.CLICK,onExitClick);
//			_hMovePane.addEventListener(MoveEvent.ITEM_MOVE_END,onItemMoveEnd);
//			_hMovePane.addEventListener(MoveEvent.COUNT_CHANGE,onCountChange);
//			_hMovePane.addEventListener(MoveEvent.PLAY_NEXT,onPlayNext);
			lobbyButton.addEventListener(MouseEvent.CLICK,onLobbyClick);
		}
		
		override protected function onHide():void{
			_exitButton.removeEventListener(MouseEvent.CLICK,onExitClick);
//			_hMovePane.removeEventListener(MoveEvent.ITEM_MOVE_END,onItemMoveEnd);
//			_hMovePane.removeEventListener(MoveEvent.COUNT_CHANGE,onCountChange);
//			_hMovePane.removeEventListener(MoveEvent.PLAY_NEXT,onPlayNext);
		}
		
		
		/**
		 *更新容器位置 
		 * 
		 */		
		override protected function onRePosition():void{
			
//			var tmpX:int = (this.width - _moveBg.width)/2;
//			var rX:int = limitWidth - _hMovePane.width + 5;
//			if(tmpX < rX){
//				tmpX = rX;
//			}
//			_moveBg.x = tmpX;
//			_hMovePane.x = _moveBg.x + 15;
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize();
			//判断当前窗口是否大于最小宽度
			if(Context.stage.stageWidth >= limitWidth){
				this.width = Context.stage.stageWidth;
			}else{
				this.width = limitWidth;
			}
		}
		/**
		 *当前容器最小宽度 
		 * @return 
		 * 
		 */		
		override public function get limitWidth():int{
			//退出按钮宽度 + （用户名字宽度 或者 当前房间人数宽度） + 滚动容器宽度 + 间隔; 
//			return _exitButton.width + Math.max(_nameLabel.textWidth,_countLabel.textWidth+_iconEye.width)  + 10 + _hMovePane.width + 5;
			return _exitButton.width + Math.max(_nameLabel.textWidth,_countLabel.textWidth+_iconEye.width)  + 10;
		}
		
//		private function onPlayNext(e:Event):void{
//			showNextMessage();
//		}
//		
//		
//		private function onItemMoveEnd(e:Event):void{
////			showMessage();
//		}
//		
//		private function onCountChange(e:Event):void{
////			showMessage();	
//		}
		

		
		public function updateName(name:String):void{
			_nameLabel.text = name;
			_nameLabel.width  = _nameLabel.textWidth + 10;
		}
		
		public function updateCount(count:int):void{
			_countLabel.text = count+"";
		}
		
		private function onExitClick(e:MouseEvent):void{
			Util.toUrl(SEnum.domain);
		}
		
		private function onLobbyClick(e:MouseEvent):void
		{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LOBBY_SWITCH);
		}
		
//		/**
//		 *新消息 
//		 * @param data 消息
//		 * @param type 是否优先显示
//		 * 
//		 */		
//		public function addMessge(data:*,type:int = 0):void{
//			if(type != 0){
//				_messages.unshift(data);
//			}else{
//				_messages.push(data);
//			}
//			showNextMessage();
//		}
//		/**
//		 *新礼物消息 
//		 * @param data 消息
//		 * @param type 是否优先显示
//		 * 
//		 */	
//		public function addGiftMessage(data:*,type:int = 0):void{
//			if(type != 0){
//				_messages.unshift(data);
//			}else{
//				_messages.push(data);
//			}
//			showNextMessage();
//		}
//		
//		private function showNextMessage():void{
//			if(_hMovePane.canPlayNext && _messages.length > 0){
//				//创建显示对象
//				var msg:Object = _messages.shift();
//				//赋值显示消息
//				_hMovePane.playItem(getMesstByGift(msg));
//			}
//		}
//		private function getMesstByGift(data:Object):DisplayObject{
//			var str:String = "";
//			var sName:String = data.sName;
//			var tName:String = data.tName;
//			var gName:String = data.giftName;
//			var count:String = data.giftCount;
//			var page:String = data.iconPath;
//			str = sName + "送给" + tName + count + "个" + gName;
//			var text:TextField = new TextField();
//			text.height = 25;
//			text.text = str;
//			text.textColor = 0xFFFFFF;
//			text.mouseEnabled =false;
//			text.width = text.textWidth;
//			return text;
//		}
	}
}