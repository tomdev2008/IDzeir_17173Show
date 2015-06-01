package  com._17173.flash.show.base.module.activity.acts.qrj
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.module.activity.base.IAct2Link;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ACT_Rank_QRJ extends Sprite implements IAct2Link
	{
		public function ACT_Rank_QRJ(closeBack:Function)
		{
			super();
			initMc();
			initclose();
			closeback = closeBack
		}
		
		public function get link():String
		{
			// TODO Auto Generated method stub
			return "http://v.17173.com/act/show/2015/valentine.shtml";
		}
		
		private var closeback:Function;		
		private var rankMc:MovieClip;
		private var closeBtn:Button;
		public static var rCount:int = 0;
		public static var sCount:int = 0;
		
		private function initMc():void{
			rankMc = new Act_rank_qrj();
			this.addChild(rankMc);
		}
		
		private function initclose():void{
			closeBtn = new Button();
			closeBtn.setSkin(new Act_closeBtn_qrj());
			closeBtn.x = rankMc.width - closeBtn.width - 5;
			closeBtn.y = 3;
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			this.addChild(closeBtn);
			
			this.rankMc.LinkTo.addEventListener(MouseEvent.CLICK,onLink);
		}
		
		protected function onLink(event:MouseEvent):void{
			var url:String = link;
			if(url){
				Util.toUrl(url);
			}
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
			if(data.hasOwnProperty("longJieCount")){
				rCount = data.longJieCount;
				sCount = data.fengJieCount;
				updateCount();
			}
			var reData:Array = data.longJieList;
			var sendData:Array = data.fengJieList;
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
			rankMc["seCount"].text = sCount;
		}
	}
}