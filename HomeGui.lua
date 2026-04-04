-- [[ FahriRoundopHUB - Fluent Mobile Edition ]] --
-- Developer: FahriSetiawan69

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- 1. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District | Mobile",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 2. FLOATING BUTTON SYSTEM (MOBILE TOGGLE)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- 3. TABS SETUP
local Tabs = {
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "view" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- 4. FEATURES: PLAYER ESP
local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {Title = "Player ESP (Highlight)", Default = false })

ESPToggle:OnChanged(function()
    _G.ESP_Enabled = ESPToggle.Value
    
    if _G.ESP_Loaded == nil then
        _G.ESP_Loaded = true
        Fluent:Notify({
            Title = "System",
            Content = "Mendownload Modul ESP...",
            Duration = 3
        })
        loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
    end
end)

-- 5. AUTOMATIC CLEANUP (Saat Tombol X Bawaan Diklik)
-- Ini memastikan Tombol Melayang hilang saat UI ditutup total
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" or child:FindFirstChild("Main") then
        ScreenGui:Destroy()
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
    end
end)

-- Tab Settings sekarang bisa kamu isi info atau fitur lain nanti
Tabs.Settings:AddParagraph({
    Title = "FahriRoundopHUB Info",
    Content = "Version: 1.0\nStatus: Active\nGame: Violence District"
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "FahriRoundopHUB",
    Content = "Berhasil Dimuat!",
    Duration = 5
})
