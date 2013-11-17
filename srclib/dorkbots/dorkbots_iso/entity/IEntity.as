package dorkbots.dorkbots_iso.entity
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_iso.room.IIsoRoomData;

	public interface IEntity
	{
		function init(a_mc:MovieClip, aSpeed:Number, aHalfSize:Number, aRoomData:IIsoRoomData):IEntity;
		function get dY():Number;
		function set dY(value:Number):void;
		function get dX():Number;
		function set dX(value:Number):void;
		function get path():Array;
		function get currentFacing():String;
		function set currentFacing(value:String):void;
		function get facing():String;
		function set facing(value:String):void;
		function get entity_mc():MovieClip;
		function get cartPos():Point;
		function set cartPos(value:Point):void;
		function get node():Point;
		function set node(value:Point):void;
		function get moved():Boolean;
		function loop(aCornerPoint:Point):void;
		function move():void;
		function get movedAmountPoint():Point;
		function createPath(nodePoint:Point):void;
	}
}