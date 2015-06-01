package com._17173.flash.player.module.userinfo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *用户信息板子
	 * @author zhaoqinghao
	 *
	 */
	public class UserInfoUI extends Sprite implements IExtraUIItem
	{

		private var _face:UserFace = null;
		private var _money1:TextField = null;
		private var _money2:TextField = null;
		private var _btn1:SimpleButton = null;
		private var _btn2:SimpleButton = null;
		private const USER_INFO_URL:String = "http://v.17173.com/live/mi_info.action";
		private const TO_MONEY:String = "http://v.17173.com/live/ucenter/payment.action";
		private const TO_EXCHANGE:String = "http://v.17173.com/live/ucenter/goMpkgAccountLookup.action";
		private const MONEY_LIMIT:int = 99999;
		//private var chongzhiPanel:mc_chongzhiPanel = null;

		public function UserInfoUI()
		{
			super();
			init();
		}

		private function init():void
		{
			_face = new UserFace();
			_face.x = 0;
			_face.y = 5;
			this.addChild(_face);
			//放个默认图
//			chongzhiPanel = new mc_chongzhiPanel();
//			chongzhiPanel.x = 180;
//			chongzhiPanel.y = 5;
//			chongzhiPanel.chongText.buttonMode = true;
//			chongzhiPanel.chongText.addEventListener(MouseEvent.CLICK, onChongClick);
//			chongzhiPanel.chongClose.addEventListener(MouseEvent.CLICK, onChongCloseClick);
//			chongzhiPanel.addEventListener(MouseEvent.ROLL_OVER, onChongOver);
//			chongzhiPanel.addEventListener(MouseEvent.ROLL_OUT, onChongOut);
//			chongzhiPanel.chongClose.visible = false;
			

			_money1 = new TextField();
			_money1.text = "金币：0";
			_money1.mouseEnabled = false;
			_money1.width = 85;
			_money1.height = 25;
			_money1.textColor = 0xD4D4D4;
			_money1.x = 50;
			_money1.y = 4;
			this.addChild(_money1);


			_money2 = new TextField();
			_money2.text = "银币：0";
			_money2.mouseEnabled = false;
			_money2.width = 85;
			_money2.height = 25;
			_money2.textColor = 0xD4D4D4;
			_money2.x = 50;
			_money2.y = 26;
			this.addChild(_money2);

			_btn1 = new mc_goMoneyBtn();
			_btn1.x = 135;
			_btn1.y = 5;
			this.addChild(_btn1);
			_btn1.addEventListener(MouseEvent.CLICK, onMoneyClick);

			_btn2 = new mc_exchangeBtn();
			_btn2.x = 135;
			_btn2.y = 26;
			this.addChild(_btn2);
			_btn2.addEventListener(MouseEvent.CLICK, onExchangeClick);


			var sp:MovieClip = new mc_splitLine();
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			sp.x = 189;
			this.addChild(sp);
			onInfo();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_USER_INFO_GETED, onInfo);
			
//			addChild(chongzhiPanel);
		}

		private function onChongOver(e:Event):void {
//			chongzhiPanel.chongClose.visible = true;
		}
		
		private function onChongOut(e:Event):void {
//			chongzhiPanel.chongClose.visible = false;
		}
		
		private function onChongClick(e:Event):void {
			Util.toUrl("http://v.17173.com/live/show/2014cz/002/index.html");
		}
		
		private function onChongCloseClick(e:Event):void {
//			chongzhiPanel.visible = false;
		}
		
		private function onInfo(data:Object = null):void
		{
			updateInfo(Context.variables["userInfo"]);
		}

		private function onInfoFail(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[userInfo]", "获取用户数据失败");
		}

		public function refresh(isFullScreen:Boolean = false):void
		{
		}

		public function get side():Boolean
		{
			return false;
		}

		private function onMoneyClick(e:Event):void
		{
			onNormalScreen();
			Util.toUrl(TO_MONEY);
		}
		
		private function onNormalScreen():void{
//			if (Global.settings.isFullScreen) {
			if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
		}

		private function onExchangeClick(e:Event):void
		{
			onNormalScreen();
			Util.toUrl(TO_EXCHANGE);
		}

		public function updateInfo(data:Object = null):void
		{
			if(data == null) return;
			if (data.hasOwnProperty("faceUrl"))
			{
				_face.faceUrl = data.faceUrl;
			}
			//更新用户金币
			var jinbi:Number = 0;
			var yinbi:Number = 0;
			if(data.hasOwnProperty("jinbi")){
				jinbi = data.jinbi
			}
			if(data.hasOwnProperty("yinbi")){
				yinbi = data.yinbi
			}
			
			if (jinbi > MONEY_LIMIT)
			{
				_money1.text = "金币：" + MONEY_LIMIT + "+";
			}
			else
			{
				_money1.text = "金币：" + int(jinbi);
			}
			//更新用户银币
			if (yinbi > 99999)
			{
				_money2.text = "银币：" + MONEY_LIMIT + "+";
			}
			else
			{
				_money2.text = "银币：" + int(yinbi);
			}
		}
	}
}
