package com._17173.flash.player.ui.comps.progressbar
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BaseProgressBar extends Sprite
	{
		protected var _bg:Sprite;
		protected var _trackBar:Sprite;
		protected var _proBar:Sprite;
		protected var _loadBar:Sprite;
		protected var _btn:MovieClip;
		protected var _leftBtn:DisplayObject;
		protected var _rightBtn:DisplayObject;
		
		protected var _currentHeight:Number = 10;
		protected var _mouseOn:Boolean;
		//标识进度的小圆点是否是使用graphics画出来的，因为画出来的圆点是以圆心为圆点
		private var _btnIsGraphics:Boolean;
		protected var _mouseDragFlag:Boolean;
		private var _mouseStartX:Number;
		//通知当前进度改变事件（拖拽、直接点击）
		private var _progressChangeEvent:Event;
		//通知当前鼠标位置
		private var _mousePositionEvent:Event;
		
		protected var _proValue:Number = 0;
		private var _loadValue:Number = 0;
		private var _thisStage:DisplayObject;
		private var _currentMousePosition:Number;
		
		public function BaseProgressBar(stage:DisplayObject = null, defaultHeight:Number = 10)
		{
			super();
			
			if (stage) {
				thisStage = stage;
			}
			
			if (defaultHeight) {
				_currentHeight = defaultHeight;
			}
			
			init();
			addChildren();
			addChildrenLisn();
		}
		
		protected function init():void {
			this.addEventListener(MouseEvent.ROLL_OVER, thisMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, thisMouseOut);
			this.addEventListener(MouseEvent.MOUSE_UP, thisMouseUp);
			
			if (thisStage) {
				thisStage.addEventListener(MouseEvent.MOUSE_UP, thisStageMouseUp);
				thisStage.addEventListener(MouseEvent.MOUSE_MOVE, thisMouseMove);
			} else {
				this.addEventListener(MouseEvent.MOUSE_MOVE, thisMouseMove);
			}
		}
		
		private function addChildren():void {
			addBG();
			addTrackBar();
			addLoadBar();
			addProBar();
			addBtn();
			addLeftBtn();
			addRightBtn();
		}
		
		/**
		 * 给子组件添加监听事件
		 */		
		private function addChildrenLisn():void {
			if (_trackBar) {
				_trackBar.addEventListener(MouseEvent.MOUSE_MOVE, trackBarMouseMove);
				_trackBar.addEventListener(MouseEvent.MOUSE_UP, trackBarMouseUp);
				_trackBar.addEventListener(MouseEvent.ROLL_OUT, trackBarMouseOut);
			}
			
			if (_btn) {
				_btn.addEventListener(MouseEvent.MOUSE_MOVE, btnMouseMove);
				_btn.addEventListener(MouseEvent.MOUSE_DOWN, btnMouseDown);
			}
			
			if (_leftBtn) {
				_leftBtn.addEventListener(MouseEvent.ROLL_OVER, leftMouseRollOver);
				_leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, leftMouseClick);
			}
			
			if (_rightBtn) {
				_rightBtn.addEventListener(MouseEvent.ROLL_OVER, rightMouseRollOver);
				_rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, rightMouseClick);
			}
		}
		
		private function addBG():void {
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(bgColor, 1);
			_bg.graphics.drawRect(0, 0, thisStage.stage.stageWidth, currentHeight);
			_bg.graphics.endFill();
			addChild(_bg);
		}
		
		/**
		 * 添加背景条
		 */		
		private function addTrackBar():void {
			_trackBar = new Sprite();
			_trackBar.buttonMode = true;
			_trackBar.useHandCursor = true;
			_trackBar.x = 0;
			_trackBar.y = 0;
			_bg.addChild(_trackBar);
		}
		/**
		 * 添加播放进度条
		 */		
		private function addProBar():void {
			_proBar = new Sprite();
			_trackBar.addChild(_proBar);
		}
		/**
		 * 添加缓存进度条
		 */		
		private function addLoadBar():void {
			_loadBar = new Sprite();
			_trackBar.addChild(_loadBar);
		}
		/**
		 * 添加滑块
		 */		
		private function addBtn():void {
			_btn = btn;
			addChild(_btn);
		}
		/**
		 * 添加右移按钮
		 */		
		private function addRightBtn():void
		{
			_rightBtn = rightBtn;
			_rightBtn.visible = false;
			addChild(_rightBtn);
		}
		/**
		 * 添加左移按钮
		 */		
		private function addLeftBtn():void
		{
			_leftBtn = leftBtn;
			_leftBtn.visible = false;
			addChild(_leftBtn);
		}
		
		protected function get btn():MovieClip {
			_btnIsGraphics = true;
			var temp:MovieClip = new MovieClip();
			temp.graphics.beginFill(0xd83727, 0.5);
			temp.graphics.drawCircle(0, 0, 10);
			temp.graphics.endFill();
			temp.buttonMode = true;
			temp.useHandCursor = true;
			return temp;
//			return new mc_ad_close();
		}
		
		protected function get leftBtn():DisplayObject {
			return new MovieClip();
		}
		
		protected function get rightBtn():DisplayObject {
			return new MovieClip();
		}
		
		public function resize():void {
			resizeTrackBar();
			resizeProBar();
			resizeLoadBar();
			resizeLeftAndRight();
			resetY();
		}
		
		protected function moveBtn():void {
			var temp:Number = proValue * getBgWidth();
			var graphicsOffset:Number = 0;//按钮是否是画出来的偏移量，与BtnGraphicsOffset相反不能混用
			if (_btnIsGraphics) {
				graphicsOffset = 0;
			} else {
				graphicsOffset = _btn.width / 2;
			}
			var targatePosition:Number = temp - graphicsOffset + (_leftBtn.visible ? _leftBtn.width : 0) + (_mouseOn ? btnOffset : 0);
			if (targatePosition < (_trackBar.x + _btn.width / 2 - graphicsOffset)) {
				_btn.x = _trackBar.x + _btn.width / 2 - graphicsOffset;
			} else if (targatePosition > (_trackBar.x + getBgWidth() - _btn.width / 2 - graphicsOffset)) {
				_btn.x = _trackBar.x + _trackBar.width - _btn.width / 2 - graphicsOffset;
			} else {
				_btn.x = targatePosition;
			}
		}
		/**
		 * 绘制背景
		 */		
		private function resizeTrackBar():void
		{
			_trackBar.graphics.clear();
			_trackBar.graphics.beginFill(trackColor, 1);
			_trackBar.graphics.drawRect(0, 0, getBgWidth(), currentHeight);
			_trackBar.graphics.endFill();
			if (_mouseOn)
			{
				_trackBar.x = _leftBtn.width +　btnOffset;
			}
			else
			{
				_trackBar.x = 0;
			}
		}
		/**
		 * 绘制加载条
		 */		
		private function resizeLoadBar():void
		{
			_loadBar.graphics.clear();
			_loadBar.graphics.beginFill(loadBarColor);
			_loadBar.graphics.drawRect(0, 0, loadWidth, currentHeight);
			_loadBar.graphics.endFill();
		}
		/**
		 * 绘制当前播放进度
		 */		
		private function resizeProBar():void
		{
			_proBar.graphics.clear();
			_proBar.graphics.beginFill(proBarColor);
			_proBar.graphics.drawRect(0, 0, proWidth, currentHeight);
			_proBar.graphics.endFill();
		}
		private function resizeLeftAndRight():void {
			if (!_mouseOn) {
				_leftBtn.visible = false;
				_rightBtn.visible = false;
				return;
			}
			if (_leftBtn && this.contains(_leftBtn)) {
				_leftBtn.visible = true;
				_leftBtn.x = 0;
			}
			if (_rightBtn && this.contains(_rightBtn)) {
				_rightBtn.visible = true;
				_rightBtn.x = thisStage.stage.stageWidth - _rightBtn.width;
			}
		}
		/**
		 * 重新计算滑块和背景的坐标
		 */		
		private function resetY():void {
			if (_btn.height > currentHeight) {
				if (_btnIsGraphics) {
					_btn.y = _btn.height / 2;
				} else {
					_btn.y = 0;
				}
				_bg.y = (_btn.height - currentHeight) / 2;
				if (_leftBtn) {
					_leftBtn.y = _bg.y + (_bg.height - _leftBtn.height) / 2;
				}
				if (_rightBtn) {
					_rightBtn.y = _bg.y + (_bg.height - _rightBtn.height) / 2;
				}
			} else {
				if (_btnIsGraphics) {
					_btn.y = (currentHeight - _btn.height) / 2 + _btn.height / 2;
				} else {
					_btn.y = (currentHeight - _btn.height) / 2;
				}
			}
		}
		
		/**
		 * 设置当前的状态，主要用在鼠标移入和移出
		 * 为了能给外部调用，所以提成方法
		 */		
		public function setProgressBarState(value:Boolean):void {
			if (value) {
				_mouseOn = true;
				currentHeight = 15;
//				y = y - 2.5;
			} else {
				_mouseOn = false;
				currentHeight = 10;
//				y = y + 2.5;
			}
			resize();
			moveBtn();
		}
		
		public function dispatchProgressChange():void {
			if (!_progressChangeEvent) {
				_progressChangeEvent = new Event("progressChangeEvent");
			}
			this.dispatchEvent(_progressChangeEvent);
		}
		
		public function dispatchMousePositionChange():void {
			if (!_mousePositionEvent) {
				_mousePositionEvent = new Event("mousePositionEvent");
			}
			this.dispatchEvent(_mousePositionEvent);
		}
		
		
		
		////////////////////////////////////////////////
		//
		//    根据属性计算数据
		//
		////////////////////////////////////////////////
		/**
		 * 获取当前背景条可用的宽度
		 */		
		private function getBgWidth():Number {
			return maxWidth - barOffset;
		}
		
		/**
		 * 根据鼠标状态判断整个条的非背景宽度
		 * 包括，左右快进箭头、箭头和背景条中间的间隔
		 */		
		private function get barOffset():Number {
			var offset:Number = 0;
			if (_mouseOn) {
				if (_leftBtn && this.contains(_leftBtn)) {
					offset += _leftBtn.width + btnOffset;
				}
				
				if (_rightBtn && this.contains(_rightBtn)) {
					offset += _rightBtn.width + btnOffset;
				}
			}
			return offset;
		}
		
		/**
		 * 当前加载的宽度
		 * 当前load的百分比*当前的宽度
		 */		
		private function get loadWidth():Number {
			var temp:Number = loadValue * getBgWidth();
			if (temp > getBgWidth()) {
				temp = getBgWidth();
			}
			return temp;
		}
		
		private function get proWidth():Number {
			var temp:Number = proValue * getBgWidth();
			//进度条不能在btn在0的位置时候画出来，由于是圆形，左边角会显示出来
			//所以当显示宽度小于按钮宽度一半时候就不画
			if (_btn && _btn.visible && (temp < _btn.width / 2)) {
				temp = 0;
			}
			//进度条不能在btn在最大的位置时候画出来，由于是圆形，右边角会显示出来
			//右边减掉按钮一半宽度像素
			if (_btn && _btn.visible && (temp >= (getBgWidth() - _btn.width / 2))) {
				temp = getBgWidth() - _btn.width / 2;
			}
			return temp;
		}
		
		private function get BtnGraphicsOffset():Number {
			var re:Number = 0;
			if (_btnIsGraphics) {
				re = _btn.width / 2
			}
			return re;
		}
		
		
		///////////////////////////////////////////////////
		//
		//      事件
		//
		//////////////////////////////////////////////////
		protected function thisMouseOver(event:MouseEvent):void
		{
//			setProgressBarState(true);
		}
		
		protected function thisMouseOut(event:MouseEvent):void
		{
//			setProgressBarState(false);
		}
		
		protected function trackBarMouseMove(event:MouseEvent):void
		{
			changeMousePosition(event.localX);
		}
		
		protected function btnMouseMove(event:MouseEvent):void
		{
			changeMousePosition(event.localX + (_btn.x - _trackBar.x));
		}
		
		protected function changeMousePosition(value:Number):void {
			currentMousePosition = value / _trackBar.width;
			dispatchMousePositionChange();
		}
		
		protected function btnMouseDown(event:MouseEvent):void
		{
			_mouseDragFlag = true;
			_mouseStartX = this.mouseX;
		}
		
		protected function thisStageMouseUp(event:Event):void
		{
			if (_mouseDragFlag) {
				dispatchProgressChange();
			}
			_mouseDragFlag = false;
		}
		
		protected function thisMouseUp(event:Event):void
		{
			dispatchProgressChange();
		}
		
		protected function thisMouseMove(event:MouseEvent):void
		{
			if(!_mouseDragFlag)
			{
				return;
			}
			_btn.x = this.mouseX - _mouseStartX + BtnGraphicsOffset + barOffset / 2;
			if (_btn.x < (_trackBar.x + BtnGraphicsOffset)) {
				_btn.x = _trackBar.x + BtnGraphicsOffset;
			} else if (_btn.x > (_trackBar.x + _trackBar.width - btn.width + BtnGraphicsOffset)) {
				_btn.x = _trackBar.x + _trackBar.width - btn.width + BtnGraphicsOffset;
			}
			resetCurrentPro();
		}
		
		protected function resetCurrentPro():void {
			if (this.mouseX < _trackBar.x) {
				proValue = 0;
			} else if (this.mouseX > (_trackBar.x + _trackBar.width)) {
				proValue = 1;
			} else {
				proValue = (this.mouseX - _trackBar.x) / _trackBar.width;
			}
		}
		
		protected function trackBarMouseUp(event:MouseEvent):void
		{
			proValue = event.localX / _trackBar.width;
			dispatchProgressChange();
		}
		
		protected function trackBarMouseOut(event:MouseEvent):void
		{
		}
		
		protected function rightMouseClick(event:Event):void
		{
		}
		
		protected function rightMouseRollOver(event:Event):void
		{
		}
		
		protected function leftMouseClick(event:Event):void
		{
		}
		
		protected function leftMouseRollOver(event:Event):void
		{
		}
		
		
		///////////////////////////////////////////////////
		//
		//      属性
		//
		//////////////////////////////////////////////////
		/**
		 * 左右键箭头跟背景条之间的间距
		 */		
		protected function get btnOffset():Number {
			return 0;
		}
		
		/**
		 * 当前组件最大可用宽度
		 */		
		protected function get maxWidth():Number {
			return thisStage.stage.stageWidth;
		}
		
		protected function get trackColor():uint {
			return 0x474747;
		}
		
		protected function get bgColor():uint {
			return 0x000000;
		}
		
		protected function get loadBarColor():uint {
			return 0x757575;
		}
		
		protected function get proBarColor():uint {
			return 0xFCCD01;
		}
		
		protected function get barHeight():Number {
			return 5;
		}
		/**
		 * 当前播放的百分比
		 */
		public function get proValue():Number
		{
			return _proValue;
		}

		public function set proValue(value:Number):void
		{
			_proValue = value;
			moveBtn();
			resize();
		}
		/**
		 * 当前加载的百分比
		 */
		public function get loadValue():Number
		{
			return _loadValue;
		}

		public function set loadValue(value:Number):void
		{
			_loadValue = value;
			resize();
		}

		public function get thisStage():DisplayObject
		{
			return _thisStage;
		}

		public function set thisStage(value:DisplayObject):void
		{
			_thisStage = value;
		}
		/**
		 * 获取当前的鼠标位置的百分比
		 */
		public function get currentMousePosition():Number
		{
			return _currentMousePosition;
		}

		public function set currentMousePosition(value:Number):void
		{
			_currentMousePosition = value;
		}

		public function get currentHeight():Number
		{
			return _currentHeight;
		}

		public function set currentHeight(value:Number):void
		{
			_currentHeight = value;
		}

		
	}
}