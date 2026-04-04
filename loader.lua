-- [[ FahriRoundopHUB OFFICIAL LOADER ]] --
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. Pop-up Hiasan Sesuai Request
StarterGui:SetCore("SendNotification", {
    Title = "FahriRoundopHUB",
    Text = "FahriRoundopHUB Execute",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

-- 2. Logika Pemanggilan HomeGui
local function StartHub()
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. "HomeGui.lua")
    end)

    if success and content then
        loadstring(content)()
    else
        warn("[FahriRoundopHUB] 404: Gagal mengambil HomeGui.lua. Cek link GitHub!")
    end
end

task.spawn(StartHub)
