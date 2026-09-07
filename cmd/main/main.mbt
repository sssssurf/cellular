fn main {
  let args = @env.args()
  if args.length() < 2 {
    print_usage()
    return
  }
  match args[1] {
    "life" => run_life(args)
    "eca" => run_eca(args)
    "patterns" => list_patterns()
    _ => print_usage()
  }
}

fn print_usage() -> Unit {
  println("cellular — cellular automata simulator")
  println("")
  println("usage:")
  println("  cellular life <rule> <generations> <pattern>")
  println("  cellular eca <rule 0-255> <width> <generations>")
  println("  cellular patterns")
  println("")
  println("examples:")
  println("  cellular life B3/S23 10 glider")
  println("  cellular eca 30 40 20")
}

fn run_life(args : Array[String]) -> Unit {
  if args.length() < 5 {
    println("usage: cellular life <B/S rule> <generations> <pattern>")
    return
  }
  let rule = match @cellular.parse_life_rule(args[2]) {
    Some(r) => r
    None => {
      println("invalid rule: \{args[2]}")
      return
    }
  }
  let generations = parse_nonneg(args[3])
  let grid = match @cellular.pattern_by_name(args[4]) {
    Some(g) => g
    None => {
      println("unknown pattern: \{args[4]} (run `cellular patterns`)")
      return
    }
  }
  let mut cur = grid
  println(@cellular.render_grid(cur))
  for _ in 0..<generations {
    cur = @cellular.life_step(rule, cur, true)
    println(@cellular.render_grid(cur))
  }
}

fn run_eca(args : Array[String]) -> Unit {
  if args.length() < 5 {
    println("usage: cellular eca <rule 0-255> <width> <generations>")
    return
  }
  let rule = parse_nonneg(args[2])
  let width = parse_nonneg(args[3])
  let generations = parse_nonneg(args[4])
  if width < 3 {
    println("width must be at least 3")
    return
  }
  let state = Array::make(width, false)
  state[width / 2] = true
  let mut cur = state
  println(@cellular.render_eca(cur))
  for _ in 0..<generations {
    cur = @cellular.eca_step(rule, cur, true)
    println(@cellular.render_eca(cur))
  }
}

fn list_patterns() -> Unit {
  println("available patterns:")
  for name in @cellular.pattern_names() {
    println("  \{name}")
  }
}

fn parse_nonneg(s : String) -> Int {
  let mut acc = 0
  for ch in s {
    if ch >= '0' && ch <= '9' {
      acc = acc * 10 + (ch.to_int() - '0'.to_int())
    } else {
      return 0
    }
  }
  acc
}
