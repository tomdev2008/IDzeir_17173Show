package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseRightBar extends Sprite implements ISkinObjectListener
	{
		protected var _con:Sprite = null;
		private var _canShow:Boolean = false;
		private var _videoCanStart:Boolean = false;
		private var _e:IEventManager;
		
		public function BaseRightBar()
		{
			super();
			this.visible = false;
			init();
			addListeners();
		}
		
		protected function init():void {
			_con = new Sprite();
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			if (!contains(_con)) {
				addChild(_con);
			}
			
			this.visible = false;
			x = Context.stage.stageWidth;
		}
		
		protected function addListeners():void {
			Context.stage.addEventListener(MouseEvent.MOUSE_MOVE, onCheckShow);
			_e.listen(PlayerEvents.BI_PLAYER_INITED, videoInit);
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
			_e.listen(PlayerEvents.UI_TOGGLE_FULL_SCREEN, function ():void {x = Context.stage.stageWidth});
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.BI_VIDEO_CAN_START, videoCanStart);
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					resize();
					break;
				case SkinEvents.HIDE_FLOW : 
					onHide();
					break;
			}
		}
		
		protected function onCheckShow(event:MouseEvent):void {
			if (event.stageX > (Context.stage.stageWidth - width - 100)) {
				onShow();
			} else {
				onHide();
			}
		}
		
		protected function videoInit(data:Object):void {
			_canShow = true;
		}
		
		protected function onBIInitVideoInfo(data:Object):void {
			_canShow = false;
		}
		
		/**
		 * 后推不能显示rightbar 
		 * @param data
		 * 
		 */		
		protected function showBackRec(data:Object):void {
			this.visible = false;
			_canShow = false;
		}
		
		protected function hideBackRec(data:Object):void {
			x = Context.stage.stageWidth;
			this.visible = true;
			_canShow = true;
		}
		
		protected function onShow():void {
			if (_canShow) {
//				resize();
				this.visible = _videoCanStart;
//				y = (Global.uiManager.avalibleVideoHeight - height) / 2;
				y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - height) / 2;
				TweenLite.to(this, 0.5, {"x":Context.stage.stageWidth - width});
			}
		}
		
		protected function onHide():void {
			if (_canShow) {
//				y = (Global.uiManager.avalibleVideoHeight - height) / 2;
				y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - height) / 2;
				TweenLite.to(this, 0.5, {"x":Context.stage.stageWidth, onComplete:function ():void{this.visible = false}});
			}
		}
		
		public function resize():void
		{
			if(_con && contains(_con))
			{
				var d:DisplayObject = null;
				var i:int = 0;
				var tmp:int = 50;
				for (i; i < _con.numChildren; i ++) {
					d = _con.getChildAt(i);
					if (d) {
						d.x = 0;
						d.y = i * tmp;
					}
				}
			}
			if(_con && contains(_con))
			{
				_con.graphics.clear();
				_con.graphics.beginFill(0x1d1d1d);
				_con.graphics.drawRect(0, 0, 58, _con.numChildren * 50);
				_con.graphics.endFill();
			}
		}
		
		protected function videoCanStart(data:Object):void {
			_videoCanStart = true;
			this.visible = true;
		}
	}
}