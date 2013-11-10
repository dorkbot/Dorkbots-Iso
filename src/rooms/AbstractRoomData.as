package rooms
{
	import dorkbots.dorkbots_iso.IIsoRoomData;
	import dorkbots.dorkbots_iso.IsoRoomData;
	
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