package com._17173.flash.player.module.quiz
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;

	public class Quiz extends Sprite
	{
		private var _qm:QuizManager;
		private var _ui:QuizMainUI;
		private var _e:IEventManager;
		
		public function Quiz()
		{
			var ver:String = "1.0.41";
			Debugger.log(Debugger.INFO, "[quiz]", "竞猜模块[版本:" + ver + "]初始化!");
			init();
			addEventListeners();
			start();
		}
		
		private function init():void {
			_qm = new QuizManager();
			_ui = new QuizMainUI();
			_qm.ui = _ui;
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
		}
		
		private function addEventListeners():void {
			_e.listen(QuizEvents.QUIZ_GET_QUIZ_DATA_COMPLETE, getQuizDataComplete);
		}
		
		private function start():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_GET_QUIZ_DATA);
		}
		
		private function getQuizDataComplete(data:Object):void {
			var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_SECOND_EXTRA_BAR);
			streamBar.call("addItem", _ui);
		}
		
		override public function set visible(value:Boolean):void {
			if (_ui) {
				_ui.visible = value;
			}
		}
		
	}
}