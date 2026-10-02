--[[
    ╔══════════════════════════════════════════════════════════╗
    ║       DEV MASTER - DUCANHTECH OFFICIAL LOADER            ║
    ║       Direct GitHub Raw Bootstrap Engine                 ║
    ╚══════════════════════════════════════════════════════════╝
]]

-- URL GitHub Raw chính thức từ DucAnhTech
local PC_SCRIPT_URL     = "https://raw.githubusercontent.com/DucAnhTech/pcscript/refs/heads/main/pc.lua"
local MOBILE_SCRIPT_URL = "https://raw.githubusercontent.com/DucAnhTech/mobilescript/refs/heads/main/mobile.lua"

-- Dọn dẹp phiên làm việc cũ nếu đang chạy
if _G.DevMasterUnload then pcall(_G.DevMasterUnload) end
if _G.DevMasterMobileUnload then pcall(_G.DevMasterMobileUnload) end
if _G.DevMasterLoaderUnload then pcall(_G.DevMasterLoaderUnload) end

local Svc = {
    UIS     = game:GetService("UserInputService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    Tween   = game:GetService("TweenService"),
}

local LP = Svc.Players.LocalPlayer or Svc.Players.PlayerAdded:Wait()
local get_hidden_gui = get_hidden_gui or gethui or function() return Svc.CoreGui end
local targetParent = (pcall(get_hidden_gui) and get_hidden_gui()) or Svc.CoreGui or LP:WaitForChild("PlayerGui")

local syn = syn or {}
syn.protect_gui = syn.protect_gui or function(g) return g end

-- Khởi tạo Giao diện Loader
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "DucAnhTechLoader"
loaderGui.ResetOnSpawn = false
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.Parent = targetParent
syn.protect_gui(loaderGui)

local function closeLoader()
    if loaderGui and loaderGui.Parent then
        loaderGui:Destroy()
    end
end
_G.DevMasterLoaderUnload = closeLoader

local frame = Instance.new("Frame", loaderGui)
frame.Size = UDim2.new(0, 360, 0, 230)
frame.Position = UDim2.new(0.5, -180, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 185, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

-- Kéo thả hỗ trợ cả Chuột và Cảm ứng
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = frame.Position
    end
end)
Svc.UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Svc.UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 32)
title.Position = UDim2.new(0, 0, 0, 14)
title.BackgroundTransparency = 1
title.Text = "⚡ DEV MASTER CLOUD LOADER"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center

local subTitle = Instance.new("TextLabel", frame)
subTitle.Size = UDim2.new(1, 0, 0, 18)
subTitle.Position = UDim2.new(0, 0, 0, 42)
subTitle.BackgroundTransparency = 1
subTitle.Text = "by DucAnhTech · Select Edition"
subTitle.TextColor3 = Color3.fromRGB(120, 135, 160)
subTitle.Font = Enum.Font.Gotham
subTitle.TextSize = 11
subTitle.TextXAlignment = Enum.TextXAlignment.Center

local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Size = UDim2.new(1, 0, 0, 20)
statusLbl.Position = UDim2.new(0, 0, 1, -26)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Ready to connect"
statusLbl.TextColor3 = Color3.fromRGB(90, 105, 130)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Center

-- Nút đóng
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 25)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(240, 70, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(closeLoader)

-- Khung chứa 2 nút chọn
local btnContainer = Instance.new("Frame", frame)
btnContainer.Size = UDim2.new(1, -32, 0, 120)
btnContainer.Position = UDim2.new(0, 16, 0, 72)
btnContainer.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", btnContainer)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 12)

local function makeChoiceButton(icon, label, subText, accentColor)
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(0.48, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
    btn.Text = ""
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(30, 45, 70)
    btnStroke.Thickness = 1

    local icn = Instance.new("TextLabel", btn)
    icn.Size = UDim2.new(1, 0, 0, 36)
    icn.Position = UDim2.new(0, 0, 0, 10)
    icn.BackgroundTransparency = 1
    icn.Text = icon
    icn.TextSize = 26
    icn.Font = Enum.Font.GothamBold

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, 48)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = accentColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12

    local sub = Instance.new("TextLabel", btn)
    sub.Size = UDim2.new(1, -12, 0, 34)
    sub.Position = UDim2.new(0, 6, 0, 70)
    sub.BackgroundTransparency = 1
    sub.Text = subText
    sub.TextColor3 = Color3.fromRGB(120, 130, 150)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9
    sub.TextWrapped = true

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(24, 35, 55) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(18, 24, 38) end)

    return btn
end

local pcBtn  = makeChoiceButton("💻", "PC Edition", "Keyboard & Mouse\nFull Extended GUI", Color3.fromRGB(0, 200, 255))
local mobBtn = makeChoiceButton("📱", "Mobile Edition", "Touch Joystick Fly\nOn-Screen Aim Button", Color3.fromRGB(0, 220, 130))

-- Hàm tải và nạp mã nguồn từ GitHub Raw
local function fetchAndRun(url, editionName)
    statusLbl.Text = "Fetching " .. editionName .. " from GitHub..."
    statusLbl.TextColor3 = Color3.fromRGB(230, 180, 0)

    task.spawn(function()
        local success, code = pcall(function()
            -- Thêm query string tránh cache proxy
            return game:HttpGet(url .. "?t=" .. tostring(tick()))
        end)

        if success and code and #code > 0 then
            statusLbl.Text = "Launching " .. editionName .. "..."
            statusLbl.TextColor3 = Color3.fromRGB(0, 220, 130)
            task.wait(0.2)
            closeLoader()
            local runOk, runErr = pcall(function()
                loadstring(code)()
            end)
            if not runOk then
                warn("[DucAnhTech Loader Execution Error]: " .. tostring(runErr))
            end
        else
            statusLbl.Text = "Failed to load! Check your internet or GitHub."
            statusLbl.TextColor3 = Color3.fromRGB(240, 70, 80)
            task.wait(2.5)
            statusLbl.Text = "Ready to connect"
            statusLbl.TextColor3 = Color3.fromRGB(90, 105, 130)
        end
    end)
end

pcBtn.MouseButton1Click:Connect(function()
    fetchAndRun(PC_SCRIPT_URL, "PC Edition")
end)

mobBtn.MouseButton1Click:Connect(function()
    fetchAndRun(MOBILE_SCRIPT_URL, "Mobile Edition")
end)

print("⚡ DucAnhTech Dual Loader initialized.")
