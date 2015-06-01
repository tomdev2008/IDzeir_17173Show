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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class QuizUITopBar extends Sprite
	{
		private var _addQuiz:QuizUITopBarBtn;
		private var _quizRight:QuizUITopBarRight;
		private var _quizData:Array;
		private var _left:Sprite;
		private var _currentIndex:int = 1;
		private var _rightBg:Shape;
		private var _btnArr:Array;
		private var _userQuziNum:int;
		private var _mask:Shape;
		private var _leftBtn:Button;
		private var _rightBtn:Button;
		private var _btnWidth:int = 161;
		private var _btnNum:int = 3;
		private var _quizRightWidth:int = 276;
		private var _currentSelectData:QuizData;
		
		public function QuizUITopBar()
		{
			super();
			init();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		public function set quizData(value:Array):void {
			_quizData = [];
			_userQuziNum = 0;
			
			
//			var temp:Array = new Array();
//			for (var i:int = 0; i < 6; i++) {
//				temp.push(value[0]);
//			}
//			_quizData = temp;
			
			
			
			_quizData = value;
			addBtn();
			resize();
			_currentIndex = getCurrentIndex();
			resetCurrentSelect();
		}
		
		/**
		 * 获取当前所选中的竞猜
		 * 如果之前有被选中的，选之前的，如果之前选中的大于现有竞猜数量的使用第一个
		 */		
		private function getCurrentIndex():int {
			var re:int = 1;
			if (_currentIndex > 1) {
				if (_currentIndex > _quizData.length) {
					re = 1;
				} else {
					if (_currentSelectData.id == (_quizData[_currentIndex - 1] as QuizData).id) {
						re = _currentIndex;
					} else {
						re = 1;
					}
				}
			} else {
				re = 1;
			}
			return re;
		}
		
		private function addBtn():void {
			if (_left.numChildren > 0) {
				_left.removeChildren(0, _left.numChildren - 1);
			}
			if (_btnArr.length > 0 ) {
				for (var j:int = 0; j < _btnArr.length; j++) {
					_btnArr[j] = null;
				}
				_btnArr = [];
			}
			
			for (var i:int; i < _quizData.length; i++) {
				var btn:QuizUITopBarBtn;
				if ((_quizData[i] as QuizData).type == 0) {
					btn = new QuizUITopBarBtn(true);
				} else {
					btn = new QuizUITopBarBtn();
				}
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
				if ((_quizData[i] as QuizData).type == 0) {
					btn.label = formatString((_quizData[i] as QuizData).title);
				} else {
					btn.label = formatString((_quizData[i] as QuizData).title, 10);
				}
				btn.order = i + 1;
				btn.width = 160;
				if ((_quizData[i] as QuizData).type == 1) {
					if (_userQuziNum < 3) {
						_left.addChild(btn);
						_btnArr.push(btn);
						_userQuziNum ++;
					}
				} else {
					_left.addChild(btn);
					_btnArr.push(btn);
				}
				
//				if (_userQuziNum < 3 && (_quizData[i] as QuizData).type == 1) {
//					_userQuziNum ++;
//				}
			}
			if (getAddBtnVisible() && _userQuziNum < 3) {
				_btnArr.push(_addQuiz);
				_left.addChild(_addQuiz);
			}
			setMoveBtnVisible();
		}
		
		private function formatString(value:String, num:int = 8):String {
			while (Util.checkStrLength(value) > num * 2) {
				value = value.slice(0, value.length - 1);
			}
			return value;
//			if (value.length > num) {
//				return value.substr(0,num);
//			} else {
//				return value;
//			}
		}
		
		protected function btnClickHandler(evt:MouseEvent):void
		{
			_currentIndex = (evt.currentTarget as QuizUITopBarBtn).order;
			resetCurrentSelect();
		}
		
		private function init():void {
			_quizData = [];
			_btnArr = [];
			_userQuziNum = 0;
			_left = new Sprite();
			
			_addQuiz = new QuizUITopBarBtn();
			_addQuiz.label = "+添加竞猜";
			_addQuiz.width = 160;
			_addQuiz.order = 1000;
			_addQuiz.addEventListener(MouseEvent.CLICK, addQuiz);
			
			_quizRight = new QuizUITopBarRight();
			_quizRight.addEventListener("resizeThis", resize);
			
			initBtnNum(Context.stage.stageWidth);
			
			_rightBg = new Shape();
			
			addChild(_left);
			
			_mask = new Shape();
			initMask();
			addChild(_mask);
			_left.mask = _mask;
			
			addChild(_rightBg);
			
			addChild(_quizRight);
			
			initLeft();
			initRight();
		}
		
		private function initMask():void {
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff00ff, 0);
			_mask.graphics.drawRect(0, 0, _btnWidth * _btnNum, QuizMainUI.TOP_BAR_HEIGHT);
			_mask.graphics.endFill();
		}
		
		private function initBtnNum(value:Number):void {
			_btnNum = int((value - _quizRightWidth) / _btnWidth);
			if (_btnNum < 3) {
				_btnNum = 3;
			}
		}
		
		private function initLeft():void {
			_leftBtn = new Button();
			_leftBtn.setSkin(new mc_quiz_turnLeft());
			_leftBtn.addEventListener(MouseEvent.CLICK, leftBtnClick);
			addChild(_leftBtn);
		}
		
		private function initRight():void {
			_rightBtn = new Button();
			_rightBtn.setSkin(new mc_quiz_turnRight());
			_rightBtn.addEventListener(MouseEvent.CLICK, rightBtnClick);
			addChild(_rightBtn);
			_rightBtn.x = _btnWidth * _btnNum - _rightBtn.width - 1;
		}
		
		protected function leftBtnClick(event:MouseEvent):void
		{
			if ((_left.x + _btnWidth) <= 0) {
				_left.x = _left.x + _btnWidth;
			}
			setMoveBtnVisible();
		}
		
		protected function rightBtnClick(event:MouseEvent):void
		{
			if ((_left.x - _btnWidth) >= -(_btnWidth * (_left.numChildren - _btnNum))) {
				_left.x = _left.x - _btnWidth;
			}
			setMoveBtnVisible();
		}
		
		private function setMoveBtnVisible():void {
			if (_left.x < 0) {
				_leftBtn.visible = true;
			} else {
				_leftBtn.visible = false;
			}
			if (_left.x > -(_btnWidth * (_left.numChildren - _btnNum))) {
				_rightBtn.visible = true;
			} else {
				_rightBtn.visible = false;
			}
		}
		
		private function getSpace():Shape {
			var re:Shape = new Shape();
			re.graphics.clear();
			re.graphics.beginFill(0x303030);
			re.graphics.drawRect(0, 0, 1, QuizMainUI.TOP_BAR_HEIGHT);
			re.graphics.endFill();
			return re;
		}
		
		private function setButtonSource(value:QuizUITopBarBtn):void {
			value.width = 150;
			value.height = QuizMainUI.TOP_BAR_HEIGHT;
		}
		
		private function getAddBtnVisible():Boolean {
			var re:Boolean = false;
			var quizUser:QuizUserData = Context.variables["quizUser"];
			if (!quizUser) {
				re = false;
			} else {
				if (!quizUser.openAU) {
					re = false;
				} else {
					if (quizUser.openAU) {
						re = true;
					}
				}
			}
			return re;
		}
		
		/**
		 * 根据权限判断是否显示增加按钮
		 */		
		private function resetAddQuizBtnState():void {
			var quizUser:QuizUserData = Context.variables["quizUser"];
			if (!quizUser) {
				_addQuiz.visible = false;
			} else {
				if (!quizUser.openAU) {
					_addQuiz.visible = false;
					return;
				} else {
					if (quizUser.openAU) {
						_addQuiz.visible = true;
					}
				}
			}
		}
		
		private function drawBG(w:Number, alpha:Number = 1):void {
			graphics.clear();
			graphics.beginFill(0x414141, alpha);
			graphics.drawRect(0, 0, w, QuizMainUI.TOP_BAR_HEIGHT);
			graphics.endFill();
		}
		
		/**
		 * 添加竞猜
		 */		
		private function addQuiz(evt:MouseEvent):void {
			this.dispatchEvent(new Event(QuizEvents.QUIZ_ADD_QUIZ, true));
		}
		
		private function resetCurrentSelect():void {
			for (var i:int = 0; i < _left.numChildren; i++) {
				if ((_left.getChildAt(i) as QuizUITopBarBtn).order == _currentIndex) {
					(_left.getChildAt(i) as QuizUITopBarBtn).selected = true;
				} else {
					(_left.getChildAt(i) as QuizUITopBarBtn).selected = false;
				}
			}
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, currentSelectData);
			resize();//topBarRight的宽度会因为当前选中的不同竞猜而改变，因此需要每次重新计算下位置
		}
		
		private function setBtnAlphe(value:Number):void {
			for (var i:int = 0; i < _btnArr.length; i++) {
				(_btnArr[i] as QuizUITopBarBtn).alpha = value;
			}
		}
		
		public function resize(evt:Event = null):void {
			var w:Number = 0;
			var isFull:Boolean = Context.getContext(ContextEnum.SETTING)["isFullScreen"];
			if (isFull) {
				setBtnAlphe(0.8);
				_rightBg.alpha = 0.8;
				w = 760;
			} else {
				setBtnAlphe(1);
				_rightBg.alpha = 1;
				w = Context.stage.stageWidth;
			}
			initBtnNum(w);
			initMask();
			_rightBtn.x = _btnWidth * _btnNum - _rightBtn.width - 1;
			var visibleNum:int = 0;
			drawBG(w, isFull ? 0 : 1);
			if (_left && _left.numChildren > 0) {
				var child:DisplayObject = null;
				var tmp:Number = 0;
				for (var i:int = 0; i < _left.numChildren; i++) {
					child = null;
					child = _left.getChildAt(i);
					if (child.visible) {
						visibleNum++;
						child.x = tmp;
						child.y = Math.ceil((QuizMainUI.TOP_BAR_HEIGHT - child.height) / 2);
						tmp += child.width;
					}
				}
//				_left.x = 0;
			}
			resizeLeftX();
			//这里要使用quizRight的真实宽度
			var tempW:Number = isFull ? _quizRight.width : 0;
			//_btnNum：显示区域可以显示的数量     visibleNum：显示区域里面实际放了多少
			var tempNum:int = visibleNum < _btnNum ? visibleNum : _btnNum;
			_rightBg.graphics.clear();
			_rightBg.graphics.beginFill(0x414141);
			_rightBg.graphics.drawRect(0, 0, (w - tempNum * _btnWidth - tempW), QuizMainUI.TOP_BAR_HEIGHT);
			_rightBg.graphics.endFill();
//			trace(w - _btnNum * _btnWidth - tempW);
			
			if (_rightBg) {
				_rightBg.x = tempNum * _btnWidth;
				_rightBg.y = 0;
			}
			
			if (_quizRight) {
				_quizRight.x = w - _quizRight.width;
				_quizRight.y = 0;
			}
		}
		
		/**
		 * 重置当前按钮容器的坐标
		 * 原理是如果当前选中的按钮在非可视区域内，那么就将他移到可视区域即可（移动之后可能为左数第一个或者右数第一个）
		 */		
		private function resizeLeftX():void {
			var offsetNum:int = _left.x < 0 ? (-_left.x / _btnWidth) : 0;
			if (_currentIndex <= offsetNum) {
				_left.x += _btnWidth * (offsetNum - _currentIndex  + 1);
			} else {
				if (_currentIndex > (offsetNum + _btnNum)) {
					_left.x -= _btnWidth * (_currentIndex - (offsetNum + _btnNum));
				}
			}
			setMoveBtnVisible();
		}
		
//		private function getOtherWidth():Number {
//		}
		
		public function get currentSelectData():Object {
			_currentSelectData = _quizData[_currentIndex - 1];
			return _quizData[_currentIndex - 1];
		}
		
		override public function get height():Number {
			return QuizMainUI.TOP_BAR_HEIGHT;
		}
	}
}