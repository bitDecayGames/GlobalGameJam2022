package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import echo.FlxEcho;

class Floor extends FlxSprite {
	public function new() {
		var FLOOR_HEIGHT = 10;
		super(FlxG.width * .5, FlxG.height - FLOOR_HEIGHT);

		makeGraphic(FlxG.width, FLOOR_HEIGHT, FlxColor.GREEN);

		FlxEcho.add_body(this, {
			x: x,
			y: y,
			shape: {
				type: RECT,
				width: FlxG.width,
				height: FLOOR_HEIGHT,
			},
			mass: 0,
		});
	}
}
