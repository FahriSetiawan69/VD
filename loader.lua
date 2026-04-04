-- [[ RiiHUB OFFICIAL LOADER + DECORATION ]] --
-- Developer: FahriSetiawan69

local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. HIASAN POP-UP (Akan muncul segera setelah execute)
StarterGui:SetCore("SendNotification", {
    Title = "RiiHUB System",
    Text = "FahriRoundopHUB Execute", -- Teks sesuai permintaanmu
    Duration = 5, -- Muncul selama 5 detik
    Icon = "rbxassetid://4483345998" -- Ikon hiasan (bisa diganti ID lain)
})

print("------------------------------------------")
print("[RiiHUB] FahriRoundopHUB Execute...")
print("[RiiHUB] Menghubungkan ke GitHub...")

-- 2. LOGIKA LOADING HOMEGUI
local function StartRiiHUB()
    local success, scriptContent = pcall(function()
        return game:HttpGet(BaseURL .. "HomeGui.lua")
    end)

    if success and scriptContent then
        local execute, err = loadstring(scriptContent)
        if execute then
            -- Notifikasi kedua (opsional) saat berhasil terhubung
            StarterGui:SetCore("SendNotification", {
                Title = "Connection Success",
                Text = "Memuat Menu Utama...",
                Duration = 3
            })
            execute()
        else
            warn("[RiiHUB] Error dalam script HomeGui: " .. tostring(err))
        end
    else
        warn("[RiiHUB] Gagal mengambil data. Pastikan Repo Public!")
        
        StarterGui:SetCore("SendNotification", {
            Title = "Loader Error",
            Text = "Gagal memuat file dari GitHub.",
            Duration = 5
        })
    end
end

-- Jalankan proses
task.spawn(StartRiiHUB)
print("------------------------------------------")
