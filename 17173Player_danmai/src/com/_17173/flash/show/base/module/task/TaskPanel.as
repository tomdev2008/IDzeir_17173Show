package com._17173.flash.show.base.module.task
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.LoginUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TaskPanel extends Sprite
	{
		private var _taskBg:TaskBg;
		private var _close:Button;
		private var _title:TextField;
		private var _titleFormat:TextFormat;
		private var _locale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
		private var _s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		private var _e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
		private var _taskTips:TaskTips = null;
		private var _taskArray:Array = [];
		
		public function TaskPanel()
		{
			super();
			_taskBg = new TaskBg();
			_taskBg.x = 0;
			_taskBg.y = 0;
			_taskBg.height = 382;
			this.addChild(_taskBg);
			
			_titleFormat = FontUtil.DEFAULT_FORMAT;
			_titleFormat.size = 14;
			_titleFormat.color = 0xFFFFFF;
			
			_title = new TextField();
			_title.defaultTextFormat = _titleFormat;
			_title.width = 280;
			_title.x = 9;
			_title.y = 5;
			_title.selectable = false;
			_title.mouseEnabled = false;
			_title.text = _locale.get("title", "task");
			this.addChild(_title);
			
		
			_close = new Button;
			_close.setSkin(new Close);
			_close.x = 336;
			_close.y = 11;
			_close.addEventListener(MouseEvent.CLICK,closeClick);
			this.addChild(_close);
			
			for(var i:int = 0;i<= 6;i++){
				var task:TaskItemRender = new TaskItemRender(mouseOver,mouseOut);
				task.x = 0;
				task.y = 32 + i * 50;
				this.addChild(task);
				_taskArray.push(task);
			}
			
			_taskTips = new TaskTips();
			_taskTips.x = 360;
			_taskTips.y = 0;
			_taskTips.visible = false;
			_taskTips.stop();
			_taskTips.addEventListener(MouseEvent.MOUSE_OVER,tipsOver);
			_taskTips.addEventListener(MouseEvent.MOUSE_OVER,tipsOut);
			this.addChild(_taskTips);
			
		}
		
		public function update(taskArray:Array,taskInfoArray:Array):void{
			for(var i:int = 0; i< _taskArray.length ; i++){
				var task:TaskItemRender = _taskArray[i];
				var taskInfo:Object = taskInfoArray[i];
				var taskState:Object = taskArray[i];
				if(taskState.done == "UNDONE"){
					task.update(taskState,taskInfo,btnSend);
				}else{
					if(taskState.getAward == "NO"){
						task.update(taskState,taskInfo,btnReward);
					}else{
						task.update(taskState,taskInfo,null);
					}
				}
			}
		}
		
		private function tipsOver(e:MouseEvent):void{
			Ticker.stop(hideTips);
		}
		
		private function tipsOut(e:MouseEvent):void{
			Ticker.stop(hideTips);
			Ticker.tick(500,hideTips,1);
		}
		
		private function mouseOver(e:MouseEvent):void{
			Ticker.stop(hideTips);
			if(e.currentTarget is TaskItemRender){
				var item:TaskItemRender = e.currentTarget as TaskItemRender;
				var taskTipsY:int = (item.buttonType-1) * 50 + 32 + item.height/2;
				_taskTips.y = taskTipsY;
				_taskTips.gotoAndStop(item.buttonType);
				_taskTips.visible = true;
			}
		}
		
		private function mouseOut(e:MouseEvent):void{
			Ticker.stop(hideTips);
			Ticker.tick(500,hideTips,1);
		}
			
		private function hideTips():void{
			_taskTips.visible = false;
		}
		
		private function btnSend(type:int):void{
			if(type == 1){
				Util.toUrl(LoginUtil.getRegUrl());
				
				_e.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.ZHUCE, "data":getTaskBI(StatTypeEnum.ZHUCE)});
			}
			if(type == 5){
				Utils.toUrlAppedTime(SEnum.URL_MONEY);
				_e.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.CHONGZHI, "data":getTaskBI(StatTypeEnum.CHONGZHI)});
			}
		}
		
		
		private function getTaskBI(str:String,event_val:int = 0):Object{
			var cookie:String = readCookie();
			var obj:Object = new Object();
			obj.preevent = cookie;
			obj.currevent = str;
			if(event_val > 0){
				obj.event_val = event_val;
			}
			wirteCookie(str);
			return obj;
		}
		
		private function wirteCookie(str:String):void{
			var cookie:Cookies = new Cookies("shared", "/");
			cookie.put("taskBI", str, true);
			cookie.close();
		}
		
		private function readCookie():String{
			var cookie:Cookies = new Cookies("shared", "/");
			if (cookie && cookie.get("taskBI")) {
				var task:Object = cookie.get("taskBI");
				if(task){
					return (task as String);
				}
			}
			return "";
		}
		
		private function btnReward(type:int):void{
			var url:URLVariables = new URLVariables();
			url.taskId = 1;
			url.subtaskId = type;
			_s.http.getData(SEnum.TASK_REWARD, url, onSucc, onFail);
		}
		
		private var obj:Object = {1:StatTypeEnum.ZHUCE_L,2:StatTypeEnum.NICHENG_L,3:StatTypeEnum.SHIJIAN_L,4:StatTypeEnum.DINGYUE_L,
							5:StatTypeEnum.CHONGZHI_L,6:StatTypeEnum.SILIAO_L,7:StatTypeEnum.SONGLI_L};
		private function onSucc(data:Object):void{
			if(data.subTaskId){
				_e.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":obj[data.subTaskId], "data":getTaskBI(obj[data.subTaskId],data.award)});
			}
		}
		
		private function onFail(data:Object):void{
			
		}
		
		private function closeClick(e:MouseEvent):void{
			hide();
		}
		
		public function hide():void{
			this.visible = false;
			this._taskTips.visible = false;
			Ticker.stop(hideTips);
		}
		
		public function show():void{
			this.visible = true;
			this._taskTips.visible = false;
			Ticker.stop(hideTips);
		}
	}
}