package;

import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class PlayState extends FlxUIState
{
    public static var instance:PlayState;
    public var phoenixMap:Map<String, FlxSprite> = new Map();

    public var phoenixs:FlxSpriteGroup = new FlxSpriteGroup();
    public var textBox:FlxSprite;
    public var globalText:FlxTypedGroup<FlxTypeText> = new FlxTypedGroup();
    public var currentText:FlxTypeText;
    public var texts:Array<{name:String, ?delay:Float}> = [];

    override function create() 
    {
        var time = Sys.time();
        instance = this;
        super.create();

        add(phoenixs);

        var thinkinPhoenix:FlxSprite = createPhoenix("think", 960, 640, 27, 8);
        thinkinPhoenix.animation.finishCallback = function(name) 
        {
            new FlxTimer().start(.04, function(tmr:FlxTimer)
            {
                thinkinPhoenix.animation.play('idle');
            });
        };

        textBox = new FlxSprite().loadGraphic(Asset.graphic("textbox.png"));
        textBox.screenCenter();
        textBox.scale.y *= .8;
        textBox.updateHitbox();
        textBox.y += FlxG.height / 3;
        textBox.alpha = .95;
        add(textBox);
        
        add(globalText);

        createText("lmaoaaaaaaaaaaaa", 5);
        readyText("aaaaaaaaaaaaa", 1);
        readyText("meeeeeeeeeeeeee", 2.5);
        trace(Sys.time() - time);
    }

    function createPhoenix(key:String, width:Int, height:Int, frames:Int, frame:Int)
    {
        if (phoenixMap.exists(key))
            return phoenixMap.get(key);

        var phoenix:FlxSprite = Asset.gifSprite("phoenix/" + key + ".png", width, height, frames, frame);
        phoenix.screenCenter();
        phoenix.animation.play('idle');
        phoenixs.add(phoenix);
        phoenixMap.set(key, phoenix);
        return phoenix;
    }

    function createText(text:String, ?delay:Float, ?push:Bool = true)
    {
        if (push)
            texts.push({name: text, delay: delay});

        var text:FlxTypeText = new FlxTypeText(0, 0, 0, text, 50);
        text.font = "assets/fonts/def.otf";
        text.screenCenter();
        text.y = textBox.y;
        text.sounds = [new FlxSound().loadEmbedded(Asset.sound('talk_male.wav'))];
        if (delay != null)
            text.delay = delay / 50;
        text.start();
        currentText = text;
        globalText.add(text);
        return text;
    }

    function readyText(text:String, ?delay:Float)
    {
        texts.push({name: text, delay: delay});
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        if (currentText != null && (FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed))
        {
            trace(texts.length);

            var typing = @:privateAccess currentText._typing;

            if (typing)
                currentText.skip();
            else if (texts.length > 1)
            {
                texts.shift();

                var ttext = globalText.members[globalText.members.length - 1];
                globalText.remove(ttext, true);
                ttext.kill();
                ttext.destroy();

                var text = texts[Std.int(Math.min(0, texts.length - 1))];
                createText(text.name, text.delay, false);
            }
        }

        if (FlxG.keys.justPressed.R)
            FlxG.resetState();
    }
}