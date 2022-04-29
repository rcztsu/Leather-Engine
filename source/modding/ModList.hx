package modding;

#if sys
/**
	The class responsible for storing the mods that are enabled.

	It's also the class that stores them into save data.
**/
class ModList
{
	public static var modList:Map<String, Bool> = new Map<String, Bool>();

    public static var modMetadatas:Map<String, ModMetadata> = new Map();

	public static function setModEnabled(mod:String, enabled:Bool):Void
	{
		modList.set(mod, enabled);

		utilities.Options.setData(modList, "modlist", "modlist");

		ModHandler.load_all();
	}

	public static function getModEnabled(mod:String):Bool
	{
		if (!modList.exists(mod))
			setModEnabled(mod, false);

		return modList.get(mod);
	}

    public static function getActiveMods(?modsToCheck:Null<Array<String>>):Array<String>
    {
		#if sys
		if(modsToCheck == null)
			modsToCheck = sys.FileSystem.readDirectory(Sys.getCwd() + "mods/");
		#end

        var activeMods:Array<String> = [];

        for(modName in modsToCheck)
        {
            if(getModEnabled(modName))
                activeMods.push(modName);
        }

        return activeMods;
    }

	public static function load():Void
	{
		if(utilities.Options.getData("modlist", "modlist") != null && utilities.Options.getData("modlist", "modlist") != [])
			modList = utilities.Options.getData("modlist", "modlist");
	}
}
#end