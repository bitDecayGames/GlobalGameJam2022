package entities;

import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import echo.data.Data.CollisionData;

class SlimeBullet extends Bullet {
    var slimeStamp:FlxSprite;

    public function new(x:Float, y:Float, vel:FlxPoint) {
        super(x, y, vel);

        slimeStamp = new FlxSprite(AssetPaths.slime1__png);
    }

    override function hit(terrain:FlxSprite, collisionData:Array<CollisionData>) {

        FmodManager.PlaySoundOneShot(FmodSFX.BallTerrain);

        slimeStamp.angle = FlxG.random.int(0, 359);
        var localX:Int = Std.int(this.x - terrain.x - 5);
        var localY:Int = Std.int(this.y - terrain.y - 5);
        trace('stamping at local: (${localX}, ${localY}), angle: ${slimeStamp.angle}');
        terrain.stamp(slimeStamp, localX, localY);

        super.hit(terrain, collisionData);
    }
}