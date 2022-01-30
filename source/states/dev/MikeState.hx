package states.dev;

import helpers.PlayerColors;
import flixel.util.FlxColor;
import shaders.ColorShifterShader;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import entities.SlimeBullet;
import entities.BulletMagazineManager;
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
	var physics:PhysicsCollisions;

	override public function create() {
		super.create();
		// BulletMagazineManager.instance.reset();

		// // Initialize  FlxEcho
		// FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		// physics = new PhysicsCollisions();

		// // FlxG.camera.pixelPerfectRender = true;
		// var rnd = new FlxRandom();
		// var wall = new Wall(FlxG.width * .5, 0).buildWallBlocks();
		// add(wall);

		// var floor = new Floor();
		// add(floor);

		// var player1 = new Player(100, floor.y - Player.GROUND_ELEVATION, 0, physics.bullets);
		// add(player1);

		// var player2 = new Player(FlxG.width - 100, floor.y - Player.GROUND_ELEVATION, 1, physics.bullets);
		// add(player2);

		// physics.init([player1, player2], wall, floor);

		// player1.canShoot = true;
		// player2.canShoot = true;

		addPlayer(100, 10, PlayerColors.original);
		addPlayer(300, 10, PlayerColors.green);
		addPlayer(500, 10, PlayerColors.cyan);
		addPlayer(200, 300, PlayerColors.purple);
		addPlayer(400, 300, PlayerColors.yellow);
	}

	function addPlayer(x:Int, y:Int, colors:Map<Int, FlxColor>) {
		var playerTest = new FlxSprite(x, y);
		playerTest.loadGraphic(AssetPaths.player__png, true, 171, 387, true);
		playerTest.animation.add("stand", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
		playerTest.animation.add("die", [20, 21, 22, 23, 24, 25]);
		playerTest.animation.play("stand");
		var shader = new ColorShifterShader(colors);
		playerTest.shader = shader;
		add(playerTest);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// if (FlxG.keys.justPressed.Y) {
		// 	var pos = FlxG.mouse.getWorldPosition();
		// 	addBullet(pos.x, pos.y, 1.0);
		// }
		// if (FlxG.keys.justPressed.T) {
		// 	var pos = FlxG.mouse.getWorldPosition();
		// 	addBullet(pos.x, pos.y, -1.0);
		// }
	}

	function addBullet(x:Float, y:Float, v:Float) {
		var bullet = new SlimeBullet(x, y, FlxPoint.get(200 * v, 100));
		FlxG.state.add(bullet);
		if (physics.bullets != null) {
			physics.bullets.addBullet(bullet);
		}
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
