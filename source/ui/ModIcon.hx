package ui;

#if sys
import modding.ModAssets;
import flixel.FlxSprite;

class ModIcon extends FlxSprite
{
	/**
	 * Used for ModMenu! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var _modId:String = 'Template Mod';

	public function new(modId:String = 'Template Mod')
	{
		super();

		_modId = modId;

		loadGraphic(ModAssets.get_image("_polymod_icon", modId), false, 0, 0);

		setGraphicSize(150, 150);
		updateHitbox();
		
		scrollFactor.set();
		antialiasing = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	override public function destroy()
	{
		ModAssets.clear_image(_modId + ":_polymod_icon");

		super.destroy();
	}
}
#end