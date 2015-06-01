package com._17173.flash.player.module.quiz.ui.out
{
	
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.IconButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 竞猜顶部栏按钮（按钮+分隔竖线）
	 * @author Kevin
	 */	
	public class OutQuizUITopBarBtn extends Sprite
	{
		private var _sourceData:MovieClip;
		private var _btn:Button;
		private var _label:String;
		
		public function OutQuizUITopBarBtn(icon:Boolean = false)
		{
			if (icon) {
				_btn = new IconButton(new mc_quiz_icon_guan(), "", true);
			} else {
				_btn = new Button("", true);
			}
			_label = _btn.label;
			_sourceData = new custom_buttonActive();
			_btn.setSkin(_sourceData);
			addChild(_btn);
		}
		
		public function set bgAlphe(value:Number):void {
			if (_sourceData) {
				_sourceData.alpha = value;
			}
		}
		
		public function set label(value:String):void {
			_btn.label = value;
			_label = value;
			//强制更新高度,避免被内部机制算出问题而撑开
			_btn.height = 22;
		}
		
		public function get label():String {
			return _label;
		}
		
		public function set selected(value:Boolean):void {
			_btn.selected = value;
		}

		/**
		 * 获取真实的btn
		 */
		public function get btn():Button
		{
			return _btn;
		}


	}
}