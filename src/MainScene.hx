import com.haxepunk.Scene;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Draw;
import com.haxepunk.graphics.Image.createRect;

class MainScene extends Scene {
	var tiles:Tilemap;
	var changes:Array<Change>;
	public override function begin() {
		Input.define("Next", [Key.ENTER]);
		tiles = new Tilemap("graphics/tile.png", 640, 480, 20, 20);
		changes = new Array<Change>();
		
		addGraphic(tiles, 0, 0, 0);
		drawGrid();
	}

	public function drawGrid():Void {
		for ( x in 0 ... tiles.columns ) 
			addGraphic(createRect(1, 480, 0xa7a0c3, .5), 0, x * 20, 0);
		for ( y in 0 ... tiles.rows )
			addGraphic(createRect(640, 1, 0xa7a0c3, .5), 0, 0, y * 20);
	}

	public override function update():Void {
		super.update();
		if ( Input.mousePressed )
			flipTile();
		if ( Input.pressed("Next") ) {
			applyRules();
			makeChanges();
		}
	}

	public function flipTile():Void {
		if ( tiles.getTile(getColumn(), getRow()) == 0 )
			tiles.clearTile(getColumn(), getRow());
		else tiles.setTile(getColumn(), getRow());
	}

	public function applyRules():Void {
		for (column in 0 ... tiles.columns)
			for ( row in 0 ... tiles.rows ) {
				if ( tiles.getTile(column, row) == 0 ) {
					if ( numberOfNeighbors(column, row) < 2 )
						changes.push(new Change(column, row, -1));
					if ( numberOfNeighbors(column, row) > 3)
						changes.push(new Change(column, row, -1));
				} else 
					if ( numberOfNeighbors(column, row) == 3)
						changes.push(new Change(column, row, 0));
			}
	}

	public function getColumn():Int {
		var columns:Int = 0;
		while ( columns < Input.mouseX )
			columns += 20;
		return Std.int( (columns - 1) / 20);
	}

	public function getRow():Int {
		var rows:Int = 0;
		while ( rows < Input.mouseY )
			rows += 20;
		return Std.int( (rows - 1) / 20);
	}

	public function makeChanges():Void {
		for (change in changes)
			tiles.setTile(change.column, change.row, change.index);	
		
		for ( change in changes ) changes.remove(change);
	}

	public function numberOfNeighbors(column:Int, row:Int):Int {
		var neighbors:Int = 0;
		if ( column > 0 && tiles.getTile(column - 1, row) == 0 )
			neighbors++;
		if ( column < tiles.columns - 1 && tiles.getTile(column + 1, row) == 0 )
			neighbors++;
		if ( row > 0 && tiles.getTile(column, row - 1) == 0 )
			neighbors++;
		if ( row < tiles.rows - 1 && tiles.getTile(column, row + 1) == 0 )
			neighbors++;
		if ( column < tiles.columns - 1 && row < tiles.rows - 1 &&
			tiles.getTile(column + 1, row + 1) == 0 )
			neighbors++;
		if ( column < tiles.columns - 1 && row > 0 && 
			tiles.getTile(column + 1, row - 1) == 0 )
			neighbors++;
		if ( column > 0 && row < tiles.columns - 1 &&
			tiles.getTile(column - 1, row + 1) == 0 )
			neighbors++;
		if ( column > 0 && row > 0 && tiles.getTile(column - 1, row - 1) == 0 )
			neighbors++;
		return neighbors;
	}
}

class Change {
	public var column:Int;
	public var row:Int;
	public var index:Int;

	public function new(column:Int, row:Int, index:Int) {
		this.column = column;
		this.row = row;
		this.index = index;
	}
}