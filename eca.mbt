// Elementary cellular automata (1D, Wolfram rules 0-255).

/// Compute one generation of a 1D elementary cellular automaton.
/// Each cell's next state is decided by the 3-bit neighbourhood
/// (left, centre, right) and the given rule number.
pub fn eca_step(rule : Int, state : Array[Bool], toroidal : Bool) -> Array[Bool] {
  let n = state.length()
  let next = Array::make(n, false)
  for i = 0; i < n; i = i + 1 {
    let left = if i == 0 {
      if toroidal {
        state[n - 1]
      } else {
        false
      }
    } else {
      state[i - 1]
    }
    let center = state[i]
    let right = if i == n - 1 {
      if toroidal {
        state[0]
      } else {
        false
      }
    } else {
      state[i + 1]
    }
    let idx = (if left { 4 } else { 0 }) + (if center { 2 } else { 0 }) + (if right { 1 } else { 0 })
    next[i] = ((rule >> idx) & 1) == 1
  }
  next
}

/// Run `generations` steps and return all states, including the initial one.
pub fn eca_run(
  rule : Int,
  state : Array[Bool],
  generations : Int,
  toroidal : Bool
) -> Array[Array[Bool]] {
  let states : Array[Array[Bool]] = []
  states.push(state)
  let mut cur = state
  for _ in 0..<generations {
    cur = eca_step(rule, cur, toroidal)
    states.push(cur)
  }
  states
}
