-- [[ FahriRoundopHUB - Home UI (Full Version) ]] --
local CoreGui = game:GetService("CoreGui")
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- ANTI-DUPLICATE
if CoreGui:FindFirstChild("FR_MobileToggle") then CoreGui.FR_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District",
    TabWidth = 160, Size = UDim2.fromOffset(450, 300),
    Acrylic = true, Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl
})

-- 2. MOBILE TOGGLE SYNC
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

-- 3. FEATURES LOADERS
local function GetESP()
    if _G.FahriESP == nil then loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))() end
    return _G.FahriESP
end

local function GetSurvivor()
    if _G.FahriSurvivor == nil then loadstring(game:HttpGet(BaseURL .. "Features/BypassGenerator.lua"))() end
    return _G.FahriSurvivor
end

-- 4. TABS
local Tabs = {
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "view" }),
    Survivor = Window:AddTab({ Title = "Survivor", Icon = "user" })
}

-- 5. VISUALS TOGGLES (Lengkap)
Tabs.Visuals:AddToggle("P_ESP", {Title = "Player ESP", Default = false}):OnChanged(function(v)
    local E = GetESP() if E then E:SetPlayer(v) end
end)
Tabs.Visuals:AddToggle("G_ESP", {Title = "Generator ESP", Default = false}):OnChanged(function(v)
    local E = GetESP() if E then E:SetGenerator(v) end
end)
Tabs.Visuals:AddToggle("Pal_ESP", {Title = "Pallet ESP", Default = false}):OnChanged(function(v)
    local E = GetESP() if E then E:SetPallet(v) end
end)
Tabs.Visuals:AddToggle("Gate_ESP", {Title = "Gate ESP", Default = false}):OnChanged(function(v)
    local E = GetESP() if E then E:SetGate(v) end
end)

-- 6. SURVIVOR TOGGLES
Tabs.Survivor:AddToggle("BypassGen", {Title = "Bypass Generator Check", Default = false}):OnChanged(function(v)
    local S = GetSurvivor() if S then S:Toggle(v) end
end)

-- 7. CLEANUP
CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" then
        ScreenGui:Destroy()
        if _G.FahriESP then _G.FahriESP:DestroyAll() end
        if _G.FahriSurvivor then _G.FahriSurvivor:Toggle(false) end
        _G.FahriESP = nil
        _G.FahriSurvivor = nil
    end
end)

Window:SelectTab(1)
