// A rectangular 2D grid of boolean cells (true = alive).

pub struct Grid {
  width : Int
  height : Int
  cells : Array[Bool]
}

pub fn Grid::new(width : Int, height : Int) -> Grid {
  { width, height, cells: Array::make(width * height, false) }
}

pub fn Grid::get(self : Grid, x : Int, y : Int) -> Bool {
  self.cells[y * self.width + x]
}

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
