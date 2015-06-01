package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Label;

	import flash.display.Sprite;

	/**
	 * @author idzeir
	 * 创建时间：2014-3-12  上午11:59:02
	 */
	public class HistoryItemRender extends Sprite
	{
		private var label:Label;

		public function HistoryItemRender(data:*)
		{
			super();
			label = new Label(data);
			label.textColor = 0xCCCCCC;
			this.addChild(label);
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, label.maxWidth, label.height+1);
			this.graphics.endFill();
			this.mouseChildren = false;
		}
	}
}