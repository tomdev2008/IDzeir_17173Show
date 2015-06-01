package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.HtmlUtil;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 *礼物飞屏
	 * @author zhaoqinghao
	 *
	 */
	public class GiftFlyEffectManager
	{
		private var _layer:Sprite = null;
		/**
		 *全平道数据
		 */
		private var _globalMsgs:Array = null;
		/**
		 *本房间数据
		 */
		private var _localMsgs:Array = null;

		private var _localmc:GiftEffectLocal = null;
		private var _globalmc:GiftEffectGlobal = null;
		private var _localShowing:Boolean = false;
		private var _globalShowing:Boolean = false;
		private const SHOWTIME:Array = [5, 8];
		private const TO_SHOWTIME:Number = .4;
		private const TO_HIDETIME:Number = .7;
		private var _localShowTime:int = 5;
		private var _globalShowTime:int = 8;

		public function GiftFlyEffectManager(layer:Sprite)
		{
			_layer = layer;
			_globalMsgs = [];
			_localMsgs = [];
			_localmc = new GiftEffectLocal();
			_globalmc = new GiftEffectGlobal();
		}

		/**
		 *添加显示信息
		 * @param msg 信息
		 * @param type 信息类型（0本房间;1全站）
		 *
		 */
		public function addMessage(msg:Object, type:int = 0):void
		{
			if (msg && msg.hasOwnProperty("globalShowtime")) {
				_globalShowTime = msg["globalShowtime"];
			}
			if (msg && msg.hasOwnProperty("liveroomShowtime")) {
				_localShowTime = msg["liveroomShowtime"];
			}
			//添加信息判断当前是否有显示，没有则显示当前信息
			if (type == 0)
			{
				_localMsgs[_localMsgs.length] = msg;
				if (!_localShowing)
				{
					showLocalNext();
				}
			}
			else
			{
				_globalMsgs[_globalMsgs.length] = msg;
				if (!_globalShowing)
				{
					showGlobalNext();
				}
			}
		}
		
		/**
		 *组织显示label 
		 * @param msg 数据
		 * @return  【XXX】  送给  【XXX】  XX个XXX;
 		 * 
		 */		
		protected function getLabel4Msg(msg:Object):String
		{
			var result:String = "";
			var name:String = "";
			var tName:String = "";
			var count:String = "";
			var gName:String = "";
			if(msg.hasOwnProperty("userName")){
				name = HtmlUtil.decodeHtml(msg.userName);
			}
			if(msg.hasOwnProperty("toUserName")){
				tName = HtmlUtil.decodeHtml(msg.toUserName);
			}
			if(msg.hasOwnProperty("giftCount")){
				count = msg.giftCount;
			}
			if(msg.hasOwnProperty("giftName")){
				gName = msg.giftName;
			}
			result = "【" + name + "】  送给  " + "【" + tName + "】  " + count + "个" + gName;
//			trace(result);
			return result;
		}
		/**
		 *显示本房间
		 *
		 */
		private function showLocalNext():void
		{
			if (_localMsgs.length > 0)
			{
				var obj:Object = _localMsgs.shift();
				_localShowing = true;
				//获取显示对象
				_localmc.updateText(getLabel4Msg(obj));
				//展示
				showLocalEffect(_localmc);
			}
			else
			{
				_localShowing = false;
			}

		}

		/**
		 *显示全站
		 *
		 */
		private function showGlobalNext():void
		{
			if (_globalMsgs.length > 0)
			{
				var obj:Object = _globalMsgs.shift();
				_globalShowing = true;
				//获取显示对象
				_globalmc.updateText(getLabel4Msg(obj));
				//增加跳转链接
				addJumptoToGlobalMsg(_globalmc, obj);
				//展示
				showGlobalEffect(_globalmc);
			}
			else
			{
				_globalShowing = false;
			}
		}
		
		/**
		 * 给全局礼物飞屏增加跳转链接.
		 * 通过对比跳转链接中包含的id和liveRoomId进行匹配.
		 * 
		 * @author qingfeng
		 *  
		 * @param g
		 * @param data
		 */		
		private function addJumptoToGlobalMsg(g:Object, data:Object):void {
			var j:String = data.hasOwnProperty("liveRoomUrl") ? data["liveRoomUrl"] : null;
			if (!j) return;
			try {
				var jid:String = j.split("=")[1];
				var rmId:String = Context.variables["roomID"];
				if (!jid || (jid && jid != rmId)) {
					g.jumpTo = j;
				}
			} catch (e:Object) {};
		}

		/**
		 *显示动画
		 * @param eff 动画
		 *
		 */
		private function showLocalEffect(eff:DisplayObject):void
		{
			var sw:int = Context.stage.stageWidth;
			var sh:int = Context.stage.stageHeight;
			var showTime:int = int(_localShowTime);
			eff.x = int((sw - eff.width) / 2);
			eff.y = 10;
			eff.alpha = 0;
			_layer.addChild(eff);
			onShow();
			//显示
			function onShow():void
			{
				TweenLite.to(eff, TO_SHOWTIME, {alpha: 1, onComplete: onWate});
			}
			//等待
			function onWate():void
			{
				TweenLite.to(eff, showTime, {alpha: 1, onComplete: toHide});
			}
			//消失
			function toHide():void
			{
				TweenLite.to(eff, TO_HIDETIME, {alpha: 0, onComplete: onHide});
			}
			
			function onHide():void{
				if(_layer.contains(eff)){
					_layer.removeChild(eff);
				}
				showLocalNext();
			}
		}

		/**
		 *显示动画
		 * @param eff 动画
		 *
		 */
		private function showGlobalEffect(eff:DisplayObject):void
		{
			var sw:int = Context.stage.stageWidth;
			var sh:int = Context.stage.stageHeight;
			var showTime:int = int(_globalShowTime);
			eff.x = int((sw - eff.width) / 2);
			eff.y = 47;
			eff.alpha = 0;
			_layer.addChild(eff);
			onShow();
			//显示
			function onShow():void
			{
				TweenLite.to(eff, TO_SHOWTIME, {alpha: 1, onComplete: onWate});
			}
			//等待
			function onWate():void
			{
				TweenLite.to(eff, showTime, {alpha: 1, onComplete: toHide});
			}
			//消失
			function toHide():void
			{
				TweenLite.to(eff, TO_HIDETIME, {alpha: 0, onComplete: onHide});
			}
			
			function onHide():void{
				if(_layer.contains(eff)){
					_layer.removeChild(eff);
				}
				showGlobalNext();
			}
		}
		
		public function onResize():void{
			var sw:int = Context.stage.stageWidth;
			var sh:int = Context.stage.stageHeight;
			if(_globalmc){
				_globalmc.x = int((sw - _globalmc.width) / 2);
				_globalmc.y = 47;
			}
			if(_localmc){
				_localmc.x = int((sw - _localmc.width) / 2);
				_localmc.y = 10;
			}
		}
	}
}
