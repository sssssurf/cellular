# cellular

A cellular automaton library and command-line simulator written in MoonBit.

`cellular` provides two families of cellular automata:

- **Life-like automata** (2D) — configurable birth/survival rules using the
  standard `B/S` notation (e.g. Conway's Game of Life is `B3/S23`).
- **Elementary cellular automata** (1D) — the 256 Wolfram rules (0–255),
  including Rule 30, Rule 90, and Rule 110.

The core is pure functions over plain `Bool` arrays, so it is trivially
testable and runs on the native, `wasm`, and `wasm-gc` targets.

## Install

```sh
moon add sssssurf/cellular
```

## Library usage

```moonbit
let rule = @cellular.conway()

// A glider: a spaceship that travels diagonally.
let mut grid = @cellular.glider()

for _ in 0..<4 {
  grid = @cellular.life_step(rule, grid, true) // toroidal edges
}

println(@cellular.render_grid(grid))
```

Custom life-like rules via `B/S` notation:

```moonbit
let highlife = @cellular.parse_life_rule("B36/S23").unwrap()
let grid = @cellular.life_step(highlife, @cellular.r_pentomino(), false)
```

1D elementary cellular automata:

```moonbit
let state : Array[Bool] = @array.replicate(41, false)
state[20] = true

for row in @cellular.eca_run(30, state, 16, false) {
  println(@cellular.render_eca(row)) // Rule 30 -> Sierpinski-like triangle
}
```

## Command line

Run the simulator without writing code:

```sh
# Conway's Game of Life, glider pattern, 10 generations
moon run cmd/main -- life B3/S23 10 glider

# Rule 30 (1D), width 41, 16 generations
moon run cmd/main -- eca 30 41 16

# List available patterns
moon run cmd/main -- patterns
```

## Rules and patterns

| Command | Rule | Meaning |
| --- | --- | --- |
| `life B3/S23` | Conway's Game of Life | the classic rule |
| `life B36/S23` | HighLife | adds a replicator |
| `life B2/S` | Seeds | every cell dies, explosive growth |
| `life B3678/S34678` | Day & Night | symmetric under on/off inversion |
| `eca 30` | Rule 30 | chaotic, used as a PRNG |
| `eca 90` | Rule 90 | Sierpinski triangle |
| `eca 110` | Rule 110 | Turing-complete |

Built-in patterns: `block`, `blinker`, `toad`, `beacon`, `glider`,
`r-pentomino`, `beehive`, `tub`.

Additional life-like rules are also available as functions: `replicator`,
`life_without_death`, `maze`, `anneal`, `diamoeba`, and `coral`.

## Development

```sh
moon test          # run the test suite
moon build         # compile
moon run cmd/main -- help
```

## License

Apache-2.0
