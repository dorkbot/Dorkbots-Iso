package dorkbots.dorkbots_iso.entity
{
	public interface IEntityFactory
	{
		function createHero():IHero;
		function createEnemy(type:uint):IEnemy;
		function dispose():void;
	}
}