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
    panel = Color3.fromRGB(8, 5, 20),
    header = Color3.fromRGB(25, 9, 48),
    button = Color3.fromRGB(25, 15, 48),
    text = Color3.fromRGB(250, 242, 255),
    muted = Color3.fromRGB(185, 165, 220),
    purple = Color3.fromRGB(205, 45, 255),
    pink = Color3.fromRGB(255, 45, 190),
    cyan = Color3.fromRGB(45, 205, 255),
    green = Color3.fromRGB(60, 255, 170),
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
    Size = UDim2.fromOffset(390, 560),
    Position = UDim2.new(0, 18, 0.5, -280),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, gui)
addCorner(panel, 13)
addStroke(panel, COLORS.pink, 2, 0.02)
make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 7, 32)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(16, 9, 38)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 18, 35))}), Rotation = 25}, panel)

local top = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 58),
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
    Text = "✦ RAEZHY HD  /  VIOLENCE DISTRICT",
    TextColor3 = COLORS.text,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local closeButton = make("TextButton", {
    Position = UDim2.new(1, -76, 0, 13),
    Size = UDim2.fromOffset(28, 30),
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = COLORS.text,
    BackgroundColor3 = Color3.fromRGB(105, 42, 70),
    BorderSizePixel = 0,
}, top)
addCorner(closeButton, 7)

