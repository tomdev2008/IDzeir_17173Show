package com._17173.flash.player.context
{
	import com._17173.flash.core.ad.AdEnum;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 获取播放器广告位的配置
	 * @author 安庆航
	 * 
	 */	
	public class AdPosition
	{
		/**
		 * 获取播放器广告位的配置
		 */		
		public static function getPosition():Object {
			var re:Object = {};
			switch(Context.variables["type"]) {
//				case Settings.PLAYER_TYPE_FILE_ZHANEI:
				case PlayerType.F_ZHANEI:
					re[AdEnum.A1] = true;
					re[AdEnum.A2] = {"third":true};
					re[AdEnum.A3] = {"third":true};
					re[AdEnum.A4] = true;
					re[AdEnum.A5] = true;
					break;
//				case Settings.PLAYER_TYPE_FILE_ZHANWAI:
				case PlayerType.F_ZHANWAI:
					re[AdEnum.A2] = true;
					re[AdEnum.A3] = true;
					break;
//				case Settings.PLAYER_TYPE_STREAM_FIRST_PAGE:
				case PlayerType.S_SHOUYE:
					re[AdEnum.A2] = {"third":true};
					re[AdEnum.A3] = {"third":true};
					break;
//				case Settings.PLAYER_TYPE_STREAM_ZHANNEI:
				case PlayerType.S_ZHANNEI:
					re[AdEnum.A1] = true;
					re[AdEnum.A2] = {"third":true};
					re[AdEnum.A3] = {"third":true};
					break;
//				case Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM:
				case PlayerType.S_CUSTOM:
					re[AdEnum.A2] = true;
					re[AdEnum.A3] = true;
					break;
//				case Settings.PLAYER_TYPE_FILE_OUT_CUSTOM:
				case PlayerType.F_CUSTOM:
					re[AdEnum.A2] = true;
					re[AdEnum.A3] = true;
					break;
				default: 
					re[AdEnum.A1] = true;
					re[AdEnum.A2] = {"third":true};
					re[AdEnum.A3] = {"third":true};
					re[AdEnum.A4] = true;
					re[AdEnum.A5] = true;
			}
			return re;
		}
	}
}