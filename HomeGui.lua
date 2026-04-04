-- [[ RiiHUB HOME GUI - Pro Mobile Edition ]] --
-- Developer: FahriSetiawan69

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"

-- 1. PENGATURAN FLOATING BUTTON (MINIMIZE)
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")

ScreenGui.Name = "RiiHUB_MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = false -- Sembunyi di awal

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 1
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0) -- Posisi awal di layar
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Image = "rbxassetid://4483345998" -- Ganti ID ini jika punya logo sendiri
ImageButton.Draggable = true -- Agar bisa digeser-geser di layar HP

-- Fungsi saat Floating Button diklik (Restore)
ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    ScreenGui.Enabled = false
end)

-- 2. MEMBUAT WINDOW UTAMA
local Window = OrionLib:MakeWindow({
    Name = "RiiHUB | Violence District", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "RiiHUB_VD",
    IntroText = "FahriRoundopHUB Loading..."
})

-- TAB VISUALS
local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998"
})

VisualTab:AddToggle({
    Name = "Enable Player ESP",
    Default = false,
    Callback = function(Value)
        _G.ESP_Enabled = Value
        if _G.ESP_Loaded == nil then
            _G.ESP_Loaded = true
            loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
        end
    end    
})

-- TAB SETTINGS (Tempat Minimize & Close)
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998"
})

SettingsTab:AddButton({
    Name = "Minimize to Floating Button",
    Callback = function()
        -- Menutup UI Orion sementara
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
        -- Munculkan tombol melayang
        ScreenGui.Enabled = true
        
        OrionLib:MakeNotification({
            Name = "Minimized",
            Content = "Klik tombol melayang untuk membuka kembali.",
            Time = 3
        })
    end
})

SettingsTab:AddButton({
    Name = "Close Script (Total)",
    Callback = function()
        OrionLib:Destroy() -- Menghapus total UI Orion
        ScreenGui:Destroy() -- Menghapus total Floating Button
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
        
        print("[RiiHUB] Script Closed Successfully.")
    end
})

OrionLib:Init()

