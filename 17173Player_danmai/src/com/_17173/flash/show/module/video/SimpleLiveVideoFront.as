package com._17173.flash.show.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.module.video.app.AppPanel;
	import com._17173.flash.show.module.video.bottom.BottomPanel;
	import com._17173.flash.show.module.video.weekgiftstar.WeekGiftStarPanel;
	
	import flash.display.Sprite;
	
	public class SimpleLiveVideoFront extends Sprite
	{
		/**
		 * 麦序  
		 */		
		private var _micIndex:int = 1;
		
		/** 底部操作面板  **/	
		private var _bottomPanel:BottomPanel = null;
		/** 左侧周礼物  **/	
		private var _giftStarPanel:WeekGiftStarPanel;
		/** 右侧APP功能 **/
		private var _appPanel:AppPanel;
		
		public function SimpleLiveVideoFront(micIndex:int)
		{
			super();
			this._micIndex = micIndex;
			
			_bottomPanel = new BottomPanel(micIndex);
			_bottomPanel.x =  46;
			_bottomPanel.y =  370;
			this.addChild(_bottomPanel);
			
			_giftStarPanel = new WeekGiftStarPanel();
			this.addChild(_giftStarPanel);
			_giftStarPanel.x = 0;
			_giftStarPanel.y = 7;
			
			_appPanel = new AppPanel();
			this.addChild(_appPanel);
			_appPanel.x = 525;
			_appPanel.y = 12;
		}
		
		 /**
		  * 更新周礼物之星 
		  * @param data
		  * 
		  */		
		 public function updateWeekGiftStar(data:Object):void
		 {
			 _giftStarPanel.setWeedGiftStarData(data);
		 }
		 /**
		  * 设置右侧app功能 
		  * @param value
		  * 
		  */		 
		 public function setAppData(value:Object):void
		 {
			 _appPanel.setAppData(value);
		 }
		 
		/**
		 * 更新主播声音状态 
		 * 
		 */	
		public function updateSoundState():void{
			_bottomPanel.masterPanel.updateSoundState();
		}
		/**
		 * 主播更新名字 
		 * 
		 */	
		public function updateName():void
		{
			_bottomPanel.masterPanel.updateName();
		}
		/**
		 * 获得麦序 
		 * @return 
		 * 
		 */		
		public function get micIndex():int
		{
			return _micIndex;
		}
		/**
		 * 更新 
		 * 
		 */		
		public function update():void
		{
			_bottomPanel.masterPanel.updateSoundState();
			_bottomPanel.masterPanel.updateName();
			_bottomPanel.masterPanel.updateStarLevel();
			_bottomPanel.masterPanel.updateLiveTime();
			_bottomPanel.masterPanel.updateLocation();
			
			_bottomPanel.masterPanel.updateDisplayList();
			
			_bottomPanel.update();
			
			updateApp();
		}
		
		private var _appUpdateFinished:Boolean=false;
		private function updateApp():void
		{
			if(_appUpdateFinished)return;
			
			_appUpdateFinished = true;
			var _s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_s.http.getData(SEnum.VIDEO_APP,null,function (data:Object):void{
				setAppData(data);
			});
		}
	}
}

