-- [[ FahriRoundopHUB Module: ESP ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateESP(player)
    if player ~= LocalPlayer then
        local function Apply(character)
            task.wait(0.5)
            local highlight = character:FindFirstChild("FR_ESP") or Instance.new("Highlight")
            highlight.Name = "FR_ESP"
            highlight.Parent = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            
            task.spawn(function()
                while character:IsDescendantOf(game) do
                    highlight.Enabled = _G.ESP_Enabled
                    task.wait(0.5)
                end
            end)
        end
        if player.Character then Apply(player.Character) end
        player.CharacterAdded:Connect(Apply)
    end
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
