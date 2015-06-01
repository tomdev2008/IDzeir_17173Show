package com._17173.flash.player.module.quiz.ui.out
{
	
	import flash.display.Sprite;
	
	public class OutQuizBottom extends Sprite
	{
		
		public var _perGuessContainer:OutQuizPerContainer = null;
		public var _govGuessContainer:OutQuizGovContainer = null;
		
		public function OutQuizBottom()
		{
			super();
		}
		
		public function updateGovAndShow(info:Object,w:int,h:int):void
		{
			if (this.numChildren !=0)
			{
				this.removeChildren(0,this.numChildren-1);
			}
			_govGuessContainer = new OutQuizGovContainer(info,w,h);
			addChild(_govGuessContainer);
			_govGuessContainer.x = 0;
			_govGuessContainer.y = 20;
		}
		
		public function updatePerAndShow(info:Object,w:int,h:int):void
		{
			if (this.numChildren !=0)
			{
				this.removeChildren(0,this.numChildren-1);
			}
			_perGuessContainer = new OutQuizPerContainer(info,w,h);
			addChild(_perGuessContainer);
		}
		
	}
}