-- PhuQuy Hub Ultimate V1 --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CDVNNativeHub") then
    CoreGui.CDVNNativeHub:Destroy()
end
if CoreGui:FindFirstChild("PhuQuyKeySystem") then
    CoreGui.PhuQuyKeySystem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CDVNNativeHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPContainer"
ESPContainer.Parent = ScreenGui

-- ==========================================
-- HỆ THỐNG LƯU TRỮ FILE VĨNH VIỄN & BLACKLIST KEY HẾT HẠN
-- ==========================================
local FileName = "PhuQuyHub_Session.json"

local function loadSavedSession()
    if writefile and readfile and isfile and isfile(FileName) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(FileName))
        end)
        if success and data then
            if not data.ExpiredKeys then data.ExpiredKeys = {} end
            return data
        end
    end
    return { Key = "", ExpireTime = 0, ExpiredKeys = {} }
end

local function saveSession(key, expireTime, expiredList)
    if writefile then
        pcall(function()
            local data = HttpService:JSONEncode({
                Key = key,
                ExpireTime = expireTime,
                ExpiredKeys = expiredList or {}
            })
            writefile(FileName, data)
        end)
    end
end

local function clearSessionToExpired()
    local currentData = loadSavedSession()
    if currentData.Key ~= "" then
        local found = false
        for _, k in ipairs(currentData.ExpiredKeys) do
            if k == currentData.Key then found = true break end
        end
        if not found then
            table.insert(currentData.ExpiredKeys, currentData.Key)
        end
    end
    
    if writefile then
        pcall(function()
            local data = HttpService:JSONEncode({
                Key = "",
                ExpireTime = 0,
                ExpiredKeys = currentData.ExpiredKeys
            })
            writefile(FileName, data)
        end)
    end
end

local savedData = loadSavedSession()
getgenv().PhuQuySavedSession = savedData

-- ==========================================
-- 1. GIAO DIỆN NHẬP KEY
-- ==========================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "PhuQuyKeySystem"
KeyGui.Parent = CoreGui
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.IgnoreGuiInset = true

local KeyOverlay = Instance.new("Frame", KeyGui)
KeyOverlay.Size = UDim2.new(1, 0, 1, 0)
KeyOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyOverlay.BackgroundTransparency = 0.4
KeyOverlay.ZIndex = 500

local KeyFrame = Instance.new("Frame", KeyOverlay)
KeyFrame.Size = UDim2.new(0, 380, 0, 215)
KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -107)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
KeyFrame.ZIndex = 501
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)

local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(255, 255, 255)
KeyStroke.Thickness = 2.5

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0, 15)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "PHU QUY HUB - KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 16
KeyTitle.ZIndex = 502

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0, 320, 0, 42)
KeyBox.Position = UDim2.new(0.5, -160, 0, 60)
KeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyBox.Font = Enum.Font.GothamBold
KeyBox.PlaceholderText = "Nhập Key bản quyền của bạn..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 13
KeyBox.ZIndex = 502
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local ConfirmBtn = Instance.new("TextButton", KeyFrame)
ConfirmBtn.Size = UDim2.new(0, 320, 0, 42)
ConfirmBtn.Position = UDim2.new(0.5, -160, 0, 112)
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ConfirmBtn.Font = Enum.Font.GothamBold
ConfirmBtn.Text = "XÁC NHẬN KEY"
ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmBtn.TextSize = 14
ConfirmBtn.ZIndex = 502
Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel", KeyFrame)
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 0, 0, 165)
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.Font = Enum.Font.GothamBold
StatusText.Text = ""
StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusText.TextSize = 12
StatusText.ZIndex = 502

-- ==========================================
-- 2. GIAO DIỆN CHÍNH
-- ==========================================
local GlowRing = Instance.new("Frame")
GlowRing.Name = "GlowRing"
GlowRing.Parent = ScreenGui
GlowRing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlowRing.BackgroundTransparency = 0.5
GlowRing.Position = UDim2.new(0.05, -4, 0.1, -4)
GlowRing.Size = UDim2.new(0, 53, 0, 53)
GlowRing.ZIndex = 999
GlowRing.Visible = false
Instance.new("UICorner", GlowRing).CornerRadius = UDim.new(1, 0)
local GlowStroke = Instance.new("UIStroke", GlowRing)
GlowStroke.Color = Color3.fromRGB(255, 255, 255)
GlowStroke.Thickness = 2
GlowStroke.Transparency = 0.2

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "PhuQuy"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 10
ToggleBtn.ZIndex = 1000
ToggleBtn.Active = true
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
MainFrame.BorderColor3 = Color3.fromRGB(45, 45, 50)
MainFrame.Position = UDim2.new(0.18, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 340)
MainFrame.Visible = false
MainFrame.ZIndex = 100
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.ZIndex = 101
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.Size = UDim2.new(0.5, 0, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "PhuQuy Hub | Version 2.0"
TitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 102

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
CloseBtn.Position = UDim2.new(1, -30, 0, 6)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 102
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
Sidebar.ZIndex = 101

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingBottom = UDim.new(0, 10)
SidebarPadding.PaddingTop = UDim.new(0, 2)
SidebarPadding.PaddingLeft = UDim.new(0, 2)
SidebarPadding.PaddingRight = UDim.new(0, 2)

SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
end)

