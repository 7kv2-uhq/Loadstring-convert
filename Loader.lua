--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v7.0 - ULTIMATE EDITION - PARTIE 1/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- IMPORTS
-- ================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ================================================================
-- VARIABLES
-- ================================================================

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
    ✨ RAW LINK CONVERTER v7.0 - ULTIMATE EDITION - PARTIE 2/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- CRÉATION DE L'INTERFACE
-- ================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RawLinkConverterUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ================================================================
-- MAIN FRAME
-- ================================================================

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 480)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

local glass = Instance.new("Frame")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.92
glass.BorderSizePixel = 0
glass.Parent = mainFrame

local border = Instance.new("Frame")
border.Size = UDim2.new(1, 2, 1, 2)
border.Position = UDim2.new(0, -1, 0, -1)
border.BackgroundTransparency = 0.7
border.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
border.BorderSizePixel = 0
border.Parent = mainFrame

local gradientBar = Instance.new("Frame")
gradientBar.Size = UDim2.new(1, 0, 0, 3)
gradientBar.Position = UDim2.new(0, 0, 0, 0)
gradientBar.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
gradientBar.BorderSizePixel = 0
gradientBar.Parent = mainFrame

-- ================================================================
-- BARRE DE TITRE
-- ================================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 45, 0, 45)
icon.Position = UDim2.new(0, 15, 0, 8)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextColor3 = Color3.fromRGB(129, 140, 248)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 250, 0, 28)
title.Position = UDim2.new(0, 65, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Raw Link Converter"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = false
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 250, 0, 16)
subtitle.Position = UDim2.new(0, 65, 0, 38)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Générateur de loadstring premium"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
subtitle.TextScaled = false
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -48, 0, 11)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- ================================================================
-- INPUT
-- ================================================================

local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(0.9, 0, 0, 50)
inputContainer.Position = UDim2.new(0.05, 0, 0, 80)
inputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
inputContainer.BackgroundTransparency = 0.5
inputContainer.BorderSizePixel = 1
inputContainer.BorderColor3 = Color3.fromRGB(60, 60, 80)
inputContainer.ClipsDescendants = true
inputContainer.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 12)
inputCorner.Parent = inputContainer

local inputIcon = Instance.new("TextLabel")
inputIcon.Size = UDim2.new(0, 35, 0, 35)
inputIcon.Position = UDim2.new(0, 12, 0, 8)
inputIcon.BackgroundTransparency = 1
inputIcon.Text = "🔗"
inputIcon.TextColor3 = Color3.fromRGB(150, 150, 180)
inputIcon.TextScaled = true
inputIcon.Font = Enum.Font.Gotham
inputIcon.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -55, 1, 0)
inputBox.Position = UDim2.new(0, 50, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Collez votre lien ici..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputContainer

-- ================================================================
-- BOUTONS
-- ================================================================

local btnY = 150

local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(0.42, 0, 0, 48)
convertBtn.Position = UDim2.new(0.05, 0, 0, btnY)
convertBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
convertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
convertBtn.Text = "🔄 Convertir"
convertBtn.TextScaled = false
convertBtn.TextSize = 16
convertBtn.Font = Enum.Font.GothamBold
convertBtn.BorderSizePixel = 0
convertBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 10)
btnCorner1.Parent = convertBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.42, 0, 0, 48)
copyBtn.Position = UDim2.new(0.53, 0, 0, btnY)
copyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
copyBtn.BackgroundTransparency = 0.3
copyBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
copyBtn.Text = "📋 Copier"
copyBtn.TextScaled = false
copyBtn.TextSize = 16
copyBtn.Font = Enum.Font.GothamBold
copyBtn.BorderSizePixel = 1
copyBtn.BorderColor3 = Color3.fromRGB(60, 60, 80)
copyBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 10)
btnCorner2.Parent = copyBtn

-- ================================================================
-- RÉSULTAT
-- ================================================================

local resultContainer = Instance.new("Frame")
resultContainer.Size = UDim2.new(0.9, 0, 0, 120)
resultContainer.Position = UDim2.new(0.05, 0, 0, 218)
resultContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
resultContainer.BackgroundTransparency = 0.3
resultContainer.BorderSizePixel = 1
resultContainer.BorderColor3 = Color3.fromRGB(60, 60, 80)
resultContainer.ClipsDescendants = true
resultContainer.Parent = mainFrame

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 12)
resultCorner.Parent = resultContainer

local statusIcon = Instance.new("TextLabel")
statusIcon.Size = UDim2.new(0, 40, 0, 40)
statusIcon.Position = UDim2.new(0, 15, 0, 15)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "⏳"
statusIcon.TextColor3 = Color3.fromRGB(150, 150, 180)
statusIcon.TextScaled = true
statusIcon.Font = Enum.Font.Gotham
statusIcon.Parent = resultContainer

local resultText = Instance.new("TextLabel")
resultText.Size = UDim2.new(1, -70, 0, 60)
resultText.Position = UDim2.new(0, 60, 0, 12)
resultText.BackgroundTransparency = 1
resultText.Text = "En attente d'un lien..."
resultText.TextColor3 = Color3.fromRGB(180, 180, 200)
resultText.TextSize = 13
resultText.Font = Enum.Font.Gotham
resultText.TextWrapped = true
resultText.TextXAlignment = Enum.TextXAlignment.Left
resultText.Parent = resultContainer

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -70, 0, 25)
statusText.Position = UDim2.new(0, 60, 0, 80)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Prêt"
statusText.TextColor3 = Color3.fromRGB(52, 211, 153)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = resultContainer

