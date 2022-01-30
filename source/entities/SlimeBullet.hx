package entities;

import entities.emitters.TimedEmitter;
import echo.math.Vector2;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import echo.data.Data.CollisionData;

using echo.FlxEcho;

class SlimeBullet extends Bullet {
	private static final SLIME_SCALE = 3.0;

	var slimeStamp:FlxSprite;

	var tmpNormal = new Vector2(0, 0);
	var tmpLocal = new FlxPoint();
	var overlap = 10;

	public function new(x:Float, y:Float, vel:FlxPoint) {
		super(x, y, vel);

		slimeStamp = new FlxSprite(AssetPaths.slime1__png);
		slimeStamp.scale.scale(SLIME_SCALE);
	}

	override function hit(terrain:FlxSprite, collisionData:Array<CollisionData>) {
		FmodManager.PlaySoundOneShot(FmodSFX.BallTerrain);

		// stamp the terain with a splooge
		var collision = collisionData[0];
		var bullet = collision.sa;
		var terry = collision.sb;
		var normal = FlxPoint.get(collision.normal.x, collision.normal.y);
		splooge(normal, FlxPoint.get(bullet.x, bullet.y), FlxPoint.get(terry.x, terry.y), terrain);

		// spew out some goodies slime bits
		tmpNormal.set(collisionData[0].normal.x, collisionData[0].normal.y);
		tmpNormal *= overlap;
		var myMidpoint = this.getMidpoint();
		var emitter = new TimedEmitter(myMidpoint.x + tmpNormal.x, myMidpoint.y + tmpNormal.y);
		FlxG.state.add(emitter);

		super.hit(terrain, collisionData);
	}

	public function splooge(normal:FlxPoint, bulletPos:FlxPoint, terrainPos:FlxPoint, terrain:FlxSprite) {
		// !IMPORTANT! MW
		// This method currently only really works for wall terrain tiles.  It does not work for floor tiles.
		// I waited to do that bit because the art wasn't in the game yet and I figured that would change things.
		// Also, it isn't perfect on the corners and on the top and bottom of wall tiles.  But it at least looks
		// good on the left and right side of the wall tiles which covers 95% of all bullets (probably).

		// the height in raw pixels that the underlying bitmap data contains
		var terrainPixelHeight = terrain.pixels.height;
		// the height on screen of the terrain
		var terrainActualHeight = terrainPixelHeight * WallBlock.WALL_SCALE;
		// calculate how many pixels away from the top of the wall this bullet is
		var localY = bulletPos.y - (terrainPos.y - terrainActualHeight * .5);
		// normalize the distance by dividing by the height, then invert the resulting norm
		var normalizedLocalY = 1.0 - (localY / terrainActualHeight);
		// the y location on the sprite asset to stamp
		var stampY = normalizedLocalY * terrain.pixels.height;
		// move the y location to center the slime stamp
		stampY -= slimeStamp.pixels.height * .5;
		// the x location is either on the left or the right side depending on the normal
		var stampX = 0;
		if (normal.x < 0) {
			stampX = terrain.pixels.width - slimeStamp.pixels.width;
		}
		// randomize the rotation of the stamp
		slimeStamp.angle = FlxG.random.int(0, 359);
		// actually stamp the slime image ontop of the terrain image
		terrain.stamp(slimeStamp, stampX, Std.int(stampY));
	}
}
