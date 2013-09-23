package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class LaserProjectile extends FlxSprite
	{
		//get laserprojectile.png to load.
		[Embed(source='res/laserprojectile.png')]
		public static var ImgLaser:Class;
		
		//set VEL for speed of laser
		private static var VEL:int = 80;
		
		
		
		
		
		public function LaserProjectile(X:Number, Y:Number)
		{
			super(X, Y);
			// Loading image
			loadGraphic(ImgLaser, true, true, 4, 3);
			
			velocity.x = VEL
		}
	}
}