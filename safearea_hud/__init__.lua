-- Move only the four HUD corner-vignette images to the actual screen edges.
-- Other HUD elements keep using Ghosts' adjusted safe area.
local function placeAtScreenEdges(corners)
    local safeLeft, safeTop, safeRight, safeBottom = GameX.GetAdjustedSafeZoneSize()
    local screenWidth, screenHeight = GameX.GetScreenDims()
    corners:registerAnimationState("default", {
        topAnchor = false,
        leftAnchor = false,
        bottomAnchor = false,
        rightAnchor = false,
        top = -(screenHeight / 2) - (safeTop + safeBottom) / 2,
        width = screenWidth,
        height = screenHeight,
        alpha = 1
    })
    corners:animateToState("default", 0)
end

local function wrapCorners(original)
    return function(...)
        local corners = original(...)
        if corners and not Engine.IsConsoleGame() then
            local ok, err = pcall(placeAtScreenEdges, corners)
            if not ok then
                print("safearea_hud corner layout error: " .. tostring(err))
            end
        end
        return corners
    end
end

local types = LUI.MenuBuilder.m_types
local meta = getmetatable(types) or {}
local previousNewIndex = meta.__newindex
meta.__newindex = function(target, name, constructor)
    if name == "fourCornersHudDef" then
        constructor = wrapCorners(constructor)
    end
    if type(previousNewIndex) == "function" then
        return previousNewIndex(target, name, constructor)
    elseif type(previousNewIndex) == "table" then
        previousNewIndex[name] = constructor
    else
        rawset(target, name, constructor)
    end
end
setmetatable(types, meta)

if types["fourCornersHudDef"] then
    types["fourCornersHudDef"] = wrapCorners(types["fourCornersHudDef"])
end
