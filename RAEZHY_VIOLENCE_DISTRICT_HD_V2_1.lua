--[[
    RAEZHY VIOLENCE DISTRICT HD V2
    Cosmetic crosshair + client-side visual presets.
    Intended for a Roblox LocalScript in an experience you own or are authorized to modify.

    Uses standard Roblox APIs only. No executor-only functions, aim assist, ESP,
    hitbox changes, or gameplay automation.

    Save Settings stores a session snapshot only. Persistent cross-session saving
    requires a server-side DataStore implementation in an experience you own.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("RAEZHY_HD_GUI")
if oldGui then oldGui:Destroy() end

local COLORS = {
    panel = Color3.fromRGB(13, 12, 22),
    header = Color3.fromRGB(25, 17, 39),
    button = Color3.fromRGB(35, 26, 49),
    text = Color3.fromRGB(245, 235, 255),
    muted = Color3.fromRGB(185, 165, 205),
    purple = Color3.fromRGB(173, 75, 255),
}

local gui = Instance.new("ScreenGui")
gui.Name = "RAEZHY_HD_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function addCorner(parent, radius)
    local item = Instance.new("UICorner")
    item.CornerRadius = UDim.new(0, radius or 8)
    item.Parent = parent
    return item
end

local function addStroke(parent, color, thickness, transparency)
    local item = Instance.new("UIStroke")
    item.Color = color or COLORS.purple
    item.Thickness = thickness or 1
    item.Transparency = transparency or 0
    item.Parent = parent
    return item
end

local panel = make("Frame", {
    Name = "MainPanel",
    Size = UDim2.fromOffset(360, 500),
    Position = UDim2.new(0, 24, 0.5, -250),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, gui)
addCorner(panel, 13)
addStroke(panel, COLORS.purple, 1.5, 0.1)

local top = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = COLORS.header,
    BorderSizePixel = 0,
}, panel)
addCorner(top, 13)
make("Frame", {
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    BackgroundColor3 = COLORS.header,
    BorderSizePixel = 0,
}, top)

make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.new(1, -65, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "RAEZHY  /  VIOLENCE DISTRICT HD V2",
    TextColor3 = COLORS.text,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local closeButton = make("TextButton", {
    Position = UDim2.new(1, -72, 0, 10),
    Size = UDim2.fromOffset(28, 28),
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = COLORS.text,
    BackgroundColor3 = Color3.fromRGB(105, 42, 70),
    BorderSizePixel = 0,
}, top)
addCorner(closeButton, 7)

local minimize = make("TextButton", {
    Position = UDim2.new(1, -40, 0, 10),
    Size = UDim2.fromOffset(28, 28),
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = COLORS.text,
    BackgroundColor3 = Color3.fromRGB(65, 38, 88),
    BorderSizePixel = 0,
}, top)
addCorner(minimize, 7)

-- Drag support for mouse and touch. Connections are tracked for cleanup.
local dragConnections = {}
do
    local dragging = false
    local dragStart
    local startPosition

    dragConnections[#dragConnections + 1] = top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragConnections[#dragConnections + 1] = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

local body = make("ScrollingFrame", {
    Name = "SettingsScroll",
    Position = UDim2.fromOffset(12, 60),
    Size = UDim2.new(1, -24, 1, -72),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = COLORS.purple,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
}, panel)
local bodyPadding = make("UIPadding", {
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 8),
}, body)
local layout = make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, body)

local status = make("TextLabel", {
    Size = UDim2.new(1, -2, 0, 22),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "READY  •  Client-side visual tools",
    TextColor3 = COLORS.muted,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 999,
}, body)

local function section(label)
    return make("TextLabel", {
        Size = UDim2.new(1, -2, 0, 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = label,
        TextColor3 = Color3.fromRGB(205, 145, 255),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, body)
end

local function setStatus(message)
    status.Text = message
end

local function button(label, callback)
    local item = make("TextButton", {
        Size = UDim2.new(1, -2, 0, 32),
        BackgroundColor3 = COLORS.button,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamSemibold,
        Text = label,
        TextColor3 = COLORS.text,
        TextSize = 11,
        AutoButtonColor = true,
    }, body)
    addCorner(item, 7)
    addStroke(item, Color3.fromRGB(100, 62, 135), 1, 0.45)
    item.MouseButton1Click:Connect(callback)
    return item
end

-- Crosshair configuration.
local defaults = {
    crosshairEnabled = true,
    crosshairMode = "NEON VORTEX",
    rgbEnabled = true,
    ringEnabled = true,
    dotEnabled = true,
    crosshairSize = 18,
    crosshairGap = 6,
    crosshairThickness = 3,
    glowLevel = 2,
    opacity = 0,
    graphicsPreset = "MEDIUM",
}
local config = table.clone(defaults)
local savedSessionConfig = nil
local hue = 0

local cross = make("Frame", {
    Name = "Crosshair",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(1, 1),
    BackgroundTransparency = 1,
    Visible = true,
    ZIndex = 20,
}, gui)

local crosshairParts = {}
local function createPart(name, isDiagonal)
    local item = make("Frame", {
        Name = name,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = config.opacity,
        Visible = true,
        ZIndex = 22,
    }, cross)
    addCorner(item, 3)
    local outline = addStroke(item, Color3.new(1, 1, 1), 2, 0.08)
    table.insert(crosshairParts, {frame = item, outline = outline, diagonal = isDiagonal})
    return item
end

local arms = {
    top = createPart("TopArm", false),
    right = createPart("RightArm", false),
    bottom = createPart("BottomArm", false),
    left = createPart("LeftArm", false),
    topRight = createPart("TopRightArm", true),
    bottomRight = createPart("BottomRightArm", true),
    bottomLeft = createPart("BottomLeftArm", true),
    topLeft = createPart("TopLeftArm", true),
}
local centerDot = createPart("CenterDot", false)
local outerRing = make("Frame", {
    Name = "OuterRing",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(42, 42),
    BackgroundTransparency = 1,
    ZIndex = 21,
}, cross)
addCorner(outerRing, 100)
local ringStroke = addStroke(outerRing, Color3.new(1, 1, 1), 2, 0.05)

local function positionArm(item, x, y, width, height, rotation)
    item.Size = UDim2.fromOffset(width, height)
    item.Position = UDim2.fromOffset(x, y)
    item.Rotation = rotation or 0
end

local function updateCrosshair()
    cross.Visible = config.crosshairEnabled
    if not config.crosshairEnabled then return end

    local size = config.crosshairSize
    local gap = config.crosshairGap
    local thickness = config.crosshairThickness
    local mode = config.crosshairMode

    local cardinalVisible = true
    local diagonalVisible = false
    if mode == "CYBER X" then
        cardinalVisible = false
        diagonalVisible = true
    elseif mode == "PRECISION" then
        size = math.max(7, math.floor(size * 0.62))
        gap = math.max(2, math.floor(gap * 0.65))
        thickness = math.max(2, thickness - 1)
    elseif mode == "ORBITAL" then
        size = math.floor(size * 0.72)
        gap = math.floor(gap * 1.15)
    elseif mode == "RAINBOW STAR" then
        diagonalVisible = true
        size = math.floor(size * 0.82)
    end

    positionArm(arms.top, -thickness / 2, -gap - size, thickness, size, 0)
    positionArm(arms.bottom, -thickness / 2, gap, thickness, size, 0)
    positionArm(arms.left, -gap - size, -thickness / 2, size, thickness, 0)
    positionArm(arms.right, gap, -thickness / 2, size, thickness, 0)

    local diagonalSize = math.max(7, math.floor(size * 0.72))
    local diagonalOffset = gap + math.floor(diagonalSize * 0.55)
    positionArm(arms.topRight, diagonalOffset - thickness / 2, -diagonalOffset - thickness / 2, thickness, diagonalSize, -45)
    positionArm(arms.bottomRight, diagonalOffset - thickness / 2, diagonalOffset - diagonalSize / 2, thickness, diagonalSize, 45)
    positionArm(arms.bottomLeft, -diagonalOffset - thickness / 2, diagonalOffset - diagonalSize / 2, thickness, diagonalSize, -45)
    positionArm(arms.topLeft, -diagonalOffset - thickness / 2, -diagonalOffset - diagonalSize / 2, thickness, diagonalSize, 45)

    for _, item in pairs({arms.top, arms.right, arms.bottom, arms.left}) do
        item.Visible = cardinalVisible
    end
    for _, item in pairs({arms.topRight, arms.bottomRight, arms.bottomLeft, arms.topLeft}) do
        item.Visible = diagonalVisible
    end

    centerDot.Size = UDim2.fromOffset(config.dotEnabled and 4 or 0, config.dotEnabled and 4 or 0)
    centerDot.Position = UDim2.fromOffset(-2, -2)
    centerDot.Visible = config.dotEnabled
    centerDot.BackgroundTransparency = config.opacity
    outerRing.Visible = config.ringEnabled
    local ringSize = size + gap * 2 + 16
    outerRing.Size = UDim2.fromOffset(ringSize, ringSize)

    local glowThickness = ({1, 2, 3, 4})[config.glowLevel] or 2
    for _, entry in ipairs(crosshairParts) do
        entry.frame.BackgroundTransparency = config.opacity
        entry.outline.Thickness = glowThickness
        entry.outline.Transparency = 0.08 + (config.glowLevel == 1 and 0.28 or 0)
    end
    ringStroke.Thickness = glowThickness
end

local rainbowColors = {
    Color3.fromRGB(55, 230, 255), -- cyan
    Color3.fromRGB(255, 75, 170), -- pink
    Color3.fromRGB(125, 255, 175), -- mint
    Color3.fromRGB(177, 100, 255), -- purple
    Color3.fromRGB(255, 220, 90), -- yellow
    Color3.fromRGB(90, 150, 255), -- blue
    Color3.fromRGB(255, 125, 90), -- coral
    Color3.fromRGB(255, 255, 255), -- white
}

local function applyCrosshairColors()
    if config.rgbEnabled then
        local shift = math.floor(hue * #rainbowColors)
        local names = {"top", "right", "bottom", "left", "topRight", "bottomRight", "bottomLeft", "topLeft"}
        for index, name in ipairs(names) do
            local color = rainbowColors[((index + shift - 1) % #rainbowColors) + 1]
            local frame = arms[name]
            frame.BackgroundColor3 = color
            local outline = frame:FindFirstChildOfClass("UIStroke")
            if outline then outline.Color = color end
        end
        centerDot.BackgroundColor3 = Color3.new(1, 1, 1)
        local dotOutline = centerDot:FindFirstChildOfClass("UIStroke")
        if dotOutline then dotOutline.Color = Color3.new(1, 1, 1) end
        ringStroke.Color = Color3.fromHSV((hue + 0.08) % 1, 0.75, 1)
    else
        local fixed = Color3.fromRGB(224, 190, 255)
        for _, entry in ipairs(crosshairParts) do
            entry.frame.BackgroundColor3 = fixed
            entry.outline.Color = fixed
        end
        ringStroke.Color = fixed
    end
end

-- Lighting snapshot and owned post-processing effects.
local lightingSnapshot = {
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
}
local existingEffectStates = {}
for _, child in ipairs(Lighting:GetChildren()) do
    if child:IsA("PostEffect") then
        existingEffectStates[child] = child.Enabled
    end
end

local function removeOwnedEffects()
    for _, effectName in ipairs({"RAEZHY_HD_Color", "RAEZHY_HD_Bloom", "RAEZHY_HD_SunRays"}) do
        local effect = Lighting:FindFirstChild(effectName)
        if effect then effect:Destroy() end
    end
end

local function createEffect(className, name)
    local effect = Instance.new(className)
    effect.Name = name
    return effect
end

local function applyGraphicsPreset(preset)
    removeOwnedEffects()
    config.graphicsPreset = preset

    local cc = createEffect("ColorCorrectionEffect", "RAEZHY_HD_Color")
    local bloom = createEffect("BloomEffect", "RAEZHY_HD_Bloom")
    local sunRays = createEffect("SunRaysEffect", "RAEZHY_HD_SunRays")

    if preset == "LOW" or preset == "PERFORMANCE" then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1.8
        cc.Enabled = false
        bloom.Enabled = false
        sunRays.Enabled = false
    elseif preset == "MEDIUM" then
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        cc.Contrast = 0.06
        cc.Saturation = 0.08
        bloom.Intensity = 0.12
        bloom.Size = 16
        bloom.Threshold = 1.25
        sunRays.Intensity = 0.025
        sunRays.Spread = 0.7
    elseif preset == "HIGH" then
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2.15
        cc.Contrast = 0.13
        cc.Saturation = 0.16
        cc.TintColor = Color3.fromRGB(240, 230, 255)
        bloom.Intensity = 0.24
        bloom.Size = 22
        bloom.Threshold = 1.1
        sunRays.Intensity = 0.045
        sunRays.Spread = 0.8
    elseif preset == "ULTRA" then
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2.3
        cc.Contrast = 0.18
        cc.Saturation = 0.22
        cc.TintColor = Color3.fromRGB(245, 235, 255)
        bloom.Intensity = 0.34
        bloom.Size = 28
        bloom.Threshold = 1.05
        sunRays.Intensity = 0.06
        sunRays.Spread = 0.85
    else
        setStatus("Unknown graphics preset")
        return
    end

    if preset ~= "LOW" and preset ~= "PERFORMANCE" then
        cc.Parent = Lighting
        bloom.Parent = Lighting
        sunRays.Parent = Lighting
    end
    setStatus("Graphics preset applied: " .. preset)
end

local function restoreLighting()
    removeOwnedEffects()
    for property, value in pairs(lightingSnapshot) do
        pcall(function() Lighting[property] = value end)
    end
    for effect, enabled in pairs(existingEffectStates) do
        if effect and effect.Parent then
            pcall(function() effect.Enabled = enabled end)
        end
    end
    setStatus("Original lighting restored")
end

-- UI controls.
section("01  /  CROSSHAIR STUDIO")
button("Crosshair: ON / OFF", function()
    config.crosshairEnabled = not config.crosshairEnabled
    updateCrosshair()
    setStatus("Crosshair " .. (config.crosshairEnabled and "enabled" or "disabled"))
end)
button("Model: NEON VORTEX  •  Cycle", function()
    local modes = {"NEON VORTEX", "CYBER X", "PRECISION", "ORBITAL", "RAINBOW STAR"}
    local index = table.find(modes, config.crosshairMode) or 1
    config.crosshairMode = modes[index % #modes + 1]
    updateCrosshair()
    setStatus("Crosshair model: " .. config.crosshairMode)
end)
button("RGB Mix Animation: ON / OFF", function()
    config.rgbEnabled = not config.rgbEnabled
    applyCrosshairColors()
    setStatus("RGB animation " .. (config.rgbEnabled and "enabled" or "disabled"))
end)
button("Outer Ring: ON / OFF", function()
    config.ringEnabled = not config.ringEnabled
    updateCrosshair()
end)
button("Center Dot: ON / OFF", function()
    config.dotEnabled = not config.dotEnabled
    updateCrosshair()
end)
button("Size: Increase / Cycle", function()
    config.crosshairSize = config.crosshairSize >= 30 and 12 or config.crosshairSize + 3
    updateCrosshair()
    setStatus("Crosshair size: " .. config.crosshairSize)
end)
button("Gap: Increase / Cycle", function()
    config.crosshairGap = config.crosshairGap >= 12 and 3 or config.crosshairGap + 3
    updateCrosshair()
    setStatus("Crosshair gap: " .. config.crosshairGap)
end)
button("Thickness: Increase / Cycle", function()
    config.crosshairThickness = config.crosshairThickness >= 5 and 2 or config.crosshairThickness + 1
    updateCrosshair()
    setStatus("Crosshair thickness: " .. config.crosshairThickness)
end)
button("Glow Level: Cycle 1–4", function()
    config.glowLevel = config.glowLevel >= 4 and 1 or config.glowLevel + 1
    updateCrosshair()
    setStatus("Glow level: " .. config.glowLevel)
end)
button("Opacity: Cycle 0% / 20% / 40%", function()
    local values = {0, 0.2, 0.4}
    local current = table.find(values, config.opacity) or 1
    config.opacity = values[current % #values + 1]
    updateCrosshair()
    setStatus("Crosshair opacity: " .. math.floor(config.opacity * 100) .. "%")
end)

section("02  /  HD GRAPHICS BOOSTER")
button("Graphics: LOW", function() applyGraphicsPreset("LOW") end)
button("Graphics: MEDIUM", function() applyGraphicsPreset("MEDIUM") end)
button("Graphics: HIGH", function() applyGraphicsPreset("HIGH") end)
button("Graphics: ULTRA", function() applyGraphicsPreset("ULTRA") end)
button("Performance Mode: ON", function() applyGraphicsPreset("PERFORMANCE") end)
button("Restore Original Lighting", restoreLighting)

section("03  /  CONFIGURATION")
button("Save Settings (this session)", function()
    savedSessionConfig = table.clone(config)
    setStatus("Settings snapshot saved for this session")
end)
button("Load Saved Settings", function()
    if not savedSessionConfig then
        setStatus("No saved session settings yet")
        return
    end
    config = table.clone(savedSessionConfig)
    updateCrosshair()
    applyGraphicsPreset(config.graphicsPreset or "MEDIUM")
    setStatus("Saved session settings loaded")
end)
button("Reset All Settings", function()
    config = table.clone(defaults)
    updateCrosshair()
    applyCrosshairColors()
    applyGraphicsPreset(config.graphicsPreset)
    setStatus("Settings reset to defaults")
end)

-- Keep the scroll canvas sized to its content on older Roblox clients too.
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    body.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end)

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    panel.Size = minimized and UDim2.fromOffset(360, 50) or UDim2.fromOffset(360, 500)
    minimize.Text = minimized and "+" or "—"
end)

-- Render loop: per-arm rainbow colors rotate smoothly without changing gameplay.
local renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if config.rgbEnabled then
        hue = (hue + deltaTime * 0.18) % 1
        applyCrosshairColors()
    end
end)

updateCrosshair()
applyCrosshairColors()

local cleaned = false
local function cleanup()
    if cleaned then return end
    cleaned = true
    if renderConnection then renderConnection:Disconnect() end
    for _, connection in ipairs(dragConnections) do
        if connection then connection:Disconnect() end
    end
    removeOwnedEffects()
    for property, value in pairs(lightingSnapshot) do
        pcall(function() Lighting[property] = value end)
    end
    for effect, enabled in pairs(existingEffectStates) do
        if effect and effect.Parent then
            pcall(function() effect.Enabled = enabled end)
        end
    end
end

closeButton.Activated:Connect(function()
    gui:Destroy()
end)

gui.Destroying:Connect(cleanup)

print("[RAEZHY HD V2.1] Loaded: RGB Crosshair Studio + HD Graphics + Session Config")
setStatus("READY  •  RAEZHY HD V2.1 loaded")
