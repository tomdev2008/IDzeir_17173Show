package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoData;
	
	import flash.display.Sprite;
	
	public class FileBackRecommend extends Sprite
	{
		protected var _backRecBig:BackRecommend = null;
		protected var _backRecMiddle:BackRecommendMiddle = null;
		protected var _backRecSmall:BackRecommendSmall = null;
		protected var _backRecLittleSmall:BackRecommendLittleSmall = null;
		protected var _moreInfo:Array = null;
		protected var _moreLabel:String = "";
		protected var _moreUrl:String = "";
		protected var _bg:Sprite = null;
		
		public function FileBackRecommend()
		{
			super();
			
			_bg = new Sprite();
			this.addChild(_bg);
			
			getMoreInfo();
			resize();
		}
		
		private function getMoreInfo():void {
			var videoData:VideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data as VideoData;
			Context.getContext(ContextEnum.DATA_RETRIVER).reqForMore(videoData.cid, getMoreInfoBack);
//			var videoData:VideoData = Global.videoData as VideoData;
//			Global.dataRetriver.reqForMore(videoData.cid, getMoreInfoBack);
		}
		
		private function getMoreInfoBack(_moreInfo:Array, _moreLabel:String, _moreUrl:String):void
		{
			this._moreInfo = new Array();
			this._moreInfo = _moreInfo;
			this._moreLabel = _moreLabel;
			this._moreUrl = _moreUrl;
			if(!_backRecBig) {
				resize();
			}
		}
		
		public function resize():void {
			if(!_moreInfo)
			{
				return;
			}
//			var w:Number = Global.uiManager.avalibleVideoWidth;
//			var h:Number = Global.uiManager.avalibleVideoHeight;
//			if(Global.settings.isFullScreen)
			var w:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			var h:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			if(Context.getContext(ContextEnum.SETTING)["isFullScreen"])
			{
				w = Context.stage.fullScreenWidth;
				h = Context.stage.fullScreenHeight;
			}
			if(this.numChildren > 1)
			{
				this.removeChildren(1, this.numChildren - 1);
			}
			_bg.graphics.clear();
//			_bg.graphics.beginFill(0x181818);
			_bg.graphics.beginFill(0);
			_bg.graphics.drawRect(0, 0, w, h);
 			_bg.graphics.endFill();
			
			if (Context.stage.stageWidth >= 375) {
				//宽度在这个区间，要根据高度判断显示内容
			} else if (Context.stage.stageWidth <= 135) {
				resizeBackRecommendLittleSmall(w, h);
				return;
			} else {
				resizeBackRecommendSmall(w, h);
				return;
			}
			if(Context.stage.stageHeight > 400) {
				if(w > 854 || h > 478) {
					if (w > 854) {
						w = 854;
					}
					if (h > 478) {
						h = 478;
					}
				}
				resizeBackRecommend(w, h);
//				resizeBackRecommendMiddle(w, h);
			} else if(Context.stage.stageHeight <= 360 && Context.stage.stageHeight > 222) {
				resizeBackRecommendSmall(w, h);
			} else if (Context.stage.stageHeight <= 222) {
				resizeBackRecommendLittleSmall(w, h);
			} else {
				resizeBackRecommendMiddle(w, h);
			}
		}
		
		protected function resizeBackRecommend(w:Number, h:Number):void {
			_backRecBig = new BackRecommend(w, h);
			_backRecBig.resize();
			_backRecBig.setMoreInfo(_moreInfo, _moreLabel, _moreUrl);
			_backRecBig.x = ((_bg.width - w) / 2) < 0 ? 0: ((_bg.width - w) / 2);
			_backRecBig.y = (_bg.height - h) / 2;
			if (!this.contains(_backRecBig)) {
				addChild(_backRecBig);
			}
		}
		
		protected function resizeBackRecommendSmall(w:Number, h:Number):void {
			_backRecSmall = new BackRecommendSmall(w, h);
			_backRecSmall.resize();
			if (!this.contains(_backRecSmall)) {
				addChild(_backRecSmall);
			}
		}
		
		protected function resizeBackRecommendLittleSmall(w:Number, h:Number):void {
			_backRecLittleSmall = new BackRecommendLittleSmall(w, h);
			_backRecLittleSmall.resize();
			if (!this.contains(_backRecLittleSmall)) {
				addChild(_backRecLittleSmall);
			}
		}
		
		protected function resizeBackRecommendMiddle(w:Number, h:Number):void {
			_backRecMiddle = new BackRecommendMiddle(w, h);
			_backRecMiddle.resize();
			_backRecMiddle.setMoreInfo(_moreInfo, _moreLabel, _moreUrl);
			if (!this.contains(_backRecMiddle)) {
				addChild(_backRecMiddle);
			}
		}
		
	}
}