-- ================================================================
-- BARRE DE PROGRESSION
-- ================================================================

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0, 2)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
progressBar.BorderSizePixel = 0
progressBar.Parent = resultContainer

-- ================================================================
-- FOOTER
-- ================================================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 0, 440)
footer.BackgroundTransparency = 1
footer.Text = "💡 Ctrl+V pour coller  •  Entrée pour convertir  •  Glissez pour déplacer"
footer.TextColor3 = Color3.fromRGB(120, 120, 140)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame
--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v7.0 - ULTIMATE EDITION - PARTIE 3/3
    ═══════════════════════════════════════════════════════════════
]]

-- ================================================================
-- DRAG & DROP
-- ================================================================

local dragData = {
    dragging = false,
    startMouse = nil,
    framePos = nil
}

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startMouse = input.Position
        dragData.framePos = mainFrame.Position
        
        TweenService:Create(mainFrame, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.02
        }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragData.dragging = false
                TweenService:Create(mainFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.05
                }):Play()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragData.startMouse
        mainFrame.Position = UDim2.new(
            dragData.framePos.X.Scale,
            dragData.framePos.X.Offset + delta.X,
            dragData.framePos.Y.Scale,
            dragData.framePos.Y.Offset + delta.Y
        )
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
-- ÉVÉNEMENTS BOUTONS
-- ================================================================

-- Convertir
convertBtn.MouseButton1Click:Connect(function()
    local url = inputBox.Text
    if url == "" then
        updateStatus("❌ Veuillez entrer un lien !", Color3.fromRGB(251, 113, 133), "❌")
        animateButton(convertBtn, Color3.fromRGB(251, 113, 133))
        return
    end
    
    updateStatus("⏳ Conversion en cours...", Color3.fromRGB(251, 191, 36), "⏳")
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(0.5), {
        Size = UDim2.new(0.6, 0, 0, 2)
    })
    progressTween:Play()
    
    local rawUrl, wasRaw = convertToRaw(url)
    convertedUrl = rawUrl
    
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(1, 0, 0, 2)
    }):Play()
    
    task.wait(0.3)
    
    if wasRaw then
        resultText.Text = "✅ Déjà en format raw !\n" .. rawUrl
        updateStatus("✅ Lien déjà raw", Color3.fromRGB(52, 211, 153), "✅")
    else
        resultText.Text = "🔄 Converti avec succès !\n" .. rawUrl
        updateStatus("✅ Conversion réussie", Color3.fromRGB(52, 211, 153), "✅")
    end
    
    animateButton(convertBtn, Color3.fromRGB(52, 211, 153))
    
    task.wait(0.5)
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()
end)

-- Copier (AVEC LOADSTRING)
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
            updateStatus("📋 Loadstring copié !", Color3.fromRGB(100, 200, 255), "📋")
            animateButton(copyBtn, Color3.fromRGB(0, 200, 200))
            
            local origColor = copyBtn.TextColor3
            TweenService:Create(copyBtn, TweenInfo.new(0.1), {
                TextColor3 = Color3.fromRGB(0, 255, 200)
            }):Play()
            task.wait(0.2)
            TweenService:Create(copyBtn, TweenInfo.new(0.2), {
                TextColor3 = origColor
            }):Play()
        else
            updateStatus("❌ Erreur de copie", Color3.fromRGB(251, 113, 133), "❌")
        end
    end
end)

-- Fermer
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(251, 113, 133)
    }):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(180, 180, 200)
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

-- ================================================================
-- RACCOURCIS CLAVIER
-- ================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Ctrl+V pour coller
    if input.KeyCode == Enum.KeyCode.V and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.GetClipboard then
            local text = mouse:GetClipboard()
            if text and text:find("http") then
                inputBox.Text = text
                updateStatus("📋 Lien collé !", Color3.fromRGB(100, 200, 255), "📋")
            end
        end
    end
    
    -- Entrée pour convertir
    if input.KeyCode == Enum.KeyCode.Return then
        convertBtn.MouseButton1Click:Fire()
    end
    
    -- Ctrl+Shift+C pour copier le loadstring
    if input.KeyCode == Enum.KeyCode.C and 
       UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and
       UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        
        if convertedUrl ~= "" then
            local loadstringCode = 'loadstring(game:HttpGet("' .. convertedUrl .. '"))()'
            if copyToClipboard(loadstringCode) then
                updateStatus("📋 Loadstring copié ! (Ctrl+Shift+C)", Color3.fromRGB(100, 200, 255), "📋")
            end
        end
    end
end)

-- ================================================================
-- ANIMATION D'APPARITION
-- ================================================================

mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 520, 0, 480),
    BackgroundTransparency = 0.05
}):Play()

-- ================================================================
-- NOTIFICATION DE BIENVENUE
-- ================================================================

local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 300, 0, 40)
notification.Position = UDim2.new(0.5, -150, 0, 20)
notification.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
notification.BackgroundTransparency = 0.3
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Text = "✨ Raw Link Converter chargé !"
notification.TextSize = 16
notification.Font = Enum.Font.GothamBold
notification.BorderSizePixel = 1
notification.BorderColor3 = Color3.fromRGB(99, 102, 241)
notification.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notification

task.wait(3)
TweenService:Create(notification, TweenInfo.new(0.5), {
    BackgroundTransparency = 1,
    TextTransparency = 1
}):Play()
task.wait(0.5)
notification:Destroy()

-- ================================================================
-- MESSAGES FINAUX
-- ================================================================

print("✨ Raw Link Converter v7.0 chargé !")
print("📋 Ctrl+V pour coller | Entrée pour convertir")
print("⚡ Ctrl+Shift+C pour copier le loadstring")
