package com._17173.flash.player.module.onlineTime
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.onlineTime.item.OlCountDownMC;
	import com._17173.flash.player.module.onlineTime.item.OnLineTimeControlButton;
	import com._17173.flash.player.module.onlineTime.item.OnLineTimeGiftShow;
	import com._17173.flash.player.module.onlineTime.item.OnLineTimeOver;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *在线时长ui
	 * @author zhaoqinghao
	 *
	 */
	public class OnLineTimeUI extends Sprite
	{
		/**
		 *倒计时板子
		 */
		private var _countdown:OlCountDownMC = null;
		/**
		 *等待领取
		 */
		private var _overTime:OnLineTimeOver = null;
		/**
		 *播放领取动画
		 */
		private var _giftPlay:OnLineTimeGiftShow = null;
		/**
		 * 控制位置的小按钮
		 */
		private var _controlBtn:OnLineTimeControlButton = null;
		private var _status:int = -1;
		
		private var _position:String = "Right";
		
		/**
		 *当前时间
		 */
		private var _cTime:int = 0;
		
		public function OnLineTimeUI()
		{
			super();
			init();
		}
		
		
		/**
		 *当前面板状态 0 = 计时钟 ；1 等待中 ；2领取礼物中；
		 */
		public function get status():int
		{
			return _status;
		}

		/**
		 * @private
		 */
		public function set status(value:int):void
		{
			_status = value;
		}

		private function onShow():void
		{
			_overTime.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onHide():void
		{
			_overTime.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onAdd(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			onShow();
		}
		
		private function onRemove(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			onHide()
		}
		
		private function init():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			_overTime = new OnLineTimeOver();
			_overTime.visible = false;
			_overTime.stop();
			this.addChild(_overTime);
			
			_countdown = new OlCountDownMC();
			_countdown.visible = false;
			_countdown.mouseChildren = false;
			_countdown.mouseEnabled = false;
			this.addChild(_countdown);
			
			_giftPlay = new OnLineTimeGiftShow();
			_giftPlay.stop();
			_giftPlay.visible = false;
			this.addChild(_giftPlay);
			
			_controlBtn = new OnLineTimeControlButton();
			_controlBtn.buttonMode = true;
			_controlBtn.visible = false;
			_controlBtn.x = 90;
			_controlBtn.y = 90;
			_controlBtn.addEventListener(MouseEvent.CLICK, onControlButtonClick);
			
			this.addChild(_controlBtn);
		}
		
		private function onControlButtonClick(e:MouseEvent):void
		{
			if (_position == "Right")
			{
				_controlBtn.turnRight();
				//TweenLite.to(ad, 0.5, {"y":(H - ad.height) / 2});
				TweenLite.to(this,2,{"x":-90});
				_position = "Left";
			}
			else 
			{
				_controlBtn.turnLeft();
				TweenLite.to(this,2,{"x":0});
				_position = "Right";
			}
			//禁止后续操作
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		public function set position(strPosition:String):void
		{
			if (strPosition ==_position) return;
			if ((_position == "Right")&&(strPosition == "Left"))
			{
				_controlBtn.turnRight();
				//TweenLite.to(ad, 0.5, {"y":(H - ad.height) / 2});
				TweenLite.to(this,2,{"x":-90});
				_position = "Left";
			}
			else if ((_position == "Left")&&(strPosition == "Right"))
			{
				_controlBtn.turnLeft();
				TweenLite.to(this,2,{"x":0});
				_position = "Right";
			}
		}
		
		public function get position():String
		{
			return _position;
		}
		
		/**
		 *显示领取
		 *
		 */
		private function showOverTime():void
		{
			if (_status != 1)
			{
				_status = 1;
				_overTime.play();
				changeVis();
				if (position == "Left")
				{
					position = "Right";
				}
			}
		}
		
		/**
		 *点击领取
		 *
		 */
		private function onClick(e:Event):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER)).send("onLineTimeGift");
		}
		
		/**
		 *显示cd
		 *
		 */
		private function showCd(cTime:int):void
		{
			if (_status != 0)
			{
				_status = 0;
				_countdown.play();
				changeVis();
			}
			_countdown.updateTime(Util.getTimerText(cTime, false));
		}
		
		/**
		 *展示礼物
		 *
		 */
		public function giftShow(money:int):void
		{
			_status = 2;
			_giftPlay.updateMoney(money);
			_giftPlay.play();
			Ticker.tick(3000, onGiftEnd, 1);
			changeVis();
		}
		
		/**
		 *播放完毕，自动切换到 倒计时
		 *
		 */
		private function onGiftEnd():void
		{
			showCd(_cTime);
			changeVis();
		}
		
		/**
		 *三个动画显示切换
		 *
		 */
		public function changeVis():void
		{
			//计时阶段
			if (_status == 0)
			{
				_overTime.stop();
				_giftPlay.stop();
				_overTime.visible = false;
				_giftPlay.visible = false;
				_countdown.visible = true;
				_controlBtn.visible = true;
			}
			//等待阶段
			if (_status == 1)
			{
				_countdown.stop();
				_giftPlay.stop();
				_overTime.visible = true;
				_giftPlay.visible = false;
				_countdown.visible = false;
				_controlBtn.visible = true;
			}
			//领取奖励阶段
			if (_status == 2)
			{
				_countdown.stop();
				_overTime.stop();
				_overTime.visible = false;
				_giftPlay.visible = true;
				_countdown.visible = false;
				_controlBtn.visible = true;
			}
		}
		
		/**
		 *更新
		 *
		 */
		public function update(cTime:int):void
		{
			_cTime = cTime;
			if (_status != 2)
			{
				if (cTime > 0)
				{
					showCd(cTime);
				}
				else
				{
					showOverTime();
				}
			}
		}
	}
}
