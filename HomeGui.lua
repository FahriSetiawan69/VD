-- [[ FahriRoundopHUB - Home UI ]] --
local CoreGui = game:GetService("CoreGui")
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

-- 1. ANTI-DUPLICATE
if CoreGui:FindFirstChild("FR_MobileToggle") then CoreGui.FR_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. FLOATING BUTTON
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
ScreenGui.Name = "FR_MobileToggle"
ScreenGui.Parent = CoreGui
ScreenGui.Enabled = false 
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true 
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- 3. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Violence District",
    TabWidth = 160, Size = UDim2.fromOffset(450, 300),
    Acrylic = true, Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl
})

-- HOOK MINIMIZE
local OriginalMinimize = Window.Minimize
Window.Minimize = function(self)
    OriginalMinimize(self)
    ScreenGui.Enabled = Window.Minimized 
end
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- 4. HELPER: LOAD FEATURES
local function InitESP()
    if _G.FahriESP == nil then loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))() end
    return _G.FahriESP
end

local function InitSurvivor()
    if _G.FahriSurvivor == nil then loadstring(game:HttpGet(BaseURL .. "Features/BypassGenerator.lua"))() end
    return _G.FahriSurvivor
end

-- 5. TABS SETUP
local Tabs = { 
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "view" }),
    Survivor = Window:AddTab({ Title = "Survivor", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- 6. VISUALS TOGGLES
Tabs.Visuals:AddToggle("P_ESP", {Title = "Player ESP", Default = false}):OnChanged(function(v)
    local ESP = InitESP() if ESP then ESP:SetPlayer(v) end
end)
Tabs.Visuals:AddToggle("G_ESP", {Title = "Generator ESP", Default = false}):OnChanged(function(v)
    local ESP = InitESP() if ESP then ESP:SetGenerator(v) end
end)
Tabs.Visuals:AddToggle("Pal_ESP", {Title = "Pallet ESP", Default = false}):OnChanged(function(v)
    local ESP = InitESP() if ESP then ESP:SetPallet(v) end
end)
Tabs.Visuals:AddToggle("Gate_ESP", {Title = "Gate ESP", Default = false}):OnChanged(function(v)
    local ESP = InitESP() if ESP then ESP:SetGate(v) end
end)

-- 7. SURVIVOR TOGGLES
Tabs.Survivor:AddToggle("BypassGen", {Title = "Bypass Generator Check", Default = false}):OnChanged(function(v)
    local Surv = InitSurvivor() if Surv then Surv:Toggle(v) end
end)

-- 8. CLEANUP
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
