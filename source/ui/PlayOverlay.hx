package ui;

import flixel.util.FlxAxes;
import flixel.FlxObject;
import flixel.FlxG;
import entities.GameData;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PlayOverlay extends FlxSubState {
    var data:GameData;

    var startup:FlxSprite;

    var callback:()->Void;

    var gameStarted:Bool = false;

    public function new(data:GameData, startCallback:()->Void) {
        super();

        this.data = data;
        callback = startCallback;

        var test = new FlxSprite();
        test.makeGraphic(50, 50, FlxColor.LIME);
        test.x = 20;
        test.y = 20;
        add(test);


        var test2 = new FlxSprite();
        test2.makeGraphic(50, 50, FlxColor.LIME);
        test2.x = FlxG.width - 70;
        test2.y = 20;
        add(test2);

        startup = new FlxSprite();
        startup.screenCenter(FlxAxes.XY);
        startup.x -= 100;
        startup.y -= 100;
		startup.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
		startup.animation.add("countdown", [0, 1, 2, 0], 1);
        startup.animation.play("countdown");
        startup.animation.callback = (name:String, frameNum:Int, frameIndex:Int) -> {
            if (name == "countdown" && frameNum == 3) {
                callback();
                gameStarted = true;
                startup.kill();
            }
        };

        add(startup);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (gameStarted) {
            _parentState.update(elapsed);
        }
    }
}