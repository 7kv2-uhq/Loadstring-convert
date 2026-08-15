--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v6.0 - HYDRO EDITION
    ═══════════════════════════════════════════════════════════════
    Interface ultra moderne avec Hydro Library
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- CHARGEMENT DE HYDRO
-- ================================================================

local Hydro = loadstring(game:HttpGet("https://raw.githubusercontent.com/hydro-development/Hydro/main/source.lua"))()

-- ================================================================
-- CONFIGURATION
-- ================================================================

local Window = Hydro:CreateWindow({
    Title = "⚡ Raw Link Converter",
    Subtitle = "Générateur de loadstring premium",
    Size = Vector2.new(580, 480),
    Position = Enum.Center,
    Theme = "Dark",
    Transparency = 0.9
})

-- ================================================================
-- VARIABLES GLOBALES
-- ================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local currentUrl = ""
local convertedUrl = ""
local historyList = {}

-- ================================================================
-- FONCTION DE COPIE
-- ================================================================

local function copyToClipboard(text)
    local success = false
    
    if setclipboard then
        success = pcall(function() setclipboard(text) end)
    end
    
    if not success and toclipboard then
        success = pcall(function() toclipboard(text) end)
    end
    
    if not success and Clipboard then
        success = pcall(function() Clipboard = text end)
    end
    
    if not success then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.SetClipboard then
            success = pcall(function() mouse:SetClipboard(text) end)
        end
    end
    
    return success
end

-- ================================================================
-- FONCTIONS DE CONVERSION
-- ================================================================

local function convertToRaw(url)
    url = url:gsub("^%s+", ""):gsub("%s+$", "")
    
    if url:find("raw%.githubusercontent") or 
       url:find("pastebin%.com/raw") or
       url:find("gist%.githubusercontent") then
        return url, true
    end
    
    local patterns = {
        {
            pattern = "github%.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)",
            format = "https://raw.githubusercontent.com/%s/%s/%s/%s"
        },
        {
            pattern = "pastebin%.com/([%w]+)",
            format = "https://pastebin.com/raw/%s"
        },
        {
            pattern = "pastebin%.com/raw/([%w]+)",
            format = "https://pastebin.com/raw/%s"
        },
        {
            pattern = "gist%.github%.com/([^/]+)/([%w]+)",
            format = "https://gist.githubusercontent.com/%s/%s/raw"
        },
        {
            pattern = "gitlab%.com/([^/]+)/([^/]+)/-/blob/([^/]+)/(.+)",
            format = "https://gitlab.com/%s/%s/-/raw/%s/%s"
        }
    }
    
    for _, p in ipairs(patterns) do
        local captures = {url:match(p.pattern)}
        if #captures > 0 then
            return string.format(p.format, unpack(captures)), false
        end
    end
    
    return url, false
end

-- ================================================================
-- FONCTION HISTORIQUE
-- ================================================================

function addToHistory(original, converted)
    table.insert(historyList, 1, {
        original = original,
        converted = converted,
        time = os.date("%H:%M:%S")
    })
    
    if #historyList > 10 then
        table.remove(historyList)
    end
end
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v6.0 - PARTIE 2/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- TAB PRINCIPAL
-- ================================================================

local MainTab = Window:CreateTab({
    Title = "🏠 Accueil",
    Icon = "home"
})

-- ================================================================
-- SECTION : INPUT
-- ================================================================

local InputSection = MainTab:CreateSection({
    Title = "📥 Entrez votre lien"
})

-- Input
local LinkInput = InputSection:CreateInput({
    Title = "Lien à convertir",
    Subtitle = "Collez n'importe quel lien GitHub, Pastebin, Gist...",
    Placeholder = "https://github.com/user/repo/blob/main/script.lua",
    Callback = function(Value)
        currentUrl = Value
    end
})

-- ================================================================
-- SECTION : BOUTONS
-- ================================================================

local ButtonSection = MainTab:CreateSection({
    Title = "⚡ Actions"
})

-- Bouton Convertir
ButtonSection:CreateButton({
    Title = "🔄 Convertir en Raw",
    Subtitle = "Transforme le lien en format raw",
    Callback = function()
        if currentUrl == "" then
            Hydro:Notify({
                Title = "❌ Erreur",
                Content = "Veuillez entrer un lien !",
                Duration = 3
            })
            return
        end
        
        local rawUrl, wasRaw = convertToRaw(currentUrl)
        convertedUrl = rawUrl
        
        addToHistory(currentUrl, rawUrl)
        
        if wasRaw then
            ResultLabel:Set({
                Title = "✅ Déjà en format raw !",
                Subtitle = rawUrl
            })
            Hydro:Notify({
                Title = "✅ Lien déjà raw",
                Content = "Le lien est déjà au bon format",
                Duration = 3
            })
        else
            ResultLabel:Set({
                Title = "✅ Converti avec succès !",
                Subtitle = rawUrl
            })
            Hydro:Notify({
                Title = "✅ Conversion réussie !",
                Content = "Le lien a été converti en raw",
                Duration = 3
            })
        end
        
        -- Mettre à jour l'historique
        UpdateHistory()
    end
})

-- ================================================================
-- SECTION : RÉSULTAT
-- ================================================================

local ResultSection = MainTab:CreateSection({
    Title = "📋 Résultat"
})

-- Label résultat
local ResultLabel = ResultSection:CreateLabel({
    Title = "⏳ En attente d'un lien...",
    Subtitle = "Le résultat apparaîtra ici"
})

-- ================================================================
-- SECTION : ACTIONS SUR LE RÉSULTAT
-- ================================================================

local ActionSection = MainTab:CreateSection({
    Title = "🎯 Actions sur le résultat"
})

