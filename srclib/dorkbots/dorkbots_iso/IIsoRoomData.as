package dorkbots.dorkbots_iso
{
	import flash.display.MovieClip;

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
		function get borderOffsetX():uint;
		function get borderOffsetY():uint;
		function get nodeWidth():uint;
		function get viewHeight():Number;
		function get viewWidth():Number;
		function get roomNodeHeight():uint;
		function get roomNodeWidth():uint;
		function init():void;
		function get roomWalkable():Array;
		function get roomTerrain():Array;
		function get roomTriggers():Array;
		function get roomPickups():Array;
		function get roomEntities():Array;
	}
}