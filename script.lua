local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpa a versão anterior do Booster
if pgui:FindFirstChild("Kraken_V7") then pgui.Kraken_V7:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "Kraken_V7"
sg.ResetOnSpawn = false

-- FRAME PRINCIPAL (ESTILO KRAKEN VS)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- TÍTULO
local Title = Instance.new("TextLabel", Main)
Title.Text = "KRAKEN VS - CONTROLS"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- INPUT DO ALVO (LADO ESQUERDO)
local TargetInput = Instance.new("TextBox", Main)
TargetInput.Size = UDim2.new(0, 160, 0, 35)
TargetInput.Position = UDim2.new(0, 20, 0, 60)
TargetInput.BackgroundColor3 = Color3.fromRGB(35, 36, 45)
TargetInput.PlaceholderText = "Nick do Alvo"
TargetInput.Text = ""
TargetInput.TextColor3 = Color3.new(1, 1, 1)
TargetInput.Font = Enum.Font.GothamSemibold
TargetInput.TextSize = 13
Instance.new("UICorner", TargetInput)

-- ÁREA DE BOTÕES (SCROLLING LIST À DIREITA)
local ButtonList = Instance.new("ScrollingFrame", Main)
ButtonList.Size = UDim2.new(0, 250, 0, 220)
ButtonList.Position = UDim2.new(0, 210, 0, 60)
ButtonList.BackgroundTransparency = 1
ButtonList.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", ButtonList)
layout.Padding = UDim.new(0, 8)

-- FUNÇÃO PARA ENCONTRAR O ALVO
local function GetTarget()
    local t = TargetInput.Text:lower()
    if t == "" then return nil end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():find(t) or p.DisplayName:lower():find(t) then
            return p
        end
    end
    return nil
end

-- CRIADOR DE BOTÕES
local function AddAction(name, color, func)
    local btn = Instance.new("TextButton", ButtonList)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

-- --- FUNÇÕES DO VÍDEO (PUNISHMENTS) ---

-- 1. JAIL (COM TAG "PRESO!")
AddAction("Jail Target", Color3.fromRGB(50, 50, 60), function()
    local target = GetTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        local cage = Instance.new("Part", target.Character)
        cage.Size = Vector3.new(10, 12, 10)
        cage.CFrame = hrp.CFrame
        cage.Anchored = true
        cage.CanCollide = true
        cage.Transparency = 0.7
        cage.Color = Color3.new(0, 0, 0)
        cage.Material = Enum.Material.Glass
        
        local bg = Instance.new("BillboardGui", target.Character:FindFirstChild("Head"))
        bg.Size = UDim2.new(0, 200, 0, 50)
        bg.AlwaysOnTop = true
        bg.ExtentsOffset = Vector3.new(0, 3, 0)
        local l = Instance.new("TextLabel", bg)
        l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        l.Text = "PRESO!"; l.TextColor3 = Color3.new(1, 0, 0); l.Font = "GothamBold"; l.TextSize = 25
        
        task.delay(5, function() cage:Destroy(); bg:Destroy() end)
    end
end)

-- 2. RAGDOLL (ESTILO LOG DO VÍDEO)
AddAction("Ragdoll", Color3.fromRGB(160, 40, 40), function()
    local target = GetTarget()
    if target and target.Character:FindFirstChildOfClass("Humanoid") then
        local h = target.Character:FindFirstChildOfClass("Humanoid")
        h:ChangeState(Enum.HumanoidStateType.Physics)
        task.wait(3)
        h:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

-- 3. ROCKET (COM FOGO NO LOG)
AddAction("Rocket", Color3.fromRGB(200, 80, 0), function()
    local target = GetTarget()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        Instance.new("Fire", hrp)
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 150, 0)
        task.wait(2)
        bv:Destroy()
        if hrp:FindFirstChild("Fire") then hrp.Fire:Destroy() end
    end
end)

-- 4. BALLOON (FLUTUAR)
AddAction("Balloon", Color3.fromRGB(0, 120, 220), function()
    local target = GetTarget()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyVelocity", target.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 25, 0)
        task.wait(5)
        bv:Destroy()
    end
end)

-- TOGGLE P
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)
