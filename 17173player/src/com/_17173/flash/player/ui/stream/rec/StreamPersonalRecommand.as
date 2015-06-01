package com._17173.flash.player.ui.stream.rec
{
	
	/**
	 * 直播个人推荐页.
	 * 通过属性isBack设置前推或者后推.
	 * 两者界面一致. 
	 * @author shunia-17173
	 */	
	public class StreamPersonalRecommand extends BaseGridStreamRecommand
	{
		
		private static const TIP_FORE:String = "SORRY，主播来迟了，去别的直播间转转吧！";
		private static const TIP_BACK:String = "SORRY，主播休息了，去别的直播间转转吧！";
		
		public function StreamPersonalRecommand()
		{
			super();
			
			_grid.maxColumn = 4;
			_grid.maxRow = 3;
			_grid.itemHeight = 130;
			_grid.itemWidth = 160;
			_grid.horizontalGap = 25;
			_grid.verticalGap = 10;
			_grid.rendererClass = StreamPersonalRecItem;
		}
		
		override protected function get backText():String {
			return TIP_BACK;
		}
		
		override protected function get foreText():String {
			return TIP_FORE;
		}
		
		override public function resize():void {
			super.resize();
			
			var gap:int = avalibleHeight - _tf.height - _grid.height;
			gap = gap > 15 ? 15 : gap;
			if (gap > 0) {
				_tf.y = (avalibleHeight - _tf.height - gap - _grid.height) / 2;
				_grid.y = _tf.y + _tf.height + gap;
			} else {
				_tf.y = 0;
				_grid.y = _tf.y + _tf.height;
			}
		}
		
	}
}