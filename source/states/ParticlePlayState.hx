package states;

import flixel.addons.transition.FlxTransitionableState;
import flash.ui.Mouse;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flash.display.BlendMode;

class ParticlePlayState extends FlxTransitionableState
{
	/**
	 * Our example emitter.
	 */
	var _emitter:FlxEmitter;

	var _resetButton:FlxButton;
	var _stopButton:FlxButton;
	var _startButton:FlxButton;
	var _arrowGroundButton:FlxButton;

	/**
	 * Some walls stuff
	 */
	var _collisionGroup:FlxGroup;

	var _wall:FlxSprite;
	var _floor:FlxSprite;

	var _alphaTween:VarTween;

	override public function create():Void
	{
		// Here we actually initialize out emitter
		// The parameters are X, Y and Size (Maximum number of particles the emitter can store)
		// This emitter will start right in the middle of the screen.

		_emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 200);
		add(_emitter);

		_resetButton = new FlxButton(100, FlxG.height - 22, "Reset All", reset);
		add(_resetButton);

		_stopButton = new FlxButton(180, FlxG.height - 22, "Stop", onStopRequest);
		add(_stopButton);

		_startButton = new FlxButton(260, FlxG.height - 22, "Start", onStartRequest);
		add(_startButton);

		_arrowGroundButton = new FlxButton(340, FlxG.height - 22, "Arrow Ground", arrowHitsGround);
		add(_arrowGroundButton);

		// Let's setup some walls for our particles to collide against

		_collisionGroup = new FlxGroup();

		_floor = new FlxSprite(10, FlxG.height - 88);
		_floor.makeGraphic(FlxG.width - 20, 20, FlxColor.GRAY);

		// Lets make sure the pixels don't push our wall away! (though it does look funny)
		_floor.immovable = true;
		_floor.solid = true;
		_floor.elasticity = 0.8;

		// Add the floor to its group
		_collisionGroup.add(_floor);

		_wall = new FlxSprite(FlxG.width - 30, 10);
		_wall.makeGraphic(20, Std.int(_floor.y - 20), FlxColor.GRAY);
		_wall.immovable = true;
		_wall.solid = true;
		_wall.elasticity = 0.8;
		_collisionGroup.add(_wall);

		// Don't forget to add the group to the state
		add(_collisionGroup);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(_emitter, _collisionGroup);
	}

	function onResetRequest():Void
	{
		FlxG.resetGame();
	}

	function onStopRequest():Void
	{
		_emitter.kill();
	}

	function onStartRequest():Void
	{
		_emitter.revive();
		_emitter.clear();
		_emitter.makeParticles(2, 2, FlxColor.WHITE, 200);
		_emitter.start(false, 0.01);
	}

	function reset():Void 
	{
		_emitter.clear();
		_emitter.makeParticles(2, 2, FlxColor.WHITE, 200);
	}

	function arrowHitsGround():Void {
		_emitter.clear();
		_emitter.makeParticles(2, 2, FlxColor.BROWN, 200);
		_emitter.launchMode = FlxEmitterMode.SQUARE;
		_emitter.velocity.set(-10,-10,10,10,-10,-10,10,10);
		_emitter.alpha.set(0.9, 1, 0, 0);
		_emitter.lifespan.set(0.5, 1.5);
		_emitter.scale.set(0.3, 0.3, 1, 1);
		_emitter.start(true, 0.1, 5);
	}
}