-- [[ FahriRoundopHUB - Home UI ]] --
local CoreGui = game:GetService("CoreGui")
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- ANTI-DUPLICATE
if CoreGui:FindFirstChild("FR_MobileToggle") then CoreGui.FR_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District",
    TabWidth = 160, Size = UDim2.fromOffset(450, 300),
    Acrylic = true, Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl
})

-- MOBILE TOGGLE SYNC
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Enabled = false
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

local OriginalMinimize = Window.Minimize
Window.Minimize = function(self)
    OriginalMinimize(self)
    ScreenGui.Enabled = Window.Minimized 
end
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- FEATURES LOADERS
local function GetESP()
    if _G.FahriESP == nil then loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))() end
    return _G.FahriESP
end

local function GetSurvivor()
    if _G.FahriSurvivor == nil then loadstring(game:HttpGet(BaseURL .. "Features/BypassGenerator.lua"))() end
    return _G.FahriSurvivor
end

-- TABS
local Tabs = {
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "view" }),
    Survivor = Window:AddTab({ Title = "Survivor", Icon = "user" })
}

-- TOGGLES
Tabs.Visuals:AddToggle("P_ESP", {Title = "Player ESP", Default = false}):OnChanged(function(v)
    local E = GetESP() if E then E:SetPlayer(v) end
end)
-- (Tambahkan toggle Gen, Pallet, Gate di sini seperti sebelumnya)

Tabs.Survivor:AddToggle("BypassGen", {Title = "Bypass Generator Check", Default = false}):OnChanged(function(v)
    local S = GetSurvivor() if S then S:Toggle(v) end
end)

Window:SelectTab(1)
