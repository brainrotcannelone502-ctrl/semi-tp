local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pgui = player:WaitForChild("PlayerGui")

-- Limpa interfaces e pontos antigos
if pgui:FindFirstChild("BoosterPanel") then pgui.BoosterPanel:Destroy() end
if game.Workspace:FindFirstChild("TP_Points") then game.Workspace.TP_Points:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "BoosterPanel"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.85, 0, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 85)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- PASTA PARA OS QUADRADOS INDICADORES NO MAPA
local tpFolder = Instance.new("Folder", game.Workspace)
tpFolder.Name = "TP_Points"

-- PONTOS BASEADOS NA SUA IMAGEM (Coordenadas aproximadas de Slots e Loja)
local pontos = {
    [1] = Vector3.new(-38, 4, 15),  -- Slot 1 da base esquerda
    [2] = Vector3.new(-38, 4, 35),  -- Primeiro slot (baixo)
    [3] = Vector3.new(0, 4, 25),    -- Meio/Caminho desenhado
    [4] = Vector3.new(45, 4, -10)   -- Lado da lojinha/Base direita
}

-- CRIAR QUADRADOS NOS PONTOS
for i, pos in pairs(pontos) do
    local p = Instance.new("Part", tpFolder)
    p.Size = Vector3.new(2, 0.2, 2)
    p.Position = pos
    p.Anchored = true
    p.CanCollide = false
    p.Color = Color3.fromRGB(120, 80, 255) -- Roxo igual ao desenho
    p.Material = Enum.Material.Neon
    
    local txt = Instance.new("BillboardGui", p)
    txt.Size = UDim2.new(0, 50, 0, 20)
    txt.AlwaysOnTop = true
    txt.ExtentsOffset = Vector3.new(0, 2, 0)
    local l = Instance.new("TextLabel", txt)
    l.Text = tostring(i); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.Size = UDim2.new(1,0,1,0)
end

-- BOTÃO SEMI TP (SEQUÊNCIA DO VÍDEO E IMAGEM)
local SemiTP = Instance.new("TextButton", Main)
SemiTP.Text = "Semi TP (Farm)"
SemiTP.Size = UDim2.new(0, 190, 0, 45)
SemiTP.Position = UDim2.new(0, 15, 0, 40)
SemiTP.BackgroundColor3 = Color3.fromRGB(60, 60, 110)
SemiTP.TextColor3 = Color3.new(1, 1, 1)
SemiTP.Font = Enum.Font.GothamBold
Instance.new("UICorner", SemiTP)

SemiTP.MouseButton1Click:Connect(function()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for i = 1, 4 do
            hrp.CFrame = CFrame.new(pontos[i] + Vector3.new(0, 3, 0)) -- Teleporta um pouco acima do ponto
            task.wait(0.6) -- Tempo de delay igual ao vídeo
        end
    end
end)

-- BOTÃO BASE (INVISÍVEL)
local BaseBtn = Instance.new("TextButton", Main)
BaseBtn.Text = "Base Invisível"
BaseBtn.Size = UDim2.new(0, 190, 0, 45)
BaseBtn.Position = UDim2.new(0, 15, 0, 100)
BaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 110)
BaseBtn.TextColor3 = Color3.new(1, 1, 1)
BaseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BaseBtn)

local invis = false
BaseBtn.MouseButton1Click:Connect(function()
    invis = not invis
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name:lower():find("base") or obj.Name:lower():find("plot") then
            if obj:IsA("BasePart") then obj.Transparency = invis and 1 or 0 end
        end
    end
end)

-- ESTILO DO BONECO (BRANCO/LIMPO)
for _, v in pairs(character:GetChildren()) do
    if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
    if v:IsA("BasePart") then v.Color = Color3.new(1,1,1) end
end
