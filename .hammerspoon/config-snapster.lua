-- Load the spoon
hs.loadSpoon("Snapster")
local snap = spoon.Snapster

snap.showAlert = false
snap.maxHistorySize = 30

-- Grid navigation: halves on standard screens, thirds on ultrawides (ratio >= 2.0)
local grid = snap.grid(2.0)

snap:bind({{"ctrl", "alt"}, "left"}, grid.moveLeft)
snap:bind({{"ctrl", "alt"}, "right"}, grid.moveRight)
snap:bind({{"ctrl", "alt", "cmd"}, "left"}, grid.resizeLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "right"}, grid.resizeRight)
snap:bind({{"ctrl", "alt"}, "up"}, snap.scale.halfHeight, snap.anchor.top)
snap:bind({{"ctrl", "alt"}, "down"}, snap.scale.halfHeight, snap.anchor.bottom)

-- Grid navigation for half-height windows (top: U/I, bottom: J/K)
snap:bind({{"ctrl", "alt"}, "U"}, grid.moveUpLeft)
snap:bind({{"ctrl", "alt"}, "I"}, grid.moveUpRight)
snap:bind({{"ctrl", "alt"}, "J"}, grid.moveDownLeft)
snap:bind({{"ctrl", "alt"}, "K"}, grid.moveDownRight)
snap:bind({{"ctrl", "alt", "cmd"}, "U"}, grid.resizeUpLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "I"}, grid.resizeUpRight)
snap:bind({{"ctrl", "alt", "cmd"}, "J"}, grid.resizeDownLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "K"}, grid.resizeDownRight)

-- Full screen
snap:bind({{"ctrl", "alt"}, "return"}, snap.scale.fullScreen, snap.anchor.fullScreen)

-- Resize windows based on preferred size in snap.apps
snap:bind({{"ctrl", "alt"}, "Y"}, snap.resize.config)

-- Undo the last window operation
hs.hotkey.bind({"ctrl", "alt"}, "delete", function() snap:undo() end)

-- Start the spoon
snap:start()
