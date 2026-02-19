# Snapster

A Hammerspoon spoon for grid-based window management.

## Grid System

Snapster divides each screen into a column grid based on aspect ratio:

- **Standard screens** (< 2.0 ratio) get **2 columns** (halves)
- **Ultrawide screens** (>= 2.0 ratio) get **3 columns** (thirds)

The threshold is configurable when you create the grid:

```lua
local grid = snap.grid(2.0)  -- 2.0 is the default ultrawide threshold
```

### Full-Height Movement (Left/Right)

Move and resize operations step through the column grid at full screen height.

**Move** collapses multi-column windows down to a single column and shifts one
step in the given direction. If the window is already at the edge of a screen,
it jumps to the adjacent screen.

**Resize** extends the window's edge in the given direction. When it can't
extend any further (already at the screen edge), it shrinks from the opposite
side instead. This lets you cycle through all possible column spans by
repeatedly pressing the same key.

```
Standard screen (2 cols)        Ultrawide (3 cols)

 ┌──────┬──────┐                ┌──────┬──────┬──────┐
 │  0   │  1   │                │  0   │  1   │  2   │
 │      │      │                │      │      │      │
 └──────┴──────┘                └──────┴──────┴──────┘
```

### Half-Height Movement (UIJK)

The same column grid applies, but windows are constrained to the top or bottom
half of the screen. U/I operate in the top half, J/K in the bottom half.

```
 ┌──────┬──────┐    U = move left, top half
 │  U   │  I   │    I = move right, top half
 ├──────┼──────┤    J = move left, bottom half
 │  J   │  K   │    K = move right, bottom half
 └──────┴──────┘
```

Resize works the same way -- add `cmd` to grow/shrink horizontally while
staying locked to the top or bottom half.

### Resize Cycling Example

On a 3-column ultrawide, starting in column 0 and repeatedly pressing
resize-right:

```
 Step 1: extend right     Step 2: extend right     Step 3: shrink from left
 ┌───────────┬──────┐     ┌──────────────────┐     ┌──────┬───────────┐
 │  0     1  │  2   │     │  0     1     2   │     │  0   │  1     2  │
 └───────────┴──────┘     └──────────────────┘     └──────┴───────────┘
  col=0 span=2             col=0 span=3             col=1 span=2
```

## Example Configuration

```lua
local grid = snap.grid(2.0)

-- Full-height grid (arrow keys)
snap:bind({{"ctrl", "alt"}, "left"},  grid.moveLeft)
snap:bind({{"ctrl", "alt"}, "right"}, grid.moveRight)
snap:bind({{"ctrl", "alt", "cmd"}, "left"},  grid.resizeLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "right"}, grid.resizeRight)

-- Half-height grid (UIJK)
snap:bind({{"ctrl", "alt"}, "U"}, grid.moveUpLeft)
snap:bind({{"ctrl", "alt"}, "I"}, grid.moveUpRight)
snap:bind({{"ctrl", "alt"}, "J"}, grid.moveDownLeft)
snap:bind({{"ctrl", "alt"}, "K"}, grid.moveDownRight)
snap:bind({{"ctrl", "alt", "cmd"}, "U"}, grid.resizeUpLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "I"}, grid.resizeUpRight)
snap:bind({{"ctrl", "alt", "cmd"}, "J"}, grid.resizeDownLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "K"}, grid.resizeDownRight)
```
