-- This is the main configuration file for Hammerspoon.
local configDir = hs.fs.currentDir()

CONFIG = {
    USB_DEVICE_ALERTS = false,
    DEVICE_WATCHER_LOG_LEVEL = "info"
}

-- Reload Hammerspoon config
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
    hs.toggleConsole()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "X", function()
    hs.alert.show("Front application bundle ID: " .. hs.application.frontmostApplication():bundleID())
end)

-- Allow use of the hs command line tool
require("hs.ipc")

-- Load an external config file
function loadConfigFile(filePath)
    print("Loading config file: " .. filePath)

    -- Use pcall to safely load the file, catching any errors
    local status, err = pcall(function() dofile(filePath) end)

    if not status then
        hs.alert.show("Error loading config file: " .. filePath .. "\n" .. err)
    end
end


-- Load all configuration files from the same directory
for file in hs.fs.dir(configDir) do
    local fullPath = configDir .. "/" .. file

    -- Skip directories
    if hs.fs.attributes(fullPath, "mode") == "directory" then
        goto continue
    end

    -- Skip hidden / system files
    if file:sub(1, 1) == "." then
        goto continue
    end

    -- Skip the init.lua file to avoid reloading itself
    if file == "init.lua" then
        goto continue
    end

    -- Check if the file has a .lua extension
    if file:sub(-4) ~= ".lua" then
        goto continue
    end

    loadConfigFile(fullPath)

    ::continue::
end

hs.alert.show("Hammerspoon Online!")
