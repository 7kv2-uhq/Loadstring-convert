--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v8.0 - MOBILE EDITION
    ═══════════════════════════════════════════════════════════════
    Interface optimisée pour mobile et tactile
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- IMPORTS
-- ================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ================================================================
-- VARIABLES
-- ================================================================

local currentUrl = ""
local convertedUrl = ""

-- Détection mobile
local isMobile = UserInputService.TouchEnabled

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
    
    return success
end

-- ================================================================
-- FONCTION DE CONVERSION
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
    ✨ RAW LINK CONVERTER v8.0 - MOBILE EDITION - PARTIE 2/4
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- CRÉATION DE L'INTERFACE
-- ================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RawLinkConverterUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ================================================================
-- MAIN FRAME (plein écran adapté)
-- ================================================================

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Coins arrondis
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 24)
corner.Parent = mainFrame

-- Effet glassmorphism
local glass = Instance.new("Frame")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.93
glass.BorderSizePixel = 0
glass.Parent = mainFrame

-- Bordure néon
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundTransparency = 0.8
border.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
border.BorderSizePixel = 0
border.Parent = mainFrame

-- ================================================================
-- BARRE DE TITRE
-- ================================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 70)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Icône
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 15, 0, 10)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextColor3 = Color3.fromRGB(139, 92, 246)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Parent = titleBar

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0, 35)
title.Position = UDim2.new(0, 75, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Raw Converter"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = false
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Sous-titre
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.6, 0, 0, 20)
subtitle.Position = UDim2.new(0, 75, 0, 42)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Générateur de loadstring"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 190)
subtitle.TextScaled = false
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

-- Bouton fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -55, 0, 12)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v8.0 - MOBILE EDITION - PARTIE 3/4
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- INPUT FIELD (adapté tactile)
-- ================================================================

local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(0.9, 0, 0, 60)
inputContainer.Position = UDim2.new(0.05, 0, 0, 85)
inputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
inputContainer.BackgroundTransparency = 0.4
inputContainer.BorderSizePixel = 2
inputContainer.BorderColor3 = Color3.fromRGB(50, 50, 80)
inputContainer.ClipsDescendants = true
inputContainer.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 16)
inputCorner.Parent = inputContainer

-- Icône input
local inputIcon = Instance.new("TextLabel")
inputIcon.Size = UDim2.new(0, 40, 0, 40)
inputIcon.Position = UDim2.new(0, 15, 0, 10)
inputIcon.BackgroundTransparency = 1
inputIcon.Text = "🔗"
inputIcon.TextColor3 = Color3.fromRGB(160, 160, 190)
inputIcon.TextScaled = true
inputIcon.Font = Enum.Font.Gotham
inputIcon.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -70, 1, 0)
inputBox.Position = UDim2.new(0, 60, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Collez votre lien ici..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 160)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputContainer

-- Focus effect
inputBox.Focused:Connect(function()
    TweenService:Create(inputContainer, TweenInfo.new(0.2), {
        BorderColor3 = Color3.fromRGB(139, 92, 246)
    }):Play()
end)

inputBox.FocusLost:Connect(function()
    TweenService:Create(inputContainer, TweenInfo.new(0.2), {
        BorderColor3 = Color3.fromRGB(50, 50, 80)
    }):Play()
end)

-- ================================================================
-- BOUTONS (grands pour le tactile)
-- ================================================================

local btnY = 165

-- Bouton Convertir
local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(0.42, 0, 0, 55)
convertBtn.Position = UDim2.new(0.05, 0, 0, btnY)
convertBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
convertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
convertBtn.Text = "🔄 Convertir"
convertBtn.TextScaled = false
convertBtn.TextSize = 17
convertBtn.Font = Enum.Font.GothamBold
convertBtn.BorderSizePixel = 0
convertBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 14)
btnCorner1.Parent = convertBtn

