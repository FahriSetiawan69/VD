-- [[ RiiHUB HOME GUI - Pro Mobile Edition ]] --
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/refs/heads/main/source'))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"

-- 1. FLOATING BUTTON SYSTEM (MINIMIZE)
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
ScreenGui.Name = "RiiHUB_MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = false 

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ImageButton.BackgroundTransparency = 0.2
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 45, 0, 45)
ImageButton.Image = "rbxassetid://4483345998"
ImageButton.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ImageButton

ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    ScreenGui.Enabled = false
end)

-- 2. MAIN WINDOW
local Window = OrionLib:MakeWindow({
    Name = "RiiHUB | Violence District", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "RiiHUB_VD",
    IntroText = "FahriRoundopHUB Loading..."
})

-- TAB VISUALS
local VisualTab = Window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://4483345998" })

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

-- TAB SETTINGS
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://4483345998" })

SettingsTab:AddButton({
    Name = "Minimize (Floating Button)",
    Callback = function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
        ScreenGui.Enabled = true
    end
})

SettingsTab:AddButton({
    Name = "Close Script Total",
    Callback = function()
        OrionLib:Destroy()
        ScreenGui:Destroy()
        _G.ESP_Enabled = false
        _G.ESP_Loaded = nil
    end
})

OrionLib:Init()