-- Bouton Copier URL
ActionSection:CreateButton({
    Title = "📋 Copier l'URL brute",
    Subtitle = "Copie uniquement le lien raw",
    Callback = function()
        if convertedUrl == "" then
            Hydro:Notify({
                Title = "❌ Erreur",
                Content = "Aucun lien à copier !",
                Duration = 3
            })
            return
        end
        
        if copyToClipboard(convertedUrl) then
            Hydro:Notify({
                Title = "✅ Copié !",
                Content = "URL brute copiée dans le presse-papier",
                Duration = 3
            })
        else
            Hydro:Notify({
                Title = "❌ Erreur",
                Content = "Impossible de copier",
                Duration = 3
            })
        end
    end
})

-- Bouton Copier Loadstring (AVEC LE LOADSTRING)
ActionSection:CreateButton({
    Title = "⚡ Copier le loadstring",
    Subtitle = "Copie 'loadstring(game:HttpGet('url'))()'",
    Callback = function()
        if convertedUrl == "" then
            Hydro:Notify({
                Title = "❌ Erreur",
                Content = "Aucun lien à copier !",
                Duration = 3
            })
            return
        end
        
        local loadstringCode = 'loadstring(game:HttpGet("' .. convertedUrl .. '"))()'
        
        if copyToClipboard(loadstringCode) then
            Hydro:Notify({
                Title = "✅ Loadstring copié !",
                Content = "Prêt à être exécuté",
                Duration = 3
            })
        else
            Hydro:Notify({
                Title = "❌ Erreur",
                Content = "Impossible de copier",
                Duration = 3
            })
        end
    end
})
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v6.0 - PARTIE 3/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- TAB : HISTORIQUE
-- ================================================================

local HistoryTab = Window:CreateTab({
    Title = "📜 Historique",
    Icon = "history"
})

local HistorySection = HistoryTab:CreateSection({
    Title = "📋 Derniers liens convertis"
})

-- Label historique
local HistoryLabel = HistorySection:CreateLabel({
    Title = "Aucune conversion",
    Subtitle = "Les liens convertis apparaîtront ici"
})

-- Fonction pour mettre à jour l'historique
function UpdateHistory()
    local text = "🕐 Historique des conversions :\n\n"
    
    if #historyList == 0 then
        text = "Aucune conversion pour le moment"
    else
        for i, item in ipairs(historyList) do
            text = text .. i .. ". " .. item.original .. "\n   → " .. item.converted .. "\n   ⏰ " .. item.time .. "\n\n"
        end
    end
    
    HistoryLabel:Set({
        Title = text,
        Subtitle = #historyList .. " conversions enregistrées"
    })
end

-- ================================================================
-- TAB : PARAMÈTRES
-- ================================================================

local SettingsTab = Window:CreateTab({
    Title = "⚙️ Paramètres",
    Icon = "settings"
})

local SettingsSection = SettingsTab:CreateSection({
    Title = "⚙️ Configuration"
})

-- Toggle : Notifications
SettingsSection:CreateToggle({
    Title = "🔔 Notifications",
    Subtitle = "Afficher les notifications lors des actions",
    Default = true,
    Callback = function(Value)
        Hydro.NotifyEnabled = Value
    end
})

-- ================================================================
-- TAB : À PROPOS
-- ================================================================

local AboutTab = Window:CreateTab({
    Title = "ℹ️ À propos",
    Icon = "info"
})

local AboutSection = AboutTab:CreateSection({
    Title = "ℹ️ Informations"
})

AboutSection:CreateLabel({
    Title = "⚡ Raw Link Converter v6.0",
    Subtitle = "Développé avec Hydro Library\n\n"
        .. "📌 Fonctionnalités :\n"
        .. "• Conversion automatique de liens (GitHub, Pastebin, Gist, GitLab)\n"
        .. "• Copie d'URL brute\n"
        .. "• Copie de loadstring prêt à l'emploi\n"
        .. "• Historique des conversions\n"
        .. "• Interface moderne et fluide\n\n"
        .. "💡 Utilisation :\n"
        .. "1. Collez un lien\n"
        .. "2. Cliquez sur Convertir\n"
        .. "3. Copiez l'URL ou le loadstring\n\n"
        .. "⌨️ Raccourci : Ctrl+Shift+C pour copier le loadstring"
})

-- ================================================================
-- RACCOURCIS CLAVIER GLOBAUX
-- ================================================================

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Ctrl+Shift+C pour copier le loadstring
    if input.KeyCode == Enum.KeyCode.C and 
       UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and
       UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        
        if convertedUrl ~= "" then
            local loadstringCode = 'loadstring(game:HttpGet("' .. convertedUrl .. '"))()'
            if copyToClipboard(loadstringCode) then
                Hydro:Notify({
                    Title = "✅ Loadstring copié !",
                    Content = "Raccourci : Ctrl+Shift+C",
                    Duration = 2
                })
            end
        end
    end
end)

-- ================================================================
-- INITIALISER L'HISTORIQUE
-- ================================================================

addToHistory("https://github.com/example/repo/blob/main/script.lua", "https://raw.githubusercontent.com/example/repo/main/script.lua")
addToHistory("https://pastebin.com/ABC123", "https://pastebin.com/raw/ABC123")
UpdateHistory()

-- ================================================================
-- LANCEMENT
-- ================================================================

print("✨ Raw Link Converter v6.0 chargé avec Hydro !")
print("📋 Raccourci : Ctrl+Shift+C pour copier le loadstring")

-- Notifications de bienvenue
Hydro:Notify({
    Title = "⚡ Raw Link Converter",
    Content = "Interface chargée avec succès !",
    Duration = 3
})

Hydro:Notify({
    Title = "💡 Astuce",
    Content = "Ctrl+Shift+C pour copier le loadstring rapidement",
    Duration = 3
})
