package shaders;

import openfl.display.ShaderInput;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import openfl.display.ShaderParameter;
import flixel.system.FlxAssets.FlxShader;

class ColorShifterShader extends FlxShader {
	private var swapperTex:FlxSprite;

	@:glFragmentSource('
        #pragma header

        uniform sampler2D tex;

        void main()
        {
            vec4 original = texture2D(bitmap, openfl_TextureCoordv);
            vec2 coord = vec2(original.x, 1.0);
            vec4 swap = texture2D(tex, coord);
            if (swap.w != 0.0 && original.w != 0.0) {
                 original = swap;
            }
            gl_FragColor = original;
        }')
	public function new(map:Map<Int, FlxColor>) {
		super();
		swapperTex = new FlxSprite();
		swapperTex.makeGraphic(256, 1, FlxColor.TRANSPARENT, true);
		swapperTex.pixels.lock();
		for (index => value in map) {
			swapperTex.pixels.setPixel32(index, 0, value);
		}
		swapperTex.pixels.unlock();

		tex.input = swapperTex.pixels;
	}
}