local ContainerHolder = Instance.new("Frame", MainFrame)
ContainerHolder.BackgroundTransparency = 1
ContainerHolder.Position = UDim2.new(0, 145, 0, 38)
ContainerHolder.Size = UDim2.new(1, -145, 1, -38)
ContainerHolder.ZIndex = 101

local FarmNoticeOverlay = Instance.new("Frame", MainFrame)
FarmNoticeOverlay.Name = "FarmNoticeOverlay"
FarmNoticeOverlay.Size = UDim2.new(1, 0, 1, -38)
FarmNoticeOverlay.Position = UDim2.new(0, 0, 0, 38)
FarmNoticeOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FarmNoticeOverlay.BackgroundTransparency = 0.5
FarmNoticeOverlay.Visible = false
FarmNoticeOverlay.ZIndex = 200
Instance.new("UICorner", FarmNoticeOverlay).CornerRadius = UDim.new(0, 8)

local FarmNoticeBox = Instance.new("Frame", FarmNoticeOverlay)
FarmNoticeBox.Size = UDim2.new(0, 320, 0, 110)
FarmNoticeBox.Position = UDim2.new(0.5, -160, 0.5, -55)
FarmNoticeBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
FarmNoticeBox.BorderColor3 = Color3.fromRGB(60, 60, 75)
FarmNoticeBox.ZIndex = 201
Instance.new("UICorner", FarmNoticeBox).CornerRadius = UDim.new(0, 10)

local FarmNoticeText = Instance.new("TextLabel", FarmNoticeBox)
FarmNoticeText.BackgroundTransparency = 1
FarmNoticeText.Size = UDim2.new(1, -20, 1, 0)
FarmNoticeText.Position = UDim2.new(0, 10, 0, 0)
FarmNoticeText.Font = Enum.Font.GothamBold
FarmNoticeText.Text = "⚠️ Farm Level Đang Ban! Tôi Đang Cố Khắc Phục Và Update Tính Năng Mới. Xin Thông Cảm!"
FarmNoticeText.TextColor3 = Color3.fromRGB(255, 200, 50)
FarmNoticeText.TextSize = 12
FarmNoticeText.TextWrapped = true
FarmNoticeText.TextXAlignment = Enum.TextXAlignment.Center
FarmNoticeText.TextYAlignment = Enum.TextYAlignment.Center
FarmNoticeText.ZIndex = 202

local SNCLabel = Instance.new("TextLabel", ScreenGui)
SNCLabel.BackgroundTransparency = 1
SNCLabel.Position = UDim2.new(0.5, -125, 0, 25)
SNCLabel.Size = UDim2.new(0, 250, 0, 35)
SNCLabel.Font = Enum.Font.GothamBold
SNCLabel.Text = "SNC: 0"
SNCLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
SNCLabel.TextSize = 22
SNCLabel.TextXAlignment = Enum.TextXAlignment.Center
SNCLabel.ZIndex = 998

local function makeDraggable(guiObject, glowObject, dragTarget)
    dragTarget = dragTarget or guiObject
    local dragging, dragStart, startPos, glowStartPos
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            if glowObject then glowStartPos = glowObject.Position end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            if glowObject and glowStartPos then
                glowObject.Position = UDim2.new(glowStartPos.X.Scale, glowStartPos.X.Offset + delta.X, glowStartPos.Y.Scale, glowStartPos.Y.Offset + delta.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
makeDraggable(MainFrame, nil, TopBar)
makeDraggable(ToggleBtn, GlowRing)

local tabs = {}
local tabButtons = {}
local currentTab = nil

local function switchTab(name)
    for _, t in pairs(tabs) do t.Visible = false end
    for _, b in pairs(tabButtons) do 
        b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        b.TextColor3 = Color3.fromRGB(160, 160, 160)
    end
    if tabs[name] and tabButtons[name] then
        tabs[name].Visible = true
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        tabButtons[name].TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
    end
end

local function createTab(name)
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    tabBtn.Size = UDim2.new(1, -4, 0, 32)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.Text = " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    tabBtn.TextSize = 11
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.ZIndex = 102
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local tabContent = Instance.new("ScrollingFrame", ContainerHolder)
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.Visible = false
    tabContent.ZIndex = 102

    local layout = Instance.new("UIListLayout", tabContent)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    local padding = Instance.new("UIPadding", tabContent)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25)
    end)

    tabs[name] = tabContent
    tabButtons[name] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        if name == "FARM LEVEL" then
            FarmNoticeOverlay.Visible = true
            switchTab("FARM LEVEL")
            task.spawn(function()
                task.wait(1.5)
                FarmNoticeOverlay.Visible = false
                switchTab("PVP COMBAT")
            end)
        else
            FarmNoticeOverlay.Visible = false
            switchTab(name)
        end
    end)

    if not currentTab then switchTab(name) end
    return tabContent
