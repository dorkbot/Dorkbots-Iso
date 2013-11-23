package rooms
{
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	
	public class Room4Data extends AbstractRoomData implements IIsoRoomData
	{
		final public function Room4Data()
		{
			trace("{Room4Data}");
			super();
			
			_roomWalkable = 
			  // 0  1  2  3  4  5  6  7  8  9 10 11 12
			   [[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], // 0
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1], // 1
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1], // 2
				[1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1], // 3
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1], // 4
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
				[1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1], // 6
				[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], // 7
				[1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1], // 8
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 9
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 10
				[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 11
				[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1]];// 12
			
			
			_roomPickups =
			  // 0  1  2  3  4  5  6  7  8  9 10 11 12
			   [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 0
				[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 1
				[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 2
				[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 3
				[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 4
				[0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0], // 5
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];// 12
			
			
			_roomTerrain = 
			  // 0  1  2  3  4  5  6  7  8  9 10 11 12
			   [[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], // 0
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1], // 1
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1], // 2
				[1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1], // 3
				[1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1], // 4
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
				[1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1], // 6
				[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], // 7
				[1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1], // 8
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 9
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 10
				[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], // 11
				[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1]];// 12
			
			
			_roomTriggers = 
			  // 0  1  2  3  4  5  6  7  8  9 10 11 12
			   [[0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0], // 0
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];// 12
			
			
			_roomEntities = 
			  // 0  1  2  3  4  5  6  7  8  9 10 11 12
			   [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 0
				[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3
				[0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4
				[0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2], // 5
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0], // 10
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0], // 11
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];// 12
		}
	}
}