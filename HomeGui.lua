-- [[ FahriRoundopHUB - Fluent Auto-Sync Mobile ]] --
-- Developer: FahriSetiawan69

-- 1. ANTI-DUPLICATE (Hapus UI lama jika ada)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("FR_MobileToggle") then CoreGui.FR_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- 2. FLOATING BUTTON SETUP (Awalnya Sembunyi)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Parent = CoreGui
ScreenGui.Enabled = false -- Sembunyi di awal

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0) -- Posisi kiri layar
ToggleButton.Size = UDim2.new(0, 46, 0, 46)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 10)
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

-- [[ LOGIKA AUTO-SYNC TERBARU ]] --
-- Cari frame utama Fluent untuk dideteksi status Visible-nya
local FluentGui = CoreGui:FindFirstChild("Fluent")
local MainFrame = FluentGui and FluentGui:FindFirstChild("Main")

if MainFrame then
    -- Pantau perubahan status Visible pada Menu Utama
    MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        -- Jika Menu Sembunyi, maka Tombol Melayang Muncul (dan sebaliknya)
        ScreenGui.Enabled = not MainFrame.Visible
    end)
end

-- Klik tombol melayang untuk memunculkan kembali menu
ToggleButton.MouseButton1Click:Connect(function()
    Window:Minimize() -- Fungsi bawaan Fluent untuk toggle visibility
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
        Fluent:Notify({Title = "System", Content = "Loading ESP Module...", Duration = 3})
        loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
    end
end)

-- 6. SETTINGS TAB (Informasi Saja)
Tabs.Settings:AddParagraph({
    Title = "FahriRoundopHUB",
    Content = "Version 1.0\nStatus: Optimized for Mobile"
})

-- 7. CLEANUP FINAL
CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" then
        ScreenGui:Destroy()
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
    end
end)

Window:SelectTab(1)
