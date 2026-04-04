-- [[ FahriRoundopHUB OFFICIAL LOADER ]] --
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "FahriRoundopHUB",
    Text = "FahriRoundopHUB Execute",
    Duration = 5
})

local function StartHub()
    local target = BaseURL .. "HomeGui.lua"
    local success, content = pcall(function()
        return game:HttpGet(target)
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            print("[FR-HUB] HomeGui Terdeteksi! Menjalankan...")
            func()
        else
            warn("[FR-HUB] Error di dalam file HomeGui: " .. tostring(err))
        end
    else
        warn("[FR-HUB] 404: Gagal mendownload HomeGui.lua")
    end
end

task.spawn(StartHub)
