-- [[ FahriRoundopHUB - Fluent Pro Mobile Final ]] --
-- Developer: FahriSetiawan69

-- 1. ANTI-DUPLICATE (Hapus UI lama jika re-execute)
if game:GetService("CoreGui"):FindFirstChild("FR_MobileToggle") then
    game:GetService("CoreGui").FR_MobileToggle:Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("Fluent") then
    game:GetService("CoreGui").Fluent:Destroy()
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- 2. FLOATING BUTTON SETUP (Awalnya Sembunyi)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = false -- Sembunyi saat menu sedang terbuka

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- 3. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District | Mobile",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- FUNGSI UNTUK TUKAR TAMPILAN (Toggle)
local function ToggleMenu()
    Window:Minimize() -- Minimize/Maximize menu Fluent
    ScreenGui.Enabled = not ScreenGui.Enabled -- Tukar status tombol melayang
end

-- Klik tombol melayang untuk buka menu
ToggleButton.MouseButton1Click:Connect(ToggleMenu)

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
        Fluent:Notify({
            Title = "System",
            Content = "Mendownload Modul ESP...",
            Duration = 3
        })
        loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
    end
end)

-- 6. SETTINGS: MINIMIZE & INFO
Tabs.Settings:AddButton({
    Title = "Minimize Menu",
    Description = "Sembunyikan menu dan munculkan tombol melayang",
    Callback = function()
        ToggleMenu() -- Panggil fungsi tukar tampilan
    end
})

Tabs.Settings:AddParagraph({
    Title = "FahriRoundopHUB Info",
    Content = "Gunakan tombol melayang di kiri untuk membuka kembali menu."
})

-- 7. CLEANUP SAAT TOMBOL CLOSE (X) DIKLIK
-- Karena Fluent punya pop-up konfirmasi, kita deteksi saat UI benar-benar dihapus
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" or child:FindFirstChild("Main") then
        ScreenGui:Destroy() -- Hapus tombol melayang selamanya
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
    end
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "FahriRoundopHUB",
    Content = "Script Ready! Gunakan Tab Settings untuk Minimize.",
    Duration = 5
})