-- Bouton Copier
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.42, 0, 0, 55)
copyBtn.Position = UDim2.new(0.53, 0, 0, btnY)
copyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
copyBtn.BackgroundTransparency = 0.3
copyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
copyBtn.Text = "📋 Copier"
copyBtn.TextScaled = false
copyBtn.TextSize = 17
copyBtn.Font = Enum.Font.GothamBold
copyBtn.BorderSizePixel = 2
copyBtn.BorderColor3 = Color3.fromRGB(60, 60, 90)
copyBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 14)
btnCorner2.Parent = copyBtn

-- ================================================================
-- RÉSULTAT
-- ================================================================

local resultContainer = Instance.new("Frame")
resultContainer.Size = UDim2.new(0.9, 0, 0, 140)
resultContainer.Position = UDim2.new(0.05, 0, 0, 240)
resultContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
resultContainer.BackgroundTransparency = 0.3
resultContainer.BorderSizePixel = 2
resultContainer.BorderColor3 = Color3.fromRGB(40, 40, 70)
resultContainer.ClipsDescendants = true
resultContainer.Parent = mainFrame

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 16)
resultCorner.Parent = resultContainer

-- Status icon
local statusIcon = Instance.new("TextLabel")
statusIcon.Size = UDim2.new(0, 45, 0, 45)
statusIcon.Position = UDim2.new(0, 15, 0, 15)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "⏳"
statusIcon.TextColor3 = Color3.fromRGB(160, 160, 190)
statusIcon.TextScaled = true
statusIcon.Font = Enum.Font.Gotham
statusIcon.Parent = resultContainer

-- Result text
local resultText = Instance.new("TextLabel")
resultText.Size = UDim2.new(1, -75, 0, 70)
resultText.Position = UDim2.new(0, 65, 0, 10)
resultText.BackgroundTransparency = 1
resultText.Text = "En attente d'un lien..."
resultText.TextColor3 = Color3.fromRGB(180, 180, 210)
resultText.TextSize = 15
resultText.Font = Enum.Font.Gotham
resultText.TextWrapped = true
resultText.TextXAlignment = Enum.TextXAlignment.Left
resultText.Parent = resultContainer

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -75, 0, 30)
statusText.Position = UDim2.new(0, 65, 0, 95)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Prêt"
statusText.TextColor3 = Color3.fromRGB(52, 211, 153)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = resultContainer

-- ================================================================
-- BARRE DE PROGRESSION
-- ================================================================

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0, 3)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
progressBar.BorderSizePixel = 0
progressBar.Parent = resultContainer

-- ================================================================
-- FOOTER
-- ================================================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 35)
footer.Position = UDim2.new(0, 0, 0, 415)
footer.BackgroundTransparency = 1
footer.Text = "💡 Appuyez pour coller  •  🔄 Convertir  •  📋 Copier"
footer.TextColor3 = Color3.fromRGB(130, 130, 160)
footer.TextSize = 13
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v8.0 - MOBILE EDITION - PARTIE 4/4
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- DRAG & DROP (optimisé mobile)
-- ================================================================

local dragData = {
    dragging = false,
    startPos = nil,
    framePos = nil
}

local function startDrag(input)
    dragData.dragging = true
    dragData.startPos = input.Position
    dragData.framePos = mainFrame.Position
    
    TweenService:Create(mainFrame, TweenInfo.new(0.1), {
        BackgroundTransparency = 0.02
    }):Play()
end

local function endDrag()
    dragData.dragging = false
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.08
    }):Play()
end

-- Tactile
titleBar.TouchBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

titleBar.TouchEnded:Connect(function()
    endDrag()
end)

-- Souris
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                endDrag()
            end
        end)
    end
end)

-- Mouvement
UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging then
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragData.startPos
            mainFrame.Position = UDim2.new(
                dragData.framePos.X.Scale,
                dragData.framePos.X.Offset + delta.X,
                dragData.framePos.Y.Scale,
                dragData.framePos.Y.Offset + delta.Y
            )
        end
    end
end)

-- ================================================================
-- FONCTIONS UI
-- ================================================================

local function animateButton(btn, color)
    local t1 = TweenService:Create(btn, TweenInfo.new(0.1), {
        BackgroundColor3 = color
    })
    t1:Play()
    
    t1.Completed:Connect(function()
        local tBack = TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = btn.BackgroundColor3
        })
        tBack:Play()
    end)
