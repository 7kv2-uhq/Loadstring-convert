--[[
    ═══════════════════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER - PREMIUM UI (Mobile Optimized)
    Design moderne • Déplaçable • PC + Mobile
    ═══════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ========================
-- VARIABLES
-- ========================
local convertedUrl = ""
local isMobile = UserInputService.TouchEnabled

-- Taille adaptée
local frameWidth = isMobile and 340 or 400
local frameHeight = isMobile and 420 or 460

-- ========================
-- FONCTIONS UTILITAIRES
-- ========================
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

-- ========================
-- CRÉATION UI
-- ========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RawConverterPremium"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(139, 92, 246)
stroke.Thickness = 1.4
stroke.Transparency = 0.35
stroke.Parent = mainFrame

-- ========================
-- TITLE BAR
-- ========================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 54)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 36, 0, 36)
icon.Position = UDim2.new(0, 12, 0, 9)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextSize = 24
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(167, 139, 250)
icon.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.65, 0, 0, 24)
title.Position = UDim2.new(0, 54, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Raw Converter"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.65, 0, 0, 16)
subtitle.Position = UDim2.new(0, 54, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Générateur de loadstring"
subtitle.TextColor3 = Color3.fromRGB(160, 160, 190)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = closeBtn
-- ========================
-- INPUT
-- ========================
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -32, 0, 48)
inputContainer.Position = UDim2.new(0, 16, 0, 66)
inputContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
inputContainer.BackgroundTransparency = 0.25
inputContainer.BorderSizePixel = 0
inputContainer.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 12)
inputCorner.Parent = inputContainer

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(60, 55, 90)
inputStroke.Thickness = 1.1
inputStroke.Transparency = 0.4
inputStroke.Parent = inputContainer

local inputIcon = Instance.new("TextLabel")
inputIcon.Size = UDim2.new(0, 32, 0, 32)
inputIcon.Position = UDim2.new(0, 10, 0, 8)
inputIcon.BackgroundTransparency = 1
inputIcon.Text = "🔗"
inputIcon.TextSize = 18
inputIcon.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -50, 1, 0)
inputBox.Position = UDim2.new(0, 44, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Collez votre lien ici..."
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 155)
inputBox.TextColor3 = Color3.fromRGB(245, 245, 255)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.Parent = inputContainer

-- ========================
-- BOUTONS
-- ========================
local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(0.46, -6, 0, 44)
convertBtn.Position = UDim2.new(0.04, 0, 0, 128)
convertBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
convertBtn.Text = "🔄 Convertir"
convertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
convertBtn.TextSize = 15
convertBtn.Font = Enum.Font.GothamBold
convertBtn.BorderSizePixel = 0
convertBtn.Parent = mainFrame

local convertCorner = Instance.new("UICorner")
convertCorner.CornerRadius = UDim.new(0, 11)
convertCorner.Parent = convertBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.46, -6, 0, 44)
copyBtn.Position = UDim2.new(0.5, 6, 0, 128)
copyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
copyBtn.Text = "📋 Copier"
copyBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
copyBtn.TextSize = 15
copyBtn.Font = Enum.Font.GothamBold
copyBtn.BorderSizePixel = 0
copyBtn.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 11)
copyCorner.Parent = copyBtn

local copyStroke = Instance.new("UIStroke")
copyStroke.Color = Color3.fromRGB(80, 75, 120)
copyStroke.Thickness = 1.1
copyStroke.Transparency = 0.4
copyStroke.Parent = copyBtn

-- ========================
-- RÉSULTAT
-- ========================
local resultContainer = Instance.new("Frame")
resultContainer.Size = UDim2.new(1, -32, 0, 145)
resultContainer.Position = UDim2.new(0, 16, 0, 188)
resultContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 36)
resultContainer.BackgroundTransparency = 0.2
resultContainer.BorderSizePixel = 0
resultContainer.Parent = mainFrame

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 14)
resultCorner.Parent = resultContainer

local resultStroke = Instance.new("UIStroke")
resultStroke.Color = Color3.fromRGB(50, 45, 80)
resultStroke.Thickness = 1.1
resultStroke.Transparency = 0.45
resultStroke.Parent = resultContainer

local statusIcon = Instance.new("TextLabel")
statusIcon.Size = UDim2.new(0, 34, 0, 34)
statusIcon.Position = UDim2.new(0, 12, 0, 12)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "⏳"
statusIcon.TextSize = 20
statusIcon.Parent = resultContainer

