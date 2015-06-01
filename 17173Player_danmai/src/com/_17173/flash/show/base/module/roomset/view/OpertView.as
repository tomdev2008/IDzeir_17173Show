package com._17173.flash.show.base.module.roomset.view
{
	import com._17173.flash.show.base.module.roomset.component.OpertList;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class OpertView extends Sprite
	{
		private var _gonggaoPanel:GongGaoPanel = null;
		private var _editGonggaoPanel:GongGaoEditPanel = null;
		private var _changeRoomPanel:ChangeRoomPanel = null;
		private var _offlineVideo:OffLineVideoPanel = null;
		
		/*操作列表*/
		private var _opertList:OpertList;
		/**
		 *互斥面板
		 */		
		private var _closePanels:Array = null;
		/**
		 *面板容器 
		 */		
		public var panelCn:Sprite = null;
		
		public function OpertView()
		{
			super();
			panelCn = new Sprite();
			this.addChild(panelCn);
			
			_opertList = new OpertList();
			this.addChild(_opertList);
			
			_closePanels = new Array();
		}
		
		public function resize():void
		{
			
		}
		
		/**
		 *添加按钮 
		 * @param data
		 * 
		 */		
		public function addButtons(data:Array):void
		{
			_opertList.addButtons(data);
		}
		
		/**
		 *移除按钮 
		 * @param data
		 * 
		 */		
		public function removeButtons(data:Array):void{
			_opertList.removeButtons(data);
		}
		/**
		 *移除所有按钮 
		 * 
		 */		
		public function removeAllButtons():void{
			_opertList.removeAllButton();
		}
		
		/**
		 *更新按钮label 
		 * @param type 按钮事件类型
		 * @param newLabel 按钮label
		 * @param newType 新类型(是否需要修改类型，默认为不修改)
		 * 
		 */		
		public function updateButtonLabel(type:String, newLabel:String, newType:String = null):void{
			_opertList.updateLabel(type, newLabel);
			resize();
		}
		
		/**
		 * 更新公告
		 * */
		public function updateGonggao():void{
			if(_gonggaoPanel && panelCn.contains(_gonggaoPanel)){
				_gonggaoPanel.update();
			}
		}
		
		/**
		 *点击转移观众按钮 
		 * 
		 */		
		public function onChangeRoomClick(pot:Point):void{
			if(_changeRoomPanel && panelCn.contains(_changeRoomPanel)){
				hideChangeRoom();
			}else{
				showChangeRoom(pot);
			}
		}
		
		/**
		 *点击修改公告 
		 * 
		 */		
		public function onEditGonggaoClick(pot:Point):void{
			if(_editGonggaoPanel && panelCn.contains(_editGonggaoPanel)){
				hideEditGonggao();
			}else{
				showEditGonggao(pot);
			}
		}
		
		
		private function showEditGonggao(pot:Point):void{
			if(_editGonggaoPanel == null){
				_editGonggaoPanel = new GongGaoEditPanel();
				addToClosePanel(_editGonggaoPanel);
			}
			_editGonggaoPanel.x = _opertList.measuredWidth;
			_editGonggaoPanel.y =  pot.y; 
			panelCn.addChild(_editGonggaoPanel);
			closeOther(_editGonggaoPanel);
		}
		
		public function hideEditGonggao():void{
			if(_editGonggaoPanel && panelCn.contains(_editGonggaoPanel)){
				panelCn.removeChild(_editGonggaoPanel);
			}
		}
		
		public function showHideOffLineVidew(pot:Point):void{
			if(_offlineVideo && panelCn.contains(_offlineVideo)){
				hideOLView();
			}else{
				showOLView(pot);
			}
		}
		
		/**
		 *显示
		 * @param data
		 * 
		 */		
		public function showOLView(pot:Point):void{
			if(_offlineVideo == null){
				_offlineVideo = new OffLineVideoPanel();
				addToClosePanel(_offlineVideo);
			}
			_offlineVideo.x  = _opertList.measuredWidth;
			_offlineVideo.y =  pot.y; 
			panelCn.addChild(_offlineVideo);
			
			closeOther(_offlineVideo);
		}
		/**
		 *隐藏公告 
		 * 
		 */		
		public function hideOLView():void{
			if(_offlineVideo && panelCn.contains(_offlineVideo)){
				panelCn.removeChild(_offlineVideo);
			}
		}
		
		
		/**
		 *显示 
		 * @param data
		 * 
		 */		
		public function showGonggao(pot:Point):void{
			if(_gonggaoPanel == null){
				_gonggaoPanel = new GongGaoPanel();
				addToClosePanel(_gonggaoPanel);
			}
			_gonggaoPanel.x  = _opertList.measuredWidth;
			_gonggaoPanel.y =  pot.y; 
			panelCn.addChild(_gonggaoPanel);
			
			closeOther(_gonggaoPanel);
		}
		/**
		 *隐藏公告 
		 * 
		 */		
		public function hideGonggao():void{
			if(_gonggaoPanel && panelCn.contains(_gonggaoPanel)){
				panelCn.removeChild(_gonggaoPanel);
			}
		}
		/**
		 *关闭移动观众界面 
		 * 
		 */		
		public function hideChangeRoom():void{
			if(_changeRoomPanel && panelCn.contains(_changeRoomPanel)){
				panelCn.removeChild(_changeRoomPanel);
			}
		}
		/**
		 *显示移动观众 
		 * 
		 */		
		
		public function showChangeRoom(pot:Point):void{
			if(_changeRoomPanel == null){
				_changeRoomPanel = new ChangeRoomPanel();
				addToClosePanel(_changeRoomPanel);
			}
			_changeRoomPanel.x  = _opertList.measuredWidth;
			_changeRoomPanel.y =  pot.y; 
			panelCn.addChild(_changeRoomPanel);
			
			closeOther(_changeRoomPanel);
		}
		
		
		/**
		 *外部强制发送按钮点击 
		 * @param type
		 * 
		 */		
		public function sendClick4Type(type:String):void{
			
		}
		
		/**
		 *添加 到互斥面板
		 * @param panel
		 * 
		 */		
		private function addToClosePanel(panel:DisplayObject):void {
			var added:Boolean = false;
			var ds:DisplayObject;
			var len:int = _closePanels.length
			for (var i:int = 0; i < len; i++) {
				ds = _closePanels[i];
				if(ds == panel){
					added = true;
					break;
				}
			}
			if (!added) {
				_closePanels[_closePanels.length] = panel;
			}
		}
		
		/**
		 *关闭其他面板 
		 * @param panel
		 * 
		 */		
		private function closeOther(panel:DisplayObject):void {
			var ds:DisplayObject;
			var len:int = _closePanels.length
			for (var i:int = 0; i < len; i++) {
				ds = _closePanels[i];
				if (ds != panel) {
					if (ds.parent) {
						ds.parent.removeChild(ds);
					}
				}
			}
		}
	}
}