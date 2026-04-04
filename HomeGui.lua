-- [[ FahriRoundopHUB - Home UI (Rayfield Edition) ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/VD/refs/heads/main/"

local Window = Rayfield:CreateWindow({
   Name = "FahriRoundopHUB | Violence District",
   LoadingTitle = "FahriRoundopHUB",
   LoadingSubtitle = "by FahriSetiawan69",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FR_HUB", 
      FileName = "ViolenceDistrict"
   },
   KeySystem = false -- Kita tidak pakai sistem key agar simpel
})

-- TAB VISUALS
local VisualTab = Window:CreateTab("Visuals", 4483345998) -- Ikon Mata

local ESPToggle = VisualTab:CreateToggle({
   Name = "Player ESP (Highlight)",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(Value)
      _G.ESP_Enabled = Value
      if _G.ESP_Loaded == nil then
         _G.ESP_Loaded = true
         -- Memanggil ESP.lua
         loadstring(game:HttpGet(BaseURL .. "Features/ESP.lua"))()
      end
   end,
})

-- TAB SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483345998)

SettingsTab:CreateButton({
   Name = "Minimize Menu",
   Callback = function()
      -- Rayfield punya fitur minimize otomatis (cek tombol di layar)
      Rayfield:Notify({
         Title = "Minimized",
         Content = "Gunakan tombol Rayfield untuk membuka kembali.",
         Duration = 3,
         Image = 4483345998,
      })
   end,
})

SettingsTab:CreateButton({
   Name = "Close Script (Total Destroy)",
   Callback = function()
      Rayfield:Destroy()
      _G.ESP_Enabled = false
      _G.ESP_Loaded = nil
   end,
})

Rayfield:Notify({
   Title = "Success!",
   Content = "FahriRoundopHUB Berhasil Dimuat.",
   Duration = 5,
   Image = 4483345998,
})
