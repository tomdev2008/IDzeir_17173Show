package com._17173.flash.player.module.bullets.fixure
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.bullets.base.Bullet;
	import com._17173.flash.player.module.bullets.base.BulletConfig;
	import com._17173.flash.player.module.bullets.base.BulletLine;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.events.Event;

	/**
	 *固定底部出现弹幕层（由下至上） 
	 * @author zhaoqinghao
	 * 
	 */
	public class FixureBottomBulletLayer extends FixureBulletLayer
	{
		public function FixureBottomBulletLayer()
		{
			super();
		}
		/**
		 *初始化放置类型 
		 * 
		 */		
		override protected function initSetBullteTypes():void{
			_setBulletTypes[0] = BulletConfig.BULLETTYPE_FIXURE_BOTTOM;
		}
		
		/**
		 *设置弹幕初始位置 
		 * 
		 */		
		override protected function initBulltePosition(bullet:Bullet,line:BulletLine):void{
			bullet.y = getCurrentLineHeight(line) + 2;
			bullet.x = (stage.stageWidth - bullet.width)/2;
		}
		
		
		override public function resize(e:Event=null):void {
			super.resize(e);
			updateAllLine();
		}
		
		/**
		 *更新位置 
		 * 
		 */		
		private function updateAllLine():void {
			if (_showedBullets) {
				var len:int = _showedBullets.length;
				var bullet:Bullet = null;
				var line:BulletLine = null
				for (var i:int = 0; i < len; i++) {
					bullet = _showedBullets[i];
					line = _lines[bullet.lineIndex]
					if (bullet && line) {
						initBulltePosition(bullet, line);
					}
				}
				
			}
		}
		/**
		 *设置坐标 
		 * 
		 */		
		override protected function rePostion():void{
			//全屏状态下向上移动topbar距离
			if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
				this.y = -Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.FULLSCREEN_TOP_BAR).display.height-5;
			}
			else {
				this.y = 0;
			}
		}
		/**
		 *固定位置层 由下至上计算位置
		 * @param line
		 * @return 
		 * 
		 */		
		override protected function getCurrentLineHeight(line:BulletLine):int {
			var lHeight:int = 0;
			var len:int = _lines.length;
			var tLine:BulletLine;
			for (var i:int = 0; i < len; i++) 
			{
				tLine = _lines[i] as BulletLine;
				if(line === tLine){
					break;
				}
				lHeight += tLine.lineHeight;
			}
			//用当前vieo高度减去行高度，在家去弹幕高度（取的平均值）
			lHeight = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight -  lHeight - 40;
			return lHeight;
		}
	}
}