end

local function updateStatus(text, color, iconText)
    statusText.Text = text
    statusText.TextColor3 = color or Color3.fromRGB(52, 211, 153)
    if iconText then
        statusIcon.Text = iconText
        statusIcon.TextColor3 = color or Color3.fromRGB(52, 211, 153)
    end
end

-- ================================================================
-- ÉVÉNEMENTS BOUTONS (compatibles tactile)
-- ================================================================

-- Convertir
convertBtn.MouseButton1Click:Connect(function()
    local url = inputBox.Text
    if url == "" then
        updateStatus("❌ Entrez un lien !", Color3.fromRGB(251, 113, 133), "❌")
        animateButton(convertBtn, Color3.fromRGB(251, 113, 133))
        return
    end
    
    updateStatus("⏳ Conversion...", Color3.fromRGB(251, 191, 36), "⏳")
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(0.5), {
        Size = UDim2.new(0.6, 0, 0, 3)
    })
    progressTween:Play()
    
    local rawUrl, wasRaw = convertToRaw(url)
    convertedUrl = rawUrl
    
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(1, 0, 0, 3)
    }):Play()
    
    task.wait(0.3)
    
    if wasRaw then
        resultText.Text = "✅ Déjà en raw !\n" .. rawUrl
        updateStatus("✅ Lien déjà raw", Color3.fromRGB(52, 211, 153), "✅")
    else
        resultText.Text = "✅ Converti !\n" .. rawUrl
        updateStatus("✅ Converti !", Color3.fromRGB(52, 211, 153), "✅")
    end
    
    animateButton(convertBtn, Color3.fromRGB(52, 211, 153))
    
    task.wait(0.5)
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
end)

-- Copier (avec loadstring)
copyBtn.MouseButton1Click:Connect(function()
    local text = resultText.Text
    if text == "" or text == "En attente d'un lien..." then
        updateStatus("❌ Rien à copier", Color3.fromRGB(251, 113, 133), "❌")
        animateButton(copyBtn, Color3.fromRGB(251, 113, 133))
        return
    end
    
    local url = text:match("https?://[^%s]+")
    if url then
        local loadstringCode = 'loadstring(game:HttpGet("' .. url .. '"))()'
        
        if copyToClipboard(loadstringCode) then
            updateStatus("✅ Loadstring copié !", Color3.fromRGB(100, 200, 255), "✅")
            animateButton(copyBtn, Color3.fromRGB(0, 200, 200))
        else
            updateStatus("❌ Erreur de copie", Color3.fromRGB(251, 113, 133), "❌")
        end
    end
end)

-- Fermer
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

-- ================================================================
-- RACCOURCIS CLAVIER (pour mobile aussi)
-- ================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Entrée pour convertir
    if input.KeyCode == Enum.KeyCode.Return then
        convertBtn.MouseButton1Click:Fire()
    end
end)

-- ================================================================
-- ANIMATION D'APPARITION
-- ================================================================

mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1

TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
    Size = UDim2.new(0.9, 0, 0.8, 0),
    BackgroundTransparency = 0.08
}):Play()

-- ================================================================
-- NOTIFICATION DE BIENVENUE
-- ================================================================

local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0.8, 0, 0, 50)
notification.Position = UDim2.new(0.1, 0, 0, 20)
notification.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
notification.BackgroundTransparency = 0.2
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Text = "⚡ Raw Converter chargé !"
notification.TextSize = 18
notification.Font = Enum.Font.GothamBold
notification.BorderSizePixel = 2
notification.BorderColor3 = Color3.fromRGB(139, 92, 246)
notification.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 14)
notifCorner.Parent = notification

task.wait(2.5)
TweenService:Create(notification, TweenInfo.new(0.5), {
    BackgroundTransparency = 1,
    TextTransparency = 1
}):Play()
task.wait(0.5)
notification:Destroy()

-- ================================================================
-- FIN
-- ================================================================

print("✨ Raw Converter v8.0 chargé !")
print("📱 Optimisé pour mobile")
print("⚡ Loadstring avec game:HttpGet")
