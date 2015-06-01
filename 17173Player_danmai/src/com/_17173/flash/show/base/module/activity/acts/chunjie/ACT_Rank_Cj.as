package  com._17173.flash.show.base.module.activity.acts.chunjie
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ACT_Rank_Cj extends Sprite
	{
		
//		http://v.17173.com/act/show/2015/springFestival.html
		public function ACT_Rank_Cj(closeBack:Function)
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
		public static var sCount:int = 0;
		
		private function initMc():void{
			rankMc = new Act_rank_cj();
			this.addChild(rankMc);
		}
		
		private function initclose():void{
			closeBtn = new Button();
			closeBtn.setSkin(new Act_closeBtn_qrj());
			closeBtn.x = rankMc.width - closeBtn.width  + 5;
			closeBtn.y = 3;
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			this.addChild(closeBtn);
			
//			this.rankMc.LinkTo.addEventListener(MouseEvent.CLICK,onLink);
		}
		
		protected function onLink(event:MouseEvent):void{
			
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
				if(obj){
					rankMc["rName"+(i+1)].text = obj.nickName;
					rankMc["rCount"+(i+1)].text = obj.count;
				}else{
					rankMc["rName"+(i+1)].text = "";
					rankMc["rCount"+(i+1)].text = "";
				}
				
				obj = sendData[i];
				if(obj){
					rankMc["sName"+(i+1)].text = obj.nickName;
					rankMc["sCount"+(i+1)].text = obj.count;
				}else{
					rankMc["sName"+(i+1)].text = "";
					rankMc["sCount"+(i+1)].text = "";
				}
			}
		}
		
		public function updateCount():void{
			rankMc["reCount"].text = rCount;
		}
	}
}