local resultText = Instance.new("TextLabel")
resultText.Size = UDim2.new(1, -56, 0, 62)
resultText.Position = UDim2.new(0, 50, 0, 12)
resultText.BackgroundTransparency = 1
resultText.Text = "En attente d'un lien..."
resultText.TextColor3 = Color3.fromRGB(180, 180, 210)
resultText.TextSize = 13
resultText.Font = Enum.Font.Gotham
resultText.TextWrapped = true
resultText.TextXAlignment = Enum.TextXAlignment.Left
resultText.TextYAlignment = Enum.TextYAlignment.Top
resultText.Parent = resultContainer

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -56, 0, 20)
statusText.Position = UDim2.new(0, 50, 0, 85)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ Prêt"
statusText.TextColor3 = Color3.fromRGB(52, 211, 153)
statusText.TextSize = 13
statusText.Font = Enum.Font.GothamMedium
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = resultContainer

-- Progress bar
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -24, 0, 3)
progressBg.Position = UDim2.new(0, 12, 1, -14)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
progressBg.BorderSizePixel = 0
progressBg.Parent = resultContainer

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(1, 0)
progressCorner.Parent = progressBg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBar

-- ========================
-- FOOTER
-- ========================
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 26)
footer.Position = UDim2.new(0, 0, 1, -32)
footer.BackgroundTransparency = 1
footer.Text = "💡 Collez • Convertissez • Copiez"
footer.TextColor3 = Color3.fromRGB(130, 130, 160)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame
-- ========================
-- DRAG SYSTEM (PC + Mobile)
-- ========================
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        TweenService:Create(mainFrame, TweenInfo.new(0.15), {
            BackgroundTransparency = 0
        }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                TweenService:Create(mainFrame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.05
                }):Play()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- ========================
-- FONCTIONS UI
-- ========================
local function updateStatus(text, color, iconEmoji)
    statusText.Text = text
    statusText.TextColor3 = color
    if iconEmoji then
        statusIcon.Text = iconEmoji
    end
end

local function animateButton(btn, targetColor)
    local original = btn.BackgroundColor3
    TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
    task.delay(0.15, function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = original}):Play()
    end)
end

-- ========================
-- ÉVÉNEMENTS
-- ========================
convertBtn.MouseButton1Click:Connect(function()
    local url = inputBox.Text
    if url == "" or url:match("^%s*$") then
        updateStatus("❌ Entrez un lien !", Color3.fromRGB(251, 113, 133), "❌")
        animateButton(convertBtn, Color3.fromRGB(251, 113, 133))
        return
    end
    
    updateStatus("⏳ Conversion...", Color3.fromRGB(251, 191, 36), "⏳")
    
    TweenService:Create(progressBar, TweenInfo.new(0.35), {
        Size = UDim2.new(0.65, 0, 1, 0)
    }):Play()
    
    local rawUrl, wasRaw = convertToRaw(url)
    convertedUrl = rawUrl
    
    task.wait(0.2)
    
    TweenService:Create(progressBar, TweenInfo.new(0.2), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    
    task.wait(0.15)
    
    if wasRaw then
        resultText.Text = "✅ Déjà en raw !\n" .. rawUrl
        updateStatus("✅ Lien déjà raw", Color3.fromRGB(52, 211, 153), "✅")
    else
        resultText.Text = "✅ Converti !\n" .. rawUrl
        updateStatus("✅ Conversion réussie", Color3.fromRGB(52, 211, 153), "✅")
    end
    
    animateButton(convertBtn, Color3.fromRGB(52, 211, 153))
    
    task.wait(0.5)
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
end)

copyBtn.MouseButton1Click:Connect(function()
    if convertedUrl == "" then
        updateStatus("❌ Rien à copier", Color3.fromRGB(251, 113, 133), "❌")
        animateButton(copyBtn, Color3.fromRGB(251, 113, 133))
        return
    end
    
    local loadstringCode = 'loadstring(game:HttpGet("' .. convertedUrl .. '"))()'
    
    if copyToClipboard(loadstringCode) then
        updateStatus("✅ Loadstring copié !", Color3.fromRGB(96, 165, 250), "✅")
        animateButton(copyBtn, Color3.fromRGB(56, 189, 248))
    else
        updateStatus("❌ Impossible de copier", Color3.fromRGB(251, 113, 133), "❌")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    screenGui:Destroy()
end)

-- Focus effect
inputBox.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(139, 92, 246),
        Transparency = 0.1
    }):Play()
end)

inputBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(60, 55, 90),
        Transparency = 0.4
    }):Play()
end)

-- Raccourci Entrée
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Return then
        convertBtn.MouseButton1Click:Fire()
    end
end)

-- ========================
-- ANIMATION D'ENTRÉE
-- ========================
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, frameWidth, 0, frameHeight),
    BackgroundTransparency = 0.05
}):Play()

print("✨ Raw Converter Premium (Mobile Optimized) chargé")
