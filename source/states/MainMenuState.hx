package states;

import helpers.PlayerColors;
import js.html.Console;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import states.transitions.Trans;
import states.transitions.SwirlTransition;
import com.bitdecay.analytics.Bitlytics;
import config.Configure;
import flixel.FlxG;
import flixel.addons.ui.FlxUICursor;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUITypedButton;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;

using extensions.FlxStateExt;

#if windows
import lime.system.System;
#end

class MainMenuState extends FlxUIState {
	var _btnPlay:FlxButton;
	var _btnCredits:FlxButton;
	var _btnExit:FlxButton;

	var _txtTitle:FlxText;

	override public function create():Void {
		_xml_id = "main_menu";
		if (Configure.config.menus.keyboardNavigation || Configure.config.menus.controllerNavigation) {
			_makeCursor = true;
		}

		super.create();

		PlayerColors.shuffle();

		if (_makeCursor) {
			cursor.loadGraphic(AssetPaths.pointer__png, true, 32, 32);
			cursor.animation.add("pointing", [0, 1], 3);
			cursor.animation.play("pointing");
			cursor.callback = function cursorCallback(name:String, widget:IFlxUIWidget) {
				if (name == "cursor_jump") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuHover);
				}
			}

			var keys:Int = 0;
			if (Configure.config.menus.keyboardNavigation) {
				keys |= FlxUICursor.KEYS_ARROWS | FlxUICursor.KEYS_WASD;
			}
			if (Configure.config.menus.controllerNavigation) {
				keys |= FlxUICursor.GAMEPAD_DPAD;
			}
			cursor.setDefaultKeys(keys);
		}

		FmodManager.PlaySong(FmodSongs.Slime);
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		#if !windows
		// Hide exit button for non-windows targets
		var test = _ui.getAsset("exit_button");
		test.visible = false;
		#end

		// Trigger our focus logic as we are just creating the scene
		this.handleFocus();

		// we will handle transitions manually
		transOut = null;
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		switch name {
			case FlxUITypedButton.CLICK_EVENT:
				var button_action:String = params[0];
				trace('Action: "${button_action}"');

				if (button_action == "play") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
					clickPlay();
				}

				if (button_action == "credits") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
					clickCredits();
				}

				#if windows
				if (button_action == "exit") {
					clickExit();
				}
				#end
			case FlxUITypedButton.OVER_EVENT:
				var button_action:String = params[0];
				trace('Action: "${button_action}"');

				if (button_action == "play") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuHover);
				}

				if (button_action == "credits") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuHover);
				}

				#if windows
				if (button_action == "exit") {
					FmodManager.PlaySoundOneShot(FmodSFX.MenuHover);
				}
				#end
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}
	}

	function clickPlay():Void {
		// FmodManager.StopSong();
		// var swirlOut = new SwirlTransition(Trans.OUT, () -> {
		// 	// make sure our music is stopped;
		// 	FmodManager.StopSongImmediately();
		// 	FlxG.switchState(new PlayState());
		// }, FlxColor.GRAY);
		// openSubState(swirlOut);
		FmodFlxUtilities.TransitionToState(new PlayState());
	}

	function clickCredits():Void {
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	#if windows
	function clickExit():Void {
		System.exit(0);
	}
	#end

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
