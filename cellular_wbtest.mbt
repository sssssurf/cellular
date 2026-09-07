// Whitebox tests for the cellular automaton library.

test "conway: block is a still life" {
  let rule = conway()
  let g0 = block()
  let g1 = life_step(rule, g0, true)
  assert_eq!(render_grid(g1), render_grid(g0))
  assert_eq!(g0.live_count(), 4)
}

test "conway: blinker oscillates with period 2" {
  let rule = conway()
  let g0 = blinker()
  let g1 = life_step(rule, g0, true)
  let g2 = life_step(rule, g1, true)
  assert_eq!(render_grid(g2), render_grid(g0))
  assert_eq!(g0.live_count(), 3)
  assert_eq!(g1.live_count(), 3)
}

test "conway: glider moves diagonally after 4 steps" {
  let rule = conway()
  let mut g = glider()
  for _ in 0..<4 {
    g = life_step(rule, g, true)
  }
  assert_eq!(g.live_count(), 5)
  assert_eq!(g.get(1, 0), false)
  assert_eq!(g.get(0, 2), false)
  assert_eq!(g.get(2, 1), true)
  assert_eq!(g.get(3, 2), true)
  assert_eq!(g.get(1, 3), true)
}

test "conway: toad oscillates with period 2" {
  let rule = conway()
  let g0 = toad()
  let g1 = life_step(rule, g0, true)
  let g2 = life_step(rule, g1, true)
  assert_eq!(render_grid(g2), render_grid(g0))
}

test "parse_life_rule: valid and invalid" {
  assert_eq!(rule_parses("B3/S23"), true)
  assert_eq!(rule_parses("B36/S23"), true)
  assert_eq!(rule_parses("B2/S"), true)
  assert_eq!(rule_parses("B3678/S34678"), true)
  assert_eq!(rule_parses("xyz"), false)
  assert_eq!(rule_parses("B9/S23"), false)
}

test "parse_life_rule: builds the right rule" {
  match parse_life_rule("B3/S23") {
    Some(r) => {
      assert_eq!(r.birth[3], true)
      assert_eq!(r.birth[2], false)
      assert_eq!(r.survival[2], true)
      assert_eq!(r.survival[3], true)
      assert_eq!(r.survival[1], false)
    }
    None => assert_eq!(true, false)
  }
}

test "seeds: a single cell dies" {
  let rule = seeds()
  let g = make_single_cell()
  let g1 = life_step(rule, g, false)
  assert_eq!(g1.live_count(), 0)
}

test "eca rule 0 kills everything" {
  let state = [true, true, true, true, true]
  let next = eca_step(0, state, false)
  for i = 0; i < next.length(); i = i + 1 {
    assert_eq!(next[i], false)
  }
}

test "eca rule 255 makes everything alive" {
  let state = [false, false, false]
  let next = eca_step(255, state, false)
  assert_eq!(next[0], true)
  assert_eq!(next[1], true)
  assert_eq!(next[2], true)
}

test "eca rule 204 is the identity" {
  let state = [true, false, true, true, false]
  let next = eca_step(204, state, true)
  assert_eq!(eq_bool_array(next, state), true)
}

test "eca rule 30 produces three cells from a single live cell" {
  let state = [false, false, true, false, false]
  let next = eca_step(30, state, false)
  assert_eq!(next[0], false)
  assert_eq!(next[1], true)
  assert_eq!(next[2], true)
  assert_eq!(next[3], true)
  assert_eq!(next[4], false)
}

test "render_grid uses # and . with one row per line" {
  let g = block()
  let s = render_grid(g)
  assert_eq!(s, "##..\n##..\n....\n....\n")
}

test "conway: beehive and tub are still lifes" {
  let rule = conway()
  let b0 = beehive()
  let t0 = tub()
  assert_eq!(render_grid(life_step(rule, b0, false)), render_grid(b0))
  assert_eq!(render_grid(life_step(rule, t0, false)), render_grid(t0))
  assert_eq!(b0.live_count(), 6)
  assert_eq!(t0.live_count(), 4)
}

