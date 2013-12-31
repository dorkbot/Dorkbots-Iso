package dorkbots.dorkbots_iso.room
{
	import flash.display.MovieClip;
	
	import dorkbots.dorkbots_iso.entity.IEnemy;

	public interface IIsoRoomData
	{
		function get stasis():Boolean;
		function wake():void;
		function putInStasis():void;
		function dispose():void;
		function get heroFacing():String;
		function get speed():uint;
		function get tileArt():MovieClip;
		function get tileArtWithHeight():Vector.<uint>;
		function get tilePickup():MovieClip;
		function get heroHalfSize():uint;
		function get hero():MovieClip;
		function get enemyHalfSize():uint;
		function createEnemy(type:uint):MovieClip;
		function get enemies():Vector.<IEnemy>;
		function set enemies(value:Vector.<IEnemy>):void;
		function get enemiesWalkable():Array;
		function set enemiesWalkable(value:Array):void;
		function get nodeWidth():uint;
		function get roomNodeGridHeight():uint;
		function get roomNodeGridWidth():uint;
		function init():void;
		function get roomWalkable():Array;
		function set roomTileArtWithHeight(value:Array):void;
		function get roomTileArtWithHeight():Array;
		function get roomTileArt():Array
		function get roomTriggers():Array;
		function get roomPickups():Array;
		function get roomEntities():Array;
		function get entitiesGrid():Array;
	}
}