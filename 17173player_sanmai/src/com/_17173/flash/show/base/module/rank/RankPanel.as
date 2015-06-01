package com._17173.flash.show.base.module.rank
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;
	
	public class RankPanel extends Sprite
	{
		private var _s:IServiceProvider = null;
		private var _rankList:RankList;
		private var sprite:Sprite;
		private var array:Array = new Array();
		public function RankPanel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		}
		
		private function addToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			_rankList = new RankList();
			_rankList.x = 0;
			_rankList.y = 0;
			this.addChild(_rankList);
			sprite = new Sprite();
			this.addChild(sprite);
			addList();
			
			sendNameMessage();
			Ticker.tick(1000 * 3600,sendNameMessage,-1);
		}
		
		private function sendNameMessage():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.liveId != 0){
				var url:URLVariables = new URLVariables();
				url["liveId"] = liveInfo.liveId;
				url["masterId"] = liveInfo.masterId;
				url["result"] = "json";
				_s.http.getData(SEnum.PD_NAME, url, update, fail, true);
			}
		}
		public function update(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.liveId != 0){
				if(data){
					if(data[liveInfo.masterId]){
						var dataArray:Array = data[liveInfo.masterId] as Array;
						if(dataArray.length > 0){
							updateList(dataArray);
						}else{
							revertList();
						}
//						_nameText.text = HtmlUtil.decodeHtml(data[liveInfo.masterId].fromNickname);
//						_nameBg.visible = true;
					}else{
						revertList();
					}
				}else{
					revertList();
				}
			}else{
				revertList();
			}
		}
		
		private function fail(data:Object):void{
			trace();
		}
		
		private function updateList(dataArray:Array):void{
			for each(var rank:RankItemRender in array){
				var obj:Object = dataArray.shift();
				if(obj){
					rank.update({"fromNickname":HtmlUtil.decodeHtml(obj.fromNickname),"money":obj.sum});
				}else{
					rank.update({"fromNickname":"","money":""});
				}
				
			}
		}
		
		public function revertList():void{
			for each(var rank:RankItemRender in array){
				rank.update({"fromNickname":"","money":""});
			}
		}
	
		private function addList():void{
			for(var i:int = 0;i<=4;i++){
				var rankRender:RankItemRender = new RankItemRender(i);
				rankRender.x = 0;
				rankRender.y = 32 + i* 36;
				sprite.addChild(rankRender);
				array.push(rankRender);
			}
		}
	}
}