local minimize = make("TextButton", {
    Position = UDim2.new(1, -42, 0, 13),
    Size = UDim2.fromOffset(28, 30),
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
    Position = UDim2.fromOffset(12, 68),
    Size = UDim2.new(1, -24, 1, -80),
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

local currentGroup = nil
local groupCounter = 0
local function section(label)
    local heading = make("TextLabel", {
        Size = UDim2.new(1, -2, 0, 27),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Text = "✦  " .. label,
        TextColor3 = COLORS.pink,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, body)
    groupCounter += 1
    local group = make("Frame", {
        Name = "ControlGrid" .. groupCounter,
        Size = UDim2.new(1, -2, 0, 0),
        BackgroundTransparency = 1,
    }, body)
    currentGroup = group
    local grid = make("UIGridLayout", {
        CellSize = UDim2.new(0.5, -5, 0, 38),
        CellPadding = UDim2.fromOffset(8, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, group)
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        group.Size = UDim2.new(1, -2, 0, grid.AbsoluteContentSize.Y)
    end)
    return heading
end

local function setStatus(message)
    status.Text = message
end

local function button(label, callback)
    local parent = currentGroup or body
    local item = make("TextButton", {
        Size = UDim2.new(1, -2, 0, 38),
        BackgroundColor3 = COLORS.button,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = label,
        TextColor3 = COLORS.text,
        TextSize = 11,
        TextWrapped = true,
        AutoButtonColor = true,
    }, parent)
    addCorner(item, 11)
    addStroke(item, COLORS.purple, 1.4, 0.12)
    make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(48, 18, 78), Color3.fromRGB(13, 25, 54)), Rotation = 0}, item)
    item.MouseButton1Click:Connect(callback)
    return item
end

-- Crosshair configuration.
local defaults = {
    crosshairEnabled = true,
    crosshairMode = "NEON VORTEX",
    colorTheme = "NEON",
    rgbEnabled = true,      -- smooth color flow
    spinEnabled = true,     -- ring arcs / orbit dots / star rotation
    pulseEnabled = true,    -- bloom animation on click
    ringEnabled = true,
    dotEnabled = true,
    crosshairSize = 18,
    crosshairGap = 6,
    crosshairThickness = 3,
    glowLevel = 3,
    opacity = 0,
    graphicsPreset = "MEDIUM",
}
local config = table.clone(defaults)
local savedSessionConfig = nil
local hue = 0
local pulse = 0
local clock = 0

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local function round(value) return math.floor(value + 0.5) end

-- Color themes (cyclic palettes, sampled smoothly).
local PALETTES = {
    NEON = {rgb(55, 230, 255), rgb(177, 100, 255), rgb(255, 75, 170), rgb(177, 100, 255)},
    RAINBOW = {rgb(255, 70, 90), rgb(255, 200, 60), rgb(90, 255, 150), rgb(60, 200, 255), rgb(150, 100, 255), rgb(255, 80, 200)},
    TOXIC = {rgb(90, 255, 120), rgb(210, 255, 80), rgb(40, 220, 190)},
    FIRE = {rgb(255, 60, 60), rgb(255, 140, 40), rgb(255, 225, 90), rgb(255, 140, 40)},
    ICE = {rgb(255, 255, 255), rgb(160, 215, 255), rgb(90, 160, 255), rgb(160, 215, 255)},
    ROYAL = {rgb(173, 75, 255), rgb(224, 190, 255), rgb(120, 60, 220), rgb(224, 190, 255)},
}
local THEME_ORDER = {"NEON", "RAINBOW", "TOXIC", "FIRE", "ICE", "ROYAL"}

-- Crosshair models. Multipliers are applied on top of the Size / Gap / Thickness settings.
local MODES = {
    ["NEON VORTEX"] = {cardinal = true, arcs = true, ringSpin = 110},
    ["CYBER X"] = {diagonal = true, ringSpin = 70},
    ["PRECISION"] = {cardinal = true, size = 0.62, gap = 0.65, thick = -1},
    ["TACTICAL"] = {cardinal = true, hideTop = true, size = 0.9},
    ["ORBITAL"] = {cardinal = true, size = 0.72, gap = 1.15, orbit = true},
    ["RAINBOW STAR"] = {cardinal = true, diagonal = true, size = 0.82, spin = 24, ringSpin = -60, theme = "RAINBOW"},
}
local MODE_ORDER = {"NEON VORTEX", "CYBER X", "PRECISION", "TACTICAL", "ORBITAL", "RAINBOW STAR"}
local activeMode = MODES["NEON VORTEX"]

-- Glow strength per level: padding around each part and transparency of the halo.
local GLOW_LEVELS = {
    {pad = 1, alpha = 0.88, ring = 1.5},
    {pad = 2, alpha = 0.80, ring = 2},
    {pad = 3, alpha = 0.70, ring = 2.5},
    {pad = 5, alpha = 0.58, ring = 3},
}

local ARM_NAMES = {"top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "left", "topLeft"}
local ARM_PHASE = {top = 0, topRight = 0.1, right = 0.2, bottomRight = 0.3, bottom = 0.4, bottomLeft = 0.5, left = 0.6, topLeft = 0.7}

local cross = make("Frame", {
    Name = "Crosshair",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(1, 1),
    BackgroundTransparency = 1,
    Visible = true,
    ZIndex = 20,
}, gui)
local bloom = make("UIScale", {Scale = 1}, cross)

-- Everything that can rotate as one star lives in the spinner.
local spinner = make("Frame", {
    Name = "Spinner",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 22,
}, cross)

-- A part = soft glow halo (sibling behind) + colored body + white neon core + thin dark outline.
local function createPart(name, isDot)
    local glow = make("Frame", {
        Name = name .. "Glow",
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.7,
        ZIndex = 21,
    }, spinner)
    make("UICorner", {CornerRadius = UDim.new(0.5, 0)}, glow)

    local item = make("Frame", {
        Name = name,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = config.opacity,
        ZIndex = 22,
    }, spinner)
    make("UICorner", {CornerRadius = UDim.new(0.5, 0)}, item)
    local outline = addStroke(item, Color3.new(0, 0, 0), 1, 0.4)

    local core = nil
    if not isDot then
        core = make("Frame", {
            Name = "Core",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.05,
            ZIndex = 23,
        }, item)
        make("UICorner", {CornerRadius = UDim.new(0.5, 0)}, core)
    end

    return {frame = item, glow = glow, core = core, outline = outline}
end

local arms = {}
for _, name in ipairs(ARM_NAMES) do
    arms[name] = createPart(name, false)
end
local centerDot = createPart("CenterDot", true)

-- Outer ring: a gradient stroke (color + optional gaps) that spins, with a wider faint copy as glow.
local ringLayers = {}
local function createRing(name, zIndex)
    local frame = make("Frame", {
        Name = name,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(60, 60),
        BackgroundTransparency = 1,
        ZIndex = zIndex,
    }, cross)
    make("UICorner", {CornerRadius = UDim.new(0.5, 0)}, frame)
    local stroke = addStroke(frame, Color3.new(1, 1, 1), 2, 0.05)
    local gradient = make("UIGradient", {}, stroke)
    local scale = make("UIScale", {Scale = 1}, frame)
    local layer = {frame = frame, stroke = stroke, gradient = gradient, scale = scale}
    table.insert(ringLayers, layer)
    return layer
end
local ringGlow = createRing("OuterRingGlow", 20)
local ring = createRing("OuterRing", 21)

-- Orbit dots (ORBITAL model) ride on the ring.
local orbit = make("Frame", {
    Name = "Orbit",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(60, 60),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 23,
}, cross)
local orbitDots = {}
for i = 0, 2 do
    local spoke = make("Frame", {
        Name = "Spoke",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        Rotation = i * 120,
        BackgroundTransparency = 1,
        ZIndex = 23,
    }, orbit)
    local dot = make("Frame", {
        Name = "OrbitDot",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromOffset(6, 6),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        ZIndex = 24,
    }, spoke)
    make("UICorner", {CornerRadius = UDim.new(0.5, 0)}, dot)
    addStroke(dot, Color3.new(0, 0, 0), 1, 0.4)
    table.insert(orbitDots, dot)
end

local SOLID_ALPHA = NumberSequence.new(0)
local ARC_ALPHA = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.02, 0),
    NumberSequenceKeypoint.new(0.28, 0),
    NumberSequenceKeypoint.new(0.30, 1),
    NumberSequenceKeypoint.new(0.52, 1),
    NumberSequenceKeypoint.new(0.54, 0),
    NumberSequenceKeypoint.new(0.80, 0),
    NumberSequenceKeypoint.new(0.82, 1),
    NumberSequenceKeypoint.new(1, 1),
})

