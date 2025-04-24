-- Load the spoon
hs.loadSpoon("Snapster")
local snap = spoon.Snapster

snap.showAlert = false
snap.maxHistorySize = 30

-- Set your window defaults
snap.defaults = {
  -- maximumWidth = 1280,
}

-- Configure application-specific settings
snap.apps = {
  ["Google Chrome"] = {width = 1280, height = 900},
  ["Code"] = {minimumWidth = 1600},
}

-- Setup key binding for half screen layouts
snap:bind({{"ctrl", "alt", "cmd"}, "left"}, snap.scale.halfWidth, snap.anchor.left)
snap:bind({{"ctrl", "alt", "cmd"}, "right"}, snap.scale.halfWidth, snap.anchor.right)
snap:bind({{"ctrl", "alt", "cmd"}, "up"}, snap.scale.halfHeight, snap.anchor.top)
snap:bind({{"ctrl", "alt", "cmd"}, "down"}, snap.scale.halfHeight, snap.anchor.bottom)

-- Setup key binding for quarter screen layouts
snap:bind({{"ctrl", "alt", "cmd"}, "U"}, snap.scale.quarterScreen, snap.anchor.topLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "I"}, snap.scale.quarterScreen, snap.anchor.topRight)
snap:bind({{"ctrl", "alt", "cmd"}, "J"}, snap.scale.quarterScreen, snap.anchor.bottomLeft)
snap:bind({{"ctrl", "alt", "cmd"}, "K"}, snap.scale.quarterScreen, snap.anchor.bottomRight)

-- Setup key binding for full screen layout
snap:bind({{"ctrl", "alt", "cmd"}, "F"}, snap.scale.fullScreen)

-- Resize windows based on preferred size in snap.apps
snap:bind({{"ctrl", "alt", "cmd"}, "Y"}, snap.resize.config)

-- Undo the last window operation
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "L", function() snap:undo() end)

-- Start the spoon
snap:start()
