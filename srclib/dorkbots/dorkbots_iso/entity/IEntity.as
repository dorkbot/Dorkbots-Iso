package dorkbots.dorkbots_iso.entity
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastingObject;
	import dorkbots.dorkbots_iso.room.IIsoRoomData;

	public interface IEntity extends IBroadcastingObject
	{
		function init(a_mc:MovieClip, aSpeed:Number, aHalfSize:Number, aRoomData:IIsoRoomData, aType:uint):IEntity;
		function get type():uint;
		function get finalDestination():Point;
		function get dY():Number;
		function set dY(value:Number):void;
		function get dX():Number;
		function set dX(value:Number):void;
		function get path():Array;
		function get facingCurrent():String;
		function set facingCurrent(value:String):void;
		function get facingNext():String;
		function set facingNext(value:String):void;
		function get entity_mc():MovieClip;
		function get cartPos():Point;
		function set cartPos(value:Point):void;
		function get node():Point;
		function set node(value:Point):void;
		function get nodePrevious():Point;
		function get moved():Boolean;
		function loop():void;
		function move():void;
		function get movedAmountPoint():Point;
		function findPathToNode(nodePoint:Point):void;
	}
}