-- [[ FahriRoundopHUB - Fluent Ultra Optimized ]] --
-- Developer: FahriSetiawan69

local CoreGui = game:GetService("CoreGui")

-- 1. ANTI-DUPLICATE
if CoreGui:FindFirstChild("FR_MobileToggle") then CoreGui.FR_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- 2. FLOATING BUTTON SETUP
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Parent = CoreGui
ScreenGui.DisplayOrder = 999
ScreenGui.Enabled = false 

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- 3. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ PRO TIPS: MENGGUNAKAN HOOKING (TANPA LOOP) ]] --
-- Kita membajak fungsi Minimize bawaan agar tombol melayang sinkron otomatis
local OriginalMinimize = Window.Minimize
Window.Minimize = function(self)
    OriginalMinimize(self) -- Jalankan fungsi asli Fluent
    -- Sinkronkan status tombol melayang dengan status Minimize window
    ScreenGui.Enabled = Window.Minimized 
end

-- Klik tombol melayang untuk memunculkan kembali
ToggleButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- 4. TABS SETUP
local Tabs = {
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "view" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- 5. FEATURES: PLAYER ESP
local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {Title = "Player ESP (Highlight)", Default = false })

ESPToggle:OnChanged(function()
    _G.ESP_Enabled = ESPToggle.Value
    if _G.ESP_Loaded == nil then
        _G.ESP_Loaded = true
        loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
    end
end)

-- 6. CLEANUP
CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" then
        ScreenGui:Destroy()
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
    end
end)

Window:SelectTab(1)
