-- [[ FahriRoundopHUB OFFICIAL LOADER ]] --
-- Developer: FahriSetiawan69

local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. Pop-up Hiasan
StarterGui:SetCore("SendNotification", {
    Title = "FahriRoundopHUB",
    Text = "FahriRoundopHUB Execute",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

-- 2. Logika Pemanggilan HomeGui
local function StartHub()
    local target = BaseURL .. "HomeGui.lua"
    print("[FR-HUB] Mencoba mendownload: " .. target)
    
    local success, content = pcall(function()
        return game:HttpGet(target)
    end)

    if success and content then
        print("[FR-HUB] HomeGui Terdeteksi! Menjalankan...")
        loadstring(content)()
    else
        warn("[FR-HUB] 404: File tetap tidak ditemukan di link baru.")
    end
end

task.spawn(StartHub)