end

local function createToggleInTab(parentTab, text, defaultState, callback)
    local btn = Instance.new("TextButton", parentTab)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 103
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local switchBg = Instance.new("Frame", btn)
    switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 55)
    switchBg.Position = UDim2.new(1, -45, 0.5, -10)
    switchBg.Size = UDim2.new(0, 36, 0, 20)
    switchBg.ZIndex = 104
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local switchCircle = Instance.new("Frame", switchBg)
    switchCircle.BackgroundColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    switchCircle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    switchCircle.Size = UDim2.new(0, 16, 0, 16)
    switchCircle.ZIndex = 105
    Instance.new("UICorner", switchCircle).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    callback(state)

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            switchCircle.Position = UDim2.new(1, -18, 0.5, -8)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            switchCircle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            switchCircle.Position = UDim2.new(0, 2, 0.5, -8)
        end
        callback(state)
    end)
end

-- ================= KHỞI TẠO CÁC TAB =================
local tab1 = createTab("PVP COMBAT")
local tab2 = createTab("ESP VIP")
local tab3 = createTab("FARM LEVEL")
local tab4 = createTab("FIX LAG")
local tab5 = createTab("TREO TIỀN")
local tab6 = createTab("LH ADMIN")

-- --- TAB 6: LH ADMIN & HIỂN THỊ KEY/TIMER ---
local adminLabel = Instance.new("TextLabel", tab6)
adminLabel.BackgroundTransparency = 1
adminLabel.Size = UDim2.new(1, -10, 0, 50)
adminLabel.Font = Enum.Font.GothamBold
adminLabel.Text = "Hỗ trợ / Liên hệ Admin:\nFacebook: fb.com/PhuQuyHub\nZalo: 0123456789"
adminLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
adminLabel.TextSize = 13
adminLabel.ZIndex = 103

local KeyInfoBox = Instance.new("Frame", tab6)
KeyInfoBox.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
KeyInfoBox.Size = UDim2.new(1, -10, 0, 75)
KeyInfoBox.ZIndex = 103
Instance.new("UICorner", KeyInfoBox).CornerRadius = UDim.new(0, 6)

local KeyInfoText = Instance.new("TextLabel", KeyInfoBox)
KeyInfoText.BackgroundTransparency = 1
KeyInfoText.Position = UDim2.new(0, 10, 0, 5)
KeyInfoText.Size = UDim2.new(1, -20, 1, -10)
KeyInfoText.Font = Enum.Font.GothamBold
KeyInfoText.Text = "Key : Chưa nhập\nThời Gian : 00:00"
KeyInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInfoText.TextSize = 12
KeyInfoText.TextXAlignment = Enum.TextXAlignment.Left
KeyInfoText.TextYAlignment = Enum.TextYAlignment.Top
KeyInfoText.ZIndex = 104

local function grantAccess()
    KeyGui.Enabled = false
    MainFrame.Visible = true
    ToggleBtn.Visible = true
    GlowRing.Visible = true
end

if getgenv().PhuQuySavedSession.ExpireTime > os.time() then
    grantAccess()
end

