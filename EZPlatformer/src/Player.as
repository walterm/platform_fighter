package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source='res/player.png')]
		public static var ImgPlayer:Class;
		
		[Embed(source='res/jump.mp3')]
		public static var Mp3Jump:Class;
		
		// PLayer configuration constants
		private static var DRAG_FACTOR:int = 4;
		private static var GRAVITY_ACCEL:int = 200;
		private static var MAX_X_VEL:int = 80;
		private static var MAX_Y_VEL:int = 200;
		private static var X_ACCEL_SCALAR:int = 4;
		private static var Y_ACCEL_SCALAR:Number = 0.5;
		private static var MAX_HEALTH:Number = 100;
		
		public function Player()
		{
			super(FlxG.width / 2, FlxG.height/2-10);
			health = MAX_HEALTH;
			
			// Loading image
			loadGraphic(ImgPlayer, true, true, 14, 15);
			
			// Setting animations
			addAnimation("idle" /*name of animation*/, [0] /*used frames*/);
			addAnimation("walk", [0, 1, 2, 1], 5 /*frames per second*/);
			addAnimation("jump", [3]);
			
			maxVelocity.x = MAX_X_VEL;
			maxVelocity.y = MAX_Y_VEL;
			acceleration.y = GRAVITY_ACCEL;
			drag.x = maxVelocity.x * DRAG_FACTOR;
			facing = RIGHT;
		}
		
		public function hit(damage:int):void
		{
			health -= damage;
			if (health <= 0){
				// end the game
				// TODO
			}
		}
		
		override public function update():void
		{	
			super.update();
			
			acceleration.x = 0;
			
			var right:Boolean = (FlxG.keys.RIGHT || FlxG.keys.D);
			var left:Boolean = (FlxG.keys.LEFT || FlxG.keys.A);
			
			if (left){
				acceleration.x = -maxVelocity.x * X_ACCEL_SCALAR;
				facing = LEFT;
			}
			if (right){
				acceleration.x = maxVelocity.x * X_ACCEL_SCALAR;
				facing = RIGHT;
			}
			if (FlxG.keys.SPACE && isTouching(FlxObject.FLOOR))
			{
				velocity.y = -maxVelocity.y * Y_ACCEL_SCALAR;
				FlxG.play(Mp3Jump, 0.5);
			}
			
			if (FlxG.keys.C){
				// shoot a projectile
				// TODO
			}
			
			if (isTouching(FlxObject.FLOOR))
			{
				if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT)
				{
					play("idle");
				}
				else
				{
					play("walk");
				}
			}
			else
			{
				play("jump");
			}
		}
	}
}