package  com._17173.flash.show.base.module.gamelink
{
	import com._17173.flash.core.components.common.VScrollPanel;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 *游戏链接 
	 * @author zhaoqinghao
	 * 
	 */
	public class GameLinkPanel extends VScrollPanel
	{
		public function GameLinkPanel(parent:DisplayObjectContainer=null)
		{
			super(parent);
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
			var obj:Object = {label:"四大美女",link:"http://v.17173.com/show/open/togame.action?gt=0",icon:new Icon_link1(),jk:"0"};
			var obj1:Object = {label:"水果转转转",link:"http://v.17173.com/show/open/togame.action?gt=1",icon:new Icon_link2(),jk:"1"};
			var obj2:Object = {label:"名驹",link:"http://v.17173.com/show/open/togame.action?gt=2",icon:new Icon_link3(),jk:"2"};
			_datas[_datas.length] = obj;
			_datas[_datas.length] = obj1;
			_datas[_datas.length] = obj2;
		}
		
		private function createItem():void{
			 var btn:GameLinkButton; 
			 var len:int = _datas.length;
			 for (var i:int = 0; i < len; i++) 
			 {
				 var obj:Object = _datas[i];
				 btn = new GameLinkButton(obj.label,obj.icon,obj.link,obj.jk);
				 btn.x = (i%2) * COL_SPACE + 5;
				 btn.y = (Math.floor(i/2)) *  ROW_SPACE + 5;
				 this.addChild(btn);
			 }
			 
		}
		
	}
}