--- GridOp
--- Class
--- Grid-based window navigation and resizing.
---
--- Divides each screen into columns based on aspect ratio (halves for standard
--- screens, thirds for ultrawides) and provides operations to move windows
--- through the grid or grow/shrink them. Movement crosses screen boundaries;
--- resizing is constrained to the current screen.
---
--- Move: steps one column at a time, collapsing multi-column windows.
--- Resize: extends the edge in the given direction if possible, otherwise
---         shrinks from the opposite side.

GridOp = LayoutOperation:new()
GridOp.__index = GridOp

--- GridOp:new(direction, mode, threshold, vertical)
--- Method
--- Creates a new GridOp instance.
---
--- Parameters:
---  * direction - "left" or "right"
---  * mode - "move" (navigate one cell) or "resize" (extend or shrink)
---  * threshold - Minimum aspect ratio for 3-column grids (default 2.0)
---  * vertical - "full" (default), "top", or "bottom" — vertical extent of the frame
---
--- Returns:
---  * A new GridOp instance
function GridOp:new(direction, mode, threshold, vertical)
    local instance = {
        direction = direction,
        mode = mode,
        threshold = threshold or 2.0,
        vertical = vertical or "full",
    }
    return setmetatable(instance, self)
end

local function round(x)
    return math.floor(x + 0.5)
end

local function getNumCols(screen, threshold)
    local sf = screen:frame()
    return (sf.w / sf.h) >= threshold and 3 or 2
end

local function detectPosition(win, threshold)
    local screen = win:screen()
    local sf = screen:frame()
    local wf = win:frame()
    local numCols = getNumCols(screen, threshold)
    local colWidth = sf.w / numCols

    local col = round((wf.x - sf.x) / colWidth)
    col = math.max(0, math.min(col, numCols - 1))

    local span = round(wf.w / colWidth)
    span = math.max(1, math.min(span, numCols - col))

    return {
        col = col,
        span = span,
        numCols = numCols,
        screen = screen,
        colWidth = colWidth,
        screenFrame = sf,
    }
end

local function makeFrame(sf, colWidth, col, span, vertical)
    local y = sf.y
    local h = sf.h
    if vertical == "top" then
        h = sf.h / 2
    elseif vertical == "bottom" then
        y = sf.y + sf.h / 2
        h = sf.h / 2
    end
    return hs.geometry.rect(
        sf.x + col * colWidth,
        y,
        colWidth * span,
        h
    )
end

--- GridOp:apply(frame, context)
--- Method
--- Applies the grid operation to the window.
---
--- Parameters:
---  * frame - The current window frame (ignored; position is detected from the window)
---  * context - The hs.window object
---
--- Returns:
---  * The new frame positioned on the grid
function GridOp:apply(frame, context)
    local logger = spoon.Snapster.logger
    local pos = detectPosition(context, self.threshold)

    logger.d("GridOp:", self.mode, self.direction,
        "col:", pos.col, "span:", pos.span, "of", pos.numCols)

    if self.mode == "move" then
        return self:_move(pos)
    else
        return self:_resize(pos)
    end
end

function GridOp:_move(pos)
    local logger = spoon.Snapster.logger
    local v = self.vertical

    if self.direction == "right" then
        local nextCol = pos.col + pos.span
        if nextCol < pos.numCols then
            return makeFrame(pos.screenFrame, pos.colWidth, nextCol, 1, v)
        end
        local next = pos.screen:toEast()
        if next then
            local sf = next:frame()
            local nc = getNumCols(next, self.threshold)
            logger.d("  -> screen:", next:name())
            return makeFrame(sf, sf.w / nc, 0, 1, v)
        end
        return makeFrame(pos.screenFrame, pos.colWidth, pos.numCols - 1, 1, v)
    else
        local nextCol = pos.col - 1
        if nextCol >= 0 then
            return makeFrame(pos.screenFrame, pos.colWidth, nextCol, 1, v)
        end
        local prev = pos.screen:toWest()
        if prev then
            local sf = prev:frame()
            local nc = getNumCols(prev, self.threshold)
            logger.d("  -> screen:", prev:name())
            return makeFrame(sf, sf.w / nc, nc - 1, 1, v)
        end
        return makeFrame(pos.screenFrame, pos.colWidth, 0, 1, v)
    end
end

function GridOp:_resize(pos)
    local logger = spoon.Snapster.logger
    local v = self.vertical

    if self.direction == "right" then
        if pos.col + pos.span < pos.numCols then
            logger.d("  extend right edge")
            return makeFrame(pos.screenFrame, pos.colWidth, pos.col, pos.span + 1, v)
        elseif pos.span > 1 then
            logger.d("  shrink from left")
            return makeFrame(pos.screenFrame, pos.colWidth, pos.col + 1, pos.span - 1, v)
        end
    else
        if pos.col > 0 then
            logger.d("  extend left edge")
            return makeFrame(pos.screenFrame, pos.colWidth, pos.col - 1, pos.span + 1, v)
        elseif pos.span > 1 then
            logger.d("  shrink from right")
            return makeFrame(pos.screenFrame, pos.colWidth, pos.col, pos.span - 1, v)
        end
    end

    logger.d("  no change")
    return makeFrame(pos.screenFrame, pos.colWidth, pos.col, pos.span, v)
end

return GridOp
