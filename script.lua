local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pgui = player:WaitForChild("PlayerGui")

-- Limpeza de UI e Marcadores antigos
if pgui:FindFirstChild("BoosterPanel") then pgui.BoosterPanel:Destroy() end
if game.Workspace:FindFirstChild("TP_Marks") then game.Workspace.TP_Marks:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "BoosterPanel"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 200, 0, 160)
Main.Position = UDim2.new(0.85, 0, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 85)
Instance.new("UICorner", Main)

local marksFolder = Instance.new("Folder", game.Workspace)
marksFolder.Name = "TP_Marks"

-- COORDENADAS REAIS DO MAPA (Slots -> Caminho -> Loja de Equipamentos)
local mapPontos = {
    [1] = Vector3.new(-38, 4, 15),  -- Slot 1 (Base Esquerda)
    [2] = Vector3.new(-38, 4, 30),  -- Slot 2 (Base Esquerda)
    [3] = Vector3.new(-10, 4, 10),  -- Transição/Caminho
    [4] = Vector3.new(25, 4, -45)   -- Loja de Equipamentos (Topo/Direita)
}

-- CRIAR QUADRADOS ROXOS NOS PONTOS (IGUAL AO DESENHO)
for i, pos in pairs(mapPontos) do
    local p = Instance.new("Part", marksFolder)
    p.Size = Vector3.new(3.5, 0.2, 3.5)
    p.Position = pos
    p.Anchored = true
    p.CanCollide = false
    p.Color = Color3.fromRGB(180, 50, 255) -- Roxo Neon
    p.Material = Enum.Material.Neon
    
    local bg = Instance.new("BillboardGui", p)
    bg.Size = UDim2.new(0, 40, 0, 20)
    bg.AlwaysOnTop = true
    bg.ExtentsOffset = Vector3.new(0, 2, 0)
    local l = Instance.new("TextLabel", bg)
    l.Text = tostring(i); l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0); l.Font = "GothamBold"
end

-- BOTÃO SEMI TP
local SemiTP = Instance.new("TextButton", Main)
SemiTP.Text = "Semi TP (Loja Equip.)"
SemiTP.Size = UDim2.new(0, 170, 0, 45)
SemiTP.Position = UDim2.new(0, 15, 0, 30)
SemiTP.BackgroundColor3 = Color3.fromRGB(70, 70, 130)
SemiTP.TextColor3 = Color3.new(1, 1, 1)
SemiTP.Font = "GothamBold"
Instance.new("UICorner", SemiTP)

SemiTP.MouseButton1Click:Connect(function()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for i = 1, 4 do
            hrp.CFrame = CFrame.new(mapPontos[i] + Vector3.new(0, 3, 0))
            task.wait(0.6)
        end
    end
end)

-- FUNÇÃO BASE INVISÍVEL
local BaseBtn = Instance.new("TextButton", Main)
BaseBtn.Text = "Base Invisível"
BaseBtn.Size = UDim2.new(0, 170, 0, 45)
BaseBtn.Position = UDim2.new(0, 15, 0, 85)
BaseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 130)
BaseBtn.TextColor3 = Color3.new(1, 1, 1)
BaseBtn.Font = "GothamBold"
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

-- ESTILO DO PERSONAGEM (BRANCO E LIMPO)
for _, v in pairs(character:GetChildren()) do
    if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
    if v:IsA("BasePart") then v.Color = Color3.new(1,1,1) end
end
