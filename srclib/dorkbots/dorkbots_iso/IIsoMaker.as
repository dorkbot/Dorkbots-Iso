package dorkbots.dorkbots_iso
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastingObject;
	import dorkbots.dorkbots_iso.entity.IEnemy;
	import dorkbots.dorkbots_iso.entity.IHero;

	public interface IIsoMaker extends IBroadcastingObject
	{
		function set borderOffsetY(value:Number):void;
		function set borderOffsetX(value:Number):void;
		function set viewHeight(value:Number):void;
		function set viewWidth(value:Number):void;
		function get canvas():Bitmap;
		function start():void;
		function loop():void;
		function get hero():IHero;
		function enemyDestroy(enemy:IEnemy):void
		function get enemiesSeekHero():Boolean;
		function set enemiesSeekHero(value:Boolean):void;
		function get enemyTargetNode():Point;
		function set enemyTargetNode(value:Point):void;
	}
}