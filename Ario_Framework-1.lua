-- ARIO COMPACT MOBILE TERMINAL EDITION
--[[
    ARIO FRAMEWORK v4
    Custom key system framework using ARIO Scripts Validator.

    Usage:
        local Ario = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

        Ario.new({
            Title = "Ario",
            Description = "Key System",
            Theme = "Ario",
            Folder = "Ario",

            Intro = true,

            KeySystem = {
                Enabled = true,
                ScriptSlug = "YOUR_SCRIPT_SLUG",
            },

            Callback = function(key)
                -- Optional callback after validation.
            end,
        })

    Validator endpoints are configured below.
]]

local Ario = {}
Ario.__index = Ario
Ario.Name = "Ario"
Ario.Version = "4.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- ARIO VALIDATOR
-- ============================================================

local ArioValidator = {}

ArioValidator.API_ENDPOINT = "https://arioscript.lovable.app/api/public/keys/validate"
ArioValidator.GET_KEY_URL = "https://arioscript.lovable.app/keys"
ArioValidator.SAVE_FILE = "ario_verified_key.txt"
ArioValidator.BASE_RAW_URL = "https://arioscript.lovable.app/raw/"

local function httpRequest(url)
    local fn =
        (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
        or (fluxus and fluxus.request)

    if fn then
        local ok, response = pcall(function()
            return fn({
                Url = url,
                Method = "GET",
            })
        end)

        if ok and response then
            return response.Body or response.body or ""
        end
    end

    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if ok then
        return body
    end

    return nil
end

function ArioValidator.clean(rawKey)
    if not rawKey then
        return ""
    end

    return string.upper(
        tostring(rawKey):gsub('["\'%s\r\n\t]', "")
    )
end

function ArioValidator.verify(rawKey)
    local key = ArioValidator.clean(rawKey)

    if #key < 8 then
        return false, "Key is too short or empty"
    end

    local encodedKey = key:gsub("([^%w%-_%.~])", function(char)
        return string.format("%%%02X", string.byte(char))
    end)

    local url = ArioValidator.API_ENDPOINT .. "?key=" .. encodedKey

    local ok, body = pcall(function()
        return httpRequest(url)
    end)

    if not ok or not body or body == "" then
        return false, "Unable to reach verification server"
    end

    local decodeOk, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if not decodeOk or type(data) ~= "table" then
        return false, "Server returned an invalid response"
    end

    if data.valid == true then
        if writefile then
            pcall(function()
                writefile(ArioValidator.SAVE_FILE, key)
            end)
        end

        if getgenv then
            pcall(function()
                getgenv().SCRIPT_KEY = key
            end)
        end

        return true, data
    end

    return false, data.error or "Key is invalid or expired"
end

function ArioValidator.checkSavedKey()
    if not (isfile and readfile) then
        return false, nil
    end

    local exists = false

    pcall(function()
        exists = isfile(ArioValidator.SAVE_FILE)
    end)

    if not exists then
        return false, nil
    end

    local saved = ""

    pcall(function()
        saved = ArioValidator.clean(
            readfile(ArioValidator.SAVE_FILE)
        )
    end)

    if saved == "" then
        return false, nil
    end

    local valid = ArioValidator.verify(saved)

    if valid then
        return true, saved
    end

    return false, nil
end

function ArioValidator.getKeyLink()
    return ArioValidator.GET_KEY_URL
end

function ArioValidator.copyKeyLink()
    local clip =
        setclipboard
        or toclipboard
        or (Clipboard and Clipboard.set)

    if clip then
        local ok = pcall(function()
            clip(ArioValidator.GET_KEY_URL)
        end)

        return ok
    end

    return false
end

function ArioValidator.openKeyLink()
    local opener =
        (syn and syn.open_url)
        or (http and http.open_url)
        or open_url

    if opener then
        return pcall(function()
            opener(ArioValidator.GET_KEY_URL)
        end)
    end

    return false
end

function ArioValidator.runScript(slugOrUrl)
    local target = tostring(slugOrUrl or "")

    if target == "" then
        return false, "No script slug supplied"
    end

    -- Only allow the configured ARIO raw endpoint.
    if not target:find("^https?://") then
        target = ArioValidator.BASE_RAW_URL .. target
    end

    if not target:find("^" .. ArioValidator.BASE_RAW_URL:gsub("([%.%-])", "%%%1")) then
        return false, "External script URLs are disabled"
    end

    local ok, source = pcall(function()
        return httpRequest(target)
    end)

    if not ok or not source or source == "" then
        warn("[ARIO] Failed to fetch script:", target)
        return false, "Failed to fetch target script"
    end

    local fn, err = loadstring(source)

    if not fn then
        warn("[ARIO] Script load error:", err)
        return false, err
    end

    task.spawn(function()
        local ran, runtimeError = pcall(fn)

        if not ran then
            warn("[ARIO] Target script error:", runtimeError)
        end
    end)

    return true
end

Ario.Validator = ArioValidator

-- ============================================================
-- THEMES
-- ============================================================

Ario.Themes = {
    Ario = {
        A=Color3.fromRGB(55,120,255), A2=Color3.fromRGB(105,170,255),
        BG=Color3.fromRGB(7,10,17), C=Color3.fromRGB(15,20,31),
        C2=Color3.fromRGB(23,30,45), I=Color3.fromRGB(18,25,39),
        S=Color3.fromRGB(50,66,96), T=Color3.fromRGB(245,248,255),
        M=Color3.fromRGB(145,157,181), OK=Color3.fromRGB(65,220,135),
        W=Color3.fromRGB(255,190,70), E=Color3.fromRGB(255,82,105)
    },

    Midnight = {
        A=Color3.fromRGB(126,92,255), A2=Color3.fromRGB(190,155,255),
        BG=Color3.fromRGB(7,6,14), C=Color3.fromRGB(17,14,29),
        C2=Color3.fromRGB(28,23,45), I=Color3.fromRGB(24,20,40),
        S=Color3.fromRGB(69,57,104), T=Color3.fromRGB(248,246,255),
        M=Color3.fromRGB(163,155,188), OK=Color3.fromRGB(80,225,145),
        W=Color3.fromRGB(255,190,75), E=Color3.fromRGB(255,88,120)
    },

    Cyan = {
        A=Color3.fromRGB(0,205,255), A2=Color3.fromRGB(100,240,255),
        BG=Color3.fromRGB(5,13,18), C=Color3.fromRGB(10,24,31),
        C2=Color3.fromRGB(15,36,46), I=Color3.fromRGB(13,32,41),
        S=Color3.fromRGB(33,91,108), T=Color3.fromRGB(240,252,255),
        M=Color3.fromRGB(137,178,190), OK=Color3.fromRGB(75,230,155),
        W=Color3.fromRGB(255,195,80), E=Color3.fromRGB(255,85,110)
    },

    Ruby = {
        A=Color3.fromRGB(255,58,92), A2=Color3.fromRGB(255,125,145),
        BG=Color3.fromRGB(16,7,10), C=Color3.fromRGB(28,13,18),
        C2=Color3.fromRGB(42,19,27), I=Color3.fromRGB(38,17,24),
        S=Color3.fromRGB(91,38,53), T=Color3.fromRGB(255,244,247),
        M=Color3.fromRGB(190,145,155), OK=Color3.fromRGB(75,225,145),
        W=Color3.fromRGB(255,190,70), E=Color3.fromRGB(255,65,90)
    },

    Emerald = {
        A=Color3.fromRGB(45,220,135), A2=Color3.fromRGB(105,255,180),
        BG=Color3.fromRGB(5,15,11), C=Color3.fromRGB(10,27,20),
        C2=Color3.fromRGB(16,40,30), I=Color3.fromRGB(14,37,27),
        S=Color3.fromRGB(34,92,65), T=Color3.fromRGB(239,255,247),
        M=Color3.fromRGB(137,181,158), OK=Color3.fromRGB(55,235,145),
        W=Color3.fromRGB(255,195,75), E=Color3.fromRGB(255,82,105)
    },

    Orange = {
        A=Color3.fromRGB(255,135,45), A2=Color3.fromRGB(255,190,100),
        BG=Color3.fromRGB(17,10,5), C=Color3.fromRGB(30,18,9),
        C2=Color3.fromRGB(45,26,13), I=Color3.fromRGB(42,25,12),
        S=Color3.fromRGB(96,53,24), T=Color3.fromRGB(255,248,238),
        M=Color3.fromRGB(190,157,125), OK=Color3.fromRGB(70,225,140),
        W=Color3.fromRGB(255,190,60), E=Color3.fromRGB(255,80,95)
    },

    Rose = {
        A=Color3.fromRGB(255,85,175), A2=Color3.fromRGB(255,145,210),
        BG=Color3.fromRGB(16,7,14), C=Color3.fromRGB(29,12,25),
        C2=Color3.fromRGB(43,18,37), I=Color3.fromRGB(41,17,35),
        S=Color3.fromRGB(99,39,82), T=Color3.fromRGB(255,244,252),
        M=Color3.fromRGB(190,145,175), OK=Color3.fromRGB(70,225,145),
        W=Color3.fromRGB(255,190,75), E=Color3.fromRGB(255,80,115)
    },

    Mono = {
        A=Color3.fromRGB(235,235,240), A2=Color3.fromRGB(255,255,255),
        BG=Color3.fromRGB(8,8,10), C=Color3.fromRGB(17,17,20),
        C2=Color3.fromRGB(29,29,34), I=Color3.fromRGB(24,24,28),
        S=Color3.fromRGB(62,62,70), T=Color3.fromRGB(248,248,250),
        M=Color3.fromRGB(150,150,158), OK=Color3.fromRGB(130,235,165),
        W=Color3.fromRGB(240,195,95), E=Color3.fromRGB(255,105,120)
    },

    Neon = {
        A=Color3.fromRGB(125,255,0), A2=Color3.fromRGB(210,255,120),
        BG=Color3.fromRGB(5,10,4), C=Color3.fromRGB(12,23,8),
        C2=Color3.fromRGB(20,39,13), I=Color3.fromRGB(17,32,11),
        S=Color3.fromRGB(48,91,26), T=Color3.fromRGB(245,255,235),
        M=Color3.fromRGB(150,180,125), OK=Color3.fromRGB(125,255,80),
        W=Color3.fromRGB(255,210,75), E=Color3.fromRGB(255,80,90)
    },

    DeepSea = {
        A=Color3.fromRGB(40,125,255), A2=Color3.fromRGB(90,210,255),
        BG=Color3.fromRGB(3,10,17), C=Color3.fromRGB(7,19,30),
        C2=Color3.fromRGB(10,29,45), I=Color3.fromRGB(9,27,42),
        S=Color3.fromRGB(22,67,96), T=Color3.fromRGB(237,249,255),
        M=Color3.fromRGB(125,165,188), OK=Color3.fromRGB(60,225,155),
        W=Color3.fromRGB(255,195,75), E=Color3.fromRGB(255,85,105)
    },

    Sunset = {
        A=Color3.fromRGB(255,90,70), A2=Color3.fromRGB(255,175,75),
        BG=Color3.fromRGB(17,8,8), C=Color3.fromRGB(30,14,12),
        C2=Color3.fromRGB(44,21,17), I=Color3.fromRGB(42,19,15),
        S=Color3.fromRGB(100,43,31), T=Color3.fromRGB(255,247,241),
        M=Color3.fromRGB(192,151,133), OK=Color3.fromRGB(70,225,140),
        W=Color3.fromRGB(255,185,65), E=Color3.fromRGB(255,75,80)
    },

    Frost = {
        A=Color3.fromRGB(110,205,255), A2=Color3.fromRGB(210,245,255),
        BG=Color3.fromRGB(8,13,17), C=Color3.fromRGB(17,25,31),
        C2=Color3.fromRGB(25,37,45), I=Color3.fromRGB(23,34,42),
        S=Color3.fromRGB(65,91,105), T=Color3.fromRGB(245,252,255),
        M=Color3.fromRGB(153,179,191), OK=Color3.fromRGB(80,225,160),
        W=Color3.fromRGB(255,200,80), E=Color3.fromRGB(255,90,110)
    }
}

-- ============================================================
-- HELPERS
-- ============================================================

local function tw(object, duration, properties, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()
    return tween
end

local function cr(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = object
    return corner
end

local function st(object, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = 1
    stroke.Parent = object
    return stroke
end

local function callback(fn, ...)
    if type(fn) ~= "function" then
        return
    end

    task.spawn(function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            warn("[ARIO]", err)
        end
    end, ...)
end

local function resolveTheme(name)
    name = tostring(name or "Ario")

    for key in pairs(Ario.Themes) do
        if key:lower() == name:lower() then
            return key
        end
    end

    return "Ario"
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================

function Ario:Notify(data)
    if not self.Notifs then
        return
    end

    data = type(data) == "table" and data or {
        Content = tostring(data)
    }

    local kind = tostring(data.Type or "info"):lower()

    local color =
        kind == "success" and self.C.OK
        or kind == "warning" and self.C.W
        or kind == "error" and self.C.E
        or self.C.A

    local notification = Instance.new("TextButton")
    notification.AutoButtonColor = false
    notification.Text = ""
    notification.BackgroundColor3 = self.C.C
    notification.Size = UDim2.new(1, 0, 0, 66)
    notification.Parent = self.Notifs

    cr(notification, 12)
    st(notification, self.C.S, 0.25)

    local stripe = Instance.new("Frame")
    stripe.BackgroundColor3 = color
    stripe.BorderSizePixel = 0
    stripe.Position = UDim2.new(0, 8, 0, 10)
    stripe.Size = UDim2.new(0, 4, 1, -20)
    stripe.Parent = notification
    cr(stripe, 3)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = data.Title or "ARIO"
    title.TextColor3 = self.C.T
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 23, 0, 8)
    title.Size = UDim2.new(1, -30, 0, 20)
    title.Parent = notification

    local message = Instance.new("TextLabel")
    message.BackgroundTransparency = 1
    message.Text = data.Content or data.Message or ""
    message.TextColor3 = self.C.M
    message.TextSize = 12
    message.Font = Enum.Font.Gotham
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextTruncate = Enum.TextTruncate.AtEnd
    message.Position = UDim2.new(0, 23, 0, 31)
    message.Size = UDim2.new(1, -30, 0, 20)
    message.Parent = notification

    notification.Position = UDim2.new(1, 30, 0, 0)
    tw(notification, 0.35, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    local closed = false

    local function close()
        if closed then
            return
        end

        closed = true

        tw(notification, 0.25, {
            Position = UDim2.new(1, 30, 0, 0),
            BackgroundTransparency = 1
        })

        task.delay(0.27, function()
            if notification then
                notification:Destroy()
            end
        end)
    end

    notification.MouseButton1Click:Connect(close)

    task.delay(data.Duration or 3.5, close)

    return {
        Close = close,
        Instance = notification
    }
end

-- ============================================================
-- DRAGGING
-- ============================================================

function Ario:_makeDraggable(handle, object)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        object.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

-- ============================================================
-- THEME
-- ============================================================

function Ario:ChangeTheme(name)
    name = resolveTheme(name)

    self.ThemeName = name
    self.C = Ario.Themes[name]

    self:Notify({
        Title = "Theme Changed",
        Content = name,
        Type = "success"
    })

    callback(self.Config.OnThemeChanged, name)
end

function Ario.GetThemes()
    local themes = {}

    for name in pairs(Ario.Themes) do
        table.insert(themes, name)
    end

    table.sort(themes)

    return themes
end

function Ario.GetVersion()
    return Ario.Version
end

-- ============================================================
-- TABS
-- ============================================================

function Ario:AddTab(name)
    name = type(name) == "table"
        and (name.Name or name.Title)
        or name or "Tab"

    if self.Tabs[name] then
        return self.Tabs[name].Page
    end

    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.Text = name
    button.TextColor3 = self.C.M
    button.TextSize = 12
    button.Font = Enum.Font.GothamMedium
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(0, 90, 1, 0)
    button.Parent = self.TabBar

    local page = Instance.new("ScrollingFrame")
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.fromScale(1, 1)
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = self.C.A
    page.Parent = self.Pages

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 3)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0, 0,
            0,
            layout.AbsoluteContentSize.Y + 20
        )
    end)

    button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    self.Tabs[name] = {
        Button = button,
        Page = page
    }

    if not self.CurrentTab then
        self:SelectTab(name)
    end

    return page
end

function Ario:SelectTab(name)
    for tabName, tab in pairs(self.Tabs) do
        tab.Page.Visible = tabName == name

        tw(tab.Button, 0.15, {
            TextColor3 = tabName == name
                and self.C.T
                or self.C.M
        })
    end

    self.CurrentTab = name
end

-- ============================================================
-- ELEMENTS
-- ============================================================

function Ario:AddButton(tabName, data)
    local tab = self.Tabs[tabName]
    if not tab then
        return
    end

    data = data or {}

    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.Text = data.Title or data.Name or "Button"
    button.TextColor3 = self.C.T
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.BackgroundColor3 = self.C.C2
    button.Size = UDim2.new(1, 0, 0, 43)
    button.Parent = tab.Page

    cr(button, 10)
    st(button, self.C.S, 0.3)

    button.MouseEnter:Connect(function()
        tw(button, 0.15, {
            BackgroundColor3 = self.C.I
        })
    end)

    button.MouseLeave:Connect(function()
        tw(button, 0.15, {
            BackgroundColor3 = self.C.C2
        })
    end)

    button.MouseButton1Click:Connect(function()
        callback(data.Callback)
    end)

    return button
end

function Ario:AddParagraph(tabName, data)
    local tab = self.Tabs[tabName]
    if not tab then
        return
    end

    data = data or {}

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = self.C.C
    frame.Size = UDim2.new(1, 0, 0, 72)
    frame.Parent = tab.Page

    cr(frame, 12)
    st(frame, self.C.S, 0.35)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = data.Title or "ARIO"
    title.TextColor3 = self.C.T
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 14, 0, 9)
    title.Size = UDim2.new(1, -28, 0, 20)
    title.Parent = frame

    local content = Instance.new("TextLabel")
    content.BackgroundTransparency = 1
    content.Text = data.Content or data.Description or ""
    content.TextColor3 = self.C.M
    content.TextSize = 12
    content.Font = Enum.Font.Gotham
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.Position = UDim2.new(0, 14, 0, 32)
    content.Size = UDim2.new(1, -28, 0, 30)
    content.Parent = frame

    return frame
