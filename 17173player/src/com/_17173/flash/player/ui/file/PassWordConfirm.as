package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoData;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.tip.TooltipData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PassWordConfirm extends Sprite
	{
		private var _pw:DisplayObject = null;
		private var _bg:Sprite = null;
		private var _star:DisplayObject = null;
		
		public function PassWordConfirm()
		{
			super();
//			var _height:int = Context.stage.stageHeight - Global.uiManager.bottomBarHeight;
			var _height:int = Context.stage.stageHeight - Context.getContext(ContextEnum.UI_MANAGER).bottomBarHeight;
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000);
//			_bg.graphics.drawRect(0, 0, Global.uiManager.avalibleVideoWidth, Global.uiManager.avalibleVideoHeight);
			_bg.graphics.drawRect(0, 0, Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth, Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight);
			_bg.graphics.endFill();
			addChild(_bg);
			
			_star = new mc_pw_back();
			addChild(_star);
			
			var scale:Number = 1;
			if (_star.width > _bg.width || _star.height > _bg.height) {
//				var sx:Number = Global.uiManager.avalibleVideoWidth / _star.width;
//				var sy:Number = Global.uiManager.avalibleVideoHeight / _star.height;
				var sx:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth / _star.width;
				var sy:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight / _star.height;
				scale = sx < sy ? sx : sy;
			}
			_star.scaleX = _star.scaleY = scale;
			
//			_star.x = (Global.uiManager.avalibleVideoWidth - _star.width) / 2 + _star.width / 2;
//			_star.y = (Global.uiManager.avalibleVideoHeight - _star.height) / 2 + _star.height / 2;
			_star.x = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - _star.width) / 2 + _star.width / 2;
			_star.y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - _star.height) / 2 + _star.height / 2;
			
			_pw = new mc_password();
			_pw.x = (Context.stage.stageWidth - _pw.width) / 2;
			_pw.y = (_height - _pw.height) / 2;
			addChild(_pw);
			
			_pw.addEventListener("confirmPassword", confirmPasswordHandler);
		}
		
		private function init():void
		{
		}
		
		/**
		 * 验证视频id
		 */
		private function checkPWBack(value:Object):void
		{
			if(value["success"] == 0) {
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("密码错误"));
			} else if(value["success"] > 0) {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.HIDE_PASS_WORD);
			} else {
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("密码错误"));
			}
//			if(value["success"] == 0) {
//				Global.uiManager.showTooltip(TooltipData.fromContent("密码错误"));
//			} else if(value["success"] > 0) {
//				Global.eventManager.send(PlayerEvents.HIDE_PASS_WORD);
//			} else {
//				Global.uiManager.showTooltip(TooltipData.fromContent("密码错误"));
//			}
		}
		
		private function confirmPasswordHandler(evt:Event):void
		{
			var videoData:VideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data as VideoData;
			Context.getContext(ContextEnum.DATA_RETRIVER)["checkPW"](videoData.cid, _pw["password"], checkPWBack);
//			var videoData:VideoData = Global.videoData as VideoData;
//			Global.dataRetriver["checkPW"](videoData.cid, _pw["password"], checkPWBack);
		}
		
		public function showPassword():void
		{
//			Global.uiManager.popup(this);
			Context.getContext(ContextEnum.UI_MANAGER).popup(this);
		}
		
		public function hidePassword():void
		{
//			Global.uiManager.closePopup(this);
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(this);
		}
	}
}