package
{
	import LaserProjectile;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source='res/player.png')]
		public static var ImgPlayer:Class;
		
		[Embed(source='res/jump.mp3')]
		public static var Mp3Jump:Class;
		
		[Embed(source='res/laser.mp3')]
		public static var Mp3Laser:Class;
		
		public static var Lasers:Array;
		// PLayer configuration constants
		private static var DRAG_FACTOR:int = 4;
		private static var GRAVITY_ACCEL:int = 200;
		private static var MAX_X_VEL:int = 80;
		private static var MAX_Y_VEL:int = 200;
		private static var X_ACCEL_SCALAR:int = 4;
		private static var Y_ACCEL_SCALAR:Number = 0.5;
		private static var MAX_HEALTH:Number = 100;
		
		public var laser:LaserProjectile;
		
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
			addAnimation("shoot", [4, 5, 6, 5], 5);
			addAnimation("shoot_short", [6], 5, false);
			
			maxVelocity.x = MAX_X_VEL;
			maxVelocity.y = MAX_Y_VEL;
			acceleration.y = GRAVITY_ACCEL;
			drag.x = maxVelocity.x * DRAG_FACTOR;
			facing = RIGHT;
			
			play("idle");
		}
		
		public function hit(damage:int):void
		{
			health -= damage;
			if (health <= 0){
				// end the game
				// TODO
			}
		}
		
		public function isFiring():Boolean
		{
			if (_curAnim.name == "shoot_short"){
				if(finished)
					return false;
				else
					return true;
			} else {
				return false;
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
			if (FlxG.keys.UP && isTouching(FlxObject.FLOOR))
			{
				velocity.y = -maxVelocity.y * Y_ACCEL_SCALAR;
				FlxG.play(Mp3Jump);
				play("jump");
			}
			if(FlxG.keys.justPressed("SPACE")){
				FlxG.play(Mp3Laser, 0.2);
				play("shoot_short");
				
				var sprite:FlxSprite = (FlxG.state as PlayState).playerBullets.recycle() as FlxSprite;
				sprite.reset(x + width/2 - sprite.width/2, y + height/2);
				sprite.color = 0x990000;
				if(facing == RIGHT){
					sprite.velocity.x = 200;
				}
				else{
					sprite.velocity.x = -200;
				}
			}
			
			if (isTouching(FlxObject.FLOOR))
			{
				if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT && !isFiring())
				{
					play("idle");
				}
				else if(!isFiring())
				{
					play("walk");
				}
			}
			else if (!isFiring())
			{
				play("jump");
			}
		}
	}
}