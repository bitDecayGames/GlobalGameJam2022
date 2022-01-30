package entities;

import helpers.PlayerColors;
import ui.PlayOverlay;
import extensions.FlxPointExt;
import flixel.system.FlxAssets;
import lime.utils.Assets;
import shaders.ColorShifterShader;
import flixel.FlxState;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import entities.physicsgroups.BulletsPhysicsGroup;
import flixel.math.FlxVector;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Int64Helper;
import input.InputCalcuator;
import input.SimpleController;

using echo.FlxEcho;

class Player extends FlxTypedSpriteGroup<FlxSprite> {
	private static final CHANGE_ANGLE_SPEED:Float = 1.0;
	private static final POWER_SCALE:Float = 300;
	private static final MIN_SHOOT_POWER:Float = 75;
	private static final ANGLE_RADIUS:Float = 80;
	public static final GROUND_ELEVATION:Float = 70;
	// set this to -1 for infinite ammo
	private static final MAX_AMMO:Int = 5;
	private static final SCALE:Float = 0.3;
	private static final ARM_OFFSET:Float = 20;

	public var gameMode:String = "";
	public var normalControls:Bool = false;
	public var windmillSpeed:Int = 6;

	public var screenshakeIntensityDenominator:Int = 150;

	public var canShoot:Bool = false;

	var hasNotTriedToShoot:Bool = true;

	var speed:Float = 30;

	public var playerNum:Int;

	var wid = 50;
	var hig = 100;

	private var angleInd:AngleIndicator;
	private var powerMeter:PowerMeter;

	public var body:FlxSprite;
	public var arm:FlxSprite;

	private var bulletPhysicsGroup:Null<BulletsPhysicsGroup>;
	private var overlay:PlayOverlay;

	public var magazine:BulletMagazine;

	var isDead:Bool = false;

	public static inline var IDLE = "idle";
	public static inline var DYING = "dying";

