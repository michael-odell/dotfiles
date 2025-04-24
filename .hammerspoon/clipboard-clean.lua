-- Remove RTF version of current clipboard, leaving just plaintext
--
-- Based strongly on example at https://www.hammerspoon.org/go/#window-filters
-- Related examples there could make this app-specific if I had a particular way
-- I thought I'd like it to go.
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    local pb = hs.pasteboard.contentTypes()
    local contains = hs.fnutils.contains

    -- local log = hs.logger.new('clipboard-clean', 'debug')
    -- log.i("No public.rtf: ", table.concat(pb, '\n') )

    -- log.i("typesAvailable:\n ", table.concat(hs.pasteboard.typesAvailable(), '\n') )
    -- log.i("Contents:\n", hs.pasteboard.getContents())

    if contains(pb, "public.rtf") or contains(pb, "public.html") then
        hs.pasteboard.setContents(hs.pasteboard.getContents())
        hs.alert.show("Clipboard -> Plaintext")
    end
end)
