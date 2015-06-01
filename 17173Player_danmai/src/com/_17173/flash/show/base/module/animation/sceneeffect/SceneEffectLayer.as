package  com._17173.flash.show.base.module.animation.sceneeffect
{
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	
	public class SceneEffectLayer extends BaseAnimationLayer
	{
		public function SceneEffectLayer()
		{
			super();
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		/**
		 *添加动画 
		 * @param aData
		 * 
		 */		
		override public function addAnimation(aData:IAnimationPlay):void{
			var type:String = aData.type;
			switch(type)
			{
				case AnimationType.ATYPE_SCENE_CE: //嫦娥动画位置
				{
					aData.mc.x = 865;
					aData.mc.y = 160;
					break;
				}
				case AnimationType.ATYPE_SCENE_TS: //嫦娥动画位置
				{
					aData.mc.x = 1165;
					aData.mc.y = 305;
					break;
				}
				default:
				{
					aData.mc.x = 1225;
					aData.mc.y = 50;
					break;
				}
			}
			this.addChild(aData.mc);
		}
	}
}

