package rooms
{
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	import dorkbots.dorkbots_iso.room.IsoRoomData;
	
	public class AbstractRoomData extends IsoRoomData implements IIsoRoomData
	{
		final public function AbstractRoomData()
		{
			super();
			
			heroClass = Hero_MC;
			enemyClass = Enemy_MC;
			tileArtClass = TerrainTile_MC;
			tilePickupClass = PickupTile_MC;
		}
	}
}