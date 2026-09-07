// Named patterns and a lookup helper for demos and the CLI.

fn make_pattern(width : Int, height : Int, cells : Array[(Int, Int)]) -> Grid {
  let g = Grid::new(width, height)
  for t in cells {
    let (x, y) = t
    g.set(x, y, true)
  }
  g
}

/// A still life: a 2x2 block.
pub fn block() -> Grid {
  make_pattern(4, 4, [(0, 0), (1, 0), (0, 1), (1, 1)])
}

/// A period-2 oscillator.
pub fn blinker() -> Grid {
  make_pattern(5, 5, [(1, 2), (2, 2), (3, 2)])
}

/// A period-2 oscillator.
pub fn toad() -> Grid {
  make_pattern(6, 6, [(1, 1), (2, 1), (3, 1), (0, 2), (1, 2), (2, 2)])
}

/// A period-2 oscillator.
pub fn beacon() -> Grid {
  make_pattern(6, 6, [(0, 0), (1, 0), (0, 1), (2, 2), (3, 2), (2, 3), (3, 3)])
}

/// A spaceship that travels diagonally.
pub fn glider() -> Grid {
  make_pattern(5, 5, [(1, 0), (2, 1), (0, 2), (1, 2), (2, 2)])
}

/// A methuselah: a tiny seed that evolves for a very long time.
pub fn r_pentomino() -> Grid {
  make_pattern(5, 5, [(1, 0), (2, 0), (0, 1), (1, 1), (1, 2)])
}

/// A still life shaped like a beehive.
pub fn beehive() -> Grid {
  make_pattern(4, 4, [(1, 0), (2, 0), (0, 1), (3, 1), (1, 2), (2, 2)])
}

/// A still life shaped like a tub.
pub fn tub() -> Grid {
  make_pattern(4, 4, [(1, 0), (0, 1), (2, 1), (1, 2)])
}

/// Look up a pattern by name (used by the CLI).
pub fn pattern_by_name(name : String) -> Grid? {
  match name {
    "block" => Some(block())
    "blinker" => Some(blinker())
    "toad" => Some(toad())
    "beacon" => Some(beacon())
    "glider" => Some(glider())
    "r-pentomino" => Some(r_pentomino())
    "beehive" => Some(beehive())
    "tub" => Some(tub())
    _ => None
  }
}

/// All supported pattern names.
pub fn pattern_names() -> Array[String] {
  ["block", "blinker", "toad", "beacon", "glider", "r-pentomino", "beehive", "tub"]
}
