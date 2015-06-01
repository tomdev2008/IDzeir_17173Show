package com._17173.flash.show.base.module.scene
{
	import com._17173.flash.show.base.context.module.IModule;

	public interface IScene extends IModule
	{
		
		/**
		 * 初始化场景上的相关功能.
		 * 不调用此方法,注册的场景元素将不会被添加到舞台. 
		 */		
		function initScene():void;
		/**
		 * 注册场景元素信息.
		 *  
		 * @param element 要注册到场景上的元素,默认是sceneElement对象.也可以直接注册显示对象,直接注册显示对象会显示在最上层.
		 */		
		function addElement(element:Object):void;
		
	}
}