ConfirmBtn.MouseButton1Click:Connect(function()
    local userKey = KeyBox.Text
    if userKey == "" then
        StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
        StatusText.Text = "Vui lòng nhập Key vào ô trống!"
        return
    end

    -- KIỂM TRA XEM KEY NÀY ĐÃ TỪNG HẾT HẠN TRƯỚC ĐÓ CHƯA
    local currentData = loadSavedSession()
    for _, k in ipairs(currentData.ExpiredKeys) do
        if k == userKey then
            StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
            StatusText.Text = "Key này đã hết hạn, không thể dùng lại!"
            return
        end
    end

    StatusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    StatusText.Text = "Đang xác thực Key..."

    task.spawn(function()
        task.wait(0.4)

        local isValid = false
        local timeInSeconds = 3600

        if #userKey >= 4 then
            isValid = true
            local lowerKey = userKey:lower()

            if string.match(lowerKey, "^1h") or string.match(lowerKey, "hour") then
                timeInSeconds = 3600
            elseif string.match(lowerKey, "^1d") or string.match(lowerKey, "day") then
                timeInSeconds = 86400
            elseif string.match(lowerKey, "^3d") then
                timeInSeconds = 86400 * 3
            elseif string.match(lowerKey, "^1w") or string.match(lowerKey, "week") then
                timeInSeconds = 86400 * 7
            elseif string.match(lowerKey, "^1m") or string.match(lowerKey, "month") then
                timeInSeconds = 86400 * 30
            else
                timeInSeconds = 3600
            end
        end

        if isValid then
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
            StatusText.Text = "Xác nhận Key thành công! Đang vào Menu..."
            
            local expireTimestamp = os.time() + timeInSeconds
            getgenv().PhuQuySavedSession = {
                Key = userKey,
                ExpireTime = expireTimestamp,
                ExpiredKeys = currentData.ExpiredKeys
            }
            saveSession(userKey, expireTimestamp, currentData.ExpiredKeys)

            task.wait(0.8)
            grantAccess()
        else
            StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
            StatusText.Text = "Key không hợp lệ! Vui lòng kiểm tra lại."
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().PhuQuySavedSession.ExpireTime > 0 then
            local timeLeft = getgenv().PhuQuySavedSession.ExpireTime - os.time()
            
            if timeLeft > 0 then
                local days = math.floor(timeLeft / 86400)
                local hours = math.floor((timeLeft % 86400) / 3600)
                local minutes = math.floor((timeLeft % 3600) / 60)
                local seconds = timeLeft % 60
                
                local activeKey = getgenv().PhuQuySavedSession.Key
                if days > 0 then
                    KeyInfoText.Text = string.format("Key : %s\nThời Gian : %d ngày %02d:%02d:%02d", activeKey, days, hours, minutes, seconds)
                elseif hours > 0 then
                    KeyInfoText.Text = string.format("Key : %s\nThời Gian : %02d:%02d:%02d", activeKey, hours, minutes, seconds)
                else
                    KeyInfoText.Text = string.format("Key : %s\nThời Gian : %02d:%02d", activeKey, minutes, seconds)
                end
            else
                MainFrame.Visible = false
                ToggleBtn.Visible = false
                GlowRing.Visible = false
                KeyBox.Text = ""
                StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
                StatusText.Text = "Key đã hết hạn! Vui lòng nhập Key mới."
                KeyGui.Enabled = true
                KeyInfoText.Text = "Key : Đã hết hạn\nThời Gian : 00:00"
                
                clearSessionToExpired()
                getgenv().PhuQuySavedSession = loadSavedSession()
            end
        end
    end
end)

-- --- TAB 1: PVP COMBAT ---
local autoPVPEnabled, autoSpinEnabled, noclipEnabled, hitboxEnabled, autoHealEnabled, autoBuyEnabled, speedVipEnabled, antiBanEnabled = false, false, false, false, false, false, false, false
local spinSpeed = 50
local speedValue = 16

createToggleInTab(tab1, "1. Auto PVP (Đánh liên tục)", false, function(state)
    autoPVPEnabled = state
    task.spawn(function()
        while autoPVPEnabled do
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
            task.wait(0.02)
        end
    end)
end)

createToggleInTab(tab1, "2. Auto Xoay 360", false, function(state) autoSpinEnabled = state end)

local SpinThickContainer = Instance.new("Frame", tab1)
SpinThickContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
SpinThickContainer.Size = UDim2.new(1, -10, 0, 50)
SpinThickContainer.ZIndex = 103
Instance.new("UICorner", SpinThickContainer).CornerRadius = UDim.new(0, 6)

local SpinThickLabel = Instance.new("TextLabel", SpinThickContainer)
SpinThickLabel.BackgroundTransparency = 1
SpinThickLabel.Position = UDim2.new(0, 10, 0, 5)
SpinThickLabel.Size = UDim2.new(1, -20, 0, 20)
SpinThickLabel.Font = Enum.Font.Gotham
SpinThickLabel.Text = "  Tốc độ Xoay 360 (0-100): " .. spinSpeed
SpinThickLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpinThickLabel.TextSize = 12
SpinThickLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpinThickBar = Instance.new("TextButton", SpinThickContainer)
SpinThickBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpinThickBar.Position = UDim2.new(0, 10, 0, 30)
SpinThickBar.Size = UDim2.new(1, -20, 0, 10)
SpinThickBar.Text = ""
Instance.new("UICorner", SpinThickBar).CornerRadius = UDim.new(1, 0)

local SpinThickFill = Instance.new("Frame", SpinThickBar)
SpinThickFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SpinThickFill.Size = UDim2.new(spinSpeed / 100, 0, 1, 0)
Instance.new("UICorner", SpinThickFill).CornerRadius = UDim.new(1, 0)

local spinSliding = false
SpinThickBar.MouseButton1Down:Connect(function() spinSliding = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then spinSliding = false end end)
UserInputService.InputChanged:Connect(function(input)
    if spinSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((input.Position.X - SpinThickBar.AbsolutePosition.X) / SpinThickBar.AbsoluteSize.X, 0, 1)
        spinSpeed = math.floor(p * 100)
        SpinThickFill.Size = UDim2.new(p, 0, 1, 0)
        SpinThickLabel.Text = "  Tốc độ Xoay 360 (0-100): " .. spinSpeed
    end
end)

createToggleInTab(tab1, "3. Noclip (Xuyên Tường)", false, function(state) noclipEnabled = state end)
createToggleInTab(tab1, "4. Hitbox Người Chơi", false, function(state) hitboxEnabled = state end)
createToggleInTab(tab1, "5. Speed VIP", false, function(state) speedVipEnabled = state end)

local SpeedThickContainer = Instance.new("Frame", tab1)
SpeedThickContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
SpeedThickContainer.Size = UDim2.new(1, -10, 0, 50)
SpeedThickContainer.ZIndex = 103
Instance.new("UICorner", SpeedThickContainer).CornerRadius = UDim.new(0, 6)

local SpeedThickLabel = Instance.new("TextLabel", SpeedThickContainer)
SpeedThickLabel.BackgroundTransparency = 1
SpeedThickLabel.Position = UDim2.new(0, 10, 0, 5)
SpeedThickLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedThickLabel.Font = Enum.Font.Gotham
SpeedThickLabel.Text = "  Tốc độ Speed VIP (0-100): " .. speedValue
SpeedThickLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedThickLabel.TextSize = 12
SpeedThickLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedThickBar = Instance.new("TextButton", SpeedThickContainer)
SpeedThickBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedThickBar.Position = UDim2.new(0, 10, 0, 30)
SpeedThickBar.Size = UDim2.new(1, -20, 0, 10)
SpeedThickBar.Text = ""
Instance.new("UICorner", SpeedThickBar).CornerRadius = UDim.new(1, 0)

local SpeedThickFill = Instance.new("Frame", SpeedThickBar)
SpeedThickFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SpeedThickFill.Size = UDim2.new(speedValue / 100, 0, 1, 0)
Instance.new("UICorner", SpeedThickFill).CornerRadius = UDim.new(1, 0)

local speedSliding = false
SpeedThickBar.MouseButton1Down:Connect(function() speedSliding = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then speedSliding = false end end)
UserInputService.InputChanged:Connect(function(input)
    if speedSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((input.Position.X - SpeedThickBar.AbsolutePosition.X) / SpeedThickBar.AbsoluteSize.X, 0, 1)
        speedValue = math.floor(p * 100)
        SpeedThickFill.Size = UDim2.new(p, 0, 1, 0)
        SpeedThickLabel.Text = "  Tốc độ Speed VIP (0-100): " .. speedValue
    end
end)

createToggleInTab(tab1, "6. Auto Heal (Dùng băng gạc)", false, function(state)
    autoHealEnabled = state
    task.spawn(function()
        while autoHealEnabled do
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    local function findHealItem(container)
                        if not container then return nil end
                        for _, item in pairs(container:GetChildren()) do
                            if item:IsA("Tool") then
                                local name = item.Name:lower()
                                if name:find("band") or name:find("heal") or name:find("med") or name:find("gạc") or name:find("kit") then
                                    return item
                                end
                            end
                        end
                        return nil
                    end
                    local targetItem = findHealItem(char) or findHealItem(backpack)
                    if targetItem then
                        if targetItem.Parent == backpack then
                            hum:EquipTool(targetItem)
                            task.wait(0.1)
                        end
                        targetItem:Activate()
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

createToggleInTab(tab1, "7. Auto Mua Băng Gạc", false, function(state)
    autoBuyEnabled = state
    task.spawn(function()
        while autoBuyEnabled do
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                local function hasHealItem(container)
                    if not container then return false end
                    for _, item in pairs(container:GetChildren()) do
                        if item:IsA("Tool") then
                            local name = item.Name:lower()
                            if name:find("band") or name:find("heal") or name:find("med") or name:find("gạc") or name:find("kit") then
                                return true
                            end
                        end
                    end
                    return false
                end
                if not hasHealItem(backpack) and not hasHealItem(char) then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            local oText = v.ObjectText:lower()
                            local aText = v.ActionText:lower()
                            if oText:find("band") or oText:find("shop") or oText:find("heal") or aText:find("buy") or aText:find("mua") then
                                fireproximityprompt(v)
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

createToggleInTab(tab1, "8. AntiBan", false, function(state) antiBanEnabled = state end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if noclipEnabled then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            if autoSpinEnabled and rootPart then
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * 0.8), 0)
            end
            if speedVipEnabled and rootPart and hum then
                if hum.MoveDirection.Magnitude > 0 then
                    local speedMultiplier = 1 + (speedValue / 15) 
                    rootPart.CFrame = rootPart.CFrame + (hum.MoveDirection * (speedMultiplier * 0.6))
                end
            end
        end
        if hitboxEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(6, 6, 6)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- --- TAB 2: ESP VIP ---
local espEnabled, boxEnabled, nameEnabled, lineEnabled = true, true, true, true
local boxColor = Color3.fromRGB(255, 255, 255)
local boxThickness = 2
local lineColor = Color3.fromRGB(255, 255, 255)
local lineThickness = 2

createToggleInTab(tab2, "ESP Tổng", true, function(state) espEnabled = state end)
createToggleInTab(tab2, "Box (Hộp chữ nhật)", true, function(state) boxEnabled = state end)

local BoxColorBtn = Instance.new("TextButton", tab2)
BoxColorBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
BoxColorBtn.Size = UDim2.new(1, -10, 0, 36)
BoxColorBtn.Font = Enum.Font.Gotham
BoxColorBtn.Text = "  🎨 Đổi Màu Box"
BoxColorBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
BoxColorBtn.TextSize = 12
BoxColorBtn.TextXAlignment = Enum.TextXAlignment.Left
BoxColorBtn.ZIndex = 103
Instance.new("UICorner", BoxColorBtn).CornerRadius = UDim.new(0, 6)

local boxColorIndex = 1
local boxColorsList = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 150, 255), Color3.fromRGB(255, 255, 0)}
BoxColorBtn.MouseButton1Click:Connect(function()
    boxColorIndex = boxColorIndex % #boxColorsList + 1
    boxColor = boxColorsList[boxColorIndex]
    BoxColorBtn.TextColor3 = boxColor
end)

local BoxThickContainer = Instance.new("Frame", tab2)
BoxThickContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
BoxThickContainer.Size = UDim2.new(1, -10, 0, 50)
BoxThickContainer.ZIndex = 103
Instance.new("UICorner", BoxThickContainer).CornerRadius = UDim.new(0, 6)

local BoxThickLabel = Instance.new("TextLabel", BoxThickContainer)
BoxThickLabel.BackgroundTransparency = 1
BoxThickLabel.Position = UDim2.new(0, 10, 0, 5)
BoxThickLabel.Size = UDim2.new(1, -20, 0, 20)
BoxThickLabel.Font = Enum.Font.Gotham
BoxThickLabel.Text = "  Độ dày Box (1-10): " .. boxThickness
BoxThickLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
BoxThickLabel.TextSize = 12
BoxThickLabel.TextXAlignment = Enum.TextXAlignment.Left

local BoxThickBar = Instance.new("TextButton", BoxThickContainer)
BoxThickBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BoxThickBar.Position = UDim2.new(0, 10, 0, 30)
BoxThickBar.Size = UDim2.new(1, -20, 0, 10)
BoxThickBar.Text = ""
Instance.new("UICorner", BoxThickBar).CornerRadius = UDim.new(1, 0)

local BoxThickFill = Instance.new("Frame", BoxThickBar)
BoxThickFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BoxThickFill.Size = UDim2.new(boxThickness / 10, 0, 1, 0)
Instance.new("UICorner", BoxThickFill).CornerRadius = UDim.new(1, 0)

local boxThickSliding = false
BoxThickBar.MouseButton1Down:Connect(function() boxThickSliding = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then boxThickSliding = false end end)
UserInputService.InputChanged:Connect(function(input)
    if boxThickSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((input.Position.X - BoxThickBar.AbsolutePosition.X) / BoxThickBar.AbsoluteSize.X, 0, 1)
        boxThickness = math.max(1, math.floor(p * 10))
        BoxThickFill.Size = UDim2.new(boxThickness / 10, 0, 1, 0)
        BoxThickLabel.Text = "  Độ dày Box (1-10): " .. boxThickness
    end
end)

createToggleInTab(tab2, "Hiện Tên Người Chơi", true, function(state) nameEnabled = state end)
createToggleInTab(tab2, "Line (Đường kẻ)", true, function(state) lineEnabled = state end)

local LineColorBtn = Instance.new("TextButton", tab2)
LineColorBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
LineColorBtn.Size = UDim2.new(1, -10, 0, 36)
LineColorBtn.Font = Enum.Font.Gotham
LineColorBtn.Text = "  🎨 Đổi Màu Line"
LineColorBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
LineColorBtn.TextSize = 12
LineColorBtn.TextXAlignment = Enum.TextXAlignment.Left
LineColorBtn.ZIndex = 103
Instance.new("UICorner", LineColorBtn).CornerRadius = UDim.new(0, 6)

local lineColorIndex = 1
local lineColorsList = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 150, 255), Color3.fromRGB(255, 255, 0)}
LineColorBtn.MouseButton1Click:Connect(function()
    lineColorIndex = lineColorIndex % #lineColorsList + 1
    lineColor = lineColorsList[lineColorIndex]
    LineColorBtn.TextColor3 = lineColor
end)

