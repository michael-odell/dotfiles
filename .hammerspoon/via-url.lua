-- Not useful as is -- but I'm keeping this here to remind me how to do this when it comes up.

-- Directly from https://www.hammerspoon.org/go/#automating-hammerspoon-with-urls
hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)
