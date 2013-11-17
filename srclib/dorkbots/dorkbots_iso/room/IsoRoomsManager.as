package dorkbots.dorkbots_iso.room
{
	public class IsoRoomsManager implements IIsoRoomsManager
	{
		private var rooms:Vector.<Class> = new Vector.<Class>();
		private var roomsInStasis:Array = new Array();
		private var _roomCurrentNum:uint = 0;
		private var _roomLastNum:uint = 0;
		private var _roomTotal:uint = 0;
		private var _roomHasChanged:Boolean = false;
		
		public function IsoRoomsManager()
		{
		}

		public final function get roomLastNum():uint
		{
			return _roomLastNum;
		}

		public final function get roomHasChanged():Boolean
		{
			return _roomHasChanged;
		}

		public final function get roomTotal():uint
		{
			return _roomTotal;
		}
		
		public final function set roomCurrentNum(value:uint):void
		{
			if (_roomCurrentNum != value) _roomHasChanged = true;
			_roomLastNum = _roomCurrentNum;
			_roomCurrentNum = value;
		}
		
		public final function get roomCurrentNum():uint
		{
			return _roomCurrentNum;
		}
		
		public final function putRoomInStasis(roomData:IIsoRoomData):void
		{
			roomData.stasis();
		}
		
		public final function disposeOfRoom(roomData:IIsoRoomData):void
		{
			var index:int = roomsInStasis.indexOf(roomData);
			if (index > -1) roomsInStasis[index] = null;
			roomData.dispose();
		}
		
		public final function addRoom(room:Class):void
		{
			if(rooms.indexOf(room) < 0)
			{
				rooms.push(room);
				_roomTotal = rooms.length;
			}
			else
			{
				throw new Error("Room already added!!!");
			}
		}
		
		public final function getRoom(roomNum:uint):IIsoRoomData
		{
			var room:IIsoRoomData;
			if (roomsInStasis[roomNum])
			{
				room = roomsInStasis[roomNum];
			}
			else
			{
				room = new rooms[roomNum];
				roomsInStasis[roomNum] = room;
			}
			
			return room;
		}
		
		public function dispose():void
		{
			rooms.length = 0;
			rooms = null;
			
			for (var i:int = 0; i < roomsInStasis.length; i++) 
			{
				IIsoRoomData(roomsInStasis[i]).dispose();
			}
			
			roomsInStasis.length = 0;
			roomsInStasis = null;
		}
	}
}