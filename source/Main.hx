package;

import helpers.PlayerColors;
import states.SplashScreenState;
import states.PlayState;
import misc.Macros;
import states.MainMenuState;
import flixel.FlxState;
import config.Configure;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import misc.FlxTextFactory;
import openfl.display.Sprite;
import states.PlayState;
import states.TristanState;
import states.ParticlePlayState;
#if mike
import states.dev.MikeState;
#end

class Main extends Sprite {
	public function new() {
		super();
		Configure.initAnalytics(false);

		PlayerColors.shuffle();

		var startingState:Class<FlxState> = SplashScreenState;
		#if play
		startingState = PlayState;
		#elseif mike
		startingState = MikeState;
		#elseif logan
		startingState = PlayState;
		#elseif tristan
		startingState = TristanState;
		#elseif tanner
		startingState = ParticlePlayState;
		#else
		if (Macros.isDefined("SKIP_SPLASH")) {
			startingState = MainMenuState;
		}
		#end
		addChild(new FlxGame(0, 0, startingState, 1, 60, 60, true, false));

		FlxG.fixedTimestep = false;

		// Disable flixel volume controls as we don't use them because of FMOD
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;

		// Don't use the flixel cursor
		FlxG.mouse.useSystemCursor = true;

		#if debug
		FlxG.autoPause = false;
		#end

		// Set up basic transitions. To override these see `transOut` and `transIn` on any FlxTransitionable states
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);

		FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
	}
}
