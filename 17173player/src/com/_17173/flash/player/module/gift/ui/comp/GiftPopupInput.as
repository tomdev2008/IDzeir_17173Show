package com._17173.flash.player.module.gift.ui.comp
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 可输入的框,点击后会出现弹出列表
	 *  
	 * @author shunia-17173
	 */	
	public class GiftPopupInput extends Sprite
	{
		
		protected var _popupView:GiftPopupList = null;
		protected var _inputBG:MovieClip = null;
		protected var _input:TextField = null;
		
		public function GiftPopupInput()
		{
			super();
			
			_inputBG = new mc_userInputBG();
			addChild(_inputBG);
			_inputBG.width = actualWidth;
			
			var fmt:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			_input = new TextField();
			_input.defaultTextFormat = fmt;
			_input.width = actualTextWidth;
			addChild(_input);
			
			_input.addEventListener(MouseEvent.CLICK, onPopupView);
			addEventListener(MouseEvent.MOUSE_MOVE, onRefresh);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("onUIResize", onResize);
		}
		
		protected function onHide():void {
			if (_popupView && _popupView.parent) {
				_popupView.removeEventListener("itemSelected", onPopupSelected);
				_popupView.removeEventListener(MouseEvent.MOUSE_MOVE, onRefresh);
				_popupView.parent.removeChild(_popupView);
			}
		}
		
		protected function onRefresh(event:MouseEvent):void {
			Ticker.stop(onHide);
			
			Ticker.tick(3000, onHide, 1);
		}
		
		protected function onPopupView(event:MouseEvent):void {
			if (_popupView == null) {
				_popupView = initPopView();
			}
			if (!Context.stage.contains(_popupView)) {
				Context.stage.addChild(_popupView);
				_popupView.addEventListener(MouseEvent.MOUSE_MOVE, onRefresh);
			}
			
			_popupView.addEventListener("itemSelected", onPopupSelected);
			reposPopupView();
		}
		
		protected function onResize(data:Object = null):void {
			onHide();
		}
		
		private function reposPopupView():void {
			var pos:Point = localToGlobal(new Point((_input.width - _popupView.width) / 2 + _input.x, -_popupView.height));
			_popupView.x = pos.x;
			_popupView.y = pos.y;
		}
		
		protected function onPopupSelected(event:Event):void {
			onHide();
		}
		
		protected function initPopView():GiftPopupList {
			return null;
		}
		
		protected function get actualWidth():Number {
			return 100;
		}
		
		protected function get actualTextWidth():Number {
			return actualWidth;
		}
		
	}
}