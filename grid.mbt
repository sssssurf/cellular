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

/// Parse a grid from ASCII art. `#`, `O`, `1`, or `X` marks a live cell; any
/// other character marks a dead cell. Rows are separated by newlines and must
/// all have the same length. Returns None for empty or ragged input.
pub fn Grid::from_string(s : String) -> Grid? {
  let lines : Array[String] = []
  let mut cur = StringBuilder()
  for ch in s {
    if ch == '\n' {
      lines.push(cur.to_string())
      cur = StringBuilder()
    } else {
      cur.write_char(ch)
    }
  }
  let last = cur.to_string()
  if last.length() > 0 {
    lines.push(last)
  }
  if lines.length() == 0 {
    return None
  }
  let height = lines.length()
  let width = lines[0].length()
  for line in lines {
    if line.length() != width {
      return None
    }
  }
  let g = Grid::new(width, height)
  for y = 0; y < height; y = y + 1 {
    let line = lines[y]
    for x = 0; x < width; x = x + 1 {
      let c = line[x]
      if c == '#' || c == 'O' || c == '1' || c == 'X' {
        g.set(x, y, true)
      }
    }
  }
  Some(g)
}

/// Return an independent copy of the grid.
pub fn Grid::copy(self : Grid) -> Grid {
  let g = Grid::new(self.width, self.height)
  for i = 0; i < self.cells.length(); i = i + 1 {
    g.cells[i] = self.cells[i]
  }
  g
}

/// Fraction of cells that are alive (0.0 to 1.0). Returns 0.0 for an empty grid.
pub fn Grid::density(self : Grid) -> Double {
  let total = self.width * self.height
  if total == 0 {
    0.0
  } else {
    self.live_count().to_double() / total.to_double()
  }
}
