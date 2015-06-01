package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.Button;
	
	public class GiftPageButton extends Button
	{
		private var _pageIdx:int = 0
		public function GiftPageButton(pageidx:int)
		{
			_pageIdx = pageidx;
			super("",false);
			this.setSkin(new Skin_Btn_GiftPage());
			this.width = 8;
			this.height = 8
		}

		public function get pageIdx():int
		{
			return _pageIdx;
		}

		public function set pageIdx(value:int):void
		{
			_pageIdx = value;
		}

	}
}