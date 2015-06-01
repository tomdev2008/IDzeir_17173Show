package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-25  上午10:33:03
	 */
	public class ExpandChatButton extends Button
	{
		private var icoBox:Sprite;

		public function ExpandChatButton(label:String = "", isSelected:Boolean = false)
		{
			super(label, isSelected);
			icoBox = new Sprite();
			this.addChild(icoBox);
		}

		public function set icon(source:DisplayObject):void
		{
			icoBox.removeChildren();
			alignIcon(source)
		}

		private function alignIcon(source:DisplayObject):void
		{
			icoBox.x = (this.width) * .5;
			icoBox.y = (this.height) * .5;
			icoBox.addChild(source);
		}
	}
}