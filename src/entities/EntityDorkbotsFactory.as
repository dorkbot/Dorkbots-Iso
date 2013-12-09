package entities
{
	import dorkbots.dorkbots_iso.entity.EntityFactory;
	import dorkbots.dorkbots_iso.entity.IEnemy;
	import dorkbots.dorkbots_iso.entity.IEntityFactory;
	import dorkbots.dorkbots_iso.entity.IHero;
	
	public class EntityDorkbotsFactory extends EntityFactory implements IEntityFactory
	{
		public function EntityDorkbotsFactory()
		{
			super();
		}
		
		override protected function _createHero():IHero
		{
			return new HeroDorkbot();
		}
		
		override protected function _createEnemy(type:uint):IEnemy
		{
			return new EnemyDorkbot();
		}
	}
}