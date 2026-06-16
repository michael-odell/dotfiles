-- Automatically switch Focus mode when a Zoom meeting starts/ends.
--
-- Requires these Shortcuts:
--   "Get Focus Mode" — copies the current focus mode name to clipboard
--   "Set Focus"      — reads focus mode name from clipboard and turns it on
--   "Focus Off"      — turns off the current focus mode

local MEETING_FOCUS = "Meeting"

local savedFocusBeforeMeeting = nil

-- Saves and restores clipboard text around fn() to avoid clobbering it.
-- Note: non-text clipboard content (images, files) cannot be preserved.
local function withClipboardPreserved(fn)
  local saved = hs.pasteboard.getContents()
  fn()
  if saved ~= nil then
    hs.pasteboard.setContents(saved)
  end
end

local function getFocusMode()
  local mode
  withClipboardPreserved(function()
    hs.execute("shortcuts run 'Get Focus Mode'", true)
    mode = hs.pasteboard.getContents()
  end)
  return mode
end

local function setFocusMode(name)
  if name then
    withClipboardPreserved(function()
      hs.pasteboard.setContents(name)
      hs.execute("shortcuts run 'Set Focus'", true)
    end)
  else
    hs.execute("shortcuts run 'Focus Off'", true)
  end
end

local zoomMeetingFilter = hs.window.filter.new(false)
  :setAppFilter("zoom.us", { allowTitles = "Zoom Meeting" })

zoomMeetingFilter:subscribe(hs.window.filter.windowCreated, function()
  savedFocusBeforeMeeting = getFocusMode()
  hs.printf("zoom-focus: meeting started, saved focus: %s", savedFocusBeforeMeeting or "nil")
  if savedFocusBeforeMeeting == "Zero" then
    hs.printf("zoom-focus: in Zero focus, leaving unchanged")
    return
  end
  setFocusMode(MEETING_FOCUS)
end)

zoomMeetingFilter:subscribe(hs.window.filter.windowDestroyed, function()
  hs.printf("zoom-focus: meeting ended, restoring focus to: %s", savedFocusBeforeMeeting or "off")
  setFocusMode(savedFocusBeforeMeeting)  -- nil triggers "Focus Off"
  savedFocusBeforeMeeting = nil
end)
