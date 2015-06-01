package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.player.module.quiz.data.QuizData;
	
	import flash.display.Sprite;
	
	/**
	 * 站外竞猜底栏容器
	 *  
	 * @author 庆峰
	 */	
	public class OutQuizBottomPanel extends Sprite
	{
		
		/**
		 * 当前界面 
		 */		
		private var _current:OutQuizBottomPanelRender = null;
		/**
		 * 点击 
		 */		
		private var _mask:Sprite = null;
		
		public function OutQuizBottomPanel()
		{
			super();
			
			_mask = new Sprite();
			_mask.buttonMode = true;
			_mask.useHandCursor = true;
			addChild(_mask);
		}
		
		public function set data(value:QuizData):void {
			if (_current) {
				removeChild(_current);
			}
			_current = null;
			
			if (!value) return;
			if (value.type == 0) {
				_current = new OutQuizBottomPanelRenderGov(OutQuizBottomPanelRenderItemGov);
			} else {
				_current = new OutQuizBottomPanelRenderPer(OutQuizBottomPanelRenderItemPer);
			}
			_current.data = value;
			addChildAt(_current, 0);
		}
		
		/**
		 * 更新大小
		 *  
		 * @param w
		 * @param h
		 */		
		public function resize(w:int, h:int):void {
			if (_current) {
				_current.resize(w, h);
				//画个遮罩出来
				_mask.graphics.clear();
				_mask.graphics.beginFill(0, 0.1);
				_mask.graphics.drawRect(0, 0, w, h);
				_mask.graphics.endFill();
			}
		}
		
	}
}