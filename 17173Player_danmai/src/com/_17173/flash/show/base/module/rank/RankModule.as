package com._17173.flash.show.base.module.rank
{
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.rank.view.RankPanel;
	
	public class RankModule extends BaseModule
	{
		
		/**
		 *排行榜面板 
		 */		
		private var rank:RankPanel;
		
		public function RankModule()
		{
			super();
			createRankPanel();
		}
		
		private function createRankPanel():void
		{
			rank = new RankPanel();
			rank.x = 528;
			rank.y = 36;
			this.addChild(rank);
		}
		
		public function updateNaming(data:Object):void
		{
			rank.update(data.ct);	
		}
		
		/**
		 *重置排行榜 
		 * 
		 */		
		public function revertList():void{
			rank.update(null);
		}
	}
}