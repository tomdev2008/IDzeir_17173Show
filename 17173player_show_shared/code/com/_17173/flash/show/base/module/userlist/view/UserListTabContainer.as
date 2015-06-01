package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.TabBar;
	import com._17173.flash.core.components.common.TabContainer;
	import com._17173.flash.core.components.common.ViewStack;

	/**
	 * @author idzeir
	 * 创建时间：2014-3-3  上午11:06:27
	 */
	public class UserListTabContainer extends TabContainer
	{
		public function UserListTabContainer()
		{
			super();
		}

		override protected function addChildren():void
		{
			tabBar = new TabBar(UserListTabButton);
			tabBar.gap = 0.5;
			viewStack = new ViewStack();

			this.addChild(tabBar);
			this.addChild(viewStack);
		}

		override protected function drawRules():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0, 0, 0);

			this.graphics.beginFill(0x976ADD);
			this.graphics.drawRect(0, tabBar.contentMaxHeight - .5, viewStack.contentMaxWidth + 4, 1);

			this.graphics.beginFill(0x5a3ba5);
			this.graphics.drawRect(0, tabBar.contentMaxHeight + .5, viewStack.contentMaxWidth + 4, 1);
		}

		public function goto(index:int):void
		{
			tabBar.index = index;
		}
	}
}