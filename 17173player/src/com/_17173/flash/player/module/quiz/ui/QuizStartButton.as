package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class QuizStartButton extends Sprite implements IExtraUIItem
	{
		private var _btn:Button;
		
		public function QuizStartButton()
		{
			super();
			init();
		}
		
		private function init():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(QuizEvents.QUZI_PANEL_VISIBLE_CHANGE, panelVisible);
			_btn = new Button();
			_btn.setSkin(new mc_quizBtn());
			_btn.width = 48;
			_btn.height = 26;
			addChild(_btn);
			
			this.graphics.clear();
			this.graphics.beginFill(0 , 0);
			this.graphics.drawRect(0, 0, 58, 26);
			this.graphics.endFill();
			
			_btn.x = 10;
			_btn.y = 0;
			
			_btn.addEventListener(MouseEvent.CLICK, thisClickHandler);
//			this.addEventListener(MouseEvent.CLICK, thisClickHandler);
//			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		protected function mouseUp(event:MouseEvent):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_SHOW_START_QUIZ);
		}
		
		private function panelVisible(data:Object):void {
			if (_btn) {
				if ((data as String) == "show") {
					_btn.disabled = true;
				} else {
					_btn.disabled = false;
				}
//				_btn.disabled = (data as String) == "show";
			}
		}
		
		private function thisClickHandler(evt:MouseEvent):void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_SHOW_START_QUIZ);
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
		}
		
		public function set enable(value:Boolean):void {
			_btn.disabled = !value;
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_RIGHT;
		}
	}
	
}