test "life_without_death: a single cell never dies" {
  let rule = life_without_death()
  let g = make_single_cell()
  let g1 = life_step(rule, g, false)
  assert_eq!(g1.live_count(), 1)
}

test "life_run returns generations + 1 grids" {
  let grids = life_run(conway(), glider(), 5, true)
  assert_eq!(grids.length(), 6)
  assert_eq!(grids[0].live_count(), 5)
}

test "toroidal wrap counts wrapped neighbours" {
  let g = Grid::new(3, 3)
  g.set(2, 0, true)
  g.set(0, 2, true)
  g.set(2, 2, true)
  assert_eq!(live_neighbors(g, 0, 0, true), 3)
  assert_eq!(live_neighbors(g, 0, 0, false), 0)
}

test "parse_life_rule: empty string is a valid empty rule" {
  match parse_life_rule("") {
    Some(r) => {
      assert_eq!(r.birth[3], false)
      assert_eq!(r.survival[2], false)
    }
    None => assert_eq!(true, false)
  }
}

test "random grid respects density bounds" {
  let all_dead = Grid::random(20, 20, 0.0)
  let all_alive = Grid::random(20, 20, 1.0)
  assert_eq!(all_dead.live_count(), 0)
  assert_eq!(all_alive.live_count(), 400)
}

test "Grid::from_string parses ASCII art" {
  match Grid::from_string(".#.\n###\n.#.") {
    Some(g) => {
      assert_eq!(g.width, 3)
      assert_eq!(g.height, 3)
      assert_eq!(g.live_count(), 5)
      assert_eq!(g.get(1, 0), true)
      assert_eq!(g.get(0, 1), true)
      assert_eq!(g.get(1, 1), true)
      assert_eq!(g.get(2, 1), true)
      assert_eq!(g.get(1, 2), true)
      assert_eq!(g.get(0, 0), false)
    }
    None => assert_eq!(true, false)
  }
}

test "Grid::from_string rejects ragged or empty input" {
  let r1 = Grid::from_string(".#.\n##")
  let r2 = Grid::from_string("")
  let bad1 = match r1 {
    Some(_) => false
    None => true
  }
  let bad2 = match r2 {
    Some(_) => false
    None => true
  }
  assert_eq!(bad1, true)
  assert_eq!(bad2, true)
}

test "Grid::copy is independent of the original" {
  let g = glider()
  let g2 = g.copy()
  g2.set(0, 0, true)
  assert_eq!(g.get(0, 0), false)
  assert_eq!(g2.get(0, 0), true)
  assert_eq!(g2.live_count(), g.live_count() + 1)
}

test "Grid::density computes the live fraction" {
  let g = Grid::new(4, 4)
  g.set(0, 0, true)
  g.set(1, 0, true)
  assert_eq!(g.density(), 0.125)
}

test "find_period detects still life and oscillator" {
  match find_period(conway(), block(), 10, false) {
    Some(r) => {
      assert_eq!(r.period, 1)
      assert_eq!(r.steps, 0)
    }
    None => assert_eq!(true, false)
  }
  match find_period(conway(), blinker(), 10, false) {
    Some(r) => {
      assert_eq!(r.period, 2)
      assert_eq!(r.steps, 0)
    }
    None => assert_eq!(true, false)
  }
}

test "rule_descriptions lists all 10 rules" {
  assert_eq!(rule_descriptions().length(), 10)
}

fn rule_parses(s : String) -> Bool {
  match parse_life_rule(s) {
    Some(_) => true
    None => false
  }
}

fn make_single_cell() -> Grid {
  let g = Grid::new(3, 3)
  g.set(1, 1, true)
  g
}

fn eq_bool_array(a : Array[Bool], b : Array[Bool]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if a[i] != b[i] {
      return false
    }
  }
  true
}
