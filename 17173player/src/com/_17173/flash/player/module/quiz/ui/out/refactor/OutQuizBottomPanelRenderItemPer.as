package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.text.TextFormat;

	public class OutQuizBottomPanelRenderItemPer extends OutQuizBottomPanelRenderItem
	{
		
		private static const LEFT:uint = 0xEE375D;
		private static const RIGHT:uint = 0x1E89CF;
		
		private var _btn:Button = null;
		/**
		 * 左右,true为右 
		 */		
		private var _right:Boolean = false;
		
		public function OutQuizBottomPanelRenderItemPer(side:Boolean) {
			_right = side;
			super();
			
			_btn = new Button();
			_btn.setSkin(side ? new customGuess_rightVote : new customGuess_leftVote);
			addChild(_btn);
		}
		
		override protected function initBar():OutQuizBar {
			return _right ? 
			new OutQuizBar(0xABABAB, RIGHT, true) : super.initBar();
		}
		
		override protected function initNameTextFormat():TextFormat {
			var fmt:TextFormat = super.initNameTextFormat();
			fmt.color = _right ? RIGHT : LEFT;
			return fmt;
		}
		
		override protected function initMoneyTextFormat():TextFormat {
			var fmt:TextFormat = super.initNameTextFormat();
			fmt.color = _right ? RIGHT : LEFT;
			return fmt;
		}
		
		override protected function initRateTextFormat():TextFormat {
			var fmt:TextFormat = super.initRateTextFormat();
			fmt.size = 10;
			fmt.color = 0x999999;
			return fmt;
		}
		
		override protected function updateData():void {
			if (_d) {
				_name.text = _d.title.substr(0,6);
				var s:String = String(_d.betcount).substr(0,6);
				s += _d.currency == "5" ? "银币" : "金币";
				_money.text = s;
				_barPer = _d.premium ? _d.betcount / _d.premium*Number(_d.odds) : 1;
				if (_d.odds == "0")
				{
					_rate.text = "0:0";
				}
				else
				{
					_rate.text = "1:" + getFormatRate(_d.odds);
				}
			}
		}
		
		private function getFormatRate(re:String):String
		{
			if (re == "0") return re;
				var s:String = re.substr(0,3);
				//如果不是小数就不删除
				if (s.indexOf(".")==-1) return s;
				while (true) {
					var temp:String = s.slice(s.length - 1, s.length);
					if (temp == "0" || temp == ".") {
						s = s.slice(0, s.length - 1);
					} else {
						break;
					}
				}
				return s;
		}
		
		override protected function calcBar():void {
			_barWidth = _w - 70;
		}
		
		override protected function layoutItems():void {
			if (_right) {
				_rate.x = _bar.width;
				_btn.x = _rate.x + 30 - 1;
				_bar.y = _name.height + 1;
				_money.x = _bar.width - _money.width;
				_rate.y = height - _rate.height;
				_btn.y = height - _btn.height;
			} else {
				_rate.x = _btn.x + _btn.width - 1;
				_money.x = _rate.x + 30 + 1;
				_bar.x = _money.x;
				_name.x = _w - _name.width;
				_bar.y = _money.height + 1;
				_btn.y = height - _btn.height;
				_rate.y = height - _rate.height;
			}
		}
		
	}
}