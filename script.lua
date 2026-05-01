local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pgui = player:WaitForChild("PlayerGui")

-- Limpa interfaces antigas
if pgui:FindFirstChild("BoosterPanel") then pgui.BoosterPanel:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "BoosterPanel"
sg.ResetOnSpawn = false

-- DESIGN DO PAINEL (IGUAL À FOTO)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.85, 0, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 85) -- Tom roxo escuro da foto
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Brilho/Borda colorida
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(120, 80, 200)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Text = "Booster"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 5)

-- FUNÇÃO: DEIXAR BONECO IGUAL AO VÍDEO (REMOVER ACESSÓRIOS E MUDAR COR)
local function EstiloVideo()
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") then
            item:Destroy()
        end
    end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Color = Color3.new(1, 1, 1) -- Branco como no vídeo
        end
    end
end
EstiloVideo()

-- BOTÃO: SEMI TP (3 LUGARES DO VÍDEO)
local SemiTP = Instance.new("TextButton", Main)
SemiTP.Text = "Semi TP"
SemiTP.Size = UDim2.new(0, 190, 0, 40)
SemiTP.Position = UDim2.new(0, 15, 0, 50)
SemiTP.BackgroundColor3 = Color3.fromRGB(60, 60, 110)
SemiTP.TextColor3 = Color3.new(1, 1, 1)
SemiTP.Font = Enum.Font.GothamBold
Instance.new("UICorner", SemiTP)

SemiTP.MouseButton1Click:Connect(function()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- 1. Em cima do Pet (Próximo à base)
        hrp.CFrame = CFrame.new(-30, 15, 10) 
        task.wait(0.5)
        -- 2. Meio das duas bases
        hrp.CFrame = CFrame.new(0, 5, 20)
        task.wait(0.5)
        -- 3. Lado da lojinha (Shop)
        hrp.CFrame = CFrame.new(45, 5, -15)
    end
end)

-- BOTÃO: BASE (DEIXAR BASES INVISÍVEIS)
local BaseBtn = Instance.new("TextButton", Main)
BaseBtn.Text = "Base Invisível"
BaseBtn.Size = UDim2.new(0, 190, 0, 40)
BaseBtn.Position = UDim2.new(0, 15, 0, 100)
BaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 110)
BaseBtn.TextColor3 = Color3.new(1, 1, 1)
BaseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BaseBtn)

local basesVisiveis = true
BaseBtn.MouseButton1Click:Connect(function()
    basesVisiveis = not basesVisiveis
    -- Procura por pastas comuns de bases em simuladores
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name:lower():find("base") or obj.Name:lower():find("plot") then
            if obj:IsA("BasePart") then
                obj.Transparency = basesVisiveis and 0 or 1
            end
        end
    end
end)

-- SLIDERS VISUAIS (CONFORME A FOTO "Booster")
local function CreateVisualSlider(name, pos)
    local label = Instance.new("TextLabel", Main)
    label.Text = name .. "   56"
    label.Size = UDim2.new(0, 190, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", Main)
    bar.Size = UDim2.new(0, 190, 0, 4)
    bar.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset + 20)
    bar.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
    
    local circle = Instance.new("Frame", bar)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = UDim2.new(0.8, -6, 0.5, -6)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
end

CreateVisualSlider("Walk Speed", UDim2.new(0, 15, 0, 160))
CreateVisualSlider("Steal Speed", UDim2.new(0, 15, 0, 210))

-- TECLA P PARA OCULTAR
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
