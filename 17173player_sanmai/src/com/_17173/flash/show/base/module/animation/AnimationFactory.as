package com._17173.flash.show.base.module.animation
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.base.module.animation.base.ResidentAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.Activity_ThreeTitleNormalAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.CACAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.CACBarAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.Double11Act;
	import com._17173.flash.show.base.module.animation.extAnimation.EnterAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.FlowerAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.FlowerMiniAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.ShowIconAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.ShowNameNormalAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.TechDayAnimation;
	import com._17173.flash.show.base.module.animation.extAnimation.TwoDayAnimation;
	import com._17173.flash.show.model.CEnum;

	/**
	 *动画工厂 
	 * @author zhaoqinghao
	 * 
	 */	
	public class AnimationFactory implements IAnimationFactory, IContextItem
	{
		public function AnimationFactory()
		{
			anims = [];
		}
		
		public function returnAmt(amt:IAnimationPlay):void
		{
			// TODO Auto Generated method stub
			anims[anims.length] = amt;
		}
		
		/**
		 *自己维护的对象池 
		 */		
		protected static var anims:Array = [];
		/**
		 *根据动画类型生成对应类（有的类型需要从对象池取） 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getAmdByType(type:String):IAnimationPlay{
			var ani:IAnimationPlay;
			switch(type)
			{
				case AnimationType.ATYPE_FLOWER:
				{
					ani = new FlowerAnimation();
					break;
				}
					
				case AnimationType.ATYPE_FLOWER_MINI:
				{
					ani = new FlowerMiniAnimation();
					break;
				}
					
				case AnimationType.GROUP_AM:
				{
					ani = new ShowIconAnimation();
					break;
				}		
					
				case AnimationType.ATYPE_CAC:
				{
					ani = SimpleObjectPool.getPool(CACAnimation).getObject();
					break;
				}
					
				case AnimationType.ATYPE_ENTER://入场动画
				{
					ani = SimpleObjectPool.getPool(EnterAnimation).getObject();
					break;
				}
					
				case AnimationType.ATYPE_CAC_LINE: //香槟鸡尾酒飘带
				{
					ani = new CACBarAnimation();
					break;
				}
					
				case AnimationType.ATYPE_TUZI://兔子
				{
					ani = new TwoDayAnimation();
					break;
				}
				case AnimationType.ATYPE_TECH: //教师节
				{
					ani = new TechDayAnimation();
					break;
				}
				case AnimationType.ATYPE_SCENE_TS: //天使动画
				{
					ani = new ResidentAnimation();
					break;
				}
				case AnimationType.ATYPE_SCENE_CE: //嫦娥
				{
					ani = new ResidentAnimation();
					break;
				}
				case AnimationType.ATYPE_GUOQING1: //嫦娥
				{
					ani = new Activity_ThreeTitleNormalAnimation();
					break;
				}
				case AnimationType.ATYPE_SCENE_TEST: //教师节
				{
					ani = new ResidentAnimation();
					break;
				}
				case AnimationType.ATYPE_D11: //教师节
				{
					ani = new Double11Act();
					break;
				}
				case AnimationType.ATYPE_SHOWNAME: //教师节
				{
					ani = new ShowNameNormalAnimation();
					break;
				}
				default:
				{
					ani = new AnimationPlay();
					break;
				}
			}
			return ani;
		}
		
		
		/**
		 *动画数据 
		 * @param url 动画地址
		 * @param type 动画类型 AnimationData.ATYPE_CAR 或 ATYPE_FLOWER
		 * 
		 */	
		public function getAmd(apath:String,atype:String,layer:IAnimactionLayer):IAnimationPlay{
			//从内部池查找是否有可用对象
			var ntd:IAnimationPlay = getAmdByPath(apath);
			//如果没有则新建对象
			if(ntd == null){
				ntd = getAmdByType(atype)
			}
			ntd.setup(apath,atype,layer);
			ntd.returned = false;
			return ntd;
		}
		
		/**
		 *查找池 
		 * @param url 地址
		 * @return 查找对象
		 * 
		 */		
		public function getAmdByPath(url:String):IAnimationPlay{
			var len:int = anims.length;
			var ani:AnimationPlay;
			for (var i:int = 0; i < len; i++) 
			{
				ani = anims[i];
				if(ani.url == url){
					anims.splice(i,1);
					return ani;
				}
			}
			return null;
		}
		
		public function get contextName():String
		{
			// TODO Auto Generated method stub
			return CEnum.ANIMATIONFACTORY;
		}
		
		public function startUp(param:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}