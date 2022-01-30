package entities;

import helpers.PlayerColors;
import shaders.ColorShifterShader;
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
	public static final SLIME_SCALE = 3.0;

	var slimeStamp:FlxSprite;

	var tmpNormal = new Vector2(0, 0);
	var tmpLocal = new FlxPoint();
	var overlap = 50;

	public function new(x:Float, y:Float, vel:FlxPoint, playerNum:Int, slimeStamp:FlxSprite) {
		super(x, y, vel);

		this.slimeStamp = slimeStamp;

		shader = new ColorShifterShader(PlayerColors.all[playerNum].ball);
	}

	override function hit(terrain:FlxSprite, collisionData:Array<CollisionData>) {
		FmodManager.PlaySoundOneShot(FmodSFX.BallTerrain);

		var bulletMidpoint = this.getMidpoint();
		var terrainMidpoint = terrain.getMidpoint();

		var tmp = new FlxPoint().copyFrom(bulletMidpoint);

		// bullet midpoint minus terrain midpoint
		tmp.subtractPoint(terrainMidpoint);

		// scale it properly
		tmp.scale(1 / terrain.scale.x);

		tmp.add(terrain.width / 2, terrain.height / 2);

		var normalAdjustment = collisionData[0].normal * overlap;

		// maybe this is bad? y in echo uses y+ = up and flixel uses y+ = down
		tmp.add(normalAdjustment.x, normalAdjustment.y);

		// randomize the rotation of the stamp
		slimeStamp.angle = FlxG.random.int(0, 359);
		// actually stamp the slime image ontop of the terrain image
		terrain.stamp(slimeStamp, Std.int(tmp.x - slimeStamp.width / 2), Std.int(tmp.y - slimeStamp.height / 2));

		super.hit(terrain, collisionData);
	}
}
