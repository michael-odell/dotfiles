--- AdaptiveOp
--- Class
--- A layout operation that delegates to different operations based on screen aspect ratio.
---
--- This allows the same hotkey to behave differently depending on the screen geometry.
--- For example, use third-width scaling on ultrawides and half-width on standard displays.

AdaptiveOp = LayoutOperation:new()
AdaptiveOp.__index = AdaptiveOp

--- AdaptiveOp:new(default, ...)
--- Method
--- Creates a new AdaptiveOp instance.
---
--- Parameters:
---  * default - The default LayoutOperation to use when no rules match
---  * ... - One or more rule tables of the form {ratio, operation}, where ratio is
---          the minimum aspect ratio (width/height) that triggers the operation
---
--- Returns:
---  * A new AdaptiveOp instance
---
--- Notes:
---  * Rules are evaluated from highest ratio to lowest; the first match wins
---  * Aspect ratio is computed from the screen's frame (width / height)
function AdaptiveOp:new(default, ...)
    local rules = {...}
    table.sort(rules, function(a, b) return a[1] > b[1] end)

    local instance = {
        rules = rules,
        default = default
    }
    return setmetatable(instance, self)
end

--- AdaptiveOp:apply(frame, context)
--- Method
--- Selects and applies the appropriate operation based on the screen's aspect ratio.
---
--- Parameters:
---  * frame - The window frame to transform
---  * context - The window object providing screen context
---
--- Returns:
---  * The modified frame
function AdaptiveOp:apply(frame, context)
    local screen = context:screen()
    local max = screen:frame()
    local ratio = max.w / max.h

    local logger = spoon.Snapster.logger
    logger.d("AdaptiveOp:apply() screen ratio:", string.format("%.2f", ratio))

    for _, rule in ipairs(self.rules) do
        if ratio >= rule[1] then
            logger.d("  matched rule: ratio >=", rule[1])
            return rule[2]:apply(frame, context)
        end
    end

    logger.d("  using default operation")
    return self.default:apply(frame, context)
end

return AdaptiveOp
