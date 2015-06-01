package  com._17173.flash.show.base.module.topbar.view
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.module.topbar.view.messages.GlobalMessageSprite;
	import com._17173.flash.show.base.module.topbar.view.messages.base.GlobalMessageBase;
	import com._17173.flash.show.base.module.topbar.view.messages.base.IGlobalMessageShow;
	import com._17173.flash.show.base.module.topbar.view.messages.factory.GlobalMessageFactory;
	import com._17173.flash.show.base.module.topbar.view.messages.factory.IGlobalMessageFactory;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;

	/**
	 *全局礼物消息展示 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CenterGlobalPane extends BaseContainer
	{
		private var _showing:Boolean = false;
		private var _currentShow:DisplayObject = null;
		/**
		 *等待时间 
		 */		
		private var _showTime:int = 1000;
		private var _xsTime:int = 550;
		private var _showed:Boolean = false;
		private var _messages:Array = [];
		private var _offextX:int = 0;
		private var _msgFactory:IGlobalMessageFactory;
		public function CenterGlobalPane(showTime:int = 1000)
		{
			_showTime = showTime;
			super();
			this.width = 1890;
			this.height = 35;
			this.graphics.endFill();
			this.mouseEnabled = false;
			_msgFactory = new GlobalMessageFactory();
		}
		
		public function get offextX():int
		{
			return _offextX;
		}

		public function set offextX(value:int):void
		{
			_offextX = value;
			onRePosition();
		}

		public function addMessage(msg:Object):void{
			_messages.push(msg);
			showNext();
		}
		
		
		private function showNext():void{
			if(_currentShow == null){
				var roomId:String = (Context.variables["showData"] as ShowData).roomID;
//				_currentShow = getMesstByGift(_messages.shift(),roomId);
				_currentShow = getMessageByNew(_messages.shift(),roomId) as GlobalMessageBase;
				_currentShow.x = Math.max(_offextX,((this.width+-40) - _currentShow.width )/2);
				_currentShow.y = -20;
				this.addChild(_currentShow);
				_currentShow.alpha = 0;
				onshow();
			}
		}
		
		override protected function onRePosition():void{
			super.onRePosition();
			if(_currentShow){
				_currentShow.x = Math.max(_offextX,((this.width+-40) - _currentShow.width )/2);
			}
		}
		
		
		
		
		private function onshow(data:Object = null):void{
			_showed = false;
			if(_currentShow is InteractiveObject){
				(_currentShow as InteractiveObject).mouseEnabled = true;
			}
			TweenLite.to(_currentShow,_xsTime/1000,{alpha:.9,onComplete:startWait});
		}
		
		private function startWait():void{
			if(_showed){
				if(_messages.length > 0){
					Ticker.tick(_showTime/50,runEff,1,true);
				}else{
					Ticker.tick(_showTime/50,startWait,1,true);
				}
			}else{
				_showed = true;
				Ticker.tick(_showTime,startWait);
			}
		}
		
		private function runEff(data:Object = null):void{
			
			if(_currentShow is InteractiveObject){
				(_currentShow as InteractiveObject).mouseEnabled = false;
			}
			TweenLite.to(_currentShow,_xsTime/1000,{alpha:0,onComplete:onEffEnd});
		}
		
		private function onEffEnd():void{
			this.removeChild(_currentShow);
			_currentShow = null;
			if(_currentShow is GlobalMessageSprite){
				_msgFactory.returnMessage((_currentShow as GlobalMessageSprite));
			}
			showNext();
		}
		
		private function getMessageByNew(data:Object,roomId:String):IGlobalMessageShow{
			var cRid:String = data.roomId;
			var linkshow:Boolean = false;
			if(Util.validateStr(data.url) && data.url!=null && roomId != cRid){
				linkshow = true;
			}
			var msg:IGlobalMessageShow = _msgFactory.getMessageByType(data);
			msg.updateInfo(data,linkshow);
			return msg;
		}
		
		private function getMesstByGift(data:Object,roomId:String):DisplayObject{
			var text:DisplayObject;
			var str:String = "";
			if(data != null){
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				var sName:String = data.sName;
				var sNo:String = data.sNo;
				var tName:String = data.tName;
				var tNo:String = data.tNo;
				var gName:String = data.giftName;
				var count:String = data.giftCount;
				var path:String = data.giftPicPath;
				var link:String = data.url;
				var cRid:String = data.roomId;
				
				var gto:GraphicTextOption = new GraphicTextOption();
				gto.linkColor = 0xffffff;
				
				var sTitleE:GraphicTextElement = textManager.createElement();
				sTitleE.content = "送礼跑道：";
				sTitleE.type = GraphicTextElementType.Element_TEXT;
				sTitleE.color = 0xCCCCCC;
				//				str = sName + "送给" + tName + count + "个" + gName;
				var sNameE:GraphicTextElement = textManager.createElement();
				sNameE.content ="[" +  sName  + "]" + " 送给 " + "[" + tName + "]" + " "+count + "个 " + gName+" ";
				if(Util.validateStr(data.url) && data.url!=null && roomId != cRid){
					sNameE.type = GraphicTextElementType.Element_TEXT;
					sNameE.link = link;
					gto.link = link;
					gto.unline = true
				}else{
					sNameE.type = GraphicTextElementType.Element_TEXT;
				}
				sNameE.color = 0x63ACFF;
				
				//				var sg:GraphicTextElement = textManager.createElement();
				//				sg.content = " 送给 ";
				//				sg.type = GraphicTextElementType.Element_TEXT;
				//				sg.color = 0x2B075E;
				//				
				//				var tNameE:GraphicTextElement = textManager.createElement();
				//				tNameE.content ="[" + tName + "]";
				//				tNameE.type = GraphicTextElementType.Element_TEXT;
				//				tNameE.color = 0x63ACFF;
				//				
				//				var countE:GraphicTextElement = textManager.createElement();
				//				countE.content = " "+count;
				//				countE.type = GraphicTextElementType.Element_TEXT;
				//				countE.color = 0x63ACFF;
				//				
				//				var ges:GraphicTextElement = textManager.createElement();
				//				ges.content = "个 ";
				//				ges.type = GraphicTextElementType.Element_TEXT;
				//				ges.color = 0x63ACFF;
				//				
				//				var gNameE:GraphicTextElement = textManager.createElement();
				//				gNameE.content = gName;
				//				gNameE.type = GraphicTextElementType.Element_TEXT;
				//				gNameE.color = 0x63ACFF;
				
				var gNameE:GraphicTextElement = textManager.createElement();
				gNameE.content = path;
				gNameE.type = GraphicTextElementType.Element_URL;
				
				text = textManager.createGraphicText([sTitleE,sNameE,gNameE],gto);
			}
			return text;
		}
		
	}
}