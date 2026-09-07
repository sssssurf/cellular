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
