package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 用户选项卡模块.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCard extends BaseModule implements IUserCard
	{
		
		/**
		 * 实际面板 
		 */		
		private var _panel:UserCardPanel = null;
		
		/**
		 * 当前用户选项卡指向的用户信息
		 */		
		private var _cardData:Object = null;

		private var _autoHide:Boolean;
		
		public function UserCard()
		{
			super();
			_version = "0.0.1";
			Context.getContext(CEnum.EVENT).listen(SEvents.USER_AUTH_CHANGED, UserAuthChange);
		}
		
		override protected function init():void {
			super.init();
			//面板提前初始化,需要的时候显示
			_panel = new UserCardPanel();
		}
		
		public function initData(value:Object):void
		{
			_cardData = value;
			showCard(UserCardData.wrapperUser(value.user, value.filterList), value.pos,value["isAuto"]);
		}
		
		public function showCard(userData:IUserCardData, stagePos:Point=null, auto:Boolean = true):void {
			//清除现有的显示效果
			reset();
			//更新面板
			_panel.data = userData;
			//确认位置信息
			stagePos = stagePos ? stagePos : new Point();
			//当成面板弹出
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			//Debugger.tracer(stagePos,_panel.height);
			//调整信息卡位置防止超出舞台底部
			if(Context.stage)
			{
				if(stagePos.y+_panel.height>Context.stage.stageHeight)
				{
					stagePos.setTo(stagePos.x,stagePos.y+Context.stage.stageHeight-stagePos.y-_panel.height);
				}
				if(stagePos.y< 0)
				{
					stagePos.setTo(stagePos.x,0);
				}
				if(stagePos.x < 0)
				{
					stagePos.setTo(0,stagePos.y);
				}
				if(stagePos.x+_panel.width>Context.stage.stageWidth)
				{
					stagePos.setTo(Context.stage.stageWidth - _panel.width,stagePos.y);
				}
			}
			ui.popupPanel(_panel, stagePos);
			ui.addAction(addAction);
			if(GuideManager.runningGuide)
			{
				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.TASK_CHAT_CLICK_MASTER,{"point":stagePos});
				return;
			}
			//3秒后隐藏
			autoHide = auto;
			//监听停留
			_panel.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_panel.addEventListener(MouseEvent.ROLL_OUT, onOut);
			
		}
		
		public function set autoHide(bool:Boolean):void
		{
			_autoHide = bool;
			if(bool)
			{
				Ticker.tick(3000, onHide);
			}else{
				Ticker.stop(onHide);
			}
		}
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		
		/**
		 * stage鼠标点击事件回调 
		 * @param e
		 * 
		 */		
		private function addAction(e:MouseEvent):void
		{
			if(!this.getBounds(Context.stage).contains(e.stageX,e.stageY))
			{
				onHide();
			}
		}
		
		private function reset():void {
			Ticker.stop(onHide);
			TweenLite.killTweensOf(_panel);
			_panel.alpha = 1;
		}
		
		private function onOver(e:MouseEvent):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			reset();
		}
		
		private function onOut(e:MouseEvent):void {
			Ticker.tick(3000, onHide);
		}
		
		public function onHide():void {
			Ticker.stop(onHide);
			TweenLite.to(_panel, 0.3, {"alpha":0, "onComplete":function ():void {
				_panel.hide();
				(Context.getContext(CEnum.UI) as IUIManager).removeAction(addAction);
				_panel.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				_panel.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}});
		}
		
		/**
		 * 用户权限改变，如果当前用户选项卡在显示，就更新
		 */		
		private function UserAuthChange(obj:Object):void {
			//如果已经要消失了,则不去刷新;会出现马上又弹出的bug
			if(_panel == null || _panel.alpha !=1 || _panel.parent == null) return;
			if (_panel.hasEventListener(MouseEvent.ROLL_OUT) && _cardData) {
				this.data = _cardData;
			}
		}

	}
}