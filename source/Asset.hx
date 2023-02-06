package;

import flixel.graphics.FlxGraphic;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.media.Sound;

using StringTools;

abstract Asset(String) from String to String
{
    public static var graphics:Map<String, FlxGraphic> = new Map();
    public static var sounds:Map<String, Sound> = new Map();

    public static function graphic(key:String) 
    {
        var key = 'assets/images/$key';
        var graphic:FlxGraphic = graphics.get(key);

        if (graphic == null)
        {
            graphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(key), false, key);
            graphic.persist = true;
            graphics.set(key, graphic);
        }

        return graphics.get(key);
    }

    public static function sound(key:String)
    {
        var key = 'assets/sounds/$key';
        var sound:Sound = sounds.get(key);

        if (sound == null)
        {
            sound = Sound.fromFile(key);
            sounds.set(key, sound);
        }

        return sounds.get(key);
    }

    public static function gifSprite(key:String, width:Int, height:Int, frames:Int, frame:Int)
    {
        var sprite:FlxSprite = new FlxSprite().loadGraphic(graphic(key), true, width, height);
        sprite.animation.add('idle', [for (i in 0...frames) i], frame, false);
        sprite.animation.finishCallback = function(name) 
        {
            new FlxTimer().start(function(tmr:FlxTimer)
            {
                sprite.animation.play('idle');
            });
        };
        return sprite;
    }
}