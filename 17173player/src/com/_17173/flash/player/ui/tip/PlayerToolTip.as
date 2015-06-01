package com._17173.flash.player.ui.tip
{
	import com._17173.flash.core.components.common.ToolTip;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 竞猜中用到的tooltip样式
	 */	
	public class PlayerToolTip extends ToolTip
	{
		public function PlayerToolTip()
		{
			super();
			this.setSkin_Bg(getBG());
		}
		
		private function getBG():Sprite {
			var re:Sprite = new Sprite();
			re.graphics.clear();
			re.graphics.beginFill(0x696969);
			re.graphics.drawRoundRect(0, 0, 20, 20 , 5, 5);
			re.graphics.endFill();
			re.scale9Grid = new Rectangle(1, 1, 18, 18);
			return re;
		}
	}
}