end

-- ============================================================
-- KEY INPUT ELEMENT
-- ============================================================

function Ario:AddKeyInput(tabName, data)
    local tab = self.Tabs[tabName]
    if not tab then
        return
    end

    data = data or {}

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = self.C.I
    box.TextColor3 = self.C.T
    box.PlaceholderColor3 = self.C.M
    box.PlaceholderText = data.Placeholder or "Enter key..."
    box.Text = data.Default or ""
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Size = UDim2.new(1, 0, 0, 44)
    box.Parent = tab.Page

    cr(box, 10)
    st(box, self.C.S, 0.3)

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(data.Callback, box.Text)
        end
    end)

    return box
end

-- ============================================================
-- KEY GUI
-- ============================================================

function Ario:_createKeyScreen()
    local holder = Instance.new("Frame")
    holder.BackgroundColor3 = self.C.BG
    holder.BackgroundTransparency = 0.06
    holder.Size = UDim2.fromScale(1, 1)
    holder.ZIndex = 50
    holder.Parent = self.Root

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.52)
    card.Size = UDim2.new(0, 380, 0, 285)
    card.BackgroundColor3 = self.C.C
    card.ZIndex = 51
    card.Parent = holder

    cr(card, 17)
    st(card, self.C.S, 0.08)

    local scale = Instance.new("UIScale")
    scale.Scale = 0.82
    scale.Parent = card

    tw(scale, 0.45, {
        Scale = 1
    })

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = self.Config.Description or "ARIO Key System"
    title.TextColor3 = self.C.T
    title.TextSize = 21
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 22, 0, 18)
    title.Size = UDim2.new(1, -44, 0, 30)
    title.ZIndex = 52
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your ARIO key to continue."
    subtitle.TextColor3 = self.C.M
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Position = UDim2.new(0, 22, 0, 50)
    subtitle.Size = UDim2.new(1, -44, 0, 25)
    subtitle.ZIndex = 52
    subtitle.Parent = card

    local input = Instance.new("TextBox")
    input.BackgroundColor3 = self.C.I
    input.TextColor3 = self.C.T
    input.PlaceholderColor3 = self.C.M
    input.PlaceholderText = "Enter key..."
    input.TextSize = 13
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Position = UDim2.new(0, 22, 0, 86)
    input.Size = UDim2.new(1, -44, 0, 45)
    input.ZIndex = 52
    input.Parent = card

    cr(input, 10)
    st(input, self.C.S, 0.2)

    local getKey = Instance.new("TextButton")
    getKey.AutoButtonColor = false
    getKey.Text = "GET KEY"
    getKey.TextColor3 = self.C.T
    getKey.TextSize = 12
    getKey.Font = Enum.Font.GothamBold
    getKey.BackgroundColor3 = self.C.C2
    getKey.Position = UDim2.new(0, 22, 0, 143)
    getKey.Size = UDim2.new(0.48, -11, 0, 42)
    getKey.ZIndex = 52
    getKey.Parent = card

    cr(getKey, 10)
    st(getKey, self.C.S, 0.2)

    local submit = Instance.new("TextButton")
    submit.AutoButtonColor = false
    submit.Text = "VERIFY KEY"
    submit.TextColor3 = Color3.new(1, 1, 1)
    submit.TextSize = 12
    submit.Font = Enum.Font.GothamBold
    submit.BackgroundColor3 = self.C.A
    submit.Position = UDim2.new(0.52, 0, 0, 143)
    submit.Size = UDim2.new(0.48, -22, 0, 42)
    submit.ZIndex = 52
    submit.Parent = card

    cr(submit, 10)

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Text = "Get a key from the ARIO portal."
    status.TextColor3 = self.C.M
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.TextWrapped = true
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Position = UDim2.new(0, 22, 0, 198)
    status.Size = UDim2.new(1, -44, 0, 40)
    status.ZIndex = 52
    status.Parent = card

    local function setStatus(text, color)
        status.Text = text
        status.TextColor3 = color
    end

    local function getKey()
        local copied = ArioValidator.copyKeyLink()

        if copied then
            setStatus(
                "Key link copied to clipboard.",
                self.C.OK
            )

            self:Notify({
                Title = "Get Key",
                Content = "Key portal link copied.",
                Type = "success"
            })
        else
            local url = ArioValidator.getKeyLink()

            setStatus(
                "Open: " .. url,
                self.C.M
            )

            self:Notify({
                Title = "Get Key",
                Content = url,
                Type = "info"
            })

            ArioValidator.openKeyLink()
        end
    end

    local verifying = false

    local function verify()
        if verifying then
            return
        end

        verifying = true
        submit.Text = "CHECKING..."
        getKey.Text = "GET KEY"

        setStatus(
            "Contacting ARIO verification server...",
            self.C.M
        )

        local valid, details = ArioValidator.verify(input.Text)

        if valid then
            setStatus(
                "Key accepted. Loading...",
                self.C.OK
            )

            self:Notify({
                Title = "Key Accepted",
                Content = "Your ARIO key is valid.",
                Type = "success"
            })

            task.wait(0.45)

            tw(card, 0.32, {
                Position = UDim2.fromScale(0.5, 0.56)
            })

            tw(scale, 0.32, {
                Scale = 0.9
            })

            task.wait(0.34)

            holder:Destroy()

            self.KeyPassed = true

            callback(
                self.Config.Callback,
                ArioValidator.clean(input.Text),
                details
            )

            local slug =
                self.Config.KeySystem
                and self.Config.KeySystem.ScriptSlug

            if slug and slug ~= "" then
                local ran, errorMessage =
                    ArioValidator.runScript(slug)

                if not ran then
                    self:Notify({
                        Title = "Script Error",
                        Content = tostring(errorMessage),
                        Type = "error"
                    })
                end
            end

            return
        end

        setStatus(
            tostring(details or "Invalid or expired key."),
            self.C.E
        )

        submit.Text = "TRY AGAIN"

        tw(card, 0.06, {
            Position = UDim2.fromScale(0.47, 0.52)
        })

        task.wait(0.06)

        tw(card, 0.06, {
            Position = UDim2.fromScale(0.53, 0.52)
        })

        task.wait(0.06)

        tw(card, 0.06, {
            Position = UDim2.fromScale(0.5, 0.52)
        })

        self:Notify({
            Title = "Verification Failed",
            Content = tostring(details or "Invalid key."),
            Type = "error"
        })

        verifying = false
    end

    getKey.MouseButton1Click:Connect(getKey)
    submit.MouseButton1Click:Connect(verify)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verify()
        end
    end)

    return holder
