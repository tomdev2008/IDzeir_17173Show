package com._17173.flash.player.module.bullets
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.bullets.base.BulletData;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 弹幕在界面上的UI元素类.
	 *  
	 * @author shunia-17173
	 */	
	public class BulletUI extends Sprite implements IExtraUIItem
	{
		
		private var _switcher:DisplayObject = null;
		private var _fullScreenInput:Sprite = null;
		private var _startSendBtn:DisplayObject = null;
		private var _input:BulletInput = null;
		private var _setBtn:DisplayObject = null
		private var _isFullScreen:Boolean = false;
		private var _setUI:BulletSetUI;
		private var _manager:Bullets = null;
		private var _setUIWidth:int = 350;
		private var _setUIHeight:int = 290;
		private var _localInputState:Boolean = false;
		private var _mouseUse:Boolean = true;
		
		public function BulletUI(manager:Bullets)
		{
			super();
			
			_manager = manager;
			_switcher = new manager.skinObject.switcher();
			addChild(_switcher);
			_switcher["enable"] = _manager.isOn;
			
			_fullScreenInput = new Sprite();
			var fullScreenBG:DisplayObject = new manager.skinObject.bg();
			_fullScreenInput.addChild(fullScreenBG);
			fullScreenBG.width = 283;
			
			_startSendBtn = new manager.skinObject.sendBtn();
			_setBtn = new manager.skinObject.setBtn();
			_input = new BulletInput(manager.skinObject.input);
			_setUI = new BulletSetUI();
			addEvents();
			refresh(_isFullScreen);
		}
		
		private function addEvents():void {
			_input.addEventListener("sendBullet", onSendBullet);
			_switcher.addEventListener(MouseEvent.CLICK, onSwitch);
			_startSendBtn.addEventListener(MouseEvent.CLICK, onStartSend);
			_setBtn.addEventListener(MouseEvent.CLICK,onSetClick);
		}
		
		private function onSetClick(e:Event):void{
			var vis:Boolean = !_setUI.visible;
			refresh(_isFullScreen);
			_setUI.visible = vis;
		}
		
		protected function onSendBullet(event:Event):void {
			//没内容啥也不干
			if (Util.trimStr(_input.content) != "") {
				var bd:BulletData = new BulletData();
				bd.content = _input.content;
				bd.updateConfig();
				_manager.sendBullet(bd);
				_input.content = "";
			}
			if (!Context.getContext(ContextEnum.SETTING).isFullScreen) {
				_input.visible = false;
			}
			if(_setUI.visible){
				_setUI.visible = false;
			}
			_localInputState = _input.visible;
		}
		
		protected function onStartSend(event:Event):void {
			_input.visible = !_input.visible;
			_localInputState = _input.visible;
			if(_setUI.visible){
				_setUI.visible = false;
			}
		}
		
		protected function onSwitch(event:Event):void {
			//统计
			var action:String = _manager.isOn ? 
				RedirectDataAction.ACTION_CLICK_BULLET_OFF : 
				RedirectDataAction.ACTION_CLICK_BULLET_ON;
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.QM, StatTypeEnum.EVENT_CLICK, {"action":action});
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":action, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
			
			_manager.isOn = !_manager.isOn;
			_switcher["enable"] = _manager.isOn;
			refresh(_isFullScreen);
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
			_isFullScreen = isFullScreen;
			if (isFullScreen) {
				if (_manager.isOn) {
					addChild(_input);
					addChild(_setBtn);
					Context.stage.addChild(_setUI);
				} else if (_input.parent) {
					_input.parent.removeChild(_input);
					if(contains(_setBtn)){
						removeChild(_setBtn);
					}
					if(_setUI.parent){
						_setUI.parent.removeChild(_setUI);
					}
				}
				_input.visible = true;
				_setUI.visible = false;
				if (contains(_startSendBtn)) {
					removeChild(_startSendBtn);
				}
				_localInputState = false;
			} else {
				if (!_manager.isOn) {
					if (contains(_startSendBtn)) {
						removeChild(_startSendBtn);
					}
					if(contains(_setBtn)){
						removeChild(_setBtn);
					}
					if(_setUI.parent){
						_setUI.parent.removeChild(_setUI);
					}
					if(_input.parent){
						_input.parent.removeChild(_input);
						_localInputState = false;
					}
				} else {
					Context.stage.addChild(_input);
					addChild(_startSendBtn);
					addChild(_setBtn);
					Context.stage.addChild(_setUI);
					
				}
				_input.visible = _localInputState
				_setUI.visible = false;
			}
			_input.isFullScreen = _isFullScreen;
			resize();
		}
		
		public function resize():void
		{
			TweenLite.killTweensOf(_switcher);
			//为了更新计算用的大小,设置标记位
			var posX:Number = 0;
			var posDirty:Boolean = false;
			//功能开/关状态下不同排版
			if (_manager.isOn == false) {
				if (_switcher.x != -_switcher.width) {
					posX = -_switcher.width;
					posDirty = true;
				}
			} else {
				//全屏/非全屏状态下不同排版
				var bottomBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.BOTTOM_BAR);
				var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
				if (_isFullScreen) {
					_input.x = -_input.width - 5 -27;
					_setBtn.x = -int(_setBtn.width);
					_input.y = 0;
					_setUI.x = (streamBar.display.x + streamBar.display.width) - _setUI.width + _setBtn.width;
					_setUI.y = streamBar.display.y  -_setUI.height - 5;
					if (_switcher.x != _input.x - _switcher.width - 5 - _setBtn.width) {
						posX = (_input.x - _switcher.width);
						posDirty = true;
					}
				} else {
					_input.x = (Context.stage.stageWidth - _input.width) / 2;
					_input.y = Context.stage.stageHeight - 
						bottomBar.display.height - 
						_input.height - (28);
					_startSendBtn.x = -_startSendBtn.width - (canShowSetUI ? 26:0);
					_setBtn.x = -int(_setBtn.width) ;
					_setUI.x = Context.stage.stageWidth - _setUI.width - 5;
					_setUI.y = Context.stage.stageHeight -_setUI.height - bottomBar.display.height - 5;
//					_startSendBtn.y = (height - _startSendBtn.height) / 2;
					if (_switcher.x != -_switcher.width - 5 + _startSendBtn.x ) {
						posX = (-_switcher.width - 5 + _startSendBtn.x);
						posDirty = true;
					}
					if(!canShowSetUI && _setBtn.visible){
						posDirty = true;
						posX = (-_switcher.width - 5 + _startSendBtn.x );
					}
				}
			}
			if (posDirty) {
				posDirty = false;
				updateBtnPos(posX);
			}
		}
		
		override public function set x(value:Number):void{
			super.x = value + this.width;
		}
		private function updateBtnPos(px:Number):void {
			var prevIV:Boolean = _input.visible;
			_input.visible = false;
			_startSendBtn.visible = false;
			_setBtn.visible = false;
			mouseEnabled = mouseChildren = false;
			TweenLite.to(_switcher, 0.3, {"x":px, "onComplete":function():void {
				if (!_isFullScreen) {
					_startSendBtn.visible = true;
					_setBtn.visible = true;
					TweenLite.from(_setBtn, 0.1, {"alpha":0});
					TweenLite.from(_startSendBtn, 0.1, {"alpha":0});
					_setBtn.visible = canShowSetUI;
				}
				if (prevIV) {
					_input.visible = true;
					_setBtn.visible = true;
					TweenLite.from(_input, 0.3, {"alpha":0, "onComplete":function ():void {
						mouseEnabled = mouseChildren = _mouseUse ? true : _mouseUse;
					}});
					TweenLite.from(_setBtn, 0.3, {"alpha":0, "onComplete":function ():void {
						mouseEnabled = mouseChildren = _mouseUse ? true : _mouseUse;
					}});
				} else {
					mouseEnabled = mouseChildren = _mouseUse ? true : _mouseUse;
				}
				
				dispatchEvent(new Event("updated"));
			}});
		}
		
		public function get side():Boolean {
			return ExtraUIItemEnum.SIDE_RIGHT;
		}
		
		/**
		 *检测是否可以显示弹幕设置版 
		 * @return 
		 * 
		 */		
		private function get canShowSetUI():Boolean {
			var result:Boolean = true;
			var ui:Object = Context.getContext(ContextEnum.UI_MANAGER);
			if (ui.avalibleVideoHeight < _setUIHeight) {
				result = false;
			}
			if (ui.avalibleVideoWidth < _setUIWidth) {
				result = false;
			}
			return result;
		}
		
		/**
		 * 组件的mouseEnable和mousechilid的更高级
		 * 由于本组件自己本身会对两个鼠标状态赋值,因此外部使用次变量操控
		 */		
		public function get mouseUse():Boolean {
			return _mouseUse;
		}
		public function set mouseUse(value:Boolean):void {
			_mouseUse = value;
		}
		
	}
}