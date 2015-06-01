package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.BaseShowStage;
	import com._17173.flash.show.base.module.activity.ActivityDelegate;
	import com._17173.flash.show.base.module.ad.AdDelagate;
	import com._17173.flash.show.base.module.animation.duang.DuangDelegate;
	import com._17173.flash.show.base.module.animation.entereffect.EnterEffectDelegate;
	import com._17173.flash.show.base.module.animation.flowermini.FlowerMiniDelegate;
	import com._17173.flash.show.base.module.animation.sceneeffect.SceneEffectDelegate;
	import com._17173.flash.show.base.module.animation.stageeffect.StageEffectDelegate;
	import com._17173.flash.show.base.module.bag.BagDelegate;
	import com._17173.flash.show.base.module.chat.ChatPanelDelegate;
	import com._17173.flash.show.base.module.dingyue.SubscribeDelegate;
	import com._17173.flash.show.base.module.enterRoom.EnterRoomDelegate;
	import com._17173.flash.show.base.module.flyscreen.FlyScreenDelegate;
	import com._17173.flash.show.base.module.gameact.GameActDelegate;
	import com._17173.flash.show.base.module.gift.GiftDelegate;
	import com._17173.flash.show.base.module.guidetask.GuideTaskDegelete;
	import com._17173.flash.show.base.module.horn.HornDelegate;
	import com._17173.flash.show.base.module.leftbar.LeftBarDelegate;
	import com._17173.flash.show.base.module.lobby.LobbyDelegate;
	import com._17173.flash.show.base.module.login.LoginDelegate;
	import com._17173.flash.show.base.module.qm.QmDeletegate;
	import com._17173.flash.show.base.module.rank.RankDelegate;
	import com._17173.flash.show.base.module.responsetest.ResponseTestDeletegate;
	import com._17173.flash.show.base.module.roomset.RoomSetDelegate;
	import com._17173.flash.show.base.module.scene.SceneDelegate;
	import com._17173.flash.show.base.module.seat.SeatAreaDelegate;
	import com._17173.flash.show.base.module.smileres.SmilePanelDelegate;
	import com._17173.flash.show.base.module.stat.StatDelegate;
	import com._17173.flash.show.base.module.topbar.TopBarDelegate;
	import com._17173.flash.show.base.module.userCard.UserCardDelegate;
	import com._17173.flash.show.base.module.userlist.UserListDelegate;
	import com._17173.flash.show.base.module.video.base.SimpleMicManager;
	import com._17173.flash.show.danmai.authority.AuthoritySingle;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.PEnum;
	import com._17173.flash.show.module.preview.SimplePreviewDelegate;
	import com._17173.flash.show.module.video.SimpleVideoDelegate;
	
	/**
	 * 三麦房项目入口类
	 *
	 * @author shunia-17173
	 */
	[Frame(factoryClass="com._17173.bussnise.main.DanmaiBootstrap")]
	[SWF(frameRate="24", backgroundColor="0x000000")]
	public class DanmaiMain extends BaseShowStage
	{
		
		public function DanmaiMain()
		{
			super();
		}
		
		override protected function init():void {

	    	_version = "单麦房 版本号:201503181624";

			super.init();
		}
		
		/**
		 * 注册Context类 
		 */		
		override protected function addContext():void {
			super.addContext();
			
			//注册权限管理
			Context.regContext(CEnum.AUTHORITY, AuthoritySingle);
			//注册麦序管理
			Context.regContext(CEnum.MICMANAGER,SimpleMicManager);
		}
		
		override protected function get delegates():Object {
			var d:Object = super.delegates;
			d[PEnum.SCENE] = SceneDelegate;
			d[PEnum.LOGIN] = LoginDelegate;
			d[PEnum.PREVIEW_VIDEO] = SimplePreviewDelegate;
			d[PEnum.VIDEO] = SimpleVideoDelegate;
			d[PEnum.ENTER_ROOM] = EnterRoomDelegate;
			return d;
		}
			
		override protected function get subDelegates():Object{
			var d:Object = super.subDelegates;
			d[PEnum.TOPBAR] = TopBarDelegate;
			d[PEnum.LEFTBAR] = LeftBarDelegate;
			d[PEnum.ROOMSET] = RoomSetDelegate;
			d[PEnum.SEATAREA] = SeatAreaDelegate;
			d[PEnum.GIFT] = GiftDelegate;
			d[PEnum.USER_LIST] = UserListDelegate;
			d[PEnum.CHAT_PANEL] = ChatPanelDelegate;
			d[PEnum.SMILERES_PANEL] = SmilePanelDelegate;
			d[PEnum.USER_CARD] = UserCardDelegate;
			d[PEnum.QUALITY_MONITER] = QmDeletegate;
			d[PEnum.LOBBY] = LobbyDelegate;
			d[PEnum.ST] = StatDelegate;
			d[PEnum.ACTIVITY] = ActivityDelegate;
			d[PEnum.SUBSCRIBE] = SubscribeDelegate;
			d[PEnum.RANK] = RankDelegate;
			d[PEnum.ENTEREFFECT] = EnterEffectDelegate;
			d[PEnum.SCENEEFFECT] = SceneEffectDelegate;
			d[PEnum.FLOWERMINI] = FlowerMiniDelegate;
			d[PEnum.HORN] = HornDelegate;
			d[PEnum.ResponseTest] = ResponseTestDeletegate;
			d[PEnum.StageEffect] = StageEffectDelegate;
			d[PEnum.Ad] = AdDelagate;
			d[PEnum.BAG] = BagDelegate;
			d[PEnum.FLYSCREEN] = FlyScreenDelegate;
			d[PEnum.BAG] = BagDelegate;
			d[PEnum.GuideTask] = GuideTaskDegelete;
			d[PEnum.GameAct] = GameActDelegate;
			d[PEnum.Duang] = DuangDelegate;
			return d;
		}
		
		
	}
}