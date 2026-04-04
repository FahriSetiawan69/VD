-- [[ FahriRoundopHUB OFFICIAL LOADER ]] --
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"
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
            func()
        else
            warn("[FR-HUB] Error compile: " .. tostring(err))
        end
    else
        warn("[FR-HUB] 404: Gagal download HomeGui.lua")
    end
end

task.spawn(StartHub)
