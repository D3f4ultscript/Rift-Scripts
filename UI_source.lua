--// ============================================================================
--// KAVO UI LIBRARY v2.0 – Modernized Rewrite
--// Performance-optimized, event-driven theme system, modern design
--// ============================================================================

local Kavo = {}

-- ============================================================================
-- SERVICES (cached for performance)
-- ============================================================================
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")

local tweeninfo   = TweenInfo.new
local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ============================================================================
-- CONSTANTS
-- ============================================================================
local CORNER_RADIUS_MAIN    = UDim.new(0, 6)
local CORNER_RADIUS_ELEMENT = UDim.new(0, 5)
local CORNER_RADIUS_SECTION = UDim.new(0, 5)
local ELEMENT_WIDTH         = 352
local ELEMENT_HEIGHT        = 33
local TWEEN_SPEED_FAST      = 0.12
local TWEEN_SPEED_NORMAL    = 0.2
local TWEEN_SPEED_SMOOTH    = 0.3
local RIPPLE_DURATION        = 0.35

-- ============================================================================
-- UTILITY MODULE
-- ============================================================================
local Utility = {}

function Utility:TweenObject(obj, properties, duration, ...)
    TweenService:Create(obj, tweeninfo(duration, ...), properties):Play()
end

function Utility:SmoothTween(obj, properties, duration)
    TweenService:Create(obj, tweeninfo(duration or TWEEN_SPEED_NORMAL, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties):Play()
end

function Utility:Darken(color, amount)
    amount = amount or 14
    return Color3.fromRGB(
        math.max(color.R * 255 - amount, 0),
        math.max(color.G * 255 - amount, 0),
        math.max(color.B * 255 - amount, 0)
    )
end

function Utility:Lighten(color, amount)
    amount = amount or 12
    return Color3.fromRGB(
        math.min(color.R * 255 + amount, 255),
        math.min(color.G * 255 + amount, 255),
        math.min(color.B * 255 + amount, 255)
    )
end

function Utility:Ripple(button, schemeColor)
    local ripple = Instance.new("ImageLabel")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 1
    ripple.Image = "http://www.roblox.com/asset/?id=4560909609"
    ripple.ImageColor3 = schemeColor
    ripple.ImageTransparency = 0.6
    ripple.ZIndex = button.ZIndex

    local x = Mouse.X - ripple.AbsolutePosition.X
    local y = Mouse.Y - ripple.AbsolutePosition.Y
    ripple.Position = UDim2.new(0, x, 0, y)

    local size
    if button.AbsoluteSize.X >= button.AbsoluteSize.Y then
        size = button.AbsoluteSize.X * 1.5
    else
        size = button.AbsoluteSize.Y * 1.5
    end

    ripple:TweenSizeAndPosition(
        UDim2.new(0, size, 0, size),
        UDim2.new(0.5, -size / 2, 0.5, -size / 2),
        "Out", "Quad", RIPPLE_DURATION, true
    )

    for i = 1, 10 do
        ripple.ImageTransparency = ripple.ImageTransparency + 0.05
        task.wait(RIPPLE_DURATION / 12)
    end
    ripple:Destroy()
end

-- ============================================================================
-- THEME DEFINITIONS
-- ============================================================================
local defaultTheme = {
    SchemeColor  = Color3.fromRGB(74, 99, 135),
    Background   = Color3.fromRGB(36, 37, 43),
    Header       = Color3.fromRGB(28, 29, 34),
    TextColor    = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}

local themeStyles = {
    DarkTheme = {
        SchemeColor  = Color3.fromRGB(64, 64, 64),
        Background   = Color3.fromRGB(0, 0, 0),
        Header       = Color3.fromRGB(0, 0, 0),
        TextColor    = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor  = Color3.fromRGB(150, 150, 150),
        Background   = Color3.fromRGB(255, 255, 255),
        Header       = Color3.fromRGB(200, 200, 200),
        TextColor    = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor  = Color3.fromRGB(227, 27, 27),
        Background   = Color3.fromRGB(10, 10, 10),
        Header       = Color3.fromRGB(5, 5, 5),
        TextColor    = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    GrapeTheme = {
        SchemeColor  = Color3.fromRGB(166, 71, 214),
        Background   = Color3.fromRGB(64, 50, 71),
        Header       = Color3.fromRGB(36, 28, 41),
        TextColor    = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor  = Color3.fromRGB(86, 76, 251),
        Background   = Color3.fromRGB(26, 32, 58),
        Header       = Color3.fromRGB(38, 45, 71),
        TextColor    = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    Midnight = {
        SchemeColor  = Color3.fromRGB(26, 189, 158),
        Background   = Color3.fromRGB(44, 62, 82),
        Header       = Color3.fromRGB(57, 81, 105),
        TextColor    = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95)
    },
    Sentinel = {
        SchemeColor  = Color3.fromRGB(230, 35, 69),
        Background   = Color3.fromRGB(32, 32, 32),
        Header       = Color3.fromRGB(24, 24, 24),
        TextColor    = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Synapse = {
        SchemeColor  = Color3.fromRGB(46, 48, 43),
        Background   = Color3.fromRGB(13, 15, 12),
        Header       = Color3.fromRGB(36, 38, 35),
        TextColor    = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Serpent = {
        SchemeColor  = Color3.fromRGB(0, 166, 58),
        Background   = Color3.fromRGB(31, 41, 43),
        Header       = Color3.fromRGB(22, 29, 31),
        TextColor    = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    },
    -- ====== NEW PREMIUM THEMES ======
    Neon = {
        SchemeColor  = Color3.fromRGB(0, 255, 170),
        Background   = Color3.fromRGB(12, 12, 18),
        Header       = Color3.fromRGB(8, 8, 14),
        TextColor    = Color3.fromRGB(230, 255, 245),
        ElementColor = Color3.fromRGB(18, 18, 28)
    },
    Frost = {
        SchemeColor  = Color3.fromRGB(100, 180, 255),
        Background   = Color3.fromRGB(22, 28, 40),
        Header       = Color3.fromRGB(16, 20, 32),
        TextColor    = Color3.fromRGB(210, 230, 255),
        ElementColor = Color3.fromRGB(28, 36, 52)
    },
    Sakura = {
        SchemeColor  = Color3.fromRGB(255, 130, 170),
        Background   = Color3.fromRGB(35, 20, 28),
        Header       = Color3.fromRGB(28, 14, 22),
        TextColor    = Color3.fromRGB(255, 225, 235),
        ElementColor = Color3.fromRGB(45, 26, 36)
    },
    Cyberpunk = {
        SchemeColor  = Color3.fromRGB(255, 210, 0),
        Background   = Color3.fromRGB(14, 10, 22),
        Header       = Color3.fromRGB(10, 6, 18),
        TextColor    = Color3.fromRGB(255, 240, 200),
        ElementColor = Color3.fromRGB(22, 16, 34)
    }
}

-- ============================================================================
-- CONFIG / PERSISTENCE
-- ============================================================================
local SettingsT = {}
local ConfigName = "KavoConfig.JSON"

pcall(function()
    if not pcall(function() readfile(ConfigName) end) then
        writefile(ConfigName, HttpService:JSONEncode(SettingsT))
    end
    SettingsT = HttpService:JSONDecode(readfile(ConfigName))
end)

-- ============================================================================
-- UNIQUE LIBRARY NAME (prevents collisions)
-- ============================================================================
local LibName = "KavoUI_" .. tostring(math.random(100000, 999999))

-- ============================================================================
-- DRAGGING SYSTEM
-- ============================================================================
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = inp.Position
            framePos = parent.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = inp
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local delta = inp.Position - mousePos
            parent.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================================
-- TOGGLE UI VISIBILITY
-- ============================================================================
function Kavo:ToggleUI()
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then
        gui.Enabled = not gui.Enabled
    end
end

-- ============================================================================
-- MAIN LIBRARY CREATION
-- ============================================================================
function Kavo.CreateLib(kavName, themeList)
    -- ---- Theme Resolution ----
    if not themeList then
        themeList = {}
        for k, v in pairs(defaultTheme) do
            themeList[k] = v
        end
    elseif type(themeList) == "string" then
        local resolved = themeStyles[themeList]
        if resolved then
            themeList = {}
            for k, v in pairs(resolved) do
                themeList[k] = v
            end
        else
            themeList = {}
            for k, v in pairs(defaultTheme) do
                themeList[k] = v
            end
        end
    else
        -- Custom color table: fill in missing keys with defaults
        for k, v in pairs(defaultTheme) do
            if themeList[k] == nil then
                themeList[k] = v
            end
        end
    end

    kavName = kavName or "Library"
    local selectedTab

    -- ---- Clean up previous instances ----
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == LibName then
            v:Destroy()
        end
    end

    -- ================================================================
    -- THEME BINDING SYSTEM (replaces all while-wait loops)
    -- ================================================================
    local themeBindings = {}

    local function bindToTheme(obj, property, getter)
        table.insert(themeBindings, { obj = obj, prop = property, get = getter })
    end

    local function refreshTheme()
        local i = 1
        while i <= #themeBindings do
            local b = themeBindings[i]
            if b.obj and b.obj.Parent then
                local ok = pcall(function()
                    b.obj[b.prop] = b.get()
                end)
                if ok then
                    i = i + 1
                else
                    table.remove(themeBindings, i)
                end
            else
                table.remove(themeBindings, i)
            end
        end
    end

    -- ================================================================
    -- GUI INSTANCE CREATION
    -- ================================================================
    local ScreenGui     = Instance.new("ScreenGui")
    local Main          = Instance.new("Frame")
    local MainCorner    = Instance.new("UICorner")
    local MainStroke    = Instance.new("UIStroke")
    local MainHeader    = Instance.new("Frame")
    local headerCorner  = Instance.new("UICorner")
    local headerCover   = Instance.new("Frame")
    local title         = Instance.new("TextLabel")
    local close         = Instance.new("ImageButton")
    local MainSide      = Instance.new("Frame")
    local sideCorner    = Instance.new("UICorner")
    local sideCover     = Instance.new("Frame")
    local tabFrames     = Instance.new("Frame")
    local tabListing    = Instance.new("UIListLayout")
    local tabPadding    = Instance.new("UIPadding")
    local pages         = Instance.new("Frame")
    local Pages         = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")
    local blurFrame     = Instance.new("Frame")

    -- ---- Dragging ----
    Kavo:DraggingEnabled(MainHeader, Main)

    -- ---- ScreenGui ----
    ScreenGui.Name = LibName
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- ---- Main Frame ----
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.336, 0, 0.275, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)

    MainCorner.CornerRadius = CORNER_RADIUS_MAIN
    MainCorner.Parent = Main

    MainStroke.Parent = Main
    MainStroke.Color = Color3.fromRGB(60, 60, 70)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.5

    bindToTheme(Main, "BackgroundColor3", function() return themeList.Background end)

    -- ---- Header ----
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(0, 525, 0, 29)

    headerCorner.CornerRadius = CORNER_RADIUS_MAIN
    headerCorner.Parent = MainHeader

    headerCover.Name = "headerCover"
    headerCover.Parent = MainHeader
    headerCover.BackgroundColor3 = themeList.Header
    headerCover.BorderSizePixel = 0
    headerCover.Position = UDim2.new(0, 0, 0.758, 0)
    headerCover.Size = UDim2.new(0, 525, 0, 7)

    bindToTheme(MainHeader, "BackgroundColor3", function() return themeList.Header end)
    bindToTheme(headerCover, "BackgroundColor3", function() return themeList.Header end)

    -- ---- Title ----
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.017, 0, 0.345, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.GothamSemibold
    title.RichText = true
    title.Text = kavName
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- ---- Close Button ----
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.95, 0, 0.138, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.ZIndex = 2
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)

    close.MouseButton1Click:Connect(function()
        Utility:SmoothTween(close, { ImageTransparency = 1 }, 0.1)
        task.wait(0.05)
        Utility:SmoothTween(Main, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }, TWEEN_SPEED_SMOOTH)
        task.wait(0.5)
        ScreenGui:Destroy()
    end)

    -- ---- Sidebar ----
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0.091, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)

    sideCorner.CornerRadius = CORNER_RADIUS_MAIN
    sideCorner.Parent = MainSide

    sideCover.Name = "sideCover"
    sideCover.Parent = MainSide
    sideCover.BackgroundColor3 = themeList.Header
    sideCover.BorderSizePixel = 0
    sideCover.Position = UDim2.new(0.95, 0, 0, 0)
    sideCover.Size = UDim2.new(0, 7, 0, 289)

    bindToTheme(MainSide, "BackgroundColor3", function() return themeList.Header end)
    bindToTheme(sideCover, "BackgroundColor3", function() return themeList.Header end)

    -- ---- Tab Frames Container ----
    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.044, 0, 0, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    tabListing.Padding = UDim.new(0, 3)

    tabPadding.Parent = tabFrames
    tabPadding.PaddingTop = UDim.new(0, 4)

    -- ---- Pages Container ----
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.BorderSizePixel = 0
    pages.Position = UDim2.new(0.299, 0, 0.123, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    Pages.Name = "Pages"
    Pages.Parent = pages

    -- ---- Info Container (tooltips area) ----
    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    infoContainer.ClipsDescendants = true
    infoContainer.Position = UDim2.new(0.299, 0, 0.874, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    -- ---- Blur Overlay ----
    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.BorderSizePixel = 0
    blurFrame.Position = UDim2.new(-0.022, 0, -0.037, 0)
    blurFrame.Size = UDim2.new(0, 376, 0, 289)
    blurFrame.ZIndex = 999

    -- ================================================================
    -- NOTIFICATION / TOAST SYSTEM
    -- ================================================================
    local notifContainer = Instance.new("Frame")
    notifContainer.Name = "NotificationContainer"
    notifContainer.Parent = ScreenGui
    notifContainer.AnchorPoint = Vector2.new(1, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.Position = UDim2.new(1, -10, 0, 10)
    notifContainer.Size = UDim2.new(0, 260, 1, -20)
    notifContainer.ZIndex = 100

    local notifLayout = Instance.new("UIListLayout")
    notifLayout.Parent = notifContainer
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.Padding = UDim.new(0, 8)
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    local notifTypeColors = {
        Info    = Color3.fromRGB(52, 152, 219),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error   = Color3.fromRGB(231, 76, 60),
    }

    function Kavo:Notify(options)
        options = options or {}
        local nTitle    = options.Title or "Notification"
        local nText     = options.Text or ""
        local nDuration = options.Duration or 3
        local nType     = options.Type or "Info"

        local accentColor = notifTypeColors[nType] or notifTypeColors.Info

        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.Parent = notifContainer
        notif.BackgroundColor3 = themeList.Header
        notif.Size = UDim2.new(1, 0, 0, 0)
        notif.ClipsDescendants = true

        local nCorner = Instance.new("UICorner")
        nCorner.CornerRadius = UDim.new(0, 8)
        nCorner.Parent = notif

        local nStroke = Instance.new("UIStroke")
        nStroke.Parent = notif
        nStroke.Color = Utility:Lighten(themeList.Header, 20)
        nStroke.Thickness = 1
        nStroke.Transparency = 0.6

        local accent = Instance.new("Frame")
        accent.Name = "Accent"
        accent.Parent = notif
        accent.BackgroundColor3 = accentColor
        accent.Size = UDim2.new(0, 3, 1, 0)
        accent.BorderSizePixel = 0

        local accentCorner = Instance.new("UICorner")
        accentCorner.CornerRadius = UDim.new(0, 3)
        accentCorner.Parent = accent

        local nTitleLabel = Instance.new("TextLabel")
        nTitleLabel.Parent = notif
        nTitleLabel.BackgroundTransparency = 1
        nTitleLabel.Position = UDim2.new(0, 14, 0, 8)
        nTitleLabel.Size = UDim2.new(1, -24, 0, 18)
        nTitleLabel.Font = Enum.Font.GothamSemibold
        nTitleLabel.Text = nTitle
        nTitleLabel.TextColor3 = themeList.TextColor
        nTitleLabel.TextSize = 13
        nTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local nTextLabel = Instance.new("TextLabel")
        nTextLabel.Parent = notif
        nTextLabel.BackgroundTransparency = 1
        nTextLabel.Position = UDim2.new(0, 14, 0, 28)
        nTextLabel.Size = UDim2.new(1, -24, 0, 24)
        nTextLabel.Font = Enum.Font.Gotham
        nTextLabel.Text = nText
        nTextLabel.TextColor3 = Utility:Darken(themeList.TextColor, 50)
        nTextLabel.TextSize = 12
        nTextLabel.TextXAlignment = Enum.TextXAlignment.Left
        nTextLabel.TextWrapped = true
        nTextLabel.RichText = true

        local progress = Instance.new("Frame")
        progress.Name = "Progress"
        progress.Parent = notif
        progress.BackgroundColor3 = accentColor
        progress.AnchorPoint = Vector2.new(0, 1)
        progress.Position = UDim2.new(0, 0, 1, 0)
        progress.Size = UDim2.new(1, 0, 0, 2)
        progress.BorderSizePixel = 0

        -- Animate in (expand height)
        Utility:SmoothTween(notif, { Size = UDim2.new(1, 0, 0, 62) }, TWEEN_SPEED_SMOOTH)

        -- Progress bar shrinks over duration
        task.delay(0.3, function()
            Utility:TweenObject(progress, { Size = UDim2.new(0, 0, 0, 2) }, nDuration, Enum.EasingStyle.Linear)
        end)

        -- Auto-dismiss
        task.delay(nDuration + 0.3, function()
            Utility:SmoothTween(notif, { Size = UDim2.new(1, 0, 0, 0) }, TWEEN_SPEED_SMOOTH)
            task.wait(TWEEN_SPEED_SMOOTH + 0.05)
            notif:Destroy()
        end)
    end

    -- ================================================================
    -- CHANGE COLOR (event-driven)
    -- ================================================================
    function Kavo:ChangeColor(prop, color)
        if themeList[prop] ~= nil then
            themeList[prop] = color
            refreshTheme()
        end
    end

    -- ================================================================
    -- INFO TIP HELPERS (centralized)
    -- ================================================================
    local function createInfoTip(tipText)
        local moreInfo = Instance.new("TextLabel")
        local corner = Instance.new("UICorner")

        moreInfo.Name = "TipMore"
        moreInfo.Parent = infoContainer
        moreInfo.BackgroundColor3 = Utility:Darken(themeList.SchemeColor, 14)
        moreInfo.Position = UDim2.new(0, 0, 2, 0)
        moreInfo.Size = UDim2.new(0, 353, 0, 33)
        moreInfo.ZIndex = 9
        moreInfo.Font = Enum.Font.GothamSemibold
        moreInfo.Text = "  " .. tipText
        moreInfo.RichText = true
        moreInfo.TextColor3 = themeList.TextColor
        moreInfo.TextSize = 14
        moreInfo.TextXAlignment = Enum.TextXAlignment.Left

        corner.CornerRadius = CORNER_RADIUS_ELEMENT
        corner.Parent = moreInfo

        bindToTheme(moreInfo, "BackgroundColor3", function()
            return Utility:Darken(themeList.SchemeColor, 14)
        end)
        bindToTheme(moreInfo, "TextColor3", function() return themeList.TextColor end)

        return moreInfo
    end

    -- ================================================================
    -- TAB SYSTEM
    -- ================================================================
    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"

        local tabButton  = Instance.new("TextButton")
        local tabCorner  = Instance.new("UICorner")
        local page       = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")
        local pagePadding = Instance.new("UIPadding")

        -- Badge
        local badge       = Instance.new("TextLabel")
        local badgeCorner = Instance.new("UICorner")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize
            TweenService:Create(page, tweeninfo(0.15, Enum.EasingStyle.Linear), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y + 8)
            }):Play()
        end

        -- ---- Page (ScrollingFrame) ----
        page.Name = tabName .. "_Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, 0, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 3
        page.Visible = false
        page.ScrollBarImageColor3 = Utility:Darken(themeList.SchemeColor, 16)
        page.ScrollBarImageTransparency = 0.3

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        pagePadding.Parent = page
        pagePadding.PaddingTop = UDim.new(0, 4)
        pagePadding.PaddingLeft = UDim.new(0, 2)

        bindToTheme(page, "BackgroundColor3", function() return themeList.Background end)
        bindToTheme(page, "ScrollBarImageColor3", function() return Utility:Darken(themeList.SchemeColor, 16) end)

        -- ---- Tab Button ----
        tabButton.Name = tabName .. "_TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 13
        tabButton.BackgroundTransparency = 1

        tabCorner.CornerRadius = CORNER_RADIUS_ELEMENT
        tabCorner.Parent = tabButton

        bindToTheme(tabButton, "TextColor3", function() return themeList.TextColor end)
        bindToTheme(tabButton, "BackgroundColor3", function() return themeList.SchemeColor end)

        -- ---- Badge ----
        badge.Name = "Badge"
        badge.Parent = tabButton
        badge.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        badge.Size = UDim2.new(0, 18, 0, 18)
        badge.Position = UDim2.new(1, -22, 0.5, -9)
        badge.Font = Enum.Font.GothamSemibold
        badge.Text = ""
        badge.TextColor3 = Color3.fromRGB(255, 255, 255)
        badge.TextSize = 10
        badge.Visible = false
        badge.ZIndex = 5

        badgeCorner.CornerRadius = UDim.new(1, 0)
        badgeCorner.Parent = badge

        -- ---- First tab auto-select ----
        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        end

        -- ---- Tab Click Handler ----
        UpdateSize()
        page.ChildAdded:Connect(UpdateSize)
        page.ChildRemoved:Connect(UpdateSize)

        tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for _, v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true

            for _, v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:SmoothTween(v, { BackgroundTransparency = 1 }, TWEEN_SPEED_FAST)
                end
            end
            Utility:SmoothTween(tabButton, { BackgroundTransparency = 0 }, TWEEN_SPEED_FAST)
        end)

        -- ---- Section System ----
        local Sections = {}
        local focusing = false
        local viewDe   = false

        -- Helper: dismiss any active info tooltip
        local function dismissFocus()
            for _, v in next, infoContainer:GetChildren() do
                Utility:SmoothTween(v, { Position = UDim2.new(0, 0, 2, 0) }, TWEEN_SPEED_NORMAL)
            end
            focusing = false
            Utility:SmoothTween(blurFrame, { BackgroundTransparency = 1 }, TWEEN_SPEED_NORMAL)
        end

        -- Helper: show an info tooltip
        local function showInfoTip(moreInfo, targetElement)
            if viewDe then return end
            viewDe = true
            focusing = true
            for _, v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:SmoothTween(v, { Position = UDim2.new(0, 0, 2, 0) }, TWEEN_SPEED_NORMAL)
                end
            end
            Utility:SmoothTween(moreInfo, { Position = UDim2.new(0, 0, 0, 0) }, TWEEN_SPEED_NORMAL)
            Utility:SmoothTween(blurFrame, { BackgroundTransparency = 0.5 }, TWEEN_SPEED_NORMAL)
            if targetElement then
                Utility:SmoothTween(targetElement, { BackgroundColor3 = themeList.ElementColor }, TWEEN_SPEED_NORMAL)
            end
            task.wait(1.5)
            focusing = false
            Utility:SmoothTween(moreInfo, { Position = UDim2.new(0, 0, 2, 0) }, TWEEN_SPEED_NORMAL)
            Utility:SmoothTween(blurFrame, { BackgroundTransparency = 1 }, TWEEN_SPEED_NORMAL)
            task.wait(0.1)
            viewDe = false
        end

        -- Helper: setup hover effect on an element
        local function setupHover(element)
            local hovering = false
            element.MouseEnter:Connect(function()
                if not focusing then
                    TweenService:Create(element, tweeninfo(TWEEN_SPEED_FAST, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = Utility:Lighten(themeList.ElementColor, 12)
                    }):Play()
                    hovering = true
                end
            end)
            element.MouseLeave:Connect(function()
                if not focusing then
                    TweenService:Create(element, tweeninfo(TWEEN_SPEED_FAST, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = themeList.ElementColor
                    }):Play()
                    hovering = false
                end
            end)
            return function() return hovering end
        end

        -- Helper: create the standard viewInfo button
        local function createViewInfoButton(parent)
            local viewInfo = Instance.new("ImageButton")
            viewInfo.Name = "viewInfo"
            viewInfo.Parent = parent
            viewInfo.BackgroundTransparency = 1
            viewInfo.LayoutOrder = 9
            viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
            viewInfo.Size = UDim2.new(0, 23, 0, 23)
            viewInfo.ZIndex = 2
            viewInfo.Image = "rbxassetid://3926305904"
            viewInfo.ImageColor3 = themeList.SchemeColor
            viewInfo.ImageRectOffset = Vector2.new(764, 764)
            viewInfo.ImageRectSize = Vector2.new(36, 36)
            bindToTheme(viewInfo, "ImageColor3", function() return themeList.SchemeColor end)
            return viewInfo
        end

        -- Badge method
        function Sections:SetBadge(count)
            if count and count > 0 then
                badge.Visible = true
                badge.Text = tostring(count)
            else
                badge.Visible = false
            end
        end

        -- ============================================================
        -- SECTION CREATION
        -- ============================================================
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            hidden = hidden or false

            local sectionFrame    = Instance.new("Frame")
            local sectionLayout   = Instance.new("UIListLayout")
            local sectionHead     = Instance.new("Frame")
            local sHeadCorner     = Instance.new("UICorner")
            local sectionName     = Instance.new("TextLabel")
            local sectionInners   = Instance.new("Frame")
            local sectionElLayout = Instance.new("UIListLayout")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0

            sectionLayout.Name = "sectionLayout"
            sectionLayout.Parent = sectionFrame
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 5)

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
            sectionHead.Visible = not hidden

            sHeadCorner.CornerRadius = CORNER_RADIUS_SECTION
            sHeadCorner.Parent = sectionHead

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.02, 0, 0, 0)
            sectionName.Size = UDim2.new(0.98, 0, 1, 0)
            sectionName.Font = Enum.Font.GothamSemibold
            sectionName.Text = secName
            sectionName.RichText = true
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 14
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1

            sectionElLayout.Name = "sectionElLayout"
            sectionElLayout.Parent = sectionInners
            sectionElLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElLayout.Padding = UDim.new(0, 3)

            bindToTheme(sectionFrame, "BackgroundColor3", function() return themeList.Background end)
            bindToTheme(sectionHead, "BackgroundColor3", function() return themeList.SchemeColor end)
            bindToTheme(sectionName, "TextColor3", function() return themeList.TextColor end)

            local function updateSectionFrame()
                local innerSc = sectionElLayout.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionLayout.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(0, ELEMENT_WIDTH, 0, frameSc.Y)
            end

            updateSectionFrame()
            UpdateSize()

            -- ========================================================
            -- ELEMENTS
            -- ========================================================
            local Elements = {}

            -- Update Section Name
            function Elements:UpdateSection(newName)
                sectionName.Text = newName
            end

            -- --------------------------------------------------------
            -- BUTTON
            -- --------------------------------------------------------
            function Elements:NewButton(bname, tipINf, callback)
                local ButtonFunction = {}
                tipINf = tipINf or "Button info"
                bname = bname or "Button"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local btnCorner     = Instance.new("UICorner")
                local btnInfo       = Instance.new("TextLabel")
                local touch         = Instance.new("ImageLabel")

                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.SourceSans
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                buttonElement.TextSize = 14

                btnCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                btnCorner.Parent = buttonElement

                touch.Name = "touch"
                touch.Parent = buttonElement
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(84, 204)
                touch.ImageRectSize = Vector2.new(36, 36)

                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1
                btnInfo.Position = UDim2.new(0.097, 0, 0.273, 0)
                btnInfo.Size = UDim2.new(0, 314, 0, 14)
                btnInfo.Font = Enum.Font.GothamSemibold
                btnInfo.Text = bname
                btnInfo.RichText = true
                btnInfo.TextColor3 = themeList.TextColor
                btnInfo.TextSize = 14
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left

                local viewInfo = createViewInfoButton(buttonElement)
                local moreInfo = createInfoTip(tipINf)

                bindToTheme(buttonElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(touch, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(btnInfo, "TextColor3", function() return themeList.TextColor end)

                updateSectionFrame()
                UpdateSize()

                local isHovering = setupHover(buttonElement)

                buttonElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        callback()
                        task.spawn(function()
                            Utility:Ripple(buttonElement, themeList.SchemeColor)
                        end)
                    else
                        dismissFocus()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, buttonElement)
                end)

                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
                end
                return ButtonFunction
            end

            -- --------------------------------------------------------
            -- TEXTBOX
            -- --------------------------------------------------------
            function Elements:NewTextBox(tname, tTip, callback)
                tname = tname or "Textbox"
                tTip = tTip or "Gets a value of Textbox"
                callback = callback or function() end

                local textboxElement = Instance.new("TextButton")
                local tbCorner       = Instance.new("UICorner")
                local write          = Instance.new("ImageLabel")
                local TextBox        = Instance.new("TextBox")
                local tbCorner2      = Instance.new("UICorner")
                local togName        = Instance.new("TextLabel")

                textboxElement.Name = "textboxElement"
                textboxElement.Parent = sectionInners
                textboxElement.BackgroundColor3 = themeList.ElementColor
                textboxElement.ClipsDescendants = true
                textboxElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                textboxElement.AutoButtonColor = false
                textboxElement.Font = Enum.Font.SourceSans
                textboxElement.Text = ""
                textboxElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                textboxElement.TextSize = 14

                tbCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                tbCorner.Parent = textboxElement

                write.Name = "write"
                write.Parent = textboxElement
                write.BackgroundTransparency = 1
                write.Position = UDim2.new(0.02, 0, 0.18, 0)
                write.Size = UDim2.new(0, 21, 0, 21)
                write.Image = "rbxassetid://3926305904"
                write.ImageColor3 = themeList.SchemeColor
                write.ImageRectOffset = Vector2.new(324, 604)
                write.ImageRectSize = Vector2.new(36, 36)

                TextBox.Parent = textboxElement
                TextBox.BackgroundColor3 = Utility:Darken(themeList.ElementColor, 6)
                TextBox.BorderSizePixel = 0
                TextBox.ClipsDescendants = true
                TextBox.Position = UDim2.new(0.489, 0, 0.212, 0)
                TextBox.Size = UDim2.new(0, 150, 0, 18)
                TextBox.ZIndex = 99
                TextBox.ClearTextOnFocus = false
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderColor3 = Utility:Darken(themeList.SchemeColor, 26)
                TextBox.PlaceholderText = "Type here!"
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.SchemeColor
                TextBox.TextSize = 12

                tbCorner2.CornerRadius = CORNER_RADIUS_ELEMENT
                tbCorner2.Parent = TextBox

                togName.Name = "togName"
                togName.Parent = textboxElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.097, 0, 0.273, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                local viewInfo = createViewInfoButton(textboxElement)
                local moreInfo = createInfoTip(tTip)

                bindToTheme(textboxElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(write, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(togName, "TextColor3", function() return themeList.TextColor end)
                bindToTheme(TextBox, "BackgroundColor3", function() return Utility:Darken(themeList.ElementColor, 6) end)
                bindToTheme(TextBox, "TextColor3", function() return themeList.SchemeColor end)
                bindToTheme(TextBox, "PlaceholderColor3", function() return Utility:Darken(themeList.SchemeColor, 26) end)

                updateSectionFrame()
                UpdateSize()

                setupHover(textboxElement)

                textboxElement.MouseButton1Click:Connect(function()
                    if focusing then dismissFocus() end
                end)

                TextBox.FocusLost:Connect(function(enterPressed)
                    if focusing then dismissFocus() end
                    if enterPressed then
                        callback(TextBox.Text)
                        task.wait(0.18)
                        TextBox.Text = ""
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, textboxElement)
                end)
            end

            -- --------------------------------------------------------
            -- TOGGLE (Modern Slide-Switch)
            -- --------------------------------------------------------
            function Elements:NewToggle(tname, nTip, callback)
                local TogFunction = {}
                tname = tname or "Toggle"
                nTip = nTip or "Toggle info"
                callback = callback or function() end
                local toggled = false

                local toggleElement = Instance.new("TextButton")
                local tCorner       = Instance.new("UICorner")
                local togName       = Instance.new("TextLabel")
                local toggleTrack   = Instance.new("Frame")
                local trackCorner   = Instance.new("UICorner")
                local toggleKnob    = Instance.new("Frame")
                local knobCorner    = Instance.new("UICorner")

                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.SourceSans
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleElement.TextSize = 14

                tCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                tCorner.Parent = toggleElement

                -- Toggle Track (pill shape)
                toggleTrack.Name = "ToggleTrack"
                toggleTrack.Parent = toggleElement
                toggleTrack.BackgroundColor3 = Utility:Lighten(themeList.ElementColor, 14)
                toggleTrack.Position = UDim2.new(0, 10, 0.5, -9)
                toggleTrack.Size = UDim2.new(0, 36, 0, 18)
                toggleTrack.BorderSizePixel = 0

                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = toggleTrack

                -- Toggle Knob (circle)
                toggleKnob.Name = "ToggleKnob"
                toggleKnob.Parent = toggleTrack
                toggleKnob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                toggleKnob.Position = UDim2.new(0, 2, 0.5, -7)
                toggleKnob.Size = UDim2.new(0, 14, 0, 14)
                toggleKnob.BorderSizePixel = 0

                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = toggleKnob

                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 54, 0.273, 0)
                togName.Size = UDim2.new(0, 260, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                local viewInfo = createViewInfoButton(toggleElement)
                local moreInfo = createInfoTip(nTip)

                bindToTheme(toggleElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(togName, "TextColor3", function() return themeList.TextColor end)

                updateSectionFrame()
                UpdateSize()

                setupHover(toggleElement)

                local function animateToggle(state)
                    if state then
                        Utility:SmoothTween(toggleKnob, { Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, TWEEN_SPEED_NORMAL)
                        Utility:SmoothTween(toggleTrack, { BackgroundColor3 = themeList.SchemeColor }, TWEEN_SPEED_NORMAL)
                    else
                        Utility:SmoothTween(toggleKnob, { Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(180, 180, 180) }, TWEEN_SPEED_NORMAL)
                        Utility:SmoothTween(toggleTrack, { BackgroundColor3 = Utility:Lighten(themeList.ElementColor, 14) }, TWEEN_SPEED_NORMAL)
                    end
                end

                toggleElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        toggled = not toggled
                        animateToggle(toggled)
                        task.spawn(function()
                            Utility:Ripple(toggleElement, themeList.SchemeColor)
                        end)
                        pcall(callback, toggled)
                    else
                        dismissFocus()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, toggleElement)
                end)

                function TogFunction:UpdateToggle(newText, isTogOn)
                    if newText ~= nil then
                        togName.Text = newText
                    end
                    if isTogOn ~= nil then
                        toggled = isTogOn
                        animateToggle(toggled)
                        pcall(callback, toggled)
                    end
                end
                return TogFunction
            end

            -- --------------------------------------------------------
            -- SLIDER
            -- --------------------------------------------------------
            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
                slidInf = slidInf or "Slider"
                slidTip = slidTip or "Slider tip"
                maxvalue = maxvalue or 100
                minvalue = minvalue or 0
                callback = callback or function() end

                local sliderElement = Instance.new("TextButton")
                local sCorner       = Instance.new("UICorner")
                local togName       = Instance.new("TextLabel")
                local sliderBtn     = Instance.new("TextButton")
                local sBtnCorner    = Instance.new("UICorner")
                local sliderDrag    = Instance.new("Frame")
                local sDragCorner   = Instance.new("UICorner")
                local write         = Instance.new("ImageLabel")
                local val           = Instance.new("TextLabel")

                sliderElement.Name = "sliderElement"
                sliderElement.Parent = sectionInners
                sliderElement.BackgroundColor3 = themeList.ElementColor
                sliderElement.ClipsDescendants = true
                sliderElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                sliderElement.AutoButtonColor = false
                sliderElement.Font = Enum.Font.SourceSans
                sliderElement.Text = ""
                sliderElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderElement.TextSize = 14

                sCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                sCorner.Parent = sliderElement

                write.Name = "write"
                write.Parent = sliderElement
                write.BackgroundTransparency = 1
                write.Position = UDim2.new(0.02, 0, 0.18, 0)
                write.Size = UDim2.new(0, 21, 0, 21)
                write.Image = "rbxassetid://3926307971"
                write.ImageColor3 = themeList.SchemeColor
                write.ImageRectOffset = Vector2.new(404, 164)
                write.ImageRectSize = Vector2.new(36, 36)

                togName.Name = "togName"
                togName.Parent = sliderElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.097, 0, 0.273, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = slidInf
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                val.Name = "val"
                val.Parent = sliderElement
                val.BackgroundTransparency = 1
                val.Position = UDim2.new(0.352, 0, 0.273, 0)
                val.Size = UDim2.new(0, 41, 0, 14)
                val.Font = Enum.Font.GothamSemibold
                val.Text = tostring(minvalue)
                val.TextColor3 = themeList.SchemeColor
                val.TextSize = 14
                val.TextXAlignment = Enum.TextXAlignment.Right

                sliderBtn.Name = "sliderBtn"
                sliderBtn.Parent = sliderElement
                sliderBtn.BackgroundColor3 = Utility:Lighten(themeList.ElementColor, 5)
                sliderBtn.BorderSizePixel = 0
                sliderBtn.Position = UDim2.new(0.489, 0, 0.394, 0)
                sliderBtn.Size = UDim2.new(0, 149, 0, 6)
                sliderBtn.AutoButtonColor = false
                sliderBtn.Font = Enum.Font.SourceSans
                sliderBtn.Text = ""
                sliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderBtn.TextSize = 14

                sBtnCorner.Parent = sliderBtn

                sliderDrag.Name = "sliderDrag"
                sliderDrag.Parent = sliderBtn
                sliderDrag.BackgroundColor3 = themeList.SchemeColor
                sliderDrag.BorderSizePixel = 0
                sliderDrag.Size = UDim2.new(0, 0, 1, 0)

                sDragCorner.Parent = sliderDrag

                local viewInfo = createViewInfoButton(sliderElement)
                local moreInfo = createInfoTip(slidTip)

                bindToTheme(sliderElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(write, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(togName, "TextColor3", function() return themeList.TextColor end)
                bindToTheme(val, "TextColor3", function() return themeList.SchemeColor end)
                bindToTheme(sliderBtn, "BackgroundColor3", function() return Utility:Lighten(themeList.ElementColor, 5) end)
                bindToTheme(sliderDrag, "BackgroundColor3", function() return themeList.SchemeColor end)

                updateSectionFrame()
                UpdateSize()

                setupHover(sliderElement)

                local mouse = Mouse
                local Value

                sliderBtn.MouseButton1Down:Connect(function()
                    if not focusing then
                        Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 149) * sliderDrag.AbsoluteSize.X) + tonumber(minvalue)) or 0
                        pcall(callback, Value)
                        sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)

                        local moveConn, releaseConn
                        moveConn = mouse.Move:Connect(function()
                            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 149) * sliderDrag.AbsoluteSize.X) + tonumber(minvalue))
                            val.Text = tostring(Value)
                            pcall(callback, Value)
                            sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)
                        end)

                        releaseConn = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 149) * sliderDrag.AbsoluteSize.X) + tonumber(minvalue))
                                pcall(callback, Value)
                                val.Text = tostring(Value)
                                sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)
                                if moveConn then moveConn:Disconnect() end
                                if releaseConn then releaseConn:Disconnect() end
                            end
                        end)
                    else
                        dismissFocus()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, sliderElement)
                end)
            end

            -- --------------------------------------------------------
            -- DROPDOWN
            -- --------------------------------------------------------
            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local DropFunction = {}
                dropname = dropname or "Dropdown"
                list = list or {}
                dropinf = dropinf or "Dropdown info"
                callback = callback or function() end

                local opened = false

                local dropFrame     = Instance.new("Frame")
                local dropOpen      = Instance.new("TextButton")
                local listImg       = Instance.new("ImageLabel")
                local itemTextbox   = Instance.new("TextLabel")
                local dCorner       = Instance.new("UICorner")
                local dropListLayout = Instance.new("UIListLayout")

                dropFrame.Name = "dropFrame"
                dropFrame.Parent = sectionInners
                dropFrame.BackgroundColor3 = themeList.Background
                dropFrame.BorderSizePixel = 0
                dropFrame.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                dropFrame.ClipsDescendants = true

                dropOpen.Name = "dropOpen"
                dropOpen.Parent = dropFrame
                dropOpen.BackgroundColor3 = themeList.ElementColor
                dropOpen.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                dropOpen.AutoButtonColor = false
                dropOpen.Font = Enum.Font.SourceSans
                dropOpen.Text = ""
                dropOpen.TextColor3 = Color3.fromRGB(0, 0, 0)
                dropOpen.TextSize = 14
                dropOpen.ClipsDescendants = true

                dCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                dCorner.Parent = dropOpen

                listImg.Name = "listImg"
                listImg.Parent = dropOpen
                listImg.BackgroundTransparency = 1
                listImg.Position = UDim2.new(0.02, 0, 0.18, 0)
                listImg.Size = UDim2.new(0, 21, 0, 21)
                listImg.Image = "rbxassetid://3926305904"
                listImg.ImageColor3 = themeList.SchemeColor
                listImg.ImageRectOffset = Vector2.new(644, 364)
                listImg.ImageRectSize = Vector2.new(36, 36)

                itemTextbox.Name = "itemTextbox"
                itemTextbox.Parent = dropOpen
                itemTextbox.BackgroundTransparency = 1
                itemTextbox.Position = UDim2.new(0.097, 0, 0.273, 0)
                itemTextbox.Size = UDim2.new(0, 138, 0, 14)
                itemTextbox.Font = Enum.Font.GothamSemibold
                itemTextbox.Text = dropname
                itemTextbox.RichText = true
                itemTextbox.TextColor3 = themeList.TextColor
                itemTextbox.TextSize = 14
                itemTextbox.TextXAlignment = Enum.TextXAlignment.Left

                local viewInfo = createViewInfoButton(dropOpen)
                local moreInfo = createInfoTip(dropinf)

                dropListLayout.Parent = dropFrame
                dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropListLayout.Padding = UDim.new(0, 3)

                bindToTheme(dropFrame, "BackgroundColor3", function() return themeList.Background end)
                bindToTheme(dropOpen, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(listImg, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(itemTextbox, "TextColor3", function() return themeList.TextColor end)

                updateSectionFrame()
                UpdateSize()

                setupHover(dropOpen)

                -- Create option buttons
                local function createOption(optionText)
                    local optionSelect = Instance.new("TextButton")
                    local oCorner      = Instance.new("UICorner")

                    optionSelect.Name = "optionSelect"
                    optionSelect.Parent = dropFrame
                    optionSelect.BackgroundColor3 = themeList.ElementColor
                    optionSelect.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                    optionSelect.AutoButtonColor = false
                    optionSelect.Font = Enum.Font.GothamSemibold
                    optionSelect.Text = "  " .. optionText
                    optionSelect.TextColor3 = Utility:Darken(themeList.TextColor, 6)
                    optionSelect.TextSize = 14
                    optionSelect.TextXAlignment = Enum.TextXAlignment.Left
                    optionSelect.ClipsDescendants = true

                    oCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                    oCorner.Parent = optionSelect

                    bindToTheme(optionSelect, "BackgroundColor3", function() return themeList.ElementColor end)
                    bindToTheme(optionSelect, "TextColor3", function() return Utility:Darken(themeList.TextColor, 6) end)

                    setupHover(optionSelect)

                    optionSelect.MouseButton1Click:Connect(function()
                        if not focusing then
                            opened = false
                            callback(optionText)
                            itemTextbox.Text = optionText
                            dropFrame:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT), "InOut", "Linear", 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            task.spawn(function()
                                Utility:Ripple(optionSelect, themeList.SchemeColor)
                            end)
                        else
                            dismissFocus()
                        end
                    end)
                end

                -- Populate initial options
                for _, v in next, list do
                    createOption(v)
                end

                -- Open/Close dropdown
                dropOpen.MouseButton1Click:Connect(function()
                    if not focusing then
                        if opened then
                            opened = false
                            dropFrame:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT), "InOut", "Linear", 0.08)
                        else
                            opened = true
                            dropFrame:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, dropListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.08, true)
                        end
                        task.wait(0.1)
                        updateSectionFrame()
                        UpdateSize()
                        task.spawn(function()
                            Utility:Ripple(dropOpen, themeList.SchemeColor)
                        end)
                    else
                        dismissFocus()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, dropOpen)
                end)

                function DropFunction:Refresh(newList)
                    newList = newList or {}
                    for _, v in next, dropFrame:GetChildren() do
                        if v.Name == "optionSelect" then
                            v:Destroy()
                        end
                    end
                    for _, v in next, newList do
                        createOption(v)
                    end
                    if opened then
                        dropFrame:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, dropListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.08, true)
                    else
                        dropFrame:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT), "InOut", "Linear", 0.08)
                    end
                    task.wait(0.1)
                    updateSectionFrame()
                    UpdateSize()
                end
                return DropFunction
            end

            -- --------------------------------------------------------
            -- KEYBIND
            -- --------------------------------------------------------
            function Elements:NewKeybind(keytext, keyinf, firstKey, callback)
                keytext = keytext or "Keybind"
                keyinf = keyinf or "Keybind info"
                callback = callback or function() end
                local oldKey = firstKey.Name

                local keybindElement = Instance.new("TextButton")
                local kCorner        = Instance.new("UICorner")
                local togName        = Instance.new("TextLabel")
                local touch          = Instance.new("ImageLabel")
                local keyDisplay     = Instance.new("TextLabel")

                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.SourceSans
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybindElement.TextSize = 14

                kCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                kCorner.Parent = keybindElement

                touch.Name = "touch"
                touch.Parent = keybindElement
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(364, 284)
                touch.ImageRectSize = Vector2.new(36, 36)

                togName.Name = "togName"
                togName.Parent = keybindElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.097, 0, 0.273, 0)
                togName.Size = UDim2.new(0, 222, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = keytext
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                keyDisplay.Name = "keyDisplay"
                keyDisplay.Parent = keybindElement
                keyDisplay.BackgroundTransparency = 1
                keyDisplay.Position = UDim2.new(0.727, 0, 0.273, 0)
                keyDisplay.Size = UDim2.new(0, 70, 0, 14)
                keyDisplay.Font = Enum.Font.GothamSemibold
                keyDisplay.Text = oldKey
                keyDisplay.TextColor3 = themeList.SchemeColor
                keyDisplay.TextSize = 14
                keyDisplay.TextXAlignment = Enum.TextXAlignment.Right

                local viewInfo = createViewInfoButton(keybindElement)
                local moreInfo = createInfoTip(keyinf)

                bindToTheme(keybindElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(touch, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(togName, "TextColor3", function() return themeList.TextColor end)
                bindToTheme(keyDisplay, "TextColor3", function() return themeList.SchemeColor end)

                updateSectionFrame()
                UpdateSize()

                setupHover(keybindElement)

                -- Click to rebind
                keybindElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        keyDisplay.Text = ". . ."
                        local a = UserInputService.InputBegan:Wait()
                        if a.KeyCode.Name ~= "Unknown" then
                            keyDisplay.Text = a.KeyCode.Name
                            oldKey = a.KeyCode.Name
                        end
                        task.spawn(function()
                            Utility:Ripple(keybindElement, themeList.SchemeColor)
                        end)
                    else
                        dismissFocus()
                    end
                end)

                -- Key press listener
                UserInputService.InputBegan:Connect(function(current, processed)
                    if not processed then
                        if current.KeyCode.Name == oldKey then
                            callback()
                        end
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, keybindElement)
                end)
            end

            -- --------------------------------------------------------
            -- COLOR PICKER
            -- --------------------------------------------------------
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                colText = colText or "ColorPicker"
                colInf = colInf or "Pick a color"
                callback = callback or function() end
                defcolor = defcolor or Color3.fromRGB(255, 255, 255)

                local h, s, v = Color3.toHSV(defcolor)
                local colorOpened = false

                local colorElement  = Instance.new("TextButton")
                local cCorner       = Instance.new("UICorner")
                local colorHeader   = Instance.new("Frame")
                local cHCorner      = Instance.new("UICorner")
                local touch         = Instance.new("ImageLabel")
                local togName       = Instance.new("TextLabel")
                local colorCurrent  = Instance.new("Frame")
                local cCurCorner    = Instance.new("UICorner")
                local cListLayout   = Instance.new("UIListLayout")
                local colorInners   = Instance.new("Frame")
                local cICorner      = Instance.new("UICorner")
                local rgbImage      = Instance.new("ImageButton")
                local rgbCorner     = Instance.new("UICorner")
                local rbgcircle     = Instance.new("ImageLabel")
                local darknessImg   = Instance.new("ImageButton")
                local drkCorner     = Instance.new("UICorner")
                local darkcircle    = Instance.new("ImageLabel")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled  = Instance.new("ImageLabel")
                local onrainbow     = Instance.new("TextButton")
                local togName_2     = Instance.new("TextLabel")

                colorElement.Name = "colorElement"
                colorElement.Parent = sectionInners
                colorElement.BackgroundColor3 = themeList.ElementColor
                colorElement.BackgroundTransparency = 1
                colorElement.ClipsDescendants = true
                colorElement.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                colorElement.AutoButtonColor = false
                colorElement.Font = Enum.Font.SourceSans
                colorElement.Text = ""
                colorElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                colorElement.TextSize = 14

                cCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                cCorner.Parent = colorElement

                -- Header
                colorHeader.Name = "colorHeader"
                colorHeader.Parent = colorElement
                colorHeader.BackgroundColor3 = themeList.ElementColor
                colorHeader.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                colorHeader.ClipsDescendants = true

                cHCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                cHCorner.Parent = colorHeader

                touch.Name = "touch"
                touch.Parent = colorHeader
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(44, 964)
                touch.ImageRectSize = Vector2.new(36, 36)

                togName.Name = "togName"
                togName.Parent = colorHeader
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.097, 0, 0.273, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = colText
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.RichText = true
                togName.TextXAlignment = Enum.TextXAlignment.Left

                local viewInfo = createViewInfoButton(colorHeader)
                local moreInfo = createInfoTip(colInf)

                colorCurrent.Name = "colorCurrent"
                colorCurrent.Parent = colorHeader
                colorCurrent.BackgroundColor3 = defcolor
                colorCurrent.Position = UDim2.new(0.793, 0, 0.212, 0)
                colorCurrent.Size = UDim2.new(0, 42, 0, 18)

                cCurCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                cCurCorner.Parent = colorCurrent

                cListLayout.Parent = colorElement
                cListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                cListLayout.Padding = UDim.new(0, 3)

                -- Color Inner Panel
                colorInners.Name = "colorInners"
                colorInners.Parent = colorElement
                colorInners.BackgroundColor3 = themeList.ElementColor
                colorInners.Size = UDim2.new(0, ELEMENT_WIDTH, 0, 105)

                cICorner.CornerRadius = CORNER_RADIUS_ELEMENT
                cICorner.Parent = colorInners

                -- RGB Spectrum
                rgbImage.Name = "rgb"
                rgbImage.Parent = colorInners
                rgbImage.BackgroundTransparency = 1
                rgbImage.Position = UDim2.new(0.02, 0, 0.048, 0)
                rgbImage.Size = UDim2.new(0, 211, 0, 93)
                rgbImage.Image = "http://www.roblox.com/asset/?id=6523286724"

                rgbCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                rgbCorner.Parent = rgbImage

                rbgcircle.Name = "rbgcircle"
                rbgcircle.Parent = rgbImage
                rbgcircle.BackgroundTransparency = 1
                rbgcircle.Size = UDim2.new(0, 14, 0, 14)
                rbgcircle.Image = "rbxassetid://3926309567"
                rbgcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                rbgcircle.ImageRectOffset = Vector2.new(628, 420)
                rbgcircle.ImageRectSize = Vector2.new(48, 48)

                -- Darkness Slider
                darknessImg.Name = "darkness"
                darknessImg.Parent = colorInners
                darknessImg.BackgroundTransparency = 1
                darknessImg.Position = UDim2.new(0.636, 0, 0.048, 0)
                darknessImg.Size = UDim2.new(0, 18, 0, 93)
                darknessImg.Image = "http://www.roblox.com/asset/?id=6523291212"

                drkCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                drkCorner.Parent = darknessImg

                darkcircle.Name = "darkcircle"
                darkcircle.Parent = darknessImg
                darkcircle.AnchorPoint = Vector2.new(0.5, 0)
                darkcircle.BackgroundTransparency = 1
                darkcircle.Size = UDim2.new(0, 14, 0, 14)
                darkcircle.Image = "rbxassetid://3926309567"
                darkcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                darkcircle.ImageRectOffset = Vector2.new(628, 420)
                darkcircle.ImageRectSize = Vector2.new(48, 48)

                -- Rainbow Toggle
                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = colorInners
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.705, 0, 0.066, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)

                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = colorInners
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.705, 0, 0.066, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1

                onrainbow.Name = "onrainbow"
                onrainbow.Parent = toggleEnabled
                onrainbow.BackgroundTransparency = 1
                onrainbow.Size = UDim2.new(1, 0, 1, 0)
                onrainbow.Font = Enum.Font.SourceSans
                onrainbow.Text = ""
                onrainbow.TextColor3 = Color3.fromRGB(0, 0, 0)
                onrainbow.TextSize = 14

                togName_2.Name = "rainbowLabel"
                togName_2.Parent = colorInners
                togName_2.BackgroundTransparency = 1
                togName_2.Position = UDim2.new(0.78, 0, 0.1, 0)
                togName_2.Size = UDim2.new(0, 60, 0, 14)
                togName_2.Font = Enum.Font.GothamSemibold
                togName_2.Text = "Rainbow"
                togName_2.TextColor3 = themeList.TextColor
                togName_2.TextSize = 14
                togName_2.TextXAlignment = Enum.TextXAlignment.Left

                bindToTheme(colorElement, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(colorHeader, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(colorInners, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(touch, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(togName, "TextColor3", function() return themeList.TextColor end)
                bindToTheme(viewInfo, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(toggleDisabled, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(toggleEnabled, "ImageColor3", function() return themeList.SchemeColor end)
                bindToTheme(togName_2, "TextColor3", function() return themeList.TextColor end)

                setupHover(colorElement)

                -- Open/Close color picker
                colorElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        if colorOpened then
                            colorOpened = false
                            colorElement:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT), "InOut", "Linear", 0.08)
                        else
                            colorOpened = true
                            colorElement:TweenSize(UDim2.new(0, ELEMENT_WIDTH, 0, 141), "InOut", "Linear", 0.08, true)
                        end
                        task.wait(0.1)
                        updateSectionFrame()
                        UpdateSize()
                        task.spawn(function()
                            Utility:Ripple(colorHeader, themeList.SchemeColor)
                        end)
                    else
                        dismissFocus()
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    showInfoTip(moreInfo, colorElement)
                end)

                updateSectionFrame()
                UpdateSize()

                -- Color picker logic
                local colorpickerActive = false
                local darknessActive = false
                local color = { 1, 1, 1 }
                local rainbow = false
                local rainbowConnection
                local counter = 0

                local function zigzag(X)
                    return math.acos(math.cos(X * math.pi)) / math.pi
                end

                local function mouseLocation()
                    return LocalPlayer:GetMouse()
                end

                local function cpUpdate()
                    if colorpickerActive then
                        local ml = mouseLocation()
                        local x = ml.X - rgbImage.AbsolutePosition.X
                        local y = ml.Y - rgbImage.AbsolutePosition.Y
                        local maxX = rgbImage.AbsoluteSize.X
                        local maxY = rgbImage.AbsoluteSize.Y
                        x = math.clamp(x, 0, maxX) / maxX
                        y = math.clamp(y, 0, maxY) / maxY
                        local cx = rbgcircle.AbsoluteSize.X / 2
                        local cy = rbgcircle.AbsoluteSize.Y / 2
                        rbgcircle.Position = UDim2.new(x, -cx, y, -cy)
                        color = { 1 - x, 1 - y, color[3] }
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                    if darknessActive then
                        local ml = mouseLocation()
                        local y = ml.Y - darknessImg.AbsolutePosition.Y
                        local maxY = darknessImg.AbsoluteSize.Y
                        y = math.clamp(y, 0, maxY) / maxY
                        local cy = darkcircle.AbsoluteSize.Y / 2
                        darkcircle.Position = UDim2.new(0.5, 0, y, -cy)
                        darkcircle.ImageColor3 = Color3.fromHSV(0, 0, y)
                        color = { color[1], color[2], 1 - y }
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                end

                local function setcolor(tbl)
                    local cx = rbgcircle.AbsoluteSize.X / 2
                    local cy = rbgcircle.AbsoluteSize.Y / 2
                    color = { tbl[1], tbl[2], tbl[3] }
                    rbgcircle.Position = UDim2.new(color[1], -cx, color[2] - 1, -cy)
                    darkcircle.Position = UDim2.new(0.5, 0, color[3] - 1, -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                end

                local function setrgbcolor(tbl)
                    local cx = rbgcircle.AbsoluteSize.X / 2
                    local cy = rbgcircle.AbsoluteSize.Y / 2
                    color = { tbl[1], tbl[2], color[3] }
                    rbgcircle.Position = UDim2.new(color[1], -cx, color[2] - 1, -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                    callback(realcolor)
                end

                local function togglerainbow()
                    if rainbow then
                        Utility:SmoothTween(toggleEnabled, { ImageTransparency = 1 }, 0.1)
                        rainbow = false
                        if rainbowConnection then
                            rainbowConnection:Disconnect()
                        end
                    else
                        Utility:SmoothTween(toggleEnabled, { ImageTransparency = 0 }, 0.1)
                        rainbow = true
                        rainbowConnection = RunService.RenderStepped:Connect(function()
                            setrgbcolor({ zigzag(counter), 1, 1 })
                            counter = counter + 0.01
                        end)
                    end
                end

                onrainbow.MouseButton1Click:Connect(togglerainbow)
                Mouse.Move:Connect(cpUpdate)
                rgbImage.MouseButton1Down:Connect(function() colorpickerActive = true end)
                darknessImg.MouseButton1Down:Connect(function() darknessActive = true end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        colorpickerActive = false
                        darknessActive = false
                    end
                end)
                setcolor({ h, s, v })
            end

            -- --------------------------------------------------------
            -- LABEL
            -- --------------------------------------------------------
            function Elements:NewLabel(labelTitle)
                local labelFunctions = {}

                local label    = Instance.new("TextLabel")
                local lCorner  = Instance.new("UICorner")

                label.Name = "label"
                label.Parent = sectionInners
                label.BackgroundColor3 = themeList.SchemeColor
                label.BorderSizePixel = 0
                label.ClipsDescendants = true
                label.Size = UDim2.new(0, ELEMENT_WIDTH, 0, ELEMENT_HEIGHT)
                label.Font = Enum.Font.GothamSemibold
                label.Text = "  " .. labelTitle
                label.RichText = true
                label.TextColor3 = themeList.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left

                lCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                lCorner.Parent = label

                bindToTheme(label, "BackgroundColor3", function() return themeList.SchemeColor end)
                bindToTheme(label, "TextColor3", function() return themeList.TextColor end)

                updateSectionFrame()
                UpdateSize()

                function labelFunctions:UpdateLabel(newText)
                    label.Text = "  " .. newText
                end
                return labelFunctions
            end

            -- --------------------------------------------------------
            -- SEPARATOR (NEW)
            -- --------------------------------------------------------
            function Elements:NewSeparator()
                local sep = Instance.new("Frame")
                sep.Name = "separator"
                sep.Parent = sectionInners
                sep.BackgroundColor3 = Utility:Lighten(themeList.ElementColor, 10)
                sep.BorderSizePixel = 0
                sep.Size = UDim2.new(0, ELEMENT_WIDTH, 0, 1)

                bindToTheme(sep, "BackgroundColor3", function()
                    return Utility:Lighten(themeList.ElementColor, 10)
                end)

                updateSectionFrame()
                UpdateSize()
            end

            -- --------------------------------------------------------
            -- PARAGRAPH (NEW)
            -- --------------------------------------------------------
            function Elements:NewParagraph(pTitle, pContent)
                local paragraphFrame = Instance.new("Frame")
                local pCorner        = Instance.new("UICorner")
                local titleLabel     = Instance.new("TextLabel")
                local contentLabel   = Instance.new("TextLabel")

                paragraphFrame.Name = "paragraphFrame"
                paragraphFrame.Parent = sectionInners
                paragraphFrame.BackgroundColor3 = themeList.ElementColor
                paragraphFrame.BorderSizePixel = 0
                paragraphFrame.Size = UDim2.new(0, ELEMENT_WIDTH, 0, 58)

                pCorner.CornerRadius = CORNER_RADIUS_ELEMENT
                pCorner.Parent = paragraphFrame

                titleLabel.Name = "paragraphTitle"
                titleLabel.Parent = paragraphFrame
                titleLabel.BackgroundTransparency = 1
                titleLabel.Position = UDim2.new(0, 10, 0, 6)
                titleLabel.Size = UDim2.new(1, -20, 0, 16)
                titleLabel.Font = Enum.Font.GothamSemibold
                titleLabel.Text = pTitle or "Paragraph"
                titleLabel.TextColor3 = themeList.TextColor
                titleLabel.TextSize = 14
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left

                contentLabel.Name = "paragraphContent"
                contentLabel.Parent = paragraphFrame
                contentLabel.BackgroundTransparency = 1
                contentLabel.Position = UDim2.new(0, 10, 0, 26)
                contentLabel.Size = UDim2.new(1, -20, 0, 26)
                contentLabel.Font = Enum.Font.Gotham
                contentLabel.Text = pContent or ""
                contentLabel.TextColor3 = Utility:Darken(themeList.TextColor, 40)
                contentLabel.TextSize = 12
                contentLabel.TextXAlignment = Enum.TextXAlignment.Left
                contentLabel.TextWrapped = true
                contentLabel.RichText = true
                contentLabel.TextYAlignment = Enum.TextYAlignment.Top

                bindToTheme(paragraphFrame, "BackgroundColor3", function() return themeList.ElementColor end)
                bindToTheme(titleLabel, "TextColor3", function() return themeList.TextColor end)
                bindToTheme(contentLabel, "TextColor3", function() return Utility:Darken(themeList.TextColor, 40) end)

                updateSectionFrame()
                UpdateSize()
            end

            return Elements
        end
        return Sections
    end
    return Tabs
end

return Kavo
