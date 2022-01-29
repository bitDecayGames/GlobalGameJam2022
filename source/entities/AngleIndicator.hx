package entities;

import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class AngleIndicator extends FlxSprite {
	public function new(x:Float, y:Float, length:Float) {
		super(x, y);
		makeGraphic(10, 10, FlxColor.WHITE);
		origin.set(0, length);
	}
}