local LineThickContainer = Instance.new("Frame", tab2)
LineThickContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
LineThickContainer.Size = UDim2.new(1, -10, 0, 50)
LineThickContainer.ZIndex = 103
Instance.new("UICorner", LineThickContainer).CornerRadius = UDim.new(0, 6)

local LineThickLabel = Instance.new("TextLabel", LineThickContainer)
LineThickLabel.BackgroundTransparency = 1
LineThickLabel.Position = UDim2.new(0, 10, 0, 5)
LineThickLabel.Size = UDim2.new(1, -20, 0, 20)
LineThickLabel.Font = Enum.Font.Gotham
LineThickLabel.Text = "  Độ dày Line (1-10): " .. lineThickness
LineThickLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
LineThickLabel.TextSize = 12
LineThickLabel.TextXAlignment = Enum.TextXAlignment.Left

local LineThickBar = Instance.new("TextButton", LineThickContainer)
LineThickBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
LineThickBar.Position = UDim2.new(0, 10, 0, 30)
LineThickBar.Size = UDim2.new(1, -20, 0, 10)
LineThickBar.Text = ""
Instance.new("UICorner", LineThickBar).CornerRadius = UDim.new(1, 0)

local LineThickFill = Instance.new("Frame", LineThickBar)
LineThickFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
LineThickFill.Size = UDim2.new(lineThickness / 10, 0, 1, 0)
Instance.new("UICorner", LineThickFill).CornerRadius = UDim.new(1, 0)

