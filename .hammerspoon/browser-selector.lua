-- Custom URL dispatcher for Hammerspoon
hs.loadSpoon("URLDispatcher")


-- Uncomment the following line to enable debug logging in console
spoon.URLDispatcher.logger.setLogLevel("debug")


function appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end


local safariBrowser = appID("/Applications/Safari.app")
local chromeBrowser = appID("/Applications/Google Chrome.app")
local zoomApp = appID("/Applications/zoom.us.app")
local slackApp = appID("/Applications/Slack.app")

spoon.URLDispatcher.default_handler = safariBrowser

-- Define URL patterns and their corresponding browsers
spoon.URLDispatcher.url_patterns = {

    -- NOTE: Lua Patterns (https://www.lua.org/pil/20.2.html), not regex

    -- NOTE: _Some_ slack links with /archives/ in them don't seem to work
    -- to pass directly to the app as of 2025-05.  The app will activate,
    -- but it won't go to the right location.
    { "https?://workday.*%.slack%.com/messages/", slackApp},

    -- Typical searches stay in safari
    { "https?://www%.google%.com/search", safariBrowser},
    { "https?://google%.com/search", safariBrowser},
    { "https?://.*github%.com/", chromeBrowser},

    -- But the rest of google should be opened in chrome
    { "https?://.*%.google%.com", chromeBrowser},
    { "https?://gmail%.com", chromeBrowser},
    { "https?://forms%.gle", chromeBrowser},
    { "https?://goo%.gl", chromeBrowser },
    { "https?://ceph%.odell%.sh", chromeBrowser },

    -- Workday systems should use Chrome
    { "https?://[^/]*workday[^/]*", chromeBrowser },
    { "https?://console%.megaleo%.com", chromeBrowser },
    { "https?://.*lucid%.app", chromeBrowser },
    { "https?://.*miro%.com", chromeBrowser },
    { "https?://.*megaleo%.com", chromeBrowser },
    { "https?://.*urldefense%.com", chromeBrowser },
    { "https?://.*achievers%.com", chromeBrowser },
    { "https?://.*wdscylla%.de", chromeBrowser },
    { "https?://.*inday%.io", chromeBrowser },
    { "https?://.*wdpharos%.io", chromeBrowser },
    { "https?://.*getcortexapp%.com", chromeBrowser },
    { "https?://s2%.bl-1%.com", chromeBrowser },
    { "https?://wolinks.com/", chromeBrowser },
    { "https?://workpool.web.app/", chromeBrowser },

    -- Open Zoom links directly in the Zoom app
    { "https?://zoom%.us", zoomApp },
    { "https?://zoom%.com", zoomApp },
}

-- Start the URL dispatcher
spoon.URLDispatcher:start()
