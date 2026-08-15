--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v5.1 - FLUENT EDITION (CORRIGÉE)
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- CHARGEMENT DE FLUENT
-- ================================================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ================================================================
-- CONFIGURATION
-- ================================================================

local Window = Fluent:CreateWindow({
    Title = "⚡ Raw Link Converter v5.1",
    SubTitle = "Générateur de loadstring premium",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ================================================================
-- VARIABLES GLOBALES
-- ================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local currentUrl = ""
local convertedUrl = ""

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
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v5.1 - PARTIE 2/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- TAB PRINCIPAL
-- ================================================================

local MainTab = Window:AddTab({
    Title = "🏠 Accueil",
    Icon = "home"
})

-- ================================================================
-- SECTION : INPUT
-- ================================================================

local InputSection = MainTab:AddSection({
    Title = "📥 Entrez votre lien"
})

-- Input
local LinkInput = InputSection:AddInput({
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

local ButtonSection = MainTab:AddSection({
    Title = "⚡ Actions"
})

-- Bouton Convertir
ButtonSection:AddButton({
    Title = "🔄 Convertir en Raw",
    Description = "Transforme le lien en format raw",
    Callback = function()
        if currentUrl == "" then
            Fluent:Notify({
                Title = "❌ Erreur",
                Content = "Veuillez entrer un lien !",
                Duration = 3
            })
            return
        end
        
        local rawUrl, wasRaw = convertToRaw(currentUrl)
        convertedUrl = rawUrl
        
        -- Ajouter à l'historique
        addToHistory(currentUrl, rawUrl)
        
        if wasRaw then
            ResultLabel:SetValue("✅ Déjà en format raw !\n" .. rawUrl)
            Fluent:Notify({
                Title = "✅ Lien déjà raw",
                Content = "Le lien est déjà au bon format",
                Duration = 3
            })
        else
            ResultLabel:SetValue("✅ Converti avec succès !\n" .. rawUrl)
            Fluent:Notify({
                Title = "✅ Conversion réussie !",
                Content = "Le lien a été converti en raw",
                Duration = 3
            })
        end
    end
})

-- ================================================================
-- SECTION : RÉSULTAT
-- ================================================================

local ResultSection = MainTab:AddSection({
    Title = "📋 Résultat"
})

-- Label résultat (CORRIGÉ)
local ResultLabel = ResultSection:AddLabel({
    Title = "En attente d'un lien...",
    Description = "Le résultat apparaîtra ici"
})

-- ================================================================
-- SECTION : ACTIONS SUR LE RÉSULTAT
-- ================================================================

local ActionSection = MainTab:AddSection({
    Title = "🎯 Actions sur le résultat"
})

-- Bouton Copier URL
ActionSection:AddButton({
    Title = "📋 Copier l'URL brute",
    Description = "Copie uniquement le lien raw",
    Callback = function()
        if convertedUrl == "" then
            Fluent:Notify({
                Title = "❌ Erreur",
                Content = "Aucun lien à copier !",
                Duration = 3
            })
            return
        end
        
        if copyToClipboard(convertedUrl) then
            Fluent:Notify({
                Title = "✅ Copié !",
                Content = "URL brute copiée dans le presse-papier",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "❌ Erreur",
                Content = "Impossible de copier",
                Duration = 3
            })
        end
    end
})

-- Bouton Copier Loadstring (AVEC LE LOADSTRING)
ActionSection:AddButton({
    Title = "⚡ Copier le loadstring",
    Description = "Copie 'loadstring(game:HttpGet('url'))()'",
    Callback = function()
        if convertedUrl == "" then
            Fluent:Notify({
                Title = "❌ Erreur",
                Content = "Aucun lien à copier !",
                Duration = 3
            })
            return
        end
        
        local loadstringCode = 'loadstring(game:HttpGet("' .. convertedUrl .. '"))()'
        
        if copyToClipboard(loadstringCode) then
            Fluent:Notify({
                Title = "✅ Loadstring copié !",
                Content = "Prêt à être exécuté",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "❌ Erreur",
                Content = "Impossible de copier",
                Duration = 3
            })
        end
    end
})
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v5.1 - PARTIE 3/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- TAB : HISTORIQUE
-- ================================================================

local HistoryTab = Window:AddTab({
    Title = "📜 Historique",
    Icon = "history"
})

local HistorySection = HistoryTab:AddSection({
    Title = "📋 Derniers liens convertis"
})

local historyList = {}
local HistoryLabel

-- Fonction pour ajouter à l'historique (CORRIGÉE)
function addToHistory(original, converted)
    table.insert(historyList, 1, {
        original = original,
        converted = converted,
        time = os.date("%H:%M:%S")
    })
    
    if #historyList > 10 then
        table.remove(historyList)
    end
    
    -- Mettre à jour l'affichage
    local text = "🕐 Historique des conversions :\n\n"
    for i, item in ipairs(historyList) do
        text = text .. i .. ". " .. item.original .. "\n   → " .. item.converted .. "\n   ⏰ " .. item.time .. "\n\n"
    end
    
    if #historyList == 0 then
        text = "Aucune conversion pour le moment"
    end
    
    -- Mettre à jour le label
    if HistoryLabel then
        HistoryLabel:SetValue(text)
    end
end

-- Créer le label d'historique (CORRIGÉ)
HistoryLabel = HistorySection:AddLabel({
    Title = "Aucune conversion",
    Description = "Les liens convertis apparaîtront ici"
})

-- ================================================================
-- TAB : PARAMÈTRES
-- ================================================================

local SettingsTab = Window:AddTab({
    Title = "⚙️ Paramètres",
    Icon = "settings"
})

local SettingsSection = SettingsTab:AddSection({
    Title = "⚙️ Configuration"
})

-- Toggle : Notifications
SettingsSection:AddToggle({
    Title = "🔔 Notifications",
    Description = "Afficher les notifications lors des actions",
    Default = true,
    Callback = function(Value)
        Fluent.NotifyEnabled = Value
    end
})

-- Toggle : Design moderne
SettingsSection:AddToggle({
    Title = "✨ Design moderne",
    Description = "Activer l'effet acrylique / glassmorphism",
    Default = true,
    Callback = function(Value)
        Window.Acrylic = Value
    end
})

-- ================================================================
-- TAB : À PROPOS
-- ================================================================

local AboutTab = Window:AddTab({
    Title = "ℹ️ À propos",
    Icon = "info"
})

local AboutSection = AboutTab:AddSection({
    Title = "ℹ️ Informations"
})

AboutSection:AddLabel({
    Title = "⚡ Raw Link Converter v5.1",
    Description = "Développé avec Fluent Library\n\n"
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
                Fluent:Notify({
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

-- ================================================================
-- LANCEMENT
-- ================================================================

print("✨ Raw Link Converter v5.1 chargé avec Fluent !")
print("📋 Raccourci : Ctrl+Shift+C pour copier le loadstring")

-- Notifications de bienvenue
Fluent:Notify({
    Title = "⚡ Raw Link Converter",
    Content = "Interface chargée avec succès !",
    Duration = 3
})

Fluent:Notify({
    Title = "💡 Astuce",
    Content = "Ctrl+Shift+C pour copier le loadstring rapidement",
    Duration = 3
})
