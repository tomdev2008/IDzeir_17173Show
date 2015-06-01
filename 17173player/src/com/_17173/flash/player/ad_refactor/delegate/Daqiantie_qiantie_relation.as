package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.context.ContextEnum;

	/**
	 * 大前贴和前贴的业务关系计算处理.
	 *  
	 * @author 庆峰
	 */	
	public class Daqiantie_qiantie_relation
	{
		
		public function Daqiantie_qiantie_relation()
		{
		}
		
		/**
		 * 根据大前贴和前贴之间的业务关系,获取单轮中优先的一个.
		 *  
		 * @param daqiantie 大前贴数据
		 * @param qiantie 前贴数据
		 * @param params 额外参数用来控制两者之间的关系
		 * @return 大前贴或者前贴数据
		 */		
		public static function getRelation(daqiantie:AdData_refactor, qiantie:AdData_refactor, params:Object):AdData_refactor {
//			// 互斥
//			return singleRoundByCookie(daqiantie, qiantie, params);
			// 按比率分配
//			return percentageDaqiantieQiantie(daqiantie, qiantie, params);
			// 动态比例.由投放同学控制round参数来进行概率计算
			return percentageDaqiantieQiantie2(daqiantie, qiantie);
		}
		
		/**
		 * 按比例分配.第三个参数代表了出现大前贴的优先级,从0-100.100表示完全优先大前贴,0表示完全优先前贴.因为只会有两个选择:大前贴或者前贴,所以0-100之间的值基本上可以代表两者出现的比率.加入传入80,即大前贴与前贴出现的概率为8:2.其他同理.</br>
		 * 用随机数取0-100中间的值与优先级进行比较得出优先级结果.
		 *  
		 * @param daqiantie 大前贴数据
		 * @param qiantie 前贴数据
		 * @param daqiantiePercentage 大前贴出现的比例,为0到100.100表示最大,也就是全部优先大前贴.
		 * @return 有大前贴并且几率满足出现大前贴,则返回大前贴.否则返回前贴.
		 */		
		protected static function percentageDaqiantieQiantie(daqiantie:AdData_refactor, qiantie:AdData_refactor, params:Object):AdData_refactor {
			var daqiantiePercentage:Number = Number(params);
			// 随机数乘以100后与优先级值进行比较.因为random方法的特殊性(<= 0, > 1),比率传0需要特殊处理一下
			daqiantiePercentage <= 0 ? daqiantiePercentage = -0.1 : daqiantiePercentage > 100 ? daqiantiePercentage = 100 : 0;
			var isDaqiantieFirst:Boolean = Math.random() * 100 <= daqiantiePercentage;
			
			// 大前贴优先并且有大前贴,肯定先播大前贴. 否则返回前贴
			if (isDaqiantieFirst && daqiantie) {
				return daqiantie;
			} else {
				return qiantie;
			}
		}
		
		/**
		 * 使用广告数据中的r参数计算展现比例
		 *  
		 * @param daqiantie
		 * @param qiantie
		 * @return 
		 */		
		protected static function percentageDaqiantieQiantie2(daqiantie:AdData_refactor, qiantie:AdData_refactor):AdData_refactor {
			var d1:int = daqiantie ? daqiantie.round : 0;
			var d2:int = qiantie ? qiantie.round : 0;
			
			return d1 ? 
					Math.random() <= (d1 / (d1 + d2)) ? 
						daqiantie ? daqiantie : qiantie 
							: qiantie 
								: qiantie;
		}
		
		/**
		 * 单轮互斥,通过so在客户端本地进行记录
		 *  
		 * @param daqiantie 大前贴数据
		 * @param qiantie 前贴数据
		 * @return 根据cookie进行互斥判断,以便在单个用户刷新的情况中,出现大前贴与前贴互斥出现的逻辑.
		 */		
		protected static function singleRoundByCookie(daqiantie:AdData_refactor, qiantie:AdData_refactor, params:Object):AdData_refactor {
			var cookieKey:String = String(params);
			var r:AdData_refactor = null;
			if (daqiantie && qiantie) {
				// 使用之前的逻辑进行互斥
				var flag:int = _(ContextEnum.SETTING).getCookie(cookieKey);
				if (flag == 2) {
					r = qiantie;
					_(ContextEnum.SETTING).saveCookie(cookieKey, 1);
				} else {
					r = daqiantie;
					_(ContextEnum.SETTING).saveCookie(cookieKey, 2);
				}
			} else {
				r = daqiantie ? daqiantie : qiantie ? qiantie : null;
			}
			return r;
		}
		
	}
}