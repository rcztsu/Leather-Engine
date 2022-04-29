package modding;

#if sys
using StringTools;

import openfl.utils.Assets;
import openfl.media.Sound;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import sys.FileSystem;
import sys.io.File;

/**
    Nice handler for loading custom system / mod files.
**/
class ModAssets
{
    /**
        The cache that stores FlxGraphics for later use.
    **/
    public static var image_cache:Map<String, FlxGraphic> = [];

    /**
        The cache that stores Sounds for later use.
    **/
    public static var sound_cache:Map<String, Sound> = [];

    /**
        Clears all asset caches.
    **/
    public static function clear_caches()
    {
        image_cache.clear();
        sound_cache.clear();
    }

    /**
        Clears a specific `image` from the cache.
        @param image The image key in the cache.
    **/
    public static function clear_image(image:String)
    {
        image_cache.remove(image);
    }

    /**
        Clears a specific `sound` from the cache.
        @param sound The sound key in the cache.
    **/
    public static function clear_sound(sound:String)
    {
        sound_cache.remove(sound);
    }

    /**
        The current working directory of the game.
    **/
    public static var cwd:String = Sys.getCwd();

    /**
        Returns if the specified `path` exists in the given `mod`
        @param path Path to file.
        @param mod Mod to check (optional).
    **/
    public static function exists(path:String, ?mod:String):Bool
    {
        if(Assets.exists(path))
            return true;
        
        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];

        if(mod != null)
        {
            if(FileSystem.exists('${cwd}mods/$mod/$good_path'))
                return true;
        }
        else
        {
            for(_mod in ModHandler.loaded_mods)
            {
                if(FileSystem.exists('${cwd}mods/$_mod/$good_path'))
                    return true;
            }
        }

        return false;
    }

    /**
        Returns the path of the `path` using the given `mod` on the system.
        @param path Path to file (in asset style).
        @param mod Mod to be checked (optional).
    **/
    public static function get_path(path:String, ?mod:String):String
    {
        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];

        if(mod != null)
        {
            if(FileSystem.exists('${cwd}mods/$mod/$good_path'))
                return 'mods/$mod/$good_path';
        }
        else
        {
            for(_mod in ModHandler.loaded_mods)
            {
                if(FileSystem.exists('${cwd}mods/$_mod/$good_path'))
                    return 'mods/$_mod/$good_path';
            }
        }

        return "assets/" + good_path;
    }

    /**
        Returns the text contents of any given `path` in any given `mod`.
        @param path The path to the text.
        @param mod The mod to load from. (optional)
    **/
    public static function get_text(path:String, ?mod:String):Null<String>
    {
        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];

        if(mod != null)
        {
            if(FileSystem.exists('${cwd}mods/$mod/$good_path'))
                return File.getContent('${cwd}mods/$mod/$good_path');
        }
        else
        {
            for(_mod in ModHandler.loaded_mods)
            {
                if(FileSystem.exists('${cwd}mods/$_mod/$good_path'))
                    return File.getContent('${cwd}mods/$_mod/$good_path');
            }
        }

        if(Assets.exists(path))
            return Assets.getText(path);
        else
            return null;
    }

    /**
        Returns the text contents of any given `path` in any given `mod`. (with `_append` folders included)
        @param path The path to the text.
        @param mod The mod to load from. (optional)
    **/
    public static function get_append_text(path:String, ?mod:String):Null<String>
    {
        var text:String = (exists(path) ? get_text(path) + "\n" : "");

        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];

        if(mod != null)
        {
            if(FileSystem.exists('${cwd}mods/$mod/_append/$good_path'))
                return text + File.getContent('${cwd}mods/$mod/_append/$good_path') + "\n";
        }
        else
        {
            for(_mod in ModHandler.loaded_mods)
            {
                if(FileSystem.exists('${cwd}mods/$_mod/_append/$good_path'))
                    text += File.getContent('${cwd}mods/$_mod/_append/$good_path') + "\n";
            }

            return text;
        }

        return text;
    }

    /**
        Returns the image of any given `path` in any given `mod`. (as a FlxGraphic)
        @param path The path to the image.
        @param mod The mod to load from. (optional)
    **/
    public static function get_image(path:String, ?mod:String, ?cache:Bool = true):Null<FlxGraphic>
    {
        if(!cache && image_cache.exists(mod + ":" + path))
            image_cache.remove(mod + ":" + path);
        
        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];
        good_path = good_path.split(":")[good_path.split(":").length - 1];

        if(good_path.endsWith(".png"))
            good_path = good_path.split(".png")[0];

        if(!image_cache.exists(mod + ":" + path))
        {
            var bitmap_data:Null<BitmapData>;
            
            bitmap_data = get_bitmap_data(good_path + ".png", mod);

            if(bitmap_data != null)
            {
                var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap_data, false, null, false);
                graphic.persist = true;

                image_cache.set(mod + ":" + path, graphic);
            }
            else
            {
                if(Assets.exists(path))
                {
                    bitmap_data = BitmapData.fromFile(cwd + path.split(":")[path.split(":").length - 1]);

                    var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap_data, false, null, false);
                    graphic.persist = true;
    
                    image_cache.set(mod + ":" + path, graphic);
                }
                else
                    return null;
            }
        }

        return image_cache.get(mod + ":" + path);
    }

    /**
        Returns the bitmap data of any given `path` in any given `mod`.
        @param path The path to the image.
        @param mod The mod to load from. (optional)
    **/
    public static function get_bitmap_data(path:String, ?mod:String):Null<BitmapData>
    {
        if(mod != null)
        {
            if(FileSystem.exists('${cwd}mods/$mod/$path'))
                return BitmapData.fromFile('${cwd}mods/$mod/$path');
        }
        else
        {
            for(_mod in ModHandler.loaded_mods)
            {
                if(FileSystem.exists('${cwd}mods/$_mod/$path'))
                    return BitmapData.fromFile('${cwd}mods/$_mod/$path');
            }
        }

        return null;
    }

    /**
        Returns the sound of any given `path` in any given `mod`. (as a Sound)
        @param path The path to the sound.
        @param mod The mod to load from. (optional)
    **/
    public static function get_sound(path:String, ?mod:String, ?cache:Bool = true):Null<Sound>
    {
        if(!cache && sound_cache.exists(mod + ":" + path))
            sound_cache.remove(mod + ":" + path);
        
        var good_path:String = path.split("assets/")[path.split("assets/").length - 1];

        if(good_path.endsWith('.${Paths.SOUND_EXT}'))
            good_path = good_path.split('.${Paths.SOUND_EXT}')[0];

        if(!sound_cache.exists(mod + ":" + path))
        {
            var sound:Null<Sound> = null;

            if(Assets.exists(path))
                sound = Sound.fromFile(cwd + path.split(":")[path.split(":").length - 1]);
            else
            {
                if(mod != null)
                {
                    if(FileSystem.exists('${cwd}mods/$mod/$good_path.${Paths.SOUND_EXT}'))
                        sound = Sound.fromFile('${cwd}mods/$mod/$good_path.${Paths.SOUND_EXT}');
                }
                else
                {
                    for(_mod in ModHandler.loaded_mods)
                    {
                        if(FileSystem.exists('${cwd}mods/$_mod/$good_path.${Paths.SOUND_EXT}'))
                            sound = Sound.fromFile('${cwd}mods/$_mod/$good_path.${Paths.SOUND_EXT}');
                    }
                }
            }

            if(sound == null)
                return null;
            else
                sound_cache.set(mod + ":" + path, sound);
        }

        return sound_cache.get(mod + ":" + path);
    }
}
#end