package
{
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		public var facingright:Boolean;
		
		public function Player(X:Number=0,Y:Number=0,SimpleGraphic:Class=null)
		{
			super(X,Y,SimpleGraphic);
			facingright = true;
		}
		

	}
	
}