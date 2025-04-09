-- Configuration for window sizes
local g_winsize_config = {

    -- Browsers
    ["Safari"]            = { width = 1280, height = 900 },
    ["Google Chrome"]     = { width = 1280, height = 900 },
    ["Microsoft Edge"]    = { width = 1280, height = 900 },

    -- Productivity Apps
    ["Microsoft Outlook"] = { width = 1200, height = 800 },
    ["Calendar"]          = { width = 1200, height = 800 },
    ["Notion"]            = { width = 1280, height = 800 },
    ["Obsidian"]          = { width = 1280, height = 900 },
    ["MindNode"]          = { width = 1600, height = 900 },
    ["Mail"]              = { width = 900,  height = 600 },
    ["Contacts"]          = { width = 900,  height = 700 },

    -- Messaging Apps
    ["Teams"]             = { width = 1000, height = 600 },
    ["Slack"]             = { width = 900,  height = 600 },
    ["Messages"]          = { width = 800,  height = 500 },
    ["Signal"]            = { width = 900,  height = 600 },

    -- File Management
    ["Cyberduck"]         = { width = 900,  height = 600 },
    ["FileZila"]          = { width = 1200, height = 800 },
    ["Finder"]            = { width = 760,  height = 480 },

    -- Media
    ["Music"]             = { width = 1280, height = 860 },
    ["Podcasts"]          = { width = 1280, height = 860 },

    -- Other
    ["Exodus"]            = { width = 1280, height = 860 }
}


-- Set the window size for the current application
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No active window found")
        return
    end

    local app = win:application()
    if not app then
        hs.alert.show("Cannot determine current application")
        return
    end

    local appName = app:name()
    if not appName then
        hs.alert.show("Cannot determine application name")
        return
    end

    local f = win:frame()

    local size = g_winsize_config[appName]

    if not size then
        hs.alert.show("No size found for " .. appName)
        return
    end

    f.w = size.width
    f.h = size.height

    win:setFrame(f)
    hs.alert.show(appName .. " (" .. size.width .. "x" .. size.height .. ")")
end)