local lineThickSliding = false
LineThickBar.MouseButton1Down:Connect(function() lineThickSliding = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then lineThickSliding = false end end)
UserInputService.InputChanged:Connect(function(input)
    if lineThickSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((input.Position.X - LineThickBar.AbsolutePosition.X) / LineThickBar.AbsoluteSize.X, 0, 1)
        lineThickness = math.max(1, math.floor(p * 10))
        LineThickFill.Size = UDim2.new(lineThickness / 10, 0, 1, 0)
        LineThickLabel.Text = "  Độ dày Line (1-10): " .. lineThickness
    end
end)

-- --- TAB 3: FARM LEVEL ---
local farmLevelEnabled = false
local antiBanFarmEnabled = false

local FarmTabOverlay = Instance.new("Frame", tab3)
FarmTabOverlay.Name = "FarmTabOverlay"
FarmTabOverlay.Size = UDim2.new(1, 0, 1, 0)
FarmTabOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FarmTabOverlay.BackgroundTransparency = 0.5
FarmTabOverlay.Visible = false
FarmTabOverlay.ZIndex = 300
Instance.new("UICorner", FarmTabOverlay).CornerRadius = UDim.new(0, 6)

createToggleInTab(tab3, "AntiBan", false, function(state) antiBanFarmEnabled = state end)
createToggleInTab(tab3, "Farm Level", false, function(state) farmLevelEnabled = state end)

