package modding;

/**
    A simple typedef to store information about mods (previously was created by `polymod`, but is custom now)
**/
typedef ModMetadata =
{
	var title:Null<String>;
	var description:Null<String>;
	var author:Null<String>;
	var api_version:Null<String>;
	var mod_version:Null<String>;
	var license:Null<String>;
}