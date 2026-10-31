-- Extend full-screen effects to the screen edges; keep HUD content in the safe area.
-- Works with IW6x / iw6-mod 0.0.5 and older builds.

-- GameX used to return tables here and now returns multiple values. Accept both
-- so a client update cannot silently disable the whole fix.
local function getSafeZone()
    local left, top, right, bottom = GameX.GetAdjustedSafeZoneSize()
    if type(left) == "table" then
        left, top, right, bottom = left[1], left[2], left[3], left[4]
    end
    return left or 0, top or 0, right or 0, bottom or 0
end

local function getScreenDims()
    local width, height = GameX.GetScreenDims()
    if type(width) == "table" then
        width, height = width[1], width[2]
    end
    return width or 0, height or 0
end

local function placeAtScreenEdges(corners, material)
    local safeLeft, safeTop, safeRight, safeBottom = getSafeZone()
    local screenWidth, screenHeight = getScreenDims()
    corners:registerAnimationState("default", {
        topAnchor = false,
        leftAnchor = false,
        bottomAnchor = false,
        rightAnchor = false,
        top = -(screenHeight / 2) - (safeTop + safeBottom) / 2,
        width = screenWidth,
        height = screenHeight,
        alpha = 1,
        material = material
    })
    corners:animateToState("default", 0)
end

local function extendKillcamBar(root)
    local background = root:getFirstDescendentById("killCamBottomBg")
    local bar = root:getFirstDescendentById("killCamBottom")
    if not background or not bar then return end
    local safeLeft, _, safeRight, safeBottom = getSafeZone()
    background:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        top = 0,
        left = -safeLeft,
        bottom = 30,
        right = -safeRight,
        material = RegisterMaterial("kk_lowbar")
    })
    background:animateToState("default", 0)
    local active = {
        topAnchor = false,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        bottom = -safeBottom + 15,
        height = 128,
        alpha = 1
    }
    bar:registerAnimationState("opening", active)
    bar:registerAnimationState("active", active)
end

local function centerFinalKillcamCard(root)
    local card = root:getFirstDescendentById("killCamPlayerCard")
    if not card then return end
    for state, left in pairs({ opening = 345, active = 375, leaving = 875 }) do
        card:registerAnimationState(state, {
            topAnchor = true,
            leftAnchor = true,
            bottomAnchor = false,
            rightAnchor = false,
            top = 50,
            left = left,
            height = 64,
            width = 256,
            alpha = state == "leaving" and 0 or 1
        })
    end
end

local function wrapCorners(original, childId)
    return function(...)
        local root = original(...)
        if root and not Engine.IsConsoleGame() then
            local ok, err = pcall(function()
                local corners = childId == "lowHealthHudDefId" and root or (childId and root:getFirstDescendentById(childId) or root)
                if corners then
                    placeAtScreenEdges(corners, childId == "lowHealthHudDefId" and RegisterMaterial("vfx_blood_screen_overlay") or nil)
                end
                if childId == "killCamCorners" then
                    extendKillcamBar(root)
                    centerFinalKillcamCard(root)
                end
            end)
            if not ok then
                print("safearea_hud layout error: " .. tostring(err))
            end
        end
        return root
    end
end

local types = LUI.MenuBuilder and LUI.MenuBuilder.m_types
if not types then
    print("safearea_hud: MenuBuilder.m_types is unavailable; not installed")
    return
end

local meta = getmetatable(types) or {}
local previousNewIndex = meta.__newindex
meta.__newindex = function(target, name, constructor)
    if name == "fourCornersHudDef" then
        constructor = wrapCorners(constructor)
    elseif name == "killCamHudDef" then
        constructor = wrapCorners(constructor, "killCamCorners")
    elseif name == "lowHealthHudDef" then
        constructor = wrapCorners(constructor, "lowHealthHudDefId")
    end
    if type(previousNewIndex) == "function" then
        return previousNewIndex(target, name, constructor)
    elseif type(previousNewIndex) == "table" then
        previousNewIndex[name] = constructor
    else
        rawset(target, name, constructor)
    end
end

local ok, err = pcall(setmetatable, types, meta)
if not ok then
    print("safearea_hud: could not hook MenuBuilder: " .. tostring(err))
end

if types["fourCornersHudDef"] then
    types["fourCornersHudDef"] = wrapCorners(types["fourCornersHudDef"])
end
if types["killCamHudDef"] then
    types["killCamHudDef"] = wrapCorners(types["killCamHudDef"], "killCamCorners")
end
if types["lowHealthHudDef"] then
    types["lowHealthHudDef"] = wrapCorners(types["lowHealthHudDef"], "lowHealthHudDefId")
end
