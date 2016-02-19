import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

class Grid extends Entity {
	var tiles:Tilemap;
	public override function new(x:Float, y:Float):Void {
		super(x,y);
		tiles = new Tilemap("graphics/tile.png", 640, 480, 20, 20);
		graphic = tiles;

		tiles.setTile(0, 0, 1);
	}
}