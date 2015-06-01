package com._17173.flash.player.ui.comps.def
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.Settings;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class ControlBarDefBarItem extends Sprite
	{
		private var _bg:Sprite = null;
		private var _cq:ControlBarDefItem = null;
		private var _gq:ControlBarDefItem = null;
		private var _bq:ControlBarDefItem = null;
		private var _defDic:Dictionary = null;
		
		private var centerWidth:Number = 62;
		private var centerHeight:Number = 28.75;
		
		private var _currentState:String = "0";
		
		private var _laseState:String = "0";
		
		public var callBack:Function = null;
		
		public function ControlBarDefBarItem()
		{
			super();
			this.buttonMode = false;
			_bg = new Sprite();
			addChild(_bg);
			
			_cq = new ControlBarDefItem("超清");
//			_cq.buttonMode = false;
//			_cq.mouseEnabled = false;
//			_cq.mouseChildren = false;
			addChild(_cq);
			
			_gq = new ControlBarDefItem("高清");
//			_gq.buttonMode = false;
//			_gq.mouseEnabled = false;
//			_gq.mouseChildren = false;
			addChild(_gq);
			
			_bq = new ControlBarDefItem("标清");
//			_bq.buttonMode = false;
//			_bq.mouseEnabled = false;
//			_bq.mouseChildren = false;
			addChild(_bq);
			
			_defDic = new Dictionary();
//			_currentState = Global.settings.def;
			_currentState = Context.getContext(ContextEnum.SETTING).def;
			
//			Global.eventManager.listen(PlayerEvents.BI_VIDEO_DEF_CHANGED, onVideoDefChanged);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_VIDEO_DEF_CHANGED, onVideoDefChanged);
		}
		
		/**
		 * 设置都有那些清晰度
		 */
		public function setDefInfo(value:String):void
		{
//			_currentState = Global.settings.def;
			_currentState = Context.getContext(ContextEnum.SETTING).def;
			if(value.search("4") != -1)
			{
				_defDic["4"] = _cq;
				_cq.enable = true;
			}
			else
			{
				_defDic["4"] = _cq;
				_cq.enable = false;
			}
			if(value.search("2") != -1)
			{
				_defDic["2"] = _gq;
				_gq.enable = true;
			}
			else
			{
				_defDic["2"] = _gq;
				_gq.enable = false;
			}
			if(value.search("1") != -1)
			{
				_defDic["1"] = _bq;
				_bq.enable = true;
			}
			else
			{
				_defDic["1"] = _bq;
				_bq.enable = false;
			}
			
			resetState();
			resize();
			init();
		}
		
		private function init():void
		{
			_bq.addEventListener("onClick", bqClickHanlder);
			_gq.addEventListener("onClick", gqClickHanlder);
			_cq.addEventListener("onClick", cqClickHanlder);
		}
		
		private function bqClickHanlder(evt:Event):void
		{
			_currentState = "1";
//			Global.settings.isAutoDef = false;
			Context.getContext(ContextEnum.SETTING).isAutoDef = false;
			changeDef();
		}
		
		private function gqClickHanlder(evt:Event):void
		{
			_currentState = "2";
//			Global.settings.isAutoDef = false;
			Context.getContext(ContextEnum.SETTING).isAutoDef = false;
			changeDef();
		}
		
		private function cqClickHanlder(evt:Event):void
		{
			_currentState = "4";
//			Global.settings.isAutoDef = false;
			Context.getContext(ContextEnum.SETTING).isAutoDef = false;
			changeDef();
		}
		
		private function yhClickHanlder(evt:Event):void
		{
			_currentState = "8";
//			Global.settings.isAutoDef = false;
			Context.getContext(ContextEnum.SETTING).isAutoDef = false;
			changeDef();
		}
		
		/**
		 * 设置当前选中状态
		 * 两个地方调用:第一个是当列表显示的时候要显示出正确的当前的选中状态,
		 * 第二个:当新选择了状态之后,会判断是否能切换,如果能切换就重新设置一次,要是不能切换,就要重新设置为上次选中的
		 */
		public function resetState():void
		{
			for(var item:Object in _defDic)
			{
				if(item == _currentState)
				{
					if(_defDic[item])
					{
						_defDic[item].isSelect = true;
					}
				}
				else
				{
					if(_defDic[item])
					{
						_defDic[item].isSelect = false;
					}
				}
			}
		}
		
		/**
		 * 切换当前的清晰度
		 * 切换的时候会验证是否可以切换，如果不能切换会设置为上次的清晰度
		 */
		private function changeDef():void
		{
//			Global.settings.saveCookie("def", "def:" + _currentState);
//			if(Global.settings.def == _currentState)
			Context.getContext(ContextEnum.SETTING).saveCookie("def", "def:" + _currentState);
			if(Context.getContext(ContextEnum.SETTING).def == _currentState)
			{
				resetState();
				return;
			}
//			Global.eventManager.send(PlayerEvents.UI_CHANGE_DEFINITION, _currentState);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_CHANGE_DEFINITION, _currentState);
		}
		
		private function onVideoDefChanged(data:Object):void {
			_laseState = _currentState;
			if (data && data.hasOwnProperty("def")) {
				_currentState = data["def"];
			} else {
				_currentState = Context.getContext(ContextEnum.SETTING).def;
			}
			callBack.call(null, Context.getContext(ContextEnum.SETTING).defName[_currentState]);
			resetState();
		}
		
		public function resize():void
		{
			if(numChildren > 1)
			{
				var d:DisplayObject = null;
				var firstY:Number = 0;
				for(var i:int = 1; i < numChildren; i++)
				{
					d = getChildAt(i);
					if(d)
					{
						d.x = (width - d.width) / 2;
						d.y = firstY;
					}
					firstY = d.y + d.height;
				}
			}
			
			if(_bg && contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0, 0);
				_bg.graphics.drawRect(0, 0, 60, 96);
				_bg.graphics.endFill();
			}
		}
	}
}