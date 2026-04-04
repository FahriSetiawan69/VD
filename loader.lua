-- [[ RiiHUB OFFICIAL LOADER - FIXED ]] --
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. Pop-up Hiasan
StarterGui:SetCore("SendNotification", {
    Title = "System Run",
    Text = "FahriRoundopHUB Execute",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

-- 2. Logika Loading
local function StartRiiHUB()
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. "HomeGui.lua")
    end)

    if success and content then
        loadstring(content)()
    else
        warn("[RiiHUB] Gagal mengambil HomeGui.lua! Cek link GitHub kamu.")
    end
end

task.spawn(StartRiiHUB)
