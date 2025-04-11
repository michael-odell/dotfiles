--- === Zing ===
---
--- Zing is a Hammerspoon spoon that provides a quick way to search the web, open bookmarks, or
--- open URLs directly from a text input. It uses a chooser interface to allow users to enter
--- queries and select from a list of suggestions.

-- Patterns that we use to match placeholders in a URL
local PLACEHOLDER_POS = "%%(%d+)"
local PLACEHOLDER_ARGS = "%%@"
local PLACEHOLDER_PARAM = "{%%([^}]*)%%}"

-- Other patterns used in this script
local BOOKMARK_PATTERN = "^%s*(%S+)%s*(.*)"

local obj = { }
obj.__index = obj

-- Metadata
obj.name = "Zing"
obj.version = "1.0"
obj.author = "Jason Heddings"
obj.license = "MIT"

-- Properties
obj.logger = hs.logger.new("Zing", "warning")
obj.chooser = nil
obj.hotkeyShow = nil

-- Configuration
obj.defaultScheme = "https"
obj.searchEngine = "https://google.com/{%?q=%@%}"
obj.inputWidth = 20

--- Zing.bookmarks
--- Variable
--- A table of bookmarks that can be used to quickly access URLs.
---
--- This table is a key-value pair where the key is a string representing the bookmark name
--- and the value is either a string representing the URL or a function that generates the URL.
---
--- The URL can contain placeholders that will be replaced with the provided arguments.
---
--- Supported placeholders in URL bookmarks:
--- - `%@` for the entire query string
--- - `%1`, `%2`, etc. for positional arguments
--- - `{%...%}` will be removed if no arguments are provided
---
--- Functions can be used to generate dynamic URLs based on the provided arguments.  Arguments
--- are passed to the function in the order they appear in the user query string.
---
--- Example:
---   Zing.bookmarks = {
---       ["g"] = "https://google.com/{%?q=%@%}",
---       ["$"] = "https://www.xe.com/currencyconverter/convert/{%?Amount=%1&From=%2&To=%3%}",
---       ["tz"] = function(hour)
---           local myTime = os.time()
---           if hour and hour ~= "" then
---               myTime = myTime + (tonumber(hour) * 3600)
---           end
---           local timestamp = os.date("!%Y%m%dT%H%M%S", myTime)
---           return "https://www.timeanddate.com/worldclock/converter.html?&p1=75&p2=136&iso=" .. timestamp
---       end
---   }
obj.bookmarks = { }

--- isURL(text)
--- Function
--- Check if a string looks like a URL
---
--- Parameters:
---  * text - The string to check
---
--- Returns:
---  * A boolean indicating whether the text appears to be a URL
function isURL(text)
    return text:match("^[a-z]+://") or text:match("^www%.")
end

--- Zing:_parseBookmark(text)
--- Method
--- Parse a string that may contain a bookmark followed by additional search terms
---
--- Parameters:
---  * text - A string that potentially contains a bookmark name followed by search terms
---
--- Returns:
---  * bookmark - The bookmark name if found, or nil
---  * rest - The remaining text after the bookmark, or nil if no bookmark was found
function obj:_parseBookmark(text)
    local bookmark, rest = text:match(BOOKMARK_PATTERN)
    if bookmark and self.bookmarks[bookmark] then
        return bookmark, rest
    end
    return nil, nil
end

--- Zing:_isBookmark(text)
--- Method
--- Check if a string is a valid bookmark or starts with a bookmark
---
--- Parameters:
---  * text - The string to check
---
--- Returns:
---  * A boolean indicating whether the text starts with a valid bookmark
function obj:_isBookmark(text)
    local bookmark, _ = self:_parseBookmark(text)
    return bookmark ~= nil
end

