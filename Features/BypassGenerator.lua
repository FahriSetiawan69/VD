-- [[ FahriRoundopHUB - Bypass Generator V7.6 (Validated Safety) ]] --
-- Research Data: RagdollConstraints & Knocked Animations

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Survivor = {
    Active = false,
    IsStopping = false,
    LastTarget = nil,
    RepairRemote = ReplicatedStorage.Remotes.Generator.RepairEvent
}

-- [[ FUNGSI SAFETY CHECK BERDASARKAN HASIL SCAN ]] --
local function IsPlayerSafe()
    local Char = Player.Character
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    if not Char or not Hum then return false end
    
    -- 1. Cek folder RagdollConstraints (Hasil Scan 1 & 2)
    if Char:FindFirstChild("RagdollConstraints") then 
        return false 
    end
    
    -- 2. Cek Animasi dengan keyword 'knocked' (Hasil Scan: idleknocked & walkknocked)
    local tracks = Hum:GetPlayingAnimationTracks()
    for _, track in pairs(tracks) do
        if string.find(string.lower(track.Name), "knocked") then
            return false
        end
    end
    
    -- 3. Cek Status Dasar
    if Hum.Health <= 0 or Hum.Sit or Hum.PlatformStand then 
        return false 
    end
    
    return true
end

-- [[ SCANNER TITIK TERDEKAT ]] --
local function getBestInteractionPoint()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    local Root = Character.HumanoidRootPart
    local closestPoint = nil
    local maxDistance = 15 
    
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

-- [[ METATABLE HOOK ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Survivor.Active and method == "FireServer" and self == Survivor.RepairRemote then
        -- Bypass mati jika player terdeteksi Knock atau Digendong
        if not Survivor.IsStopping and IsPlayerSafe() then
            if args[2] == false then
                args[2] = true
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ AUTO-ATTACH LOOP ]] --
task.spawn(function()
    while true do
        task.wait(0.3)
        if Survivor.Active then
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            
            -- Jika kondisi Aman (Tidak Knock/Gendong)
            if Humanoid and IsPlayerSafe() then
                local currentTarget = getBestInteractionPoint()
                
                if Humanoid.MoveDirection.Magnitude == 0 then
                    if currentTarget and not Survivor.LastTarget then
                        Survivor.LastTarget = currentTarget
                        Survivor.RepairRemote:FireServer(currentTarget, true)
                    end
                elseif Humanoid.MoveDirection.Magnitude > 0 then
                    if Survivor.LastTarget then
                        Survivor.IsStopping = true 
                        Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                        task.wait(0.1)
                        Survivor.IsStopping = false
                        Survivor.LastTarget = nil
                        task.wait(0.5)
                    end
                end
            else
                -- JIKA TERDETEKSI KNOCK/GENDONG: Langsung putus koneksi repair
                if Survivor.LastTarget then
                    Survivor.IsStopping = true
                    Survivor.RepairRemote:FireServer(Survivor.LastTarget, false)
                    task.wait(0.1)
                    Survivor.IsStopping = false
                    Survivor.LastTarget = nil
                end
            end
        end
    end
end)

function Survivor:Toggle(state)
    self.Active = state
    if not state then
        Survivor.IsStopping = false
        Survivor.LastTarget = nil
    end
end

_G.FahriSurvivor = Survivor
return Survivor