end

function Ario:_checkSavedKey()
    local valid, saved = ArioValidator.checkSavedKey()

    if valid then
        self.KeyPassed = true

        self:Notify({
            Title = "Saved Key",
            Content = "Valid key detected. Access granted.",
            Type = "success"
        })

        callback(self.Config.Callback, saved, {
            saved = true
        })

        local slug =
            self.Config.KeySystem
            and self.Config.KeySystem.ScriptSlug

        if slug and slug ~= "" then
            task.spawn(function()
                local ran, errorMessage =
                    ArioValidator.runScript(slug)

                if not ran then
                    self:Notify({
                        Title = "Script Error",
                        Content = tostring(errorMessage),
                        Type = "error"
                    })
                end
            end)
        end

        return true
    end

    return false
end

-- ============================================================
-- DESTROY
-- ============================================================

function Ario:Destroy()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

-- ============================================================
-- MAIN CONSTRUCTOR
-- ============================================================

function Ario.new(config)
    config = config or {}

    local self = setmetatable({}, Ario)

    self.Config = config
    self.ThemeName = resolveTheme(config.Theme)
    self.C = Ario.Themes[self.ThemeName]
    self.Tabs = {}
    self.KeyPassed = false

    if config.SupportedGames
        and config.SupportedGames[game.PlaceId] == false then

        return self
    end

    -- --------------------------------------------------------
    -- GUI ROOT
    -- --------------------------------------------------------

    local gui = Instance.new("ScreenGui")
    gui.Name = "Ario_" .. tostring(config.Folder or "UI")
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui

    self.Gui = gui

    local root = Instance.new("Frame")
    root.BackgroundTransparency = 1
    root.Size = UDim2.fromScale(1, 1)
    root.Parent = gui

    self.Root = root

    -- --------------------------------------------------------
    -- WINDOW
    -- --------------------------------------------------------

    local window = Instance.new("Frame")
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Position = UDim2.fromScale(0.5, 0.54)
    window.Size = UDim2.new(0, 570, 0, 390)
    window.BackgroundColor3 = self.C.BG
    window.Parent = root

    cr(window, 18)
    st(window, self.C.S, 0.15)

    self.Window = window

    local scale = Instance.new("UIScale")
    scale.Scale = 0.82
    scale.Parent = window

    tw(scale, 0.5, {
        Scale = 1
    })

    self:_makeDraggable(window, window)

    -- --------------------------------------------------------
    -- TOP BAR
    -- --------------------------------------------------------

    local top = Instance.new("Frame")
    top.BackgroundTransparency = 1
    top.Position = UDim2.new(0, 12, 0, 8)
    top.Size = UDim2.new(1, -24, 0, 60)
    top.Parent = window

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Ario"
    title.TextColor3 = self.C.T
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Size = UDim2.new(1, -60, 0, 27)
    title.Parent = top

    local description = Instance.new("TextLabel")
    description.BackgroundTransparency = 1
    description.Text = config.Description or "Premium Interface"
    description.TextColor3 = self.C.M
    description.TextSize = 11
    description.Font = Enum.Font.Gotham
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.Position = UDim2.new(0, 10, 0, 32)
    description.Size = UDim2.new(1, -60, 0, 18)
    description.Parent = top

    local close = Instance.new("TextButton")
    close.AutoButtonColor = false
    close.Text = "×"
    close.TextColor3 = self.C.M
    close.TextSize = 24
    close.BackgroundColor3 = self.C.C
    close.Position = UDim2.new(1, -45, 0, 6)
    close.Size = UDim2.new(0, 36, 0, 36)
    close.Parent = top

    cr(close, 10)

    close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    -- --------------------------------------------------------
    -- TABS
    -- --------------------------------------------------------

    local tabBar = Instance.new("Frame")
    tabBar.BackgroundColor3 = self.C.C
    tabBar.Position = UDim2.new(0, 16, 0, 75)
    tabBar.Size = UDim2.new(1, -32, 0, 42)
    tabBar.Parent = window

    cr(tabBar, 11)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = tabBar

    self.TabBar = tabBar

    -- --------------------------------------------------------
    -- PAGES
    -- --------------------------------------------------------

    local pages = Instance.new("Frame")
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0, 16, 0, 125)
    pages.Size = UDim2.new(1, -32, 1, -141)
    pages.Parent = window

    self.Pages = pages

    -- --------------------------------------------------------
    -- NOTIFICATIONS
    -- --------------------------------------------------------

    local notificationHolder = Instance.new("Frame")
    notificationHolder.BackgroundTransparency = 1
    notificationHolder.AnchorPoint = Vector2.new(1, 1)
    notificationHolder.Position = UDim2.new(1, -15, 1, -15)
    notificationHolder.Size = UDim2.new(0, 300, 0, 300)
    notificationHolder.Parent = root

    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notificationLayout.Padding = UDim.new(0, 6)
    notificationLayout.Parent = notificationHolder

    self.Notifs = notificationHolder

    -- --------------------------------------------------------
    -- DEFAULT TABS
    -- --------------------------------------------------------

    self:AddTab("Home")

    self:AddParagraph("Home", {
        Title = "Welcome to " .. (config.Title or "ARIO"),
        Content = "Mobile-first interface powered by ARIO."
    })

    self:AddTab("Settings")

    self:AddParagraph("Settings", {
        Title = "Theme System",
        Content = "Choose a theme below."
    })

    for themeName in pairs(Ario.Themes) do
        self:AddButton("Settings", {
            Title = themeName,
            Callback = function()
                self:ChangeTheme(themeName)
            end
        })
    end

    -- --------------------------------------------------------
    -- INTRO
    -- --------------------------------------------------------

    if config.Intro then
        local intro = Instance.new("Frame")
        intro.BackgroundColor3 = self.C.BG
        intro.Size = UDim2.fromScale(1, 1)
        intro.ZIndex = 100
        intro.Parent = root

        local introScale = Instance.new("UIScale")
        introScale.Scale = 0.7
        introScale.Parent = intro

        local logo = Instance.new("TextLabel")
        logo.BackgroundTransparency = 1
        logo.AnchorPoint = Vector2.new(0.5, 0.5)
        logo.Position = UDim2.fromScale(0.5, 0.48)
        logo.Size = UDim2.new(0, 330, 0, 70)
        logo.Text = config.Title or "ARIO"
        logo.TextColor3 = self.C.T
        logo.TextSize = 46
        logo.Font = Enum.Font.GothamBlack
        logo.TextTransparency = 1
        logo.ZIndex = 101
        logo.Parent = intro

        tw(introScale, 0.55, {
            Scale = 1
        })

        tw(logo, 0.5, {
            TextTransparency = 0
        })

        task.wait(config.IntroDuration or 1.2)

        tw(logo, 0.3, {
            TextTransparency = 1
        })

        tw(introScale, 0.3, {
            Scale = 1.12
        })

        task.wait(0.32)

        intro:Destroy()
    end

    -- --------------------------------------------------------
    -- KEY SYSTEM
    -- --------------------------------------------------------

    local keyConfig = config.KeySystem

    if keyConfig and keyConfig.Enabled ~= false then
        -- IMPORTANT:
        -- Check the saved key before displaying the key GUI.
        -- This is intentionally done before asking for a new key.
        local savedValid = self:_checkSavedKey()

        if not savedValid then
            self:_createKeyScreen()
        end
    else
        self.KeyPassed = true
        callback(config.Callback)
    end

    self:Notify({
        Title = "ARIO",
        Content = "Framework loaded.",
        Type = "success",
        Duration = 2.5
    })

    return self
end

return Ario
