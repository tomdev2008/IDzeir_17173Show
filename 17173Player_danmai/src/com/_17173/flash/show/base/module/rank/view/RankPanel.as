package com._17173.flash.show.base.module.rank.view
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.TabBar;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.Sprite;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	
	public class RankPanel extends Sprite
	{
		
		/**
		 *service 
		 */		
		private var _s:IServiceProvider = null;
		
		/**
		 *tabbar 
		 */		
		private var tabBar:TabBar;
		
		/**
		 *列表 
		 */		
		private var list:RankList;
		
		public function RankPanel()
		{
			super();
			
			var bg:RankBG = new RankBG();
			this.addChild(bg);
			
			var titleTF:Label = new Label();
			titleTF.x = 57;
			titleTF.y = 3;
			titleTF.defaultTextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 14 ,0xffcc01, false);
			titleTF.text = "排行";
			this.addChild(titleTF);
			
//			tabBar = new TabBar(RankTabButton);
//			tabBar.gap = 0;
//			tabBar.x = 4;
////			tabBar.dataProvider = new <Object>[{id:0, label:"排行"}, {id:1, label:"周榜"}, {id:2, label:"总榜"}];
//			tabBar.dataProvider = new <Object>[{id:0, label:"排行"}];
//			this.addChild(tabBar);
			
			list = new RankList();
			list.itemRenderer = RankListItemRender;
			list.y = 40;
			list.x = 6;
			this.addChild(list);
			
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			sendMessage();
			Ticker.tick(1000 * 3600, sendMessage, -1);
		}
		
		/**
		 *发送请求
		 */		
		private function sendMessage():void
		{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.liveId != 0)
			{
				var url:URLVariables = new URLVariables();
				url["liveId"] = liveInfo.liveId;
				url["masterId"] = liveInfo.masterId;
				url["result"] = "json";
				_s.http.getData(SEnum.PD_NAME, url, update, fail, true);
			}
			else
			{
				update(null);
			}
		}
		
		/**
		 *更新排行数据 
		 * @param data
		 */		
		public function update(data:Object):void
		{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(!data || !liveInfo || liveInfo.liveId == 0) 
			{
				list.data = [null, null, null, null, null];
//				list.data = [{fromNickname:"测试", sum:999}, {fromNickname:"测试", sum:999}, {fromNickname:"测试", sum:999}, {fromNickname:"测试", sum:999}, {fromNickname:"测试", sum:999}];
				return;
			}
			
			var arr:Array = data[liveInfo.masterId];
			arr = arr.slice(0, Math.min(5, arr.length));
			list.data = arr;
		}
		
		/**
		 *请求失败 
		 * @param data
		 */		
		private function fail(data:Object):void
		{
		}
	}
}