package dorkbots.dorkbots_iso
{
	import flash.display.Bitmap;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastingObject;
	import dorkbots.dorkbots_iso.entity.IHero;

	public interface IIsoMaker extends IBroadcastingObject
	{
		function get canvas():Bitmap;
		function start():void;
		function loop():void;
		function get hero():IHero;
	}
}