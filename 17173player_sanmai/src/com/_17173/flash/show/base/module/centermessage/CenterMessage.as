package com._17173.flash.show.base.module.centermessage
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.centermessage.view.CenterGlobalPane;
	import com._17173.flash.show.base.module.centermessage.view.CenterMessagePane;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class CenterMessage extends BaseModule
	{
		private var _messagePane:CenterMessagePane = null;
		private var _globalPane:CenterGlobalPane;
		public function CenterMessage()
		{
			super();
			_version = "0.0.3";
		}
		
		override protected function init():void{
			this.mouseEnabled = false;
			addEventLsn();
			addServerLsn();
			//遮罩
			var shap:Shape = new Shape();
			shap.graphics.beginFill(0xFFFFFF);
			shap.graphics.drawRect(-10,0,434,103);
			shap.graphics.endFill();
			this.mask = shap;
			this.addChild(shap);
			this.graphics.beginFill(0xff0000,.01);
			this.graphics.drawRect(0,0,402,103);
			this.graphics.endFill();
			
			hMoveInit();
			_messagePane = new CenterMessagePane();
			_messagePane.y = 50;
			_messagePane.x = -10;
			addChild(_messagePane);
		}
		
		protected function hMoveInit():void{
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			var tmpbg:MovieClip =new topbar_global_bg();
			tmpbg.x = 0;
			tmpbg.y = -5;
			tmpbg.mouseEnabled = false;
			this.addChild(tmpbg);
			
			_globalPane = new CenterGlobalPane(1000);
			_globalPane.x = 30;
			_globalPane.y = -3;
			this.addChild(_globalPane);
		}
		
		
		/**
		 *监听事件 
		 * 
		 */		
		private function addEventLsn():void{
			var event:EventManager = Context.getContext(CEnum.EVENT) as EventManager;
			event.listen(SEvents.CENTER_MESSAGE,addMessage);
			event.listen(SEvents.SHOW_GLOBAL_GIFT_MESSAGE,addGlobalGiftMessage);
		}
		private function addGlobalGiftMessage(msg:Object):void{
			//拼接字符串
			_globalPane.addMessage(msg);
			Debugger.log(Debugger.INFO,["CenterMessage"],"全局礼物展示");
		}
		/**
		 *监听通信消息 
		 * 
		 */		
		private function addServerLsn():void{
			
		}
		
		private function addMessage(data:Object):void{
			var data1:MessageVo = data.clone();
			replace4Limit(data1);
			_messagePane.addMsg(Utils.getCenterMsg(data1));
		}
		
		/**
		 *送礼消息超长操作  
		 * @param data 消息
		 * 
		 */		
		private function replace4Limit(data:MessageVo):void{
			var sName:String = data.sName;
			var sNo:String = data.sNo;
			var tName:String = data.tName;
			var tNo:String = data.tNo;
			var gName:String = data.giftName;
			var count:String = data.giftCount;
			var str:String = sName + "(" +sNo + ")" + " 送给 " + tName + "(" + tNo + ") "  + count + " " + gName ;
			//截取前接收人名长度
			//截取后接收人名长度
			var tlen1:int = 0;
			var tlen2:int = 0;
			var ttLen:int = checkStrLength(str) - 56;
			//是否超过限制
			if(ttLen > 0){
				tlen1 = checkStrLength(tName);
				//收礼人的名字是否可以截取
				if(tlen1 > 8){
					//截取名字
					data.tName = replaceName(tName);
				}
				tlen2 = checkStrLength(data.tName);
				//截取后是否还超长则截取发送方人名
				if(ttLen > (tlen1 - tlen2)){
					data.sName = replaceName(sName);
				}
			}
		}
		
		private function replaceName(name:String):String{
			var startLen:int = 2;
			var nStr:String = name.substr(0,startLen);
			while(checkStrLength(nStr) < 4){
				startLen++;
				nStr =  name.substr(0,startLen);
			}
			//					//判断如果超过4个字节则从新截取;
			//					if(checkStrLength(newTName) > 4){
			//						startLen--;
			//						newTName =  tName.substr(0,startLen);
			//					}
			return (nStr + "..");
		}
		
		private function checkStrLength(str:String):int{
			return str.replace(/[^\x00-\xff]/g,"xx").length
		}
		
	}
}