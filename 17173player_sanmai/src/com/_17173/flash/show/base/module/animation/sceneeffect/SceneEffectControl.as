package com._17173.flash.show.base.module.animation.sceneeffect
{
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	
	import flash.events.Event;

	/**
	 *屏幕特效控制器
	 * @author zhaoqinghao
	 *
	 */
	public class SceneEffectControl extends BaseAmtControl
	{
		public function SceneEffectControl(type:String, parentLayer:IAnimactionLayer)
		{
			super(type, parentLayer);
		}
		/**
		 *添加数据 
		 * @param data
		 * 
		 */		
		override public function addData(data:IAnimationPlay):void{
			data.loadAnimation();
			_datas.push(data);
		}

		override public function run(e:Event = null):void
		{
			var len:int = _datas.length;
			for (var i:int = 0; i < len; i++) 
			{
				var obj:IAnimationPlay = _datas[i] as IAnimationPlay;
				if(obj){
					obj.run();
				}
			}
			
		}
	}

}
