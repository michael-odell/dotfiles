-- Custom URL dispatcher for Hammerspoon
hs.loadSpoon("URLDispatcher")


-- Uncomment the following line to enable debug logging in console
-- spoon.URLDispatcher.logger.setLogLevel("debug")


function appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end


local safariBrowser = appID("/Applications/Safari.app")
local chromeBrowser = appID("/Applications/Google Chrome.app")
local zoomApp = appID("/Applications/zoom.us.app")
local slackApp = appID("/Applications/Slack.app")

-- Finicky used to handle these for me, but I think Hammerspoon can do
-- it all now (?)
--local finickyBrowser = appID("/Applications/Finicky.app")
--spoon.URLDispatcher.default_handler = finickyBrowser
spoon.URLDispatcher.default_handler = safariBrowser

-- Define URL patterns and their corresponding browsers
spoon.URLDispatcher.url_patterns = {

    -- NOTE: Lua Patterns (https://www.lua.org/pil/20.2.html), not regex

    { "https://workday.*%.slack%.com/archives/", slackApp},

    -- Always open Google URLs in Chrome
    { "https://google%.com", chromeBrowser},
    { "https://gmail%.com", chromeBrowser},
    { "https://forms%.gle", chromeBrowser},
    { "https://goo%.gl", chromeBrowser },
    { "https://ceph%.odell%.sh", chromeBrowser },

    -- Workday systems should use Chrome
    { "https://workday%.com", chromeBrowser },
    { "https://workdayinternal%.com", chromeBrowser },
    { "https://console%.megaleo%.com", chromeBrowser },
    { "https://.*lucid%.app", chromeBrowser },
    { "https://.*miro%.com", chromeBrowser },
    { "https://.*megaleo%.com", chromeBrowser },
    { "https://.*workday%.com", chromeBrowser },
    { "https://.*urldefense%.com", chromeBrowser },
    { "https://.*achievers%.com", chromeBrowser },
    { "https://.*wdscylla%.de", chromeBrowser },
    { "https://.*inday%.io", chromeBrowser },
    { "https://.*wdpharos%.io", chromeBrowser },
    { "https://.*getcortexapp%.com", chromeBrowser },
    { "https://s2%.bl-1%.com", chromeBrowser },

    -- Open Zoom links directly in the Zoom app
    { "https://zoom%.us", zoomApp },
    { "https://zoom%.com", zoomApp },
}

-- Start the URL dispatcher
spoon.URLDispatcher:start()
