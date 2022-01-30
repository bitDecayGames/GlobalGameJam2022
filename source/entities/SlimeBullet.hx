package entities;

import echo.math.Vector2;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import echo.data.Data.CollisionData;

using echo.FlxEcho;

class SlimeBullet extends Bullet {
    var slimeStamp:FlxSprite;

    var tmpNormal = new Vector2(0, 0);
    var tmpLocal = new FlxPoint();
    var overlap = 10;

    public function new(x:Float, y:Float, vel:FlxPoint) {
        super(x, y, vel);

        slimeStamp = new FlxSprite(AssetPaths.slime1__png);
    }

    override function hit(terrain:FlxSprite, collisionData:Array<CollisionData>) {

        FmodManager.PlaySoundOneShot(FmodSFX.BallTerrain);

        tmpNormal.set(collisionData[0].normal.x, collisionData[0].normal.y);
        tmpNormal *= overlap;

        this.getMidpoint(tmpLocal);
        tmpLocal.subtract(terrain.x, terrain.y);
        tmpLocal.subtract(slimeStamp.width/2, slimeStamp.height/2);
        var localX:Int = Std.int(tmpLocal.x + tmpNormal.x);
        var localY:Int = Std.int(tmpLocal.y + tmpNormal.y);
        trace('stamping at local: (${localX}, ${localY}), angle: ${slimeStamp.angle}');
        slimeStamp.angle = FlxG.random.int(0, 359);
        terrain.stamp(slimeStamp, localX, localY);

        super.hit(terrain, collisionData);
    }
}