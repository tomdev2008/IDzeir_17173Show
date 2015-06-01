package com._17173.flash.show.base.module.rank
{
	import com._17173.flash.show.base.context.module.BaseModule;
	
	public class RankModule extends BaseModule
	{
		private var rankPanel:RankPanel = null;
		public function RankModule()
		{
			super();
			createRankPanel();
		}
		
		private function createRankPanel():void{
			rankPanel = new RankPanel();
			rankPanel.x = 429;
			rankPanel.y = 150;
			this.addChild(rankPanel);
		}
		
		public function updateNaming(data:Object):void{
			rankPanel.update(data.ct);
		}
		
		/**
		 *重置排行榜 
		 * 
		 */		
		public function revertList():void{
			rankPanel.revertList();
		}
	}
}