-- [[ FahriRoundopHUB OFFICIAL LOADER ]] --
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. Pop-up Hiasan
StarterGui:SetCore("SendNotification", {
    Title = "FahriRoundopHUB",
    Text = "FahriRoundopHUB Execute",
    Duration = 5
})

-- 2. Logika Pemanggilan HomeGui
local function StartHub()
    local targetURL = BaseURL .. "HomeGui.lua"
    local success, content = pcall(function()
        return game:HttpGet(targetURL)
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            print("[FR-HUB] HomeGui Terdeteksi! Menjalankan...")
            func()
        else
            warn("[FR-HUB] Error Compile: " .. tostring(err))
        end
    else
        warn("[FR-HUB] HTTP 404: File tidak ditemukan di " .. targetURL)
    end
end

task.spawn(StartHub)