	public function new(x:Float, y:Float, playerNum:Int, bulletPhysicsGroup:Null<BulletsPhysicsGroup>) {
		super(x, y);
		this.bulletPhysicsGroup = bulletPhysicsGroup;
		body = new PlayerBodySprite(this);
		body.loadGraphic(AssetPaths.player__png, true, 171, 387);
		body.flipX = playerNum != 0;
		body.animation.add(IDLE, [for (i in 0...20) i], 10, true);
		body.animation.add(DYING, [for (i in 21...26) i], 10);
		body.animation.play(IDLE);
		body.scale.scale(SCALE);
		add(body);

		arm = new FlxSprite();
		arm.loadGraphic(AssetPaths.arm__png);
		arm.offset.set(arm.width * .5, arm.height - ARM_OFFSET);
		arm.origin.set(arm.width * .5, arm.height - ARM_OFFSET);
		arm.antialiasing = true;
		arm.scale.scale(SCALE);
		add(arm);

		this.playerNum = playerNum;

		angleInd = new AngleIndicator(0, -ANGLE_RADIUS, ANGLE_RADIUS);
		add(angleInd);
		if (playerNum == 0) {
			angleInd.angle = 90;
		} else if (playerNum == 1) {
			angleInd.angle = -90;
		}

		// MW notice the .25 instead of .5 here... no fucking idea...
		powerMeter = new PowerMeter(-PowerMeter.LENGTH * .25, -hig * .5);
		powerMeter.visible = false;
		add(powerMeter);
		powerMeter.saveAnchor();

		body.add_body({
			mass: 0,
			x: x,
			y: y,
			shape: {
				type: RECT,
				width: wid,
				height: hig,
			}
		});

		// set up color shifting shader based on playerNum
		var shader = new ColorShifterShader(PlayerColors.all[playerNum]);
		body.shader = shader;

		magazine = new BulletMagazine(MAX_AMMO);
		BulletMagazineManager.instance.add(magazine);
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (canShoot) {
			if ((hasNotTriedToShoot && SimpleController.pressed(Button.A, playerNum))
				|| (SimpleController.just_pressed(Button.A, playerNum) && (magazine.count() > 0 || GameData.currentRound.unlimitedAmmo))) {
				hasNotTriedToShoot = false;
				powerMeter.power = 0;
				powerMeter.visible = true;
			} else if (SimpleController.pressed(Button.A, playerNum) && powerMeter.visible) {
				powerMeter.buildUpMorePower(delta * 2);
			} else if (SimpleController.just_released(Button.A, playerNum) && powerMeter.visible) {
				powerMeter.visible = false;
				shoot();
			} else if (SimpleController.just_pressed(Button.A, playerNum) && magazine.count() <= 0) {
				FmodManager.PlaySoundOneShot(FmodSFX.PlayerShootEmpty);
			}
		}

		if (GameData.currentRound.spinningArms) {
			if (playerNum == 0) {
				angleInd.angle = (angleInd.angle - windmillSpeed) % 360;
			} else {
				angleInd.angle = (angleInd.angle + windmillSpeed) % 360;
			}
		} else {
			// TODO: KEYBOARD CONTROLS START HERE
			if (SimpleController.pressed(Button.UP, playerNum)) {
				angleInd.angle += CHANGE_ANGLE_SPEED;
			} else if (SimpleController.pressed(Button.DOWN, playerNum)) {
				angleInd.angle -= CHANGE_ANGLE_SPEED;
			}
			// KEYBOARD CONTROLS END HERE

			var stick = SimpleController.getLeftStick(playerNum);
			if (stick != null && stick.length > 0.2) {
				stick.normalize();
				// TODO: MW might want to add some lerp to this so that the angle isn't so jittery from your finger?

				// the + 90 is here because stick.degrees is relative to the horizontal axis, but we need it relative to the vertical
				// axis to match up with the fact that 0 degress equals up
				angleInd.angle = stick.degrees + 90;
			}
		}

		var reloadSuccessful = BulletMagazineManager.instance.attemptReload(bulletPhysicsGroup);
		if (reloadSuccessful) {
			overlay.reload();
		}

		arm.angle = angleInd.angle;
	}

	public function setOverlay(overlay:PlayOverlay) {
		this.overlay = overlay;
	}

	public function shoot() {
		if (magazine.shoot() || GameData.currentRound.unlimitedAmmo) {
			trace('count: ${magazine.count()}');
			FmodManager.PlaySoundOneShot(FmodSFX.PlayerShoot);

			if (overlay != null) {
				overlay.subtractAmmoFromPlayer(this);
			}

			// need the 90 degree diff because of differences in "up" from Flx to Echo.
			var tipOfGun = FlxPointExt.pointOnCircumference(FlxPoint.get(x, y), angleInd.angle - 90, ANGLE_RADIUS);
			var bullet = new SlimeBullet(tipOfGun.x - Bullet.BULLET_RADIUS * 3, tipOfGun.y - Bullet.BULLET_RADIUS * 3,
				FlxVector.get(0, -1).rotateByDegrees(angleInd.angle).scale(MIN_SHOOT_POWER + powerMeter.power * POWER_SCALE));
			FlxG.state.add(bullet);
			if (bulletPhysicsGroup != null) {
				bulletPhysicsGroup.addBullet(bullet);
			}

			FlxG.camera.shake(powerMeter.power / screenshakeIntensityDenominator, powerMeter.power / 3);
		}
	}

	public function shot(hitBy:Bullet) {
		// for now just delete the player and whatever it was hit by
		// later we can add fancy animations, screams of terror,
		// explosions, etc.
		FmodManager.PlaySoundOneShot(FmodSFX.PlayerDie);
		hitBy.kill();
		body.animation.play(DYING);
		isDead = true;
	}

	override function kill() {
		super.kill();
		// remove echo physics body from the world here
		body.get_body().active = false;
	}

	public function dead() {
		return isDead || !body.get_body().active;
	}
}
