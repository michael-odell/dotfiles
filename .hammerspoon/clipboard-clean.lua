-- Remove RTF version of current clipboard, leaving just plaintext
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    local pb = hs.pasteboard.contentTypes()
    local contains = hs.fnutils.contains
    if  contains(pb, "public.rtf") then
        hs.pasteboard.setContents(hs.pasteboard.getContents())
        hs.alert.show("Clipboard -> Plaintext")
    end
end)
