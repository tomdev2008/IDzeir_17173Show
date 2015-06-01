package  com._17173.flash.show.base.module.gamelink
{
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.components.common.VScrollPanel;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.components.common.Grid9Skin;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 *游戏链接 
	 * @author zhaoqinghao
	 * 
	 */
	public class GameLinkPanel extends VScrollPanel
	{
		private var _gameList:VGroup;
		
		private const GAME_URL:String = "assets/img/game/";

		//推荐游戏冒泡提示间隔
		private const REPEAT_TIME:uint = 15 * 60000;
		
		public function GameLinkPanel(parent:DisplayObjectContainer=null)
		{
			super(parent);
			this.sliderSkin(new Grid9Skin(Slider_thumb));
			this.vScrollbar.bglayerAlpha = 0;
			initDate();
			createItem();
		}
		
		private var _datas:Array;
		private var _items:Array;
		private static const COLCOUNT:int = 2;
		private static const COL_SPACE:int = 173;
		private static const ROW_SPACE:int = 53;
		private function initDate():void{
			_datas = [];
			var games:Array = Context.variables["conf"]["games"];
			//trace("游戏",JSON.stringify(games));			
			//var obj:Object = {label:"四大美女",link:"http://v.17173.com/show/open/togame.action?gt=0"/*,icon:new Icon_link1_1_8()*/,jk:"0"};
			//var obj1:Object = {label:"水果转转转",link:"http://v.17173.com/show/open/togame.action?gt=1"/*,icon:new Icon_link2_1_8()*/,jk:"1"};
			//var obj2:Object = {label:"六大名驹",link:"http://v.17173.com/show/open/togame.action?gt=2"/*,icon:new Icon_link3_1_8()*/,jk:"2"};
			try{
				_datas = games.concat();
			}catch(e:Error){
				Debugger.log(Debugger.ERROR,"[game] 游戏配置错误 at 'conf.json'");
				_datas = [];
			}	
			_datas.push({label:"疯狂砸蛋",link:SEvents.CHAT_GAME_CLICK});
		}
		
		private function createItem():void{
			_gameList = new VGroup();
			_gameList.gap = 0;
			//_gameList.left = 10;
			_gameList.align = VGroup.LEFT;
			
			 var btn:BitmapMovieClip; 
			 var len:int = _datas.length;
			 
			 var gir:GameItemRender;
			 
			 for (var i:int = 0; i < len; i++) 
			 {
				 var obj:Object = _datas[i];
				 btn = new BitmapMovieClip(true,352,160);//(obj.label,obj.icon,obj.link,obj.jk);
				 btn.url = GAME_URL + "game"+i+".png";
				 obj.icon = GAME_URL + "gameIcon"+i+".png";
				 gir = new GameItemRender(obj.link);
				 gir.game = btn;
				 _gameList.addChild(gir);
			 }
			 this.addChild(_gameList);			 
			 Ticker.tick(REPEAT_TIME,function():void
			 {
				 var r:uint = Math.random()*_datas.length;
				 (Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.GAME_SHOW_TIPS,_datas[r]);
			 },-1);
		}
	}
}