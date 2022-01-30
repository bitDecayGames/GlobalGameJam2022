package states.dev;

import entities.physicsgroups.PhysicsCollisions;
import entities.Floor;
import entities.Player;
import entities.AngleIndicator;
import echo.FlxEcho;
import entities.PowerMeter;
import flixel.math.FlxRandom;
import haxefmod.flixel.FmodFlxUtilities;
import input.SimpleController;
import haxe.io.Input;
import entities.Wall;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;

using extensions.FlxStateExt;

class MikeState extends FlxTransitionableState {
	override public function create() {
		super.create();

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		var physics = new PhysicsCollisions();

		FlxG.camera.pixelPerfectRender = true;
		var rnd = new FlxRandom();
		var wall = new Wall(FlxG.width * .5, 0).buildWallBlocks(10, rnd.int(1, 3));
		add(wall);

		var floor = new Floor();
		add(floor);

		var player1 = new Player(100, floor.y - Player.GROUND_ELEVATION, 0, physics.bullets);
		add(player1);

		var player2 = new Player(FlxG.width - 100, floor.y - Player.GROUND_ELEVATION, 1, physics.bullets);
		add(player2);

		physics.init([player1, player2], wall, floor);
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
