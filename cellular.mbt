// High-level rendering and simulation helpers.

/// Render a grid to a string using '#' for live cells and '.' for dead cells.
pub fn render_grid(grid : Grid) -> String {
  let buf = StringBuilder()
  for y = 0; y < grid.height; y = y + 1 {
    for x = 0; x < grid.width; x = x + 1 {
      if grid.get(x, y) {
        buf.write_char('#')
      } else {
        buf.write_char('.')
      }
    }
    buf.write_char('\n')
  }
  buf.to_string()
}

/// Render a 1D state to a string using '#' for live and ' ' for dead cells.
pub fn render_eca(state : Array[Bool]) -> String {
  let buf = StringBuilder()
  for i = 0; i < state.length(); i = i + 1 {
    if state[i] {
      buf.write_char('#')
    } else {
      buf.write_char(' ')
    }
  }
  buf.to_string()
}
