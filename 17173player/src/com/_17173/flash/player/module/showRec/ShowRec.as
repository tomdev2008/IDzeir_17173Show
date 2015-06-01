package com._17173.flash.player.module.showRec
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.showRec.ui.ShowRecImage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	/**
	 * 直播/点播推荐秀场模块
	 * @author 安庆航
	 * 
	 */	
	public class ShowRec extends Sprite
	{
		public static const GET_SHOW_PIC_URL:String = "http://v.17173.com/show/inter_liveList.action?num=5&";
//		public static const GET_SHOW_PIC_URL:String = "http://show.17173.com/inter_liveList.action?num=5&";
		
		private var _bg:Sprite;
		private var _img:ShowRecImage;
		private var _close:MovieClip;
		private var _e:IEventManager;
		private var _picUrl:String;
		private var _url:String;
		private var _uid:String = "?vid=wlbfq_show";
		
		public function ShowRec()
		{
			super();
			init();
			getData();
		}
		
		private function init():void {
			var ver:String = "1.0.3";
			Debugger.log(Debugger.INFO, "[showRec]", "直播点播推秀场模块[版本:" + ver + "]初始化!");
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
//			_e.listen(PlayerEvents.SKIN_EVENT, skinEventHandler);
			_e.listen(PlayerEvents.UI_RESIZE, onUIResize);
		}
		
		private function onUIResize(evt:Object):void {
			if (!Context.stage.contains(this)) {
				return;
			}
			var isFull:Boolean = !(Context.stage.displayState == StageDisplayState.NORMAL);
			if (isFull) {
				Context.stage.setChildIndex(this, Context.stage.numChildren - 1);
				var tempY:Number = (Context.getContext(ContextEnum.UI_MANAGER)).avalibleVideoHeight - _img.height - 43;
				this.x = Context.stage.stageWidth - _img.width - 2;
				this.y = tempY;
			} else {
				this.x = Context.stage.stageWidth - _img.width - 2;
				this.y = (Context.getContext(ContextEnum.UI_MANAGER)).avalibleVideoHeight - _img.height;
			}
		}
		
//		private function skinEventHandler(data:Object):void {
//			if (!Context.stage.contains(this)) {
//				return;
//			}
//			var isFull:Boolean = Context.getContext(ContextEnum.SETTING).isFullScreen;
//			if (isFull && data && data.hasOwnProperty("event")) {
//				var tempY:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight - _img.height - 43;
//				this.x = Context.stage.stageWidth - _img.width - 2;
//				this.y = tempY;
//				if (data["event"] == SkinEvents.SHOW_FLOW) {
//					TweenLite.to(this, 0.5, {"y":tempY});//36是因为全屏下 全屏的topbar 是35
//				} else if (data["event"] == SkinEvents.HIDE_FLOW) {
//					TweenLite.to(this, 0.5, {"y":tempY + 43});
//				}
//			}
//			if (!isFull) {
//				this.x = Context.stage.stageWidth - _img.width - 2;
//				this.y = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight - _img.height - 3;
//			}
//		}
		
		/**
		 * 获取秀场的推荐图片和跳转地址
		 */		
		private function getData():void {
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(
				GET_SHOW_PIC_URL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onGetDataSucess, onGetDataFault);
			loader.load(loaderOption);
		}
		
		private function onGetDataSucess(data:Object):void {
			if (data && data.hasOwnProperty("code") && data["code"] == "000000") {
				if (data.hasOwnProperty("obj")) {
					var temp:Array = data["obj"];
					var random:int = int(Math.random() * 5) + 1;
					if (temp.length > 0) {
						if (temp[random - 1].hasOwnProperty("randomUrl")) {
							_url = temp[random - 1]["randomUrl"];
						}
						if (temp[random - 1].hasOwnProperty("waiLianPhoto")) {
							_picUrl = temp[random - 1]["waiLianPhoto"];
						}
					}
				}
			}
			if (Util.validateStr(_url) && Util.validateStr(_picUrl)) {
				_img = new ShowRecImage();
				_img.source = _picUrl;
				_img.url = _url + _uid;
				_img.addEventListener("loadComplete", addToShow);
				_img.addEventListener("closeComplete", closeThis);
			}
		}
		
		private function onGetDataFault(data:Object):void {
			Debugger.log(Debugger.INFO, "[showRec]获取秀场接口错误");
		}
		
		/**
		 * 将模块添加到播放器中
		 */		
		private function addToShow(evt:Event):void {
			addChild(_img);
			Context.stage.addChild(this);
			this.x = Context.stage.stageWidth - _img.width - 2;
			this.y = (Context.getContext(ContextEnum.UI_MANAGER)).avalibleVideoHeight - _img.height - 3;
		}
		
		protected function closeThis(event:Event):void
		{
			if (Context.stage.contains(this)) {
				Context.stage.removeChild(this);
			}
		}
		
	}
}