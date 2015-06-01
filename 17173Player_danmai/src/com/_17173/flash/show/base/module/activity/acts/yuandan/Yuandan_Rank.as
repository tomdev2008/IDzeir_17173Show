package com._17173.flash.show.base.module.activity.acts.yuandan
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Yuandan_Rank extends Sprite
	{
		public function Yuandan_Rank(closeBack:Function)
		{
			super();
			initMc();
			initclose();
			closeback = closeBack
		}
		private var closeback:Function;		
		private var rankMc:MovieClip;
		private var closeBtn:Button;
		public static var rCount:int = 0;
		
		private function initMc():void{
			rankMc = new Act_list();
			this.addChild(rankMc);
		}
		
		private function initclose():void{
			closeBtn = new Button();
			closeBtn.setSkin(new Act_CloseBtn());
			closeBtn.x = rankMc.width - closeBtn.width - 5;
			closeBtn.y = -5;
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			this.addChild(closeBtn);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(closeback != null){
				closeback();
			}
		}
		
		public function setDate(data:Object):void{
			//设置当前主播
			if(data.hasOwnProperty("myReceive")){
				rCount = data.myReceive;
				updateCount();
			}
			var reData:Array = data.receiveList;
			var sendData:Array = data.sendList;
			var len:int = 3;
			var obj:Object;
			for (var i:int = 0; i < len; i++) 
			{
				obj = reData[i];

				rankMc["mName"+(i+1)].text
					= obj.nickName;
				rankMc["mCount"+(i+1)].text = obj.count;
				
				obj = sendData[i];
				rankMc["uName"+(i+1)].text = obj.nickName;
				rankMc["uCount"+(i+1)].text = obj.count;
			}
		}
		
		public function updateCount():void{
			rankMc["tcLabel"].text = rCount + "个";
		}
	}
}