tabButtons["FARM LEVEL"].MouseButton1Click:Connect(function()
    FarmTabOverlay.Visible = true
    task.spawn(function()
        task.wait(1.5)
        FarmTabOverlay.Visible = false
    end)
end)

-- --- TAB 4: FIX LAG ---
createToggleInTab(tab4, "Tối Ưu FPS (Boost)", false, function(state)
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.Material = state and Enum.Material.SmoothPlastic or Enum.Material.Plastic 
            elseif v:IsA("Decal") or v:IsA("Texture") then 
                v.Transparency = state and 1 or 0 
            end
        end
    end)
end)

-- --- TAB 5: TREO TIỀN ---
local treoTienEnabled = false
createToggleInTab(tab5, "Bật Auto Click Treo Tiền (Chống AFK)", false, function(state)
    treoTienEnabled = state
    task.spawn(function()
        local vu = game:GetService("VirtualUser")
        local idledConnection
        idledConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            if treoTienEnabled then
                pcall(function()
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(0.2)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end
        end)

        while treoTienEnabled do
            pcall(function()
                vu:Button1Down(Vector2.new(100, 100))
                task.wait(0.1)
                vu:Button1Up(Vector2.new(100, 100))
            end)
            task.wait(3)
        end
        
        if idledConnection then
            idledConnection:Disconnect()
        end
    end)
end)

-- --- ESP RENDER SYSTEM ---
local function createUIGuiLine()
    local lineFrame = Instance.new("Frame", ESPContainer)
    lineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lineFrame.BorderSizePixel = 0
    lineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    lineFrame.Size = UDim2.new(0, 1, 0, 0)
    lineFrame.Visible = false
    lineFrame.ZIndex = 50
    return lineFrame
end

