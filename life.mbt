// Life-like cellular automata: configurable birth/survival rules (B/S notation).

pub struct LifeRule {
  birth : Array[Bool]
  survival : Array[Bool]
}

/// Parse a rule in B/S notation, e.g. "B3/S23", "B36/S23", "B2/S".
/// Returns None if the string contains characters outside B, S, digits 0-8,
/// '/', and whitespace.
pub fn parse_life_rule(s : String) -> LifeRule? {
  let birth = Array::make(9, false)
  let survival = Array::make(9, false)
  let mut section = 'B'
  for ch in s {
    if ch == 'B' || ch == 'b' {
      section = 'B'
    } else if ch == 'S' || ch == 's' {
      section = 'S'
    } else if ch >= '0' && ch <= '8' {
      let d = ch.to_int() - '0'.to_int()
      if section == 'B' {
        birth[d] = true
      } else {
        survival[d] = true
      }
    } else if ch == '/' || ch == ' ' || ch == '\t' {
      // separators and whitespace are ignored
    } else {
      return None
    }
  }
  Some({ birth, survival })
}

/// Conway's Game of Life (B3/S23).
pub fn conway() -> LifeRule {
  rule_from([3], [2, 3])
}

/// HighLife (B36/S23).
pub fn highlife() -> LifeRule {
  rule_from([3, 6], [2, 3])
}

/// Seeds (B2/S): every cell dies, two live neighbours give birth.
pub fn seeds() -> LifeRule {
  rule_from([2], [])
}

/// Day & Night (B3678/S34678).
pub fn day_night() -> LifeRule {
  rule_from([3, 6, 7, 8], [3, 4, 6, 7, 8])
}

/// Replicator (B1357/S1357): patterns eventually replicate themselves.
pub fn replicator() -> LifeRule {
  rule_from([1, 3, 5, 7], [1, 3, 5, 7])
}

/// Life without Death (B3/S012345678): live cells never die.
pub fn life_without_death() -> LifeRule {
  rule_from([3], [0, 1, 2, 3, 4, 5, 6, 7, 8])
}

/// Maze (B3/S12345): grows maze-like structures.
pub fn maze() -> LifeRule {
  rule_from([3], [1, 2, 3, 4, 5])
}

/// Anneal (B4678/S35678): rich in still lifes.
pub fn anneal() -> LifeRule {
  rule_from([4, 6, 7, 8], [3, 5, 6, 7, 8])
}

/// Diamoeba (B35678/S5678): produces large diamond shapes.
pub fn diamoeba() -> LifeRule {
  rule_from([3, 5, 6, 7, 8], [5, 6, 7, 8])
}

/// Coral (B3/S45678): grows coral-like structures.
pub fn coral() -> LifeRule {
  rule_from([3], [4, 5, 6, 7, 8])
}

fn rule_from(birth_digits : Array[Int], survival_digits : Array[Int]) -> LifeRule {
  let birth = Array::make(9, false)
  for d in birth_digits {
    birth[d] = true
  }
  let survival = Array::make(9, false)
  for d in survival_digits {
    survival[d] = true
  }
  { birth, survival }
}

/// Compute one generation of the automaton. When `toroidal` is true, edges
/// wrap around; otherwise cells outside the grid are treated as dead.
pub fn life_step(rule : LifeRule, grid : Grid, toroidal : Bool) -> Grid {
  let next = Grid::new(grid.width, grid.height)
  for y = 0; y < grid.height; y = y + 1 {
    for x = 0; x < grid.width; x = x + 1 {
      let n = live_neighbors(grid, x, y, toroidal)
      let alive = grid.get(x, y)
      next.set(x, y, if alive { rule.survival[n] } else { rule.birth[n] })
    }
  }
  next
}

/// Run `generations` steps and return all grids, including the initial one.
pub fn life_run(
  rule : LifeRule,
  grid : Grid,
  generations : Int,
  toroidal : Bool
) -> Array[Grid] {
  let grids : Array[Grid] = []
  grids.push(grid)
  let mut cur = grid
  for _ in 0..<generations {
    cur = life_step(rule, cur, toroidal)
    grids.push(cur)
  }
  grids
}

fn live_neighbors(grid : Grid, x : Int, y : Int, toroidal : Bool) -> Int {
  let mut count = 0
  for dy = -1; dy <= 1; dy = dy + 1 {
    for dx = -1; dx <= 1; dx = dx + 1 {
      if dx == 0 && dy == 0 {
        continue
      }
      if toroidal {
        let wx = (x + dx + grid.width) % grid.width
        let wy = (y + dy + grid.height) % grid.height
        if grid.get(wx, wy) {
          count = count + 1
        }
      } else {
        let nx = x + dx
        let ny = y + dy
        if nx >= 0 && nx < grid.width && ny >= 0 && ny < grid.height && grid.get(nx, ny) {
          count = count + 1
        }
      }
    }
  }
  count
}
