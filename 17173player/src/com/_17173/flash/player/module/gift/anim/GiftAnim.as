package com._17173.flash.player.module.gift.anim
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 送礼动画 
	 * 
	 * @author shunia-17173
	 */	
	public class GiftAnim extends Sprite
	{
		
		/**
		 * 请求送礼的延时 
		 */		
		private static const REQUEST_SHOW_TIME:int = 4000;
		
		/**
		 * 显示动画次数配置,小于等于n(礼物个数)时显示t次送礼动画. 
		 */		
		private static const SHOW_CONFIG:Array = 
			[
				{"n":5, "t":1}, 
				{"n":10, "t":3}, 
				{"n":25, "t":5}, 
				{"n":50, "t":10}, 
				{"n":int.MAX_VALUE, "t":15}
			];
		
		private static var IDEL:int = 0;
		private static var IDEL_END:int = 0;
		private static var REQUEST:int = 0;
		private static var REQUEST_END:int = 0;
		private static var SEND:int = 0;
		private static var SEND_DROP:int = 0;
		private static var SEND_END:int = 0;
		
		//当前剩余的总共需要显示的送礼动画的次数
		private var _giftsNeedToShow:Array = null;
		//是否正在播放送礼动画
		private var _isGiftShowing:Boolean = false;
		//左边的一整套动画
		private var _leftAnim:MovieClip = null;
		//右边的礼物炸开动画
		private var _rightAnim:MovieClip = null;
		//关闭按钮
		private var _clsBtn:MovieClip = null;
		
		public function GiftAnim()
		{
			super();
			
			_giftsNeedToShow = [];
			
			_leftAnim = new mc_gift_anim();
			
			//从label里过滤每个状态对应的帧数
			IDEL = _leftAnim.currentLabels[0].frame;
			IDEL_END = _leftAnim.currentLabels[1].frame - 1;
			SEND = _leftAnim.currentLabels[1].frame;
			SEND_DROP = _leftAnim.currentLabels[2].frame;
			SEND_END = _leftAnim.currentLabels[3].frame - 1;
			REQUEST = _leftAnim.currentLabels[3].frame;
			REQUEST_END = _leftAnim.totalFrames;
			
			_leftAnim.gotoAndPlay(IDEL);
			
			_leftAnim.addEventListener(Event.ENTER_FRAME, onLeftAnimFrame);
			addChild(_leftAnim);
			
			onReszie();
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, onReszie);
		}
		
		protected function onLeftAnimFrame(event:Event):void {
			//如果处于idel状态,鼠标滑过会出现求送礼物
			if (_leftAnim.currentFrame <= IDEL_END) {
				_leftAnim.addEventListener(MouseEvent.ROLL_OVER, onLeftAnimMouseOver);
			} else {
				if (_leftAnim.hasEventListener(MouseEvent.ROLL_OVER)) {
					_leftAnim.removeEventListener(MouseEvent.ROLL_OVER, onLeftAnimMouseOver);
				}
			}
			
			if (_leftAnim.currentFrame == IDEL_END) {
				_leftAnim.gotoAndPlay(IDEL);
			} else if (_leftAnim.currentFrame == REQUEST_END) {
				_leftAnim.stop();
			} else if (_leftAnim.currentFrame == SEND_END) {
				_leftAnim.gotoAndPlay(1);
				//播完了重新检测
				_isGiftShowing = false;
				onShowSendGift();
			} else if (_leftAnim.currentFrame == SEND_DROP) {
				showRightGiftAnim();
			}
		}
		
		private function onShowSendGift():void {
			if (_isGiftShowing) return;
			
			if (_giftsNeedToShow.length > 0) {
				onShowAnim(_giftsNeedToShow.shift());
			} else {
				_isGiftShowing = false;
			}
		}
		
		private function onShowAnim(data:Object):void {
			_leftAnim.gotoAndPlay(SEND);
			_isGiftShowing = true;
		}
		
		/**
		 * 准备显示送礼物动画
		 *  
		 * @param data
		 */		
		public function showSendGifts(data:Object):void {
			//解析需要显示的次数
			var needToShow:Array = parseGiftData(data);
			//增加到显示次数列表里
			_giftsNeedToShow = _giftsNeedToShow.concat(needToShow);
			//启动播放
			onShowSendGift();
		}
		
		private function parseGiftData(data:Object):Array {
			var arr:Array = [];
			var count:int = data.giftCount;
			var t:int = 1;
			
			for each (var conf:Object in SHOW_CONFIG) {
				if (count <= conf.n) {
					t = conf.t;
					break;
				}
			}
			
			for (var i:int = 0; i < t; i ++) {
				arr.push(data);
			}
			
			return arr;
		}
		
		protected function onLeftAnimMouseOver(event:MouseEvent):void {
			_leftAnim.removeEventListener(MouseEvent.ROLL_OVER, onLeftAnimMouseOver);
			//发送事件通知ui显示遮罩框
			Context.getContext(ContextEnum.EVENT_MANAGER).send("requestGift");
			//播放请求送礼动画
			_leftAnim.gotoAndPlay(REQUEST);
			//延迟关闭请求送礼动画
			Ticker.tick(REQUEST_SHOW_TIME, function ():void {
				//延迟后回到第一帧
				_leftAnim.gotoAndPlay(IDEL);
				//关闭遮罩框
				Context.getContext(ContextEnum.EVENT_MANAGER).send("requestGiftHide");
			});
		}
		
		/**
		 * 显示礼物炸开的动画 
		 */		
		private function showRightGiftAnim():void {
			if (_rightAnim == null) {
				_rightAnim = new mc_recvGift_anim();
			}
			_rightAnim.gotoAndPlay(1);
			_rightAnim.addEventListener(Event.ENTER_FRAME, onRightAnimFrame);
			addChild(_rightAnim);
			
			if (_clsBtn == null) {
				_clsBtn = new mc_clsBtn();
			}
			_clsBtn.addEventListener(MouseEvent.CLICK, onCloseAnim);
			addChild(_clsBtn);
			
			onReszie();
		}
		
		/**
		 * 关闭动画 
		 * @param event
		 */		
		protected function onCloseAnim(event:MouseEvent):void {
			_giftsNeedToShow = null;
			Context.getContext(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.UI_RESIZE, onReszie);
			disposeLeftAnim();
			disposeRightAnim();
			
			dispatchEvent(new Event("close"));
		}
		
		protected function onRightAnimFrame(event:Event):void {
			if (_rightAnim.currentFrame == _rightAnim.totalFrames) {
				disposeRightAnim();
			}
		}
		
		/**
		 * 销毁左侧动画 
		 */		
		private function disposeLeftAnim():void {
			if (_leftAnim) {
				_leftAnim.removeEventListener(Event.ENTER_FRAME, onLeftAnimFrame);
				_leftAnim.stop();
				removeChild(_leftAnim);
				_leftAnim = null;
			}
		}
		
		/**
		 * 销毁右侧动画 
		 */		
		private function disposeRightAnim():void {
			if (_rightAnim) {
				_rightAnim.removeEventListener(Event.ENTER_FRAME, onRightAnimFrame);
				_rightAnim.stop();
				removeChild(_rightAnim);
				_rightAnim = null;
			}
			
			if (_clsBtn) {
				_clsBtn.removeEventListener(MouseEvent.CLICK, onCloseAnim);
				removeChild(_clsBtn);
				_clsBtn = null;
			}
		}
		
		private function onReszie(data:Object = null):void {
			Ticker.tick(0, function ():void {
				var bottomBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER)
				.getSkin(SkinsEnum.BOTTOM_BAR);
				var h:Number = Context.stage.stageHeight - bottomBar.display.height;
				
				if (_leftAnim) {
					_leftAnim.x = 3;
					_leftAnim.y = h - _leftAnim.height;
				}
				if (_rightAnim) {
					_rightAnim.x = Context.stage.stageWidth - _rightAnim.width;
					_rightAnim.y = h - _rightAnim.height - 10;
				}
				if (_clsBtn) {
					_clsBtn.x = Context.stage.stageWidth - _clsBtn.width;
					_clsBtn.y = _rightAnim.y;
				}
			}, 1);
		}
		
	}
}