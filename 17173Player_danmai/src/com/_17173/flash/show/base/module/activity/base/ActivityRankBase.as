package com._17173.flash.show.base.module.activity.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.net.ISocketService;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;

	public class ActivityRankBase extends ActivityBase
	{
		public function ActivityRankBase(actName:String)
		{
			_act = actName
			super();
		}
		protected var _rank:*;
		protected var _sub:MovieClip;
		override protected function initLsn():void
		{
			// TODO Auto Generated method stub
			super.initLsn();
			//分别请求排行榜，与收礼数量监听
			var s:ISocketService = (Context.getContext(CEnum.SERVICE) as IServiceProvider).socket;
			s.listen(SEnum.UPDATE_ACT_LIST.action,SEnum.UPDATE_ACT_LIST.type,onListBack);
			s.listen(SEnum.UPDATE_ACT_REC_COUNT.action,SEnum.UPDATE_ACT_REC_COUNT.type,onRecZCountBack);
		}
		
		override protected function initUI():void
		{
			// TODO Auto Generated method stub
			super.initUI();
			initRank();
			initSub();
		}
		
		override protected function setupData(data:Object):void
		{
			// TODO Auto Generated method stub
			super.setupData(data);
			//如果活动开始
			if(data.hdStatus == 1 && data.hd == _act){
				_rank.setDate(data);
				//如果都没显示则显示引导
				if(_rank.parent == null && _sub.parent == null){
					showSub();
				}
				show();
			}else{
				//如活动关闭，则关闭所有
				if(_rank.parent){
					this.removeChild(_rank);
				}
				if(_sub.parent){
					this.removeChild(_sub);
				}
				remove();
			}
		}
		
		
		protected function showRank():void
		{
			// TODO Auto Generated method stub
			if(_rank.parent == null){
				this.addChild(_rank);
				showRankEffect();
			}
		}
		
		protected function showRankEffect():void{
			TweenLite.to(_rank,.3,{y:-280});
		}
		
		
//		暂时不启用
//		protected function hideRankEffect():void{
//			
//		}
		
		protected function showSub():void
		{
			// TODO Auto Generated method stub
			if(_sub.parent == null){
				this.addChild(_sub);
			}
		}
		
		protected function hideRank():void
		{
			// TODO Auto Generated method stub
			if(_rank.parent){
				this.removeChild(_rank);
			}
		}
		
		protected function hideSub():void
		{
			// TODO Auto Generated method stub
			if(_sub.parent){
				this.removeChild(_sub);
			}
		}
		
		/**
		 *显示sub 
		 * @param e
		 * 
		 */		
		protected function toSub(e:Object = null):void{
			hideRank();
			showSub();
		}
		
		protected function toRank(e:Object = null):void{
			//			hideSub();
			if(_rank.parent!=null) return;
			showRank();
		}
		
		
		private function onListBack(data:Object):void{
			//检测是否属于自己的活动
			if(data.ct.hd == _act){
				listBack(data);
			}
		}
		
		private function onRecZCountBack(data:Object):void{
			//检测是否属于自己的活动
			if(data.ct.hd == _act){
				recZCountBack(data);
			}
		}
		
		/**
		 *列表数据返回 
		 * @param data
		 * 
		 */	
		protected function listBack(data:Object):void
		{
		}
		/**
		 *受到数据返回 
		 * @param data
		 * 
		 */	
		protected function recZCountBack(data:Object):void
		{
		}
		/**
		 *初始化排行榜 
		 * 
		 */		
		protected function initRank():void{
			
		}
		/**
		 *初始化展示版 
		 * 
		 */		
		protected function initSub():void{
			
		}
		
	}
}