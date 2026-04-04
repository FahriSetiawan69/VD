local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ApplyESP(player)
    if player ~= LocalPlayer then
        local function Create(character)
            task.wait(0.5)
            local highlight = character:FindFirstChild("RiiHUB_Highlight") or Instance.new("Highlight")
            highlight.Name = "RiiHUB_Highlight"
            highlight.Parent = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            
            task.spawn(function()
                while character:IsDescendantOf(game) do
                    highlight.Enabled = _G.ESP_Enabled
                    task.wait(0.5)
                end
            end)
        end
        if player.Character then Create(player.Character) end
        player.CharacterAdded:Connect(Create)
    end
end

for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
Players.PlayerAdded:Connect(ApplyESP)

