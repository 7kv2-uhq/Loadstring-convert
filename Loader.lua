--[[
    ═══════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v4.0 - PARTIE 1/3
    ═══════════════════════════════════════════════════
]]

-- ====================================================
-- IMPORTS
-- ====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ====================================================
-- FONCTION DE COPIE
-- ====================================================

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

-- ====================================================
-- COULEURS
-- ====================================================

local THEME = {
    Primary = Color3.fromRGB(99, 102, 241),
    PrimaryLight = Color3.fromRGB(129, 140, 248),
    Background = Color3.fromRGB(15, 15, 25),
    Surface = Color3.fromRGB(25, 25, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    TextDim = Color3.fromRGB(120, 120, 140),
    Success = Color3.fromRGB(52, 211, 153),
    Error = Color3.fromRGB(251, 113, 133),
    Warning = Color3.fromRGB(251, 191, 36),
    Border = Color3.fromRGB(60, 60, 90),
}

-- ====================================================
-- CONVERSION
-- ====================================================

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
    ═══════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v4.0 - PARTIE 2/3
    ═══════════════════════════════════════════════════
]]

-- ====================================================
-- CRÉATION DE L'UI
-- ====================================================

local function createUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RawLinkConverterUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
    mainFrame.BackgroundColor3 = THEME.Background
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = THEME.Border
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = mainFrame
    
    local glass = Instance.new("Frame")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = 0.94
    glass.BorderSizePixel = 0
    glass.Parent = mainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 3)
    topBar.BackgroundColor3 = THEME.Primary
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    -- ====================================================
    -- BARRE DE TITRE
    -- ====================================================
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 35, 0, 35)
    icon.Position = UDim2.new(0, 15, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = THEME.PrimaryLight
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 25)
    title.Position = UDim2.new(0, 55, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Raw Link Converter"
    title.TextColor3 = THEME.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 200, 0, 15)
    sub.Position = UDim2.new(0, 55, 0, 30)
    sub.BackgroundTransparency = 1
    sub.Text = "Générateur de loadstring"
    sub.TextColor3 = THEME.TextDim
    sub.TextSize = 10
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    -- ====================================================
    -- INPUT
    -- ====================================================
    
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(0.9, 0, 0, 45)
    inputContainer.Position = UDim2.new(0.05, 0, 0, 65)
    inputContainer.BackgroundColor3 = THEME.Surface
    inputContainer.BackgroundTransparency = 0.5
    inputContainer.BorderSizePixel = 1
    inputContainer.BorderColor3 = THEME.Border
    inputContainer.ClipsDescendants = true
    inputContainer.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputContainer
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 1, 0)
    inputBox.Position = UDim2.new(0, 10, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "🔗 Collez votre lien ici..."
    inputBox.TextColor3 = THEME.Text
    inputBox.PlaceholderColor3 = THEME.TextDim
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputContainer
    
    -- ====================================================
    -- BOUTONS
    -- ====================================================
    
    local convertBtn = Instance.new("TextButton")
    convertBtn.Size = UDim2.new(0.42, 0, 0, 42)
    convertBtn.Position = UDim2.new(0.05, 0, 0, 125)
    convertBtn.BackgroundColor3 = THEME.Primary
    convertBtn.TextColor3 = THEME.Text
    convertBtn.Text = "🔄 Convertir"
    convertBtn.TextSize = 15
    convertBtn.Font = Enum.Font.GothamBold
    convertBtn.BorderSizePixel = 0
    convertBtn.Parent = mainFrame
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 10)
    btnCorner1.Parent = convertBtn
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.42, 0, 0, 42)
    copyBtn.Position = UDim2.new(0.53, 0, 0, 125)
    copyBtn.BackgroundColor3 = THEME.Surface
    copyBtn.BackgroundTransparency = 0.3
    copyBtn.TextColor3 = THEME.TextSecondary
    copyBtn.Text = "📋 Copier"
    copyBtn.TextSize = 15
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BorderSizePixel = 1
    copyBtn.BorderColor3 = THEME.Border
    copyBtn.Parent = mainFrame
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 10)
    btnCorner2.Parent = copyBtn
    
    -- ====================================================
    -- RÉSULTAT
    -- ====================================================
    
    local resultContainer = Instance.new("Frame")
    resultContainer.Size = UDim2.new(0.9, 0, 0, 100)
    resultContainer.Position = UDim2.new(0.05, 0, 0, 185)
    resultContainer.BackgroundColor3 = THEME.Surface
    resultContainer.BackgroundTransparency = 0.3
    resultContainer.BorderSizePixel = 1
    resultContainer.BorderColor3 = THEME.Border
    resultContainer.ClipsDescendants = true
    resultContainer.Parent = mainFrame
    
    local resultCorner = Instance.new("UICorner")
    resultCorner.CornerRadius = UDim.new(0, 10)
    resultCorner.Parent = resultContainer
    
    local resultText = Instance.new("TextLabel")
    resultText.Size = UDim2.new(1, -20, 0, 50)
    resultText.Position = UDim2.new(0, 10, 0, 10)
    resultText.BackgroundTransparency = 1
    resultText.Text = "⏳ En attente d'un lien..."
    resultText.TextColor3 = THEME.TextSecondary
    resultText.TextSize = 13
    resultText.Font = Enum.Font.Gotham
    resultText.TextWrapped = true
    resultText.TextXAlignment = Enum.TextXAlignment.Center
    resultText.Parent = resultContainer
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -20, 0, 25)
    statusText.Position = UDim2.new(0, 10, 0, 65)
    statusText.BackgroundTransparency = 1
    statusText.Text = "✅ Prêt"
    statusText.TextColor3 = THEME.Success
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Center
    statusText.Parent = resultContainer
    
    -- ====================================================
    -- FOOTER
    -- ====================================================
    
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 25)
    footer.Position = UDim2.new(0, 0, 0, 385)
    footer.BackgroundTransparency = 1
    footer.Text = "💡 Ctrl+V pour coller  •  Entrée pour convertir"
    footer.TextColor3 = THEME.TextDim
    footer.TextSize = 10
    footer.Font = Enum.Font.Gotham
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = mainFrame
--[[
    ═══════════════════════════════════════════════════
    ✨ RAW LINK CONVERTER v4.0 - PARTIE 3/3
    ═══════════════════════════════════════════════════
]]

    -- ====================================================
    -- DRAG & DROP
    -- ====================================================
    
    local dragData = { dragging = false }
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = true
            dragData.startMouse = input.Position
            dragData.framePos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragData.dragging = false
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
    
    -- ====================================================
    -- FONCTIONS UI
    -- ====================================================
    
    local function updateStatus(text, color)
        statusText.Text = text
        statusText.TextColor3 = color or THEME.Success
    end
    
    local function animateButton(btn, color)
        local t = TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = color
        })
        t:Play()
        t.Completed:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = btn.BackgroundColor3
            }):Play()
        end)
    end
    
    -- ====================================================
    -- ÉVÉNEMENTS
    -- ====================================================
    
    -- Convertir
    convertBtn.MouseButton1Click:Connect(function()
        local url = inputBox.Text
        if url == "" then
            updateStatus("❌ Entrez un lien !", THEME.Error)
            animateButton(convertBtn, THEME.Error)
            return
        end
        
        updateStatus("⏳ Conversion...", THEME.Warning)
        
        local rawUrl, wasRaw = convertToRaw(url)
        
        if wasRaw then
            resultText.Text = "✅ Déjà en raw !\n" .. rawUrl
            updateStatus("✅ Déjà raw", THEME.Success)
        else
            resultText.Text = "✅ Converti !\n" .. rawUrl
            updateStatus("✅ Converti !", THEME.Success)
        end
        
        animateButton(convertBtn, THEME.Success)
    end)
    
    -- Copier
    copyBtn.MouseButton1Click:Connect(function()
        local text = resultText.Text
        if text == "" or text == "⏳ En attente d'un lien..." then
            updateStatus("❌ Rien à copier", THEME.Error)
            animateButton(copyBtn, THEME.Error)
            return
        end
        
        local url = text:match("https?://[^%s]+")
        if url then
            if copyToClipboard(url) then
                updateStatus("✅ URL copiée !", Color3.fromRGB(100, 200, 255))
                animateButton(copyBtn, Color3.fromRGB(0, 200, 200))
            else
                updateStatus("❌ Erreur de copie", THEME.Error)
            end
        else
            if copyToClipboard(text) then
                updateStatus("✅ Copié !", THEME.Success)
            else
                updateStatus("❌ Erreur de copie", THEME.Error)
            end
        end
    end)
    
    -- Fermer
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Hover fermer
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            TextColor3 = THEME.Error
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(150, 150, 180)
        }):Play()
    end)
    
    -- Raccourcis
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.V and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local mouse = LocalPlayer:GetMouse()
            if mouse and mouse.GetClipboard then
                local text = mouse:GetClipboard()
                if text and text:find("http") then
                    inputBox.Text = text
                    updateStatus("📋 Lien collé !", Color3.fromRGB(100, 200, 255))
                end
            end
        end
        
        if input.KeyCode == Enum.KeyCode.Return then
            convertBtn.MouseButton1Click:Fire()
        end
    end)
    
    -- Animation d'apparition
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 420)
    }):Play()
    
    return screenGui
end

-- ====================================================
-- LANCEMENT
-- ====================================================

local existing = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("RawLinkConverterUI")
if existing then existing:Destroy() end

createUI()

print("✅ Raw Link Converter v4.0 chargé !")
print("📋 Copie UNIQUEMENT l'URL (pas de loadstring)")
