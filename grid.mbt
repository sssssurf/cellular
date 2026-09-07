// A rectangular 2D grid of boolean cells (true = alive).

/// A rectangular grid of cells. `true` means alive, `false` means dead.
pub struct Grid {
  width : Int
  height : Int
  cells : Array[Bool]
}

/// Create an empty grid (all cells dead) of the given dimensions.
pub fn Grid::new(width : Int, height : Int) -> Grid {
  { width, height, cells: Array::make(width * height, false) }
}

/// The state of the cell at `(x, y)`. Coordinates are not bounds-checked.
pub fn Grid::get(self : Grid, x : Int, y : Int) -> Bool {
  self.cells[y * self.width + x]
}

/// Set the state of the cell at `(x, y)`. Coordinates are not bounds-checked.
pub fn Grid::set(self : Grid, x : Int, y : Int, value : Bool) -> Unit {
  self.cells[y * self.width + x] = value
}

/// Number of live cells in the grid.
pub fn Grid::live_count(self : Grid) -> Int {
  let mut n = 0
  for c in self.cells {
    if c {
      n = n + 1
    }
  }
  n
}
