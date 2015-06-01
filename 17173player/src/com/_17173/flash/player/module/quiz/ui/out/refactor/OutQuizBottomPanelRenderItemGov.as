package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 官方竞猜底栏的条
	 *  
	 * @author 庆峰
	 */	
	public class OutQuizBottomPanelRenderItemGov extends OutQuizBottomPanelRenderItem
	{
		
		private static const H_GAP:int = 5;
		private static const V_GAP:int = 1;
		
		public function OutQuizBottomPanelRenderItemGov()
		{
			super();
		}
		
		override protected function initRateTextFormat():TextFormat {
			var fmt:TextFormat = super.initRateTextFormat();
			fmt.align = TextFormatAlign.LEFT;
			fmt.color = 0x999999;
			return fmt;
		}
		
		override protected function updateData():void {
			if (_d) {
				_name.text = _d.title.substr(0, 8);
				var s:String = String(_d.betcount).substr(0,6);
				s += _d.currency == "5" ? "银币" : "金币";
				_money.text = s;
				_barPer = _d.total ? _d.betcount / _d.total : 0;
				if (_d.odds == "0")
				{
					_rate.text = "0:0";
				}
				else
				{
					_rate.text = "1:" + getFormatRate(_d.odds);
				}
//				_rate.text = "赔率 1:" + getFormatRate(_d.odds);//.substr(0, 5);
			}
		}
		
		private function getFormatRate(re:String):String
		{
			if (re == "0") return re;
			var s:String = re.substr(0,5);
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
			_barWidth = _w - 270;
		}
		
		override protected function layoutItems():void {
			_name.x = (100 - _name.width) / 2;
			_bar.x = 100 + H_GAP;
			_bar.y = (height - _bar.height) / 2 + 1;
			var moneyBase:Number = _bar.x + _bar.width + H_GAP;
			_money.x = moneyBase + (80 - _money.width);
			_rate.x = moneyBase + 80 + H_GAP;
		}
		
	}
}