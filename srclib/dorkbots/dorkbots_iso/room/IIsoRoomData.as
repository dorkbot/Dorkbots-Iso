package dorkbots.dorkbots_iso.room
{
	import flash.display.MovieClip;
	
	import dorkbots.dorkbots_iso.entity.IEnemy;

	public interface IIsoRoomData
	{
		function stasis():void;
		function dispose():void;
		function get heroFacing():String;
		function get speed():uint;
		function get terrainTile():MovieClip;
		function get pickupTile():MovieClip;
		function get heroHalfSize():uint;
		function get hero():MovieClip;
		function get enemyHalfSize():uint;
		function createEnemy(type:uint):MovieClip;
		function get enemies():Vector.<IEnemy>;
		function set enemies(value:Vector.<IEnemy>):void;
		function get borderOffsetX():uint;
		function get borderOffsetY():uint;
		function get nodeWidth():uint;
		function get viewHeight():Number;
		function get viewWidth():Number;
		function get roomNodeGridHeight():uint;
		function get roomNodeGridWidth():uint;
		function init():void;
		function get roomWalkable():Array;
		function get roomTerrain():Array;
		function get roomTriggers():Array;
		function get roomPickups():Array;
		function get roomEntities():Array;
	}
}