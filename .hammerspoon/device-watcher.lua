local logger = hs.logger.new("dev-watcher", CONFIG.DEVICE_WATCHER_LOG_LEVEL)

DEVICES = {
    -- Example
    -- NiceDeviceName = {   -- any name you want
    --     type = "usb"     -- only usb is supported at present
    --     id = {
    --         -- id's form is specific to device type.  For USB devices, there is a vendor ID and a
    --         -- product ID.  To see yours, turn on CONFIG.USB_DEVICE_ALERTS and plug it in.
    --         vendorID = 0x1234,
    --         productID= 0x1234,
    --     }
    --     onPresent = nil, -- optionally a function to run when the device is present
    --     onAbsent = nil,  -- optionally a function to run when the device is not attached
    -- },
    StreamDeck = {
        type = "usb",
        id = {
            vendorID = 0xfd9,
            productID = 0x84,
        },
        onPresent = function()
            local streamDeckApp = "com.elgato.StreamDeck"

            -- StreamDeck's app is annoying to start.  If you don't start it with special
            -- arguemnts OR even if you do but it's already running, it'll pop up a window.
            --
            -- So all of this is just to get it running without popping up a window
            local app = hs.application.get(streamDeckApp)
            if not app  then
                logger.i("Starting StreamDeck app.")
                local task = hs.task.new("/usr/bin/open", nil, {"-g", "-b", streamDeckApp, "--args", "--runinbk"}):start()
            end

            -- It's much easier to start mutedeck
            logger.i("Making sure MuteDeck is running.")
            hs.application.open("com.mutedeck.mac")
        end,
        onAbsent = function()
            local streamDeckApp = "com.elgato.StreamDeck"
            local app = hs.application.get(streamDeckApp)
            if app then
                logger.i("Stopping StreamDeck app.")
                app:kill()
            end
            app = hs.application.get("com.mutedeck.mac")
            if app then
                logger.i("Stopping mutedeck app.")
                app:kill()
            end
        end
    }
}

function handleUsbDevicePresent(vendorName, vendorID, productName, productID)
    local message = string.format("USB present: %s(0x%x) %s(0x%x)",
                                  vendorName, vendorID, productName, productID)
    logger.i(message)
    if CONFIG.USB_DEVICE_ALERTS then
        hs.alert.show(message)
    end

    for k, v in pairs(DEVICES) do
        if v.type == "usb" then
            -- Execute handler if one exists
            if v.onPresent ~= nil and v.id.vendorID == vendorID and v.id.productID == productID then
                v.onPresent()
            end
        end
    end
end

function handleUsbDeviceAbsent(vendorName, vendorID, productName, productID)
    local message = string.format("USB absent: %s(0x%x) %s(0x%x)",
                                  vendorName, vendorID, productName, productID)

    logger.i(message)
    if CONFIG.USB_DEVICE_ALERTS then
        hs.alert.show(message)
    end

    for k, v in pairs(DEVICES) do
        if v.type == "usb" then
            -- Execute handler if one exists
            if v.onAbsent ~= nil and v.id.vendorID == vendorID and v.id.productID == productID then
                v.onAbsent()
            end
        end
    end
end


-- USB Device Watcher
usbWatcher = hs.usb.watcher.new(function(e)
    -- signature ref: https://www.hammerspoon.org/docs/hs.usb.watcher.html#new
    local eventType = e.eventType
    local productName = e.productName
    local vendorName = e.vendorName
    local vendorID = e.vendorID
    local productID = e.productID

    if eventType == "added" then
        handleUsbDevicePresent(vendorName, vendorID, productName, productID)
    elseif eventType == "removed" then
        handleUsbDeviceAbsent(vendorName, vendorID, productName, productID)
    else
        logger.ef("Unrecognized eventType=%s", eventType)
        hs.alert.show("Unrecognized eventType=" .. eventType)
    end
end)

-- Start watching for USB events
usbWatcher:start()

-- And handle all initially connected devices
for _, e in ipairs(hs.usb.attachedDevices()) do
    handleUsbDevicePresent(e.vendorName, e.vendorID, e.productName, e.productID)
end

