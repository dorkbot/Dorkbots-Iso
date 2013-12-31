package dorkbots.dorkbots_iso.entity
{
	public interface IEnemy extends IEntity
	{
		function attackReadyReset():void;
		function attackReady():Boolean;
	}
}