package com._17173.flash.show.base.module.rank
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class RankDelegate extends BaseModuleDelegate
	{
		
		public function RankDelegate()
		{
			super();
			_s.socket.listen(SEnum.R_NAMEING.action, SEnum.R_NAMEING.type, updateNaming);
			_e.listen(SEvents.MIC_DOWN_MESSAGE,endVideo);
		}
		
		private function updateNaming(data:Object):void{
			if(!module){
				return;
			}
			module.data = {"updateNaming":[data]};
		}
		
		private function endVideo(data:Object):void{
			if(!module){
				return;
			}
			module.data = {"revertList":null};
		}
	}
}