--- Zing:_processTemplate(text, ...)
--- Method
--- Expand placeholders in a URL text with the provided parameters
---
--- Parameters:
---  * text - The URL text containing placeholders
---  * ... - The template parameters for placeholders
---
--- Returns:
---  * The expanded URL with placeholders replaced
---
--- Notes:
---  * Text within template wrappers {%...%} will be removed if no parameters are provided
function obj:_processTemplate(text, ...)
    local paramCount = select("#", ...)

    if paramCount > 0 then
        text = self:_expandPlaceholders(text, ...)
    else
        text = text:gsub(PLACEHOLDER_PARAM, "")
    end

    return text
end

--- Zing:_expandPlaceholders(text, ...)
--- Method
--- Handle parameter replacement in text with placeholder values
---
--- Parameters:
---  * text - The text containing placeholders
---  * ... - The parameters to replace placeholders
---
--- Returns:
---  * The expanded text with placeholders replaced by encoded parameter values
---
--- Notes:
---  * Use %% to get a literal % in the output (escaping)
---  * Use %@ to replace with all parameters joined by a space
---  * Use %1, %2, etc. to replace with positional parameters
function obj:_expandPlaceholders(text, ...)
    local params = {...}

    -- Temporarily replace escaped percent signs
    local percentMarker = "\0PERCENT_SIGN\0"
    text = text:gsub("%%%%", percentMarker)

    -- Replace %@ with all parameters
    text = text:gsub(
        PLACEHOLDER_ARGS,
        function()
            self.logger.v("Found placeholder: @")
            local value = table.concat(params, " ")
            return hs.http.encodeForQuery(value)
        end
    )

    -- Replace numeric placeholders
    text = text:gsub(
        PLACEHOLDER_POS,
        function(n)
            local index = tonumber(n)
            self.logger.v("Found placeholder:", index)

            if index <= #params then
                local value = params[index]
                return hs.http.encodeForQuery(value)
            end

            return ""
        end
    )

    -- Remove template markers, but keep the content inside
    text = text:gsub(PLACEHOLDER_PARAM, "%1")

    -- Finally, restore the escaped % as a single %
    text = text:gsub(percentMarker, "%%")

    return text
end

--- Zing:_handleBookmark(text)
--- Method
--- Process a bookmark and its parameters into a URL
---
--- Parameters:
---  * text - A string containing a bookmark name followed by optional parameters
---
--- Returns:
---  * The generated URL, or nil if the text doesn't start with a valid bookmark
function obj:_handleBookmark(text)
    local bookmark, rest = self:_parseBookmark(text)

    if bookmark then
        local target = self.bookmarks[bookmark]
        local params = hs.fnutils.split(rest, "%s+")
        local kind = type(target)

        self.logger.d("Processing bookmark:", bookmark, " [", kind, "]")

        if kind == "function" then
            self.logger.d("Executing function:", bookmark, "{", table.concat(params, ", "), "}")
            return target(table.unpack(params))
        else
            self.logger.d("Processing URL:", bookmark, "->", target, "? {", table.concat(params, ", "), "}")
            return self:_processTemplate(target, table.unpack(params))
        end
    end

    return nil
end

--- Zing:_handleWebsiteQuery(url)
--- Method
--- Process URLs, adding a scheme if needed
---
--- Parameters:
---  * url - A URL string, possibly without a scheme
---
--- Returns:
---  * A properly formatted URL with a scheme
function obj:_handleWebsiteQuery(url)
    self.logger.v("Processing URL request:", url)

    -- If it is missing the scheme (http/https), add it
    if not url:match("://") then
        url = self.defaultScheme .. "://" .. url
    end

    return url
end

--- Zing:_handleSearchQuery(text)
--- Method
--- Process a search query using the default search engine
---
--- Parameters:
---  * text - The search query text
---
--- Returns:
---  * A URL for the search using the configured search engine
function obj:_handleSearchQuery(text)
    self.logger.v("Processing search request:", text)
    return self:_processTemplate(self.searchEngine, text)
end

--- Zing:_handleQueryText(text)
--- Method
--- Process a user query and return an appropriate URL
---
--- Parameters:
---  * text - User query text that might be a bookmark, URL, or search query
---
--- Returns:
---  * A URL to open, or nil if the text couldn't be processed
function obj:_handleQueryText(text)
    if not text or text == "" then
        return nil
    end

    self.logger.v("Processing user query:", text)

    if self:_isBookmark(text) then
        return obj:_handleBookmark(text)
    end

    if isURL(text) then
        return obj:_handleWebsiteQuery(text)
    end

    return obj:_handleSearchQuery(text)
