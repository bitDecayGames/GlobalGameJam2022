package states;

import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import entities.Bullet;
import entities.Floor;
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
import entities.Wall;
using extensions.FlxStateExt;
using echo.FlxEcho;

class TristanState extends FlxTransitionableState {
	var player:FlxSprite;

	var world:World;

	var physicsObjects = new FlxGroup();
	public static inline var gravity = 98;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: gravity});

		// Draw the debug scene so we can see the Echo bodies
		FlxEcho.draw_debug = true;

		var bullet = new Bullet(50, 50);

		var rnd = new FlxRandom();
		var wall = new Wall(100, 0).buildWallBlocks(10, rnd.int(1, 3));
		var floor = new Floor();
		add(floor);
		add(wall);
		add(bullet);
		for (member in wall.members) {
			member.add_to_group(physicsObjects);
		}
		floor.add_to_group(physicsObjects);

		FlxEcho.listen(bullet, physicsObjects);

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
