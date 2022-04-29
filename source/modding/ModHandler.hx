package modding;

#if sys
/**
    The class responsible for loading in mods.
**/
class ModHandler
{
    /**
        An Array of all the currently loaded mods.
    **/
    public static var loaded_mods:Array<String> = [];

    /**
        An Array with all mods found.
    **/
    public static var all_mods:Array<String> = [];

    /**
        Initializes everything required to load mods.
    **/
    public static function init()
    {
        load_all();
    }

    /**
        Loads all active mods.
    **/
    public static function load_all()
    {
        scan_mods();

        loaded_mods = [];

        for(mod in ModList.getActiveMods())
        {
            load_mod(mod);
        }
    }

    /**
        Loads a specific mod using the `mod_name` parameter.
        @param mod_name Name of the folder mod to load
    **/
    public static function load_mod(mod_name:String)
    {
        if(all_mods.contains(mod_name))
            loaded_mods.push(mod_name);
    }

    /**
        Unloads all active mods.
    **/
    public static function unload_all()
    {
        for(mod in loaded_mods)
        {
            unload_mod(mod);
        }
    }

    /**
        Unloads a specific mod using the `mod_name` parameter.
        @param mod_name Name of the folder mod to unload
    **/
    public static function unload_mod(mod_name:String)
    {
        loaded_mods.remove(mod_name);
    }

    /**
        Loads all mod's metadata
    **/
    public static function load_mod_metadata()
    {
        ModList.modMetadatas.clear();

        for(mod in all_mods)
        {
            ModList.modMetadatas.set(mod, haxe.Json.parse(ModAssets.get_text("_polymod_meta.json", mod)));
        }
    }

    /**
        Scans and finds all possible mods.
    **/
    public static function scan_mods()
    {
        all_mods = [];

        var mod_dir:String = Sys.getCwd() + "mods/";

        for(dir in sys.FileSystem.readDirectory(mod_dir))
        {
            var dir_mod = mod_dir + "/" + dir + "/";

            if(sys.FileSystem.exists(dir_mod + "_polymod_meta.json") && sys.FileSystem.exists(dir_mod + "_polymod_icon.png"))
                all_mods.push(dir);
        }

        load_mod_metadata();
    }
}
#end