local function updateUIGuiLine(lineFrame, p1, p2, color, thickness)
    if thickness <= 0 then lineFrame.Visible = false return end
    local distance = (p2 - p1).Magnitude
    local center = (p1 + p2) / 2
    local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)
    lineFrame.BackgroundColor3 = color
    lineFrame.Size = UDim2.new(0, distance, 0, thickness)
    lineFrame.Position = UDim2.new(0, center.X, 0, center.Y)
    lineFrame.Rotation = math.deg(angle)
    lineFrame.Visible = true
end

local espObjects = {}
local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].BoxContainer then espObjects[player].BoxContainer:Destroy() end
        if espObjects[player].NameLabel then espObjects[player].NameLabel:Destroy() end
        if espObjects[player].Line then espObjects[player].Line:Destroy() end
        espObjects[player] = nil
    end
end

RunService:BindToRenderStep("CDVN_ESP_Render", Enum.RenderPriority.Camera.Value + 1, function()
    local realPlayersCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            realPlayersCount = realPlayersCount + 1
            if not espObjects[player] then
                local bContainer = Instance.new("Frame", ESPContainer)
                bContainer.BackgroundTransparency = 1
                bContainer.Visible = false
                bContainer.ZIndex = 50
                for _, name in ipairs({"Top", "Bottom", "Left", "Right"}) do
                    local f = Instance.new("Frame", bContainer)
                    f.Name = name
                    f.BorderSizePixel = 0
                end
                
                local nLabel = Instance.new("TextLabel", ESPContainer)
                nLabel.BackgroundTransparency = 1
                nLabel.Size = UDim2.new(0, 200, 0, 20)
                nLabel.AnchorPoint = Vector2.new(0.5, 1)
                nLabel.Font = Enum.Font.GothamBold
                nLabel.TextSize = 12
                nLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nLabel.TextStrokeTransparency = 0.5
                nLabel.Visible = false
                nLabel.ZIndex = 51

                espObjects[player] = { BoxContainer = bContainer, NameLabel = nLabel, Line = createUIGuiLine() }
            end
            
            local objs = espObjects[player]
            local char = player.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            if espEnabled and char and rootPart and head and humanoid and humanoid.Health > 0 then
                local headVector, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local rootVector, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                if headVector.Z > 0 or rootVector.Z > 0 then
                    local height = math.clamp(math.abs(headVector.Y - rootVector.Y), 10, Camera.ViewportSize.Y)
                    local width = math.clamp(height * 0.6, 8, Camera.ViewportSize.X)
                    
                    if boxEnabled and boxThickness > 0 then
                        objs.BoxContainer.Visible = true
                        objs.BoxContainer.Size = UDim2.new(0, width, 0, height)
                        objs.BoxContainer.Position = UDim2.new(0, headVector.X - width / 2, 0, headVector.Y)
                        for _, f in ipairs(objs.BoxContainer:GetChildren()) do
                            if f:IsA("Frame") then
                                f.BackgroundColor3 = boxColor
                                if f.Name == "Top" then f.Size = UDim2.new(1, 0, 0, boxThickness) f.Position = UDim2.new(0, 0, 0, 0)
                                elseif f.Name == "Bottom" then f.Size = UDim2.new(1, 0, 0, boxThickness) f.Position = UDim2.new(0, 0, 1, -boxThickness)
                                elseif f.Name == "Left" then f.Size = UDim2.new(0, boxThickness, 1, 0) f.Position = UDim2.new(0, 0, 0, 0)
                                elseif f.Name == "Right" then f.Size = UDim2.new(0, boxThickness, 1, 0) f.Position = UDim2.new(1, -boxThickness, 0, 0) end
                            end
                        end
                    else
                        objs.BoxContainer.Visible = false
                    end
                    
                    if nameEnabled then
                        objs.NameLabel.Visible = true
                        objs.NameLabel.Text = player.Name
                        objs.NameLabel.Position = UDim2.new(0, headVector.X, 0, headVector.Y - 6)
                    else
                        objs.NameLabel.Visible = false
                    end
                    
                    if lineEnabled and lineThickness > 0 then
                        local startPoint = Vector2.new(Camera.ViewportSize.X / 2, 65)
                        local targetPoint = Vector2.new(headVector.X, headVector.Y)
                        updateUIGuiLine(objs.Line, startPoint, targetPoint, lineColor, lineThickness)
                    else
                        objs.Line.Visible = false
                    end
                else
                    objs.BoxContainer.Visible = false
                    objs.NameLabel.Visible = false
                    objs.Line.Visible = false
                end
            else
                objs.BoxContainer.Visible = false
                objs.NameLabel.Visible = false
                objs.Line.Visible = false
            end
        end
    end
    SNCLabel.Text = "SNC: " .. realPlayersCount
end)

Players.PlayerRemoving:Connect(function(player) removeESP(player) end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
