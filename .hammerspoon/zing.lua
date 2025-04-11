-- Configure Zing for Hammerspoon
hs.loadSpoon("Zing")
local zing = spoon.Zing

-- Configuration for Zing
zing.searchEngine = "https://duckduckgo.com/{%?q=%@%}"
zing.inputWidth = 16

zing.bookmarks = {
    -- General bookmarks
    ["gpt"] = "https://chatgpt.com/{%?q=%@%}",

    -- Workday bookmarks
    ["jira"] = "https://jira2.workday.com/{%browse/%1%}",
    ["jql"] = "https://jira2.workday.com/issues/{%?jql=%@%}",
    ["wd"] = "https://wd5.myworkday.com/workday/",

    -- Personal bookmarks
    ["gh"] = "https://github.com/{%jmichael-odell/%1%}",

    -- Timezone converter
    ["tz"] = function(hour)
        local myTime = os.time()

        if hour and hour ~= "" then
            myTime = myTime + (tonumber(hour) * 3600)
        end

        local timestamp = os.date("!%Y%m%dT%H%M%S", myTime)
        return "https://www.timeanddate.com/worldclock/converter.html?&p1=75&p2=136&iso=" .. timestamp
    end
}

zing:bindHotkeys({
    show = {{"cmd", "alt", "ctrl"}, "Space"}
})

zing:start()
