package states;

import entities.Bullet;
import flixel.util.FlxColor;
import flixel.FlxObject;
import echo.Body;
import echo.Echo;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;
import echo.World;

using extensions.FlxStateExt;
using echo.FlxEcho;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

	var world:World;
	public static inline var gravity = 98;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: gravity});

		// Draw the debug scene so we can see the Echo bodies
		FlxEcho.draw_debug = true;

		var object = new Bullet(50, 50);
		add(object);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