end

--- _createBookmarkChoice(key)
--- Method
--- Create a choice object for a specific bookmark
---
--- Parameters:
---  * key - The bookmark key to create a choice for
---
--- Returns:
---  * A choice table for use with hs.chooser
function obj:_createBookmarkChoice(key)
    local target = self.bookmarks[key]
    local subText

    -- TODO indicate number of arguments for function
    if type(target) == "function" then
        subText = "Function: execute"
    else
        -- For URLs with parameters, clean them for display
        subText = "Bookmark: " .. target:gsub(PLACEHOLDER_PARAM, "")
    end

    return {
        ["text"] = key,
        ["subText"] = subText
    }
end

--- Zing:_completionCallback(choice)
--- Method
--- Callback function when a user selects a choice from the chooser
---
--- Parameters:
---  * choice - The selected choice object containing the query text
---
--- Returns:
---  * Boolean indicating success or failure
function obj:_completionCallback(choice)
    if not choice then
        self.logger.w("No choice selected")
        return false
    end

    local text = choice.text
    local url = self:_handleQueryText(text)
    
    if not url then
        hs.alert.show("Invalid query")
        return false
    end

    self.logger.d("Opening URL:", url)
    hs.urlevent.openURL(url)

    return true
end

--- Zing:_queryChangedCallback(query)
--- Method
--- Callback function called when the query text in the chooser changes
---
--- Parameters:
---  * query - The current text in the chooser input field
---
--- Notes:
---  * This updates the list of choices shown in the chooser:
---    * The current query is always shown as the first choice
---    * Bookmark suggestions are shown if the query matches any bookmark names
function obj:_queryChangedCallback(query)
    local choices = { }
    local subText = isURL(query) and "Press Enter to open URL" or "Press Enter to search"
    
    -- Add the main query option
    table.insert(choices, {
        ["text"] = query, 
        ["subText"] = subText
    })
    
    -- Add bookmark suggestions that match the query
    local queryLower = query:lower()
    for key, _ in pairs(self.bookmarks) do
        if key:lower():find(queryLower, 1, true) then
            table.insert(choices, self:_createBookmarkChoice(key))
        end
    end

    self.chooser:choices(choices)
end

--- Zing:show()
--- Method
--- Show the Zing chooser
---
--- Returns:
---  * The Zing object
function obj:show()
    if self.chooser then
        self.chooser:query(nil)
        self.chooser:show()
    else
        hs.alert.show("Zing chooser not initialized")
    end

    return self
end

--- Zing:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Zing
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following (optional) items:
---   * show - This will display the Zing chooser
---
--- Returns:
---  * The Zing object
function obj:bindHotkeys(mapping)
    if (self.hotkeyShow) then
        self.hotkeyShow:delete()
    end

    local toggleMods = mapping["show"][1]
    local toggleKey = mapping["show"][2]

    self.hotkeyShow = hs.hotkey.new(toggleMods, toggleKey, function() self:show() end)

    return self
end

--- Zing:start()
--- Method
--- Start the Zing chooser
---
--- Returns:
---  * The Zing object
function obj:start()
    self.chooser = hs.chooser.new(function(choice) return self:_completionCallback(choice) end)

    self.chooser:placeholderText("Enter URL, bookmark, or search query")
    self.chooser:searchSubText(false)
    self.chooser:width(self.inputWidth)
    self.chooser:queryChangedCallback(function(query) self:_queryChangedCallback(query) end)

    if (self.hotkeyShow) then
        self.hotkeyShow:enable()
    end

    return self
end

--- Zing:stop()
--- Method
--- Stops Zing
---
--- Returns:
---  * The Zing object
function obj:stop()
    if (self.hotkeyShow) then
        self.hotkeyShow:disable()
    end

    return self
end

return obj
