package rooms
{
	import com.dayvid.iso.IIsoRoomData;
	import com.dayvid.iso.IsoRoomData;
	
	public class AbstractRoomData extends IsoRoomData implements IIsoRoomData
	{
		final public function AbstractRoomData()
		{
			super();
			
			heroClass = Hero_MC;
			terrainTileClass = TerrainTile_MC;
			pickupTileClass = PickupTile_MC;
		}
	}
}