package entities;

import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class Bullet extends FlxSprite {

    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(10, 10, FlxColor.RED);

        FlxEcho.add_body(this, {
			x: x,
			y: y,
			shape: {
				type: CIRCLE,
				radius: 5
			},
			velocity_x: 20,
			velocity_y: -20
		});
    }
}