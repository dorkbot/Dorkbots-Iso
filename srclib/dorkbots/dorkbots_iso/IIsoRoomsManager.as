package dorkbots.dorkbots_iso
{
	public interface IIsoRoomsManager
	{
		function get roomHasChanged():Boolean;
		function get roomTotal():uint;
		function get roomLastNum():uint;
		function set roomCurrentNum(value:uint):void;
		function get roomCurrentNum():uint;
		function addRoom(level:Class):void;
		function getRoom(levelNum:uint):IIsoRoomData;
		function putRoomInStasis(roomData:IIsoRoomData):void;
		function disposeOfRoom(roomData:IIsoRoomData):void;
		function dispose():void;
	}
}