package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.data.QuizUserData;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 竞猜主界面topbar右边栏
	 */	
	public class QuizUITopBarRight extends Sprite
	{
		private var _bg:Sprite;
		//举报按钮
		private var _reportBtn:Button;
		//问题按钮
		private var _questionBtn:Button;
		//我的竞猜按钮
		private var _myQuizBtn:Button;
		//我要开猜按钮
		private var _startDaelerBtn:Button;
		//停止投注按钮
		private var _stopDealerBtn:Button;
		//开奖按钮
		private var _kaijiangBtn:Button;
		//竞猜用户信息
		private var _quizUser:QuizUserData;
		
		private var _e:IEventManager;
		
		public function QuizUITopBarRight()
		{
			super();
			init();
			addListener();
			setState(3);
		}
		
		private function init():void {
			_quizUser = Context.variables["quizUser"];
			
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			
			_bg = new Sprite();
			
			_reportBtn = new Button();
			setBtnStyle(_reportBtn, 16, 16, new quizJuBaoBtn());
			Context.getContext(ContextEnum.UI_MANAGER).registerTip(_reportBtn,"举报");
			_reportBtn.addEventListener(MouseEvent.CLICK, reportClick);
			
			_questionBtn = new Button();
			setBtnStyle(_questionBtn, 16, 16, new quizQuestionBtn());
			Context.getContext(ContextEnum.UI_MANAGER).registerTip(_questionBtn,"帮助中心");
			_questionBtn.addEventListener(MouseEvent.CLICK, questionClick);
			
			_myQuizBtn = new Button();
			setBtnStyle(_myQuizBtn, 63, 21, new quizMyQuizBtn());
			_myQuizBtn.addEventListener(MouseEvent.CLICK, toMyQuizInfo);
			
			_startDaelerBtn = new Button();
			setBtnStyle(_startDaelerBtn, 63, 21, new quizKaiCaiBtn());
			_startDaelerBtn.addEventListener(MouseEvent.CLICK, startDealer);
			
			_stopDealerBtn = new Button();
			setBtnStyle(_stopDealerBtn, 63, 21, new quizStopXiaZhuBtn());
			_stopDealerBtn.addEventListener(MouseEvent.CLICK, closeDealer);
			
			_kaijiangBtn = new Button();
			setBtnStyle(_kaijiangBtn, 63, 21, new quizKaiJingBtn());
			_kaijiangBtn.addEventListener(MouseEvent.CLICK, closeQuiz);
			
			addChild(_bg);
			_bg.addChild(_reportBtn);
			_bg.addChild(_questionBtn);
			_bg.addChild(_myQuizBtn);
			_bg.addChild(_startDaelerBtn);
			_bg.addChild(_stopDealerBtn);
			_bg.addChild(_kaijiangBtn);
		}
		
		private function addListener():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_RESIZE, resize);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, quizSelectChange);
		}
		
		private function setBtnStyle(value:Button, w:int, h:int, dis:DisplayObject):void {
			value.width = w;
			value.height = h;
			value.setSkin(dis);
		}
		
		/**
		 * 举报
		 */		
		private function reportClick(evt:MouseEvent):void {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			Util.toUrl("http://bbs.17173.com/");
		}
		
		/**
		 * 问题
		 */		
		private function questionClick(evt:MouseEvent):void {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			Util.toUrl("http://bbs.17173.com/thread-8042949-1-1.html");
		}
		
		/**
		 * 我的竞猜
		 */		
		private function toMyQuizInfo(evt:MouseEvent):void {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			if (Context.getContext(ContextEnum.SETTING)["userLogin"]) {
				Util.toUrl("http://v.17173.com/live/ucenter/jctj_goQuizJspAction.action?m=goQuizJsp&type=1");
			} else {
				Context.getContext(ContextEnum.SETTING).login();
			}
		}
		
		/**
		 * 关闭竞猜（开奖）
		 */		
		private function closeQuiz(evt:MouseEvent):void {
			dispatchEvt(QuizEvents.QUIZ_CLOSE_QUIZ);
		}
		
		/**
		 * 关闭庄
		 */		
		private function closeDealer(evt:MouseEvent):void {
			dispatchEvt(QuizEvents.QUIZ_CLOSE_DEALER);
		}
		
		/**
		 * 开庄
		 */		
		private function startDealer(evt:MouseEvent):void {
			dispatchEvt(QuizEvents.QUIZ_SHOW_START_DEALER);
		}
		
		/**
		 * 派发事件
		 */		
		private function dispatchEvt(evt:String, bu:Boolean = true):void {
			_e.send(evt);
		}
		
		public function resize(evt:Event = null):void {
			var leftOffset:int = 10;
			var rightOffset:int = 10;
			if (_reportBtn) {
				_reportBtn.x = leftOffset;
				_reportBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _reportBtn.height) / 2;
			}
			if (_questionBtn) {
				_questionBtn.x = _reportBtn.x + _reportBtn.width + 5;
				_questionBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _questionBtn.height) / 2;
			}
			if (_myQuizBtn) {
				_myQuizBtn.x = _questionBtn.x + _questionBtn.width + 10;
				_myQuizBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _myQuizBtn.height) / 2;
			}
			if (_startDaelerBtn) {
				if (_startDaelerBtn.visible) {
					_startDaelerBtn.x = _myQuizBtn.x + _myQuizBtn.width + 10;
					_startDaelerBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _startDaelerBtn.height) / 2;
				} else {
					_startDaelerBtn.x = _myQuizBtn.x;
					_startDaelerBtn.y = _myQuizBtn.y;
				}
			}
			if (_kaijiangBtn) {
				if (_kaijiangBtn.visible) {
					_kaijiangBtn.x = _myQuizBtn.x + _myQuizBtn.width + 10;
					_kaijiangBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _kaijiangBtn.height) / 2;
				} else {
					_kaijiangBtn.x = _startDaelerBtn.x;
					_kaijiangBtn.y = _startDaelerBtn.y;
				}
			}
			if (_stopDealerBtn) {
				if (_stopDealerBtn.visible) {
					_stopDealerBtn.x = _startDaelerBtn.x + _startDaelerBtn.width + 10;
					_stopDealerBtn.y = (QuizMainUI.TOP_BAR_HEIGHT - _stopDealerBtn.height) / 2;
				} else {
					_stopDealerBtn.x = _startDaelerBtn.x;
					_stopDealerBtn.y = _startDaelerBtn.y;
				}
			}
			
			if (_bg) {
				_bg.graphics.clear();
				if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
					_bg.graphics.beginFill(0x414141, 0.8);
				} else {
					_bg.graphics.beginFill(0x414141);
				}
				_bg.graphics.drawRect(0, 0, width + leftOffset + rightOffset, QuizMainUI.TOP_BAR_HEIGHT);
				_bg.graphics.endFill();
			}
		}
		
		/**
		 * 根据当前用户信息和竞猜信息判断各按钮的显示状态
		 */		
		private function setState(value:int):void {
			switch (value) {
				case 1:
					//管理员或者竞猜开启着
					_startDaelerBtn.visible = false;
					_stopDealerBtn.visible = false;
					_kaijiangBtn.visible = true;
					break;
				case 2:
					//有庄的用户
					_startDaelerBtn.visible = true;
					_stopDealerBtn.visible = true;
					_kaijiangBtn.visible = false;
					break;
				case 3:
					//普通用户
					_startDaelerBtn.visible = true;
					_stopDealerBtn.visible = false;
					_kaijiangBtn.visible = false;
					break;
				case 4:
					//官方竞猜
					_startDaelerBtn.visible = false;
					_stopDealerBtn.visible = false;
					_kaijiangBtn.visible = false;
					break;
				default :
					_startDaelerBtn.visible = true;
					_stopDealerBtn.visible = false;
					_kaijiangBtn.visible = false;
			}
			resize();
			this.dispatchEvent(new Event("resizeThis"));
		}
		
		private function quizSelectChange(data:Object):void {
			if (!data) {
				return;
			}
			var temp:QuizData = data as QuizData;
			var userID:String = Context.getContext(ContextEnum.SETTING)["userID"];
			if (temp.type == 0) {
				//官方竞猜
				setState(4);
				return;
			}
			if (!_quizUser) {
//				Debugger.log(Debugger.INFO, "[quiz]权限显示部分，未登录");
				setState(3);
				return;
			}
			if (_quizUser.openAU) {
				if (_quizUser.role == QuizUserData.QUIZ_ADMIN) {
//					Debugger.log(Debugger.INFO, "[quiz]权限显示部分，管理员");
					setState(1);
				} else {
					if (temp.userID && userID && temp.userID == userID) {
//						Debugger.log(Debugger.INFO, "[quiz]权限显示部分，竞猜开启者");
						setState(1);
					} else {
						if (_quizUser.joinArr.indexOf(temp.id) != -1) {
//							Debugger.log(Debugger.INFO, "[quiz]权限显示部分，主播并且坐庄");
							setState(2);
						} else {
//							Debugger.log(Debugger.INFO, "[quiz]权限显示部分，主播并且未坐庄");
							setState(3);
						}
					}
				}
			} else {
				if (_quizUser.joinArr.indexOf(temp.id) != -1) {
//					Debugger.log(Debugger.INFO, "[quiz]权限显示部分，普通用户并且坐庄");
					setState(2);
				} else {
//					Debugger.log(Debugger.INFO, "[quiz]权限显示部分，普通用户");
					setState(3);
				}
			}
			
		}
		
//		override public function get width():Number {
//			//全部最大5个按钮都显示的宽度
//			return 276;
//		}
		
	}
}