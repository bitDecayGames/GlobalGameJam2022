package ui;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PlayOverlay extends FlxSubState {
    public function new() {
        super();

        var test = new FlxSprite();
        test.makeGraphic(50, 50, FlxColor.LIME);
        test.x = 50;
        test.y = 50;
        add(test);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        _parentState.update(elapsed);
    }
}