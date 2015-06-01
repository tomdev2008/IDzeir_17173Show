package com._17173.flash.show.base.module.topbar.view.messages
{
	import com._17173.flash.show.base.module.topbar.view.messages.base.GlobalMessageBase;
	import com._17173.flash.show.base.utils.Utils;
	
	public class GlobalMessageYanhua extends GlobalMessageBase
	{
		public function GlobalMessageYanhua()
		{
			super();
			_limieWidth = 110;
		}
		override protected function setupInfo():void{
			if(lvlIcon.parent){
				lvlIcon.parent.removeChild(lvlIcon);
			}
			if(giftIcon.parent){
				giftIcon.parent.removeChild(giftIcon);
			}
			giftIcon = Utils.getURLGraphic(infos.giftPicPath);
			lvlIcon = Utils.getRichIcon(infos.userFunLvl);
			
			showSp.addChild(lvlIcon);
			showSp.addChild(giftIcon);
			sName = infos.sName;
			tname = infos.tName;
			gName = "<font color='#63D3FF' size='16'> 在  </font>";
			otCount = "<font color='#63D3FF' size='16'> 房间点燃  </font><font color='#FFFF00' size='16'>" + infos.giftCount + " </font>" + "<font color='#63D3FF' size='16'>个" + infos.giftName + "</font>";
			otLabel.htmlText = otCount;
			otLabel.width = otLabel.textWidth + 4;
			sgLabel.htmlText = gName;
			sgLabel.width = sgLabel.textWidth + 4;
			//超过则截取一半
			if(!checkLen(sName)){
				sLabel.htmlText = "<font color='#FFFFFF' size='16'>" + sName.slice(0,sName.length/2) + "...</font>";
			}else{
				sLabel.htmlText = "<font color='#FFFFFF' size='16'>" + sName + "</b></font>";
			}
			sLabel.width = sLabel.textWidth + 4;
			_ui.registerTip(sLabel,sName);
			//超过则截取一半
			if(!checkLen(tname)){
				tLabel.htmlText = "<font color='#FFFFFF' size='16'>" + tname.slice(0,tname.length/2) + "...</font>";
			}else{
				tLabel.htmlText = "<font color='#FFFFFF' size='16'>" + tname+ "</font>";
			}
			tLabel.width = tLabel.textWidth + 4;
			_ui.registerTip(tLabel,tname);
			
			timeLabel.htmlText = "<font color = '#63D3FF'>(" + infos.time +  ")</font>";
			timeLabel.width = timeLabel.textWidth + 4;
			//排版
			lvlIcon.x = 0;
			lvlIcon.y = 30;
			
			sLabel.x = lvlIcon.x + lvlIcon.width;
			sLabel.y = lvlIcon.y;
			
			sgLabel.x = sLabel.x + sLabel.width;
			sgLabel.y = lvlIcon.y;
			
			tLabel.x = sgLabel.x + sgLabel.width;
			tLabel.y = lvlIcon.y;
			
			otLabel.x = tLabel.x + tLabel.width;
			otLabel.y = lvlIcon.y;
			
			giftIcon.x = otLabel.x + otLabel.width;
			giftIcon.y = lvlIcon.y;
			
			timeLabel.x = giftIcon.x + giftIcon.width;
			timeLabel.y = lvlIcon.y;
			
			showSp.x = (this.width - showSp.width)/2
		}
	}
}