local function samplePalette(palette, t)
    local count = #palette
    local position = (t % 1) * count
    local index = math.floor(position)
    local fraction = position - index
    local a = palette[index % count + 1]
    local b = palette[(index + 1) % count + 1]
    return a:Lerp(b, fraction)
end

local function buildSequence(palette)
    local count = #palette
    local keys = {}
    for i = 0, count do
        keys[#keys + 1] = ColorSequenceKeypoint.new(i / count, palette[i % count + 1])
    end
    return ColorSequence.new(keys)
end

local function currentPalette()
    local themeName = activeMode.theme or config.colorTheme
    return PALETTES[themeName] or PALETTES.NEON
end

local gradientPalette = nil
local function applyCrosshairColors()
    local palette = currentPalette()
    if palette ~= gradientPalette then
        gradientPalette = palette
        local sequence = buildSequence(palette)
        for _, layer in ipairs(ringLayers) do
            layer.gradient.Color = sequence
        end
    end

    for _, name in ipairs(ARM_NAMES) do
        local color = samplePalette(palette, hue + ARM_PHASE[name])
        arms[name].frame.BackgroundColor3 = color
        arms[name].glow.BackgroundColor3 = color
    end

    centerDot.frame.BackgroundColor3 = Color3.new(1, 1, 1)
    centerDot.glow.BackgroundColor3 = samplePalette(palette, hue + 0.5)

    for index, dot in ipairs(orbitDots) do
        dot.BackgroundColor3 = samplePalette(palette, hue + index / 3)
    end
end

local function placePart(entry, cx, cy, width, height, rotation, horizontal, pad)
    local x = round(cx - width / 2)
    local y = round(cy - height / 2)
    entry.frame.Size = UDim2.fromOffset(width, height)
    entry.frame.Position = UDim2.fromOffset(x, y)
    entry.frame.Rotation = rotation
    entry.glow.Size = UDim2.fromOffset(width + pad * 2, height + pad * 2)
    entry.glow.Position = UDim2.fromOffset(x - pad, y - pad)
    entry.glow.Rotation = rotation
    if entry.core then
        local coreThickness = math.max(1, math.floor(math.min(width, height) / 2))
        if horizontal then
            entry.core.Size = UDim2.new(1, -2, 0, coreThickness)
        else
            entry.core.Size = UDim2.new(0, coreThickness, 1, -2)
        end
    end
end

local function setPartVisible(entry, visible, glowOn)
    entry.frame.Visible = visible
    entry.glow.Visible = visible and glowOn
end

local function updateCrosshair()
    cross.Visible = config.crosshairEnabled
    if not config.crosshairEnabled then return end

    local mode = MODES[config.crosshairMode] or MODES["NEON VORTEX"]
    activeMode = mode

    local size = math.max(4, math.floor(config.crosshairSize * (mode.size or 1)))
    local gap = math.max(1, math.floor(config.crosshairGap * (mode.gap or 1)))
    local thickness = math.max(1, config.crosshairThickness + (mode.thick or 0))
    local glowStyle = GLOW_LEVELS[config.glowLevel] or GLOW_LEVELS[3]
    local pad = glowStyle.pad
    local glowAlpha = glowStyle.alpha + (1 - glowStyle.alpha) * config.opacity

    -- Cardinal arms.
    local half = size / 2
    placePart(arms.top, 0, -(gap + half), thickness, size, 0, false, pad)
    placePart(arms.bottom, 0, gap + half, thickness, size, 0, false, pad)
    placePart(arms.left, -(gap + half), 0, size, thickness, 0, true, pad)
    placePart(arms.right, gap + half, 0, size, thickness, 0, true, pad)

    -- Diagonal arms: centered on the 45 degree lines, rotated to point at the center.
    local diagonalSize = math.max(7, math.floor(size * 0.72))
    local diagonalCenter = (gap + diagonalSize / 2 + 1) * 0.7071
    placePart(arms.topRight, diagonalCenter, -diagonalCenter, thickness, diagonalSize, 45, false, pad)
    placePart(arms.bottomLeft, -diagonalCenter, diagonalCenter, thickness, diagonalSize, 45, false, pad)
    placePart(arms.bottomRight, diagonalCenter, diagonalCenter, thickness, diagonalSize, -45, false, pad)
    placePart(arms.topLeft, -diagonalCenter, -diagonalCenter, thickness, diagonalSize, -45, false, pad)

    local cardinalVisible = mode.cardinal == true
    local diagonalVisible = mode.diagonal == true
    local glowOn = glowAlpha < 0.99
    setPartVisible(arms.top, cardinalVisible and not mode.hideTop, glowOn)
    setPartVisible(arms.right, cardinalVisible, glowOn)
    setPartVisible(arms.bottom, cardinalVisible, glowOn)
    setPartVisible(arms.left, cardinalVisible, glowOn)
    setPartVisible(arms.topRight, diagonalVisible, glowOn)
    setPartVisible(arms.bottomRight, diagonalVisible, glowOn)
    setPartVisible(arms.bottomLeft, diagonalVisible, glowOn)
    setPartVisible(arms.topLeft, diagonalVisible, glowOn)

    -- Center dot.
    placePart(centerDot, 0, 0, 4, 4, 0, false, pad)
    setPartVisible(centerDot, config.dotEnabled, glowOn)

    -- Transparency (opacity setting applies to bodies, cores and halos).
    for _, entry in pairs(arms) do
        entry.frame.BackgroundTransparency = config.opacity
        entry.outline.Transparency = 0.4 + 0.6 * config.opacity
        entry.glow.BackgroundTransparency = glowAlpha
        if entry.core then entry.core.BackgroundTransparency = 0.05 + 0.95 * config.opacity end
    end
    centerDot.frame.BackgroundTransparency = config.opacity
    centerDot.outline.Transparency = 0.4 + 0.6 * config.opacity
    centerDot.glow.BackgroundTransparency = glowAlpha

    -- Ring sits just outside the longest arm tip.
    local tip = 0
    if cardinalVisible then tip = gap + size end
    if diagonalVisible then tip = math.max(tip, gap + diagonalSize + 1) end
    local ringSize = (tip + 8) * 2
    local alphaSequence = mode.arcs and ARC_ALPHA or SOLID_ALPHA
    for _, layer in ipairs({ringGlow, ring}) do
        layer.frame.Size = UDim2.fromOffset(ringSize, ringSize)
        layer.frame.Visible = config.ringEnabled
        layer.gradient.Transparency = alphaSequence
    end
    ring.stroke.Thickness = glowStyle.ring
    ring.stroke.Transparency = 0.05 + 0.9 * config.opacity
    ringGlow.stroke.Thickness = glowStyle.ring + pad + 1
    ringGlow.stroke.Transparency = math.min(1, glowAlpha + 0.12)
    ringGlow.frame.Visible = config.ringEnabled and glowOn

    orbit.Size = UDim2.fromOffset(ringSize, ringSize)
    orbit.Visible = config.ringEnabled and mode.orbit == true

    if not config.spinEnabled or (mode.spin or 0) == 0 then
        spinner.Rotation = 0
    end

    applyCrosshairColors()
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
local modelButton, themeButton
local function refreshLabels()
    modelButton.Text = "Model: " .. config.crosshairMode .. "  •  Cycle"
    themeButton.Text = "Color Theme: " .. config.colorTheme .. "  •  Cycle"
end
modelButton = button("", function()
    local index = table.find(MODE_ORDER, config.crosshairMode) or 1
    config.crosshairMode = MODE_ORDER[index % #MODE_ORDER + 1]
    refreshLabels()
    updateCrosshair()
    setStatus("Crosshair model: " .. config.crosshairMode)
end)
themeButton = button("", function()
    local index = table.find(THEME_ORDER, config.colorTheme) or 1
    config.colorTheme = THEME_ORDER[index % #THEME_ORDER + 1]
    refreshLabels()
    applyCrosshairColors()
    setStatus("Color theme: " .. config.colorTheme)
end)
refreshLabels()
button("Color Flow Animation: ON / OFF", function()
    config.rgbEnabled = not config.rgbEnabled
    applyCrosshairColors()
    setStatus("Color flow " .. (config.rgbEnabled and "enabled" or "disabled"))
end)
button("Spin / Orbit Animation: ON / OFF", function()
    config.spinEnabled = not config.spinEnabled
    updateCrosshair()
    setStatus("Spin animation " .. (config.spinEnabled and "enabled" or "disabled"))
end)
button("Click Bloom Pulse: ON / OFF", function()
    config.pulseEnabled = not config.pulseEnabled
    setStatus("Click pulse " .. (config.pulseEnabled and "enabled" or "disabled"))
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
    refreshLabels()
    updateCrosshair()
    applyGraphicsPreset(config.graphicsPreset or "MEDIUM")
    setStatus("Saved session settings loaded")
end)
button("Reset All Settings", function()
    config = table.clone(defaults)
    refreshLabels()
    updateCrosshair()
    applyGraphicsPreset(config.graphicsPreset)
    setStatus("Settings reset to defaults")
end)

-- Keep the scroll canvas sized to its content on older Roblox clients too.
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    body.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end)

local minimized = false
local restoreButton = make("TextButton", {
    Name = "FloatingRestoreMenu",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -22, 1, -95),
    Size = UDim2.fromOffset(66, 66),
    BackgroundColor3 = Color3.fromRGB(45, 8, 75),
    BorderSizePixel = 0,
    Text = "✦\nMENU",
    TextColor3 = COLORS.text,
    TextSize = 15,
    Font = Enum.Font.GothamBlack,
    TextWrapped = true,
    Visible = false,
    ZIndex = 50,
    AutoButtonColor = true,
}, gui)
addCorner(restoreButton, 1)
addStroke(restoreButton, COLORS.pink, 3, 0)
make("UIGradient", {Color = ColorSequence.new(COLORS.purple, COLORS.cyan), Rotation = 45}, restoreButton)

local function setMinimized(value)
    minimized = value
    panel.Visible = not minimized
    restoreButton.Visible = minimized
end

minimize.Activated:Connect(function()
    setMinimized(true)
end)
restoreButton.Activated:Connect(function()
    setMinimized(false)
end)

-- Click bloom: the crosshair briefly expands and settles back (purely visual).
dragConnections[#dragConnections + 1] = UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not config.pulseEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pulse = 1
    end
end)

-- Render loop: smooth color flow, spinning ring arcs / orbit dots / star, breathing ring, click bloom.
local renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if not config.crosshairEnabled then return end
    clock += deltaTime

    if config.rgbEnabled then
        hue = (hue + deltaTime * 0.12) % 1
        applyCrosshairColors()
    end

    if config.spinEnabled then
        local spinSpeed = activeMode.spin or 0
        if spinSpeed ~= 0 then
            spinner.Rotation = (spinner.Rotation + spinSpeed * deltaTime) % 360
        end
        local ringSpeed = activeMode.ringSpin or 0
        if ringSpeed ~= 0 then
            for _, layer in ipairs(ringLayers) do
                layer.gradient.Rotation = (layer.gradient.Rotation + ringSpeed * deltaTime) % 360
            end
        end
        if orbit.Visible then
            orbit.Rotation = (orbit.Rotation + 150 * deltaTime) % 360
        end
        local breathe = 1 + 0.025 * math.sin(clock * 2.4)
        for _, layer in ipairs(ringLayers) do
            layer.scale.Scale = breathe
        end
    end

    if pulse > 0 then
        pulse = math.max(0, pulse - deltaTime * 4.5)
    end
    bloom.Scale = 1 + 0.22 * pulse * pulse
end)

updateCrosshair()

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

print("[RAEZHY HD V2.2] Loaded: Neon Grid UI + Floating Restore + RGB Crosshair Studio + HD Graphics")
setStatus("READY  •  RAEZHY HD V2.2 loaded")
