package com._17173.flash.show.base.module.activity.item
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.Sprite;

	/**
	 *双节礼物数量显示
	 * @author zhaoqinghao
	 *
	 */
	public class TwoDayIcon extends Sprite
	{
		private var iconType:int = 0;
		private var count:int = 99;
		private var iconC:IconCount;
		public function TwoDayIcon()
		{
			super();
			init();
		}
		
		public function init():void{
			iconC = new IconCount();
			iconC.setbg(new Bg_Act());
			this.addChild(iconC);
			addLsn();
			refInfo();
		}
		
		
		private function addLsn():void{
			Context.getContext(CEnum.SERVICE).socket.listen(SEnum.R_ACT_DATA.action,SEnum.R_ACT_DATA.type,actDataBack);
		}
		/**
		 *自己刷新数据 
		 * 
		 */		
		private function refInfo():void{
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			var data:Object = {};
			data.masterId = Context.variables.showData.roomOwnMasterID;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.ACT_TWODAY_COUNT,data,onSecc);
		}
		
		private function actDataBack(data:Object):void{
			setupData(data.ct);
			updateInfo();
		}
		
		private function onSecc(data:Object):void{
			setupData(data);
			updateInfo();
		}
		
		
		private function setupData(data:Object):void{
			if(data.zhongQiuHdStatus == 1){
				iconType = 0;
				count =  data.zhongQiuReceiveCount;
				setVsb(true);
				updateInfo();
			}else if(data.jiaoShiHdStatus == 1){
				count =  data.jiaoShiReceiveCount;
				iconType = 1;
				setVsb(true);
				updateInfo();
			}else{
				setVsb(false);
			}
		}
			
		
		
		private function setVsb(show:Boolean):void{
			this.visible = show;
		}
		/**
		 *socket消息 
		 * 
		 */		
		public function updateInfo():void{
			if(iconType == 0){
				iconC.setIcon(new Icon_yuebing());
			}else{
				iconC.setIcon(new Icon_xrk());
			}
			iconC.updateLabel("<font color='#FFFFFF' size='20'>"+count+"</font>");
			iconC.x = -iconC.width;
		}

	}
}
