-- [[ FahriRoundopHUB - Bypass Generator Engine ]] --
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Survivor = {
    Active = false,
    RepairRemote = ReplicatedStorage.Remotes.Generator.RepairEvent
}

-- Fungsi Smart Scanner (Mencari GeneratorPoint terdekat)
local function getBestInteractionPoint()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local Root = Character.HumanoidRootPart
    local closestPoint = nil
    local maxDistance = 12
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(obj.Name, "GeneratorPoint") then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < maxDistance then
                maxDistance = dist
                closestPoint = obj
            end
        end
    end
    return closestPoint
end

-- METATABLE HOOK (Logic Bypass V6)
-- Hook ini dipasang sekali, tapi aksinya hanya jalan jika Survivor.Active = true
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        
        -- Jika karakter diam (tidak bergerak), lakukan bypass
        if Humanoid and Humanoid.MoveDirection.Magnitude == 0 then
            if args[2] == false then
                args[2] = true -- Ubah Gagal jadi Berhasil
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- SPAM LOOP WITH AUTO-ATTACH
task.spawn(function()
    while true do
        task.wait(0.4)
        if Survivor.Active then
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                local target = getBestInteractionPoint()
                if Humanoid.MoveDirection.Magnitude == 0 then
                    if target then Survivor.RepairRemote:FireServer(target, true) end
                elseif Humanoid.MoveDirection.Magnitude > 0 then
                    if target then Survivor.RepairRemote:FireServer(target, false) end
                    task.wait(0.3)
                end
            end
        end
    end
end)

-- Fungsi Control untuk UI
function Survivor:Toggle(state)
    self.Active = state
    print("[FahriRoundopHUB] Bypass Generator: " .. tostring(state))
end

_G.FahriSurvivor = Survivor
return Survivor
