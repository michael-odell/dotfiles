-- Custom window tiling in Hammerspoon

hs.window.animationDuration = 0

config = {
    -- Note: Backspace doesn't seem to respond to cmd-alt-ctrl, perhaps
    -- for macos reasons: https://github.com/Hammerspoon/hammerspoon/issues/3642
    modKeys = {"alt", "ctrl"},
    showAlert = false,

    maxWindowWidth = 1250,  -- maximum window width in pixels (nil for no limit)
    maxWindowHeight = nil, -- maximum window height in pixels (nil for no limit)
}

local anchor = {
    left = "left",
    right = "right",
    top = "top",
    bottom = "bottom",
}

local scale = {
    quarter = 0.25,
    third = 0.333,
    half = 0.5,
    full = 1.0,
}

function resizeWindow(anchors, scaleWidth, scaleHeight, constrainWidth, constrainHeight)
    local win = hs.window.focusedWindow()
    if not win then return end

    local frame = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    -- Calculate the dimensions for the window
    frame.w = math.floor(max.w * scaleWidth)
    frame.h = math.floor(max.h * scaleHeight)

    -- Apply maximum dimension constraints from config
    if config.maxWindowWidth and constrainWidth then
        frame.w = math.min(config.maxWindowWidth, frame.w)
    end
    if config.maxWindowHeight and constrainHeight then
        frame.h = math.min(config.maxWindowHeight, frame.h)
    end

    if hs.fnutils.contains(anchors, anchor.left) then
        frame.x = max.x
    end
    if hs.fnutils.contains(anchors, anchor.right) then
        frame.x = max.x + max.w - frame.w
    end
    if hs.fnutils.contains(anchors, anchor.top) then
        frame.y = max.y
    end
    if hs.fnutils.contains(anchors, anchor.bottom) then
        frame.y = max.y + max.h - frame.h
    end

    if config.showAlert then
        hs.alert.show(string.format("Window size: %d x %d", frame.w, frame.h))
    end

    magnetState = {
        lastWindow = win,
        lastFrame = win:frame()
    }

    win:setFrame(frame)
end

-- Tile the current window to the left half of the screen
hs.hotkey.bind(config.modKeys, "Left", function()
    resizeWindow({anchor.left, anchor.top, anchor.bottom}, scale.half, scale.full, true, false)
end)

-- Tile the current window to the right half of the screen
hs.hotkey.bind(config.modKeys, "Right", function()
    resizeWindow({anchor.right, anchor.top, anchor.bottom}, scale.half, scale.full, true, false)
end)

-- Tile the current window to the top half of the screen
hs.hotkey.bind(config.modKeys, "Up", function()
    resizeWindow({anchor.top, anchor.left, anchor.right}, scale.full, scale.half, false, false)
end)

-- Tile the current window to the bottom half of the screen
hs.hotkey.bind(config.modKeys, "Down", function()
    resizeWindow({anchor.bottom, anchor.left, anchor.right}, scale.full, scale.half, false, false)
end)

-- Full Screen
hs.hotkey.bind(config.modKeys, "Return", function()
    resizeWindow({anchor.bottom, anchor.left, anchor.right, anchor.top}, scale.full, scale.full, false, false)
end)

-- Tile the current window to top left corner
hs.hotkey.bind(config.modKeys, "U", function()
    resizeWindow({anchor.top, anchor.left}, scale.half, scale.half, true, true)
end)

-- Tile the current window to top right corner
hs.hotkey.bind(config.modKeys, "I", function()
    resizeWindow({anchor.top, anchor.right}, scale.half, scale.half, true, true)
end)

-- Tile the current window to bottom left corner
hs.hotkey.bind(config.modKeys, "J", function()
    resizeWindow({anchor.bottom, anchor.left}, scale.half, scale.half, true, true)
end)

-- Tile the current window to bottom right corner
hs.hotkey.bind(config.modKeys, "K", function()
    resizeWindow({anchor.bottom, anchor.right}, scale.half, scale.half, true, true)
end)

hs.hotkey.bind(config.modKeys, "delete", function()
    if magnetState then
        magnetState.lastWindow:setFrame(magnetState.lastFrame)
        magnetState = nil
    end
end)
