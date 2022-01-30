package states;

import flixel.tweens.FlxTween;
import flixel.FlxCamera.FlxCameraFollowStyle;
import entities.CurrentRound;
import entities.BulletMagazineManager;
import haxe.Timer;
import flixel.util.FlxTimer;
import input.SimpleController;
import entities.GameData;
import entities.Floor;
import entities.Wall;
import entities.physicsgroups.PhysicsCollisions;
import flixel.math.FlxPoint;
import ui.PlayOverlay;
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
	var world:World;
	var overlay:PlayOverlay;

	var player1:Player;
	var player2:Player;

	var physics:PhysicsCollisions;


	var roundEndStart:Bool = false;
	var timeSinceRoundEnded:Float = 0;
	var maxRoundEndTime:Float = 8;
	var roundEnding = false;

	var PLAYER_MIN_EDGE_DIST = 50;
	var PLAYER_MAX_EDGE_DIST = 300;

	var floor:FlxSprite;

	public static inline var gravity = 98;

	override public function create() {
		super.create();
		BulletMagazineManager.instance.reset();
		bgColor = FlxColor.GRAY;
		Lifecycle.startup.dispatch();

		FmodManager.PlaySong(FmodSongs.Slime);

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		// this is required for collisions to work
		physics = new PhysicsCollisions();

		FlxG.camera.pixelPerfectRender = true;

		var bg = new FlxSprite(AssetPaths.moonscape__png);
		bg.scale.x = FlxG.width / bg.width;
		bg.scale.y = FlxG.height / bg.height;
		bg.screenCenter();
		add(bg);

		var floorImage = new FlxSprite(AssetPaths.floor__png);
		floorImage.width = FlxG.width;
		floorImage.y = FlxG.height - floorImage.height;
		add(floorImage);

		var wall = new Wall(FlxG.width * .5, 0).buildWallBlocks();
		add(wall);

		var floor = new Floor();
		add(floor);

		var playerPlacement = FlxG.random.int(PLAYER_MIN_EDGE_DIST, PLAYER_MAX_EDGE_DIST);

		GameData.currentRound = new CurrentRound(GameData.gameMode);

		player1 = new Player(playerPlacement, floor.y - Player.GROUND_ELEVATION, 0, physics.bullets);
		add(player1);

		player2 = new Player(FlxG.width - playerPlacement, floor.y - Player.GROUND_ELEVATION, 1, physics.bullets);
		add(player2);

		physics.init([player1, player2], wall, floor);
	}

	var timeOnState:Float = 0;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		timeOnState+=elapsed;
		if (subState == null) {
			overlay = new PlayOverlay(() -> {
				player1.canShoot = true;
				player2.canShoot = true;
			});
			player1.setOverlay(overlay);
			player2.setOverlay(overlay);
			openSubState(overlay);
		}

		#if debug
		if (timeOnState > 1 && (FlxG.keys.justPressed.SPACE || SimpleController.just_pressed(Button.B, 0))) {
			FlxG.resetGame();
		}
		#end

		if (player1.dead() || player2.dead()) {
			startEndOfRound();
			roundEndStart = true;
		}

		if (roundEndStart){
			timeSinceRoundEnded += elapsed;
		}

		physics.cullStrayBullets();
	}

	private function startEndOfRound() {
		if (roundEnding) {
			return;
		}

		roundEnding = true;
		queueEndCheck();
	}

	private function queueEndCheck() {
		Timer.delay(() -> {
			if (player1.dead() && player2.dead()) {
				trace('checking for tie');
				checkWinner();
			} else if (physics.bullets.bulletsAlive() && timeSinceRoundEnded < maxRoundEndTime) {
				queueEndCheck();
			} else {
				trace('checking winner');
				checkWinner();
			}
		}, 1000);
	}

	private function checkWinner() {
		if (player1.dead() && player2.dead()) {
			trace('TIE GAME!');
			Timer.delay(() -> {
                FlxG.resetState();
            }, 1500);
		} else if (player1.dead()) {
			trace("PLAYER 2 WINS!");
			declareWinner(player2);
		} else if (player2.dead()) {
			trace("PLAYER 1 WINS!");
			declareWinner(player1);
		} else {
			trace("SOMEHOW NOBODY DIED");
		}
	}

	private function declareWinner(player:Player) {
		if (player.playerNum == 0){
			GameData.p1Points++;
		} else if (player.playerNum == 1){
			GameData.p2Points++;
		}

		overlay.declareWinner(player);
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
