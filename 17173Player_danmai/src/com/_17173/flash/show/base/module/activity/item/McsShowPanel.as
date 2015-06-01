package com._17173.flash.show.base.module.activity.item
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	

	/**
	 *圣诞节活动板子 
	 * @author zhaoqinghao
	 * 
	 */	
	public class McsShowPanel extends Sprite
	{
		public function McsShowPanel()
		{
			super();
			panelMc = new Act_msPanel();
			closeBtn = new Button();
			closeBtn.setSkin(new Act_msClose());
			closeBtn.x = panelMc.width - closeBtn.width - 5;
			closeBtn.y = 30;
			this.addChild(panelMc);
			this.addChild(closeBtn);
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		public var CloseBack:Function;
		
		protected function onClose(event:MouseEvent):void
		{
//			if(this.parent){
//				this.parent.removeChild(this);
//				isClose = true;
//				if(CloseBack){
//					CloseBack();
//				}
//			}
			isClose = true;
			if(CloseBack!=null){
				CloseBack();
			}
		}
		public var isClose:Boolean = false;
		private var panelMc:MovieClip;
		private var closeBtn:Button;
		/**
		 *装载数据 
		 * @param data
		 * 
		 */		
		private var _coorArray:Array = [116,149,187];
		public function updataData(data:Object):void{
			var keys:Array = ["giftName","giftCoung","nameLvl1","nameLvl2","nameLvl3"];
			var datas:Array = data.hdData;
			for (var i:int = 0; i < datas.length; i++) 
			{
				var mdata:Object = datas[i]	;
				var idx:int = i+1;
				panelMc[keys[0] + idx].text = mdata.giftName;
				panelMc[keys[1] + idx].text = mdata.giftCount;
				getString(panelMc[keys[2] + idx],mdata.commonStatus,_coorArray[0]);
				getString(panelMc[keys[3] + idx],mdata.silverStatus,_coorArray[1]);
				getString(panelMc[keys[4] + idx],mdata.goldStatus,_coorArray[2]);
			}
			
		}
		
		private function getString(txt:TextField,stat:int,ty:int):void{
			var result:String = "";
			if(stat < 0){
				txt.text = "已完成";
				txt.height = txt.textHeight + 5;
				txt.y = ty + 5;
			}else{
				txt.multiline = true;
				txt.height = 60;
				txt.htmlText = "尚未完成 \n 还差<font color='#FFFF00'>"+stat + "</font>个";
				txt.y = ty - 3;
			}
		}
		
	}
}