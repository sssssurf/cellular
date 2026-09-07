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

/// Create a grid where each cell is alive with probability `density`
/// (0.0 = all dead, 1.0 = all alive).
pub fn Grid::random(width : Int, height : Int, density : Double) -> Grid {
  let g = Grid::new(width, height)
  let rand = @random.Rand::new()
  for y = 0; y < height; y = y + 1 {
    for x = 0; x < width; x = x + 1 {
      g.set(x, y, rand.double() < density)
    }
  }
  g
}
