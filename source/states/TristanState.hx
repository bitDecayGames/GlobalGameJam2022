package states;

import echo.World;
import entities.Bullet;
import entities.Player;
import entities.Floor;
import entities.Wall;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import signals.Lifecycle;

using echo.FlxEcho;
using extensions.FlxStateExt;

class TristanState extends FlxTransitionableState {
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

		var bullet = new Bullet(50, 50, FlxPoint.get(20, -10));

		var rnd = new FlxRandom();
		var wall = new Wall(100, 0).buildWallBlocks(10, rnd.int(1, 3));
		var floor = new Floor();
		var player = new Player(50, floor.y - 100, 0, null);
		add(floor);
		add(wall);
		add(bullet);
		add(player);
		for (member in wall.members) {
			member.add_to_group(physicsObjects);
		}
		floor.add_to_group(physicsObjects);

		FlxEcho.listen(bullet, physicsObjects);
		FlxEcho.listen(player, physicsObjects);
		player.listen(bullet, {
			stay: (p, b, c) -> {
				var playerHit:Player = cast(p.get_object());
				var bulletHit:Bullet = cast(b.get_object());
				playerHit.shot(bulletHit);
			}
		});
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
