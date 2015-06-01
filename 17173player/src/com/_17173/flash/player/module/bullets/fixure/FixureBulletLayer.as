package com._17173.flash.player.module.bullets.fixure
{
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.player.module.bullets.base.Bullet;
	import com._17173.flash.player.module.bullets.base.BulletConfig;
	import com._17173.flash.player.module.bullets.base.BulletData;
	import com._17173.flash.player.module.bullets.base.BulletLayer;
	import com._17173.flash.player.module.bullets.base.BulletLine;

	/**
	 * 固定位置弹幕 
	 * @author zhaoqinghao
	 * 
	 */
	public class FixureBulletLayer extends BulletLayer
	{
		public function FixureBulletLayer()
		{
			super();
		}
		/**
		 *初始化放置类型 
		 * 
		 */		
		override protected function initSetBullteTypes():void{
			_setBulletTypes[0] = BulletConfig.BULLETTYPE_FIXURE_TOP;
		}
		/**
		 * 检查弹幕是否已经移出当前这条线上了
		 * 当一条弹幕的尾部超过屏幕右侧的时候,则认为该条弹幕已经移出这条线,这条线的occupation为false
		 *  
		 * @param bullet
		 */		
		override protected function checkLineOccupation(bullet:Bullet):void {
			var line:BulletLine = getLineByIndex(bullet.lineIndex);
			//固定弹幕需要判断其是否已经消失了，否则不能再当前line添加新弹幕
			if (line && line.isBulletOccupationed(bullet) && bullet.isTimeToDisappear) {
				line.getOccupation(bullet);
				bullet.lineIndex = -1;
			}
		}
		
		override public function destroy():void{
			clear();
			this.parent.removeChild(this);
			SimpleObjectPool.getPool(FixureBullet).destroyAll();
			SimpleObjectPool.getPool(BulletData).destroyAll();
			while (this.numChildren) {
				this.removeChildAt(0);
			}
		}
		/**
		 *设置弹幕初始位置 
		 * 
		 */		
		override protected function initBulltePosition(bullet:Bullet,line:BulletLine):void{
			bullet.y = getCurrentLineHeight(line) + 2;
			bullet.x = (stage.stageWidth - bullet.width)/2;
		}
		
		override protected function returnBullet(bullet:Bullet):void{
			SimpleObjectPool.getPool(FixureBullet).returnObject(bullet);
		}
		
		override protected function getBullet():Bullet{
			return SimpleObjectPool.getPool(FixureBullet).getObject() as FixureBullet;
		}
	
	}
}