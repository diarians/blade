do
    -- ====== SEGUIR (tecla 6) ======
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local localPlayer = Players.LocalPlayer
    local alvoNome = "azklev"
    local distancia = 10
    local ativo = false
    local connection

    local function getHRP(player)
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart")
    end

    local function iniciarLoop()
        if connection then connection:Disconnect() end

        connection = RunService.Heartbeat:Connect(function()
            if not ativo then return end

            local alvo = Players:FindFirstChild(alvoNome)
            if not alvo or not alvo.Character then return end

            local meuHRP = getHRP(localPlayer)
            local alvoHRP = getHRP(alvo)

            -- posição X studs atrás do alvo
            local pos = alvoHRP.Position - (alvoHRP.CFrame.LookVector * distancia)
            meuHRP.CFrame = CFrame.new(pos)
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end

        if input.KeyCode == Enum.KeyCode.Six then
            ativo = not ativo
            print("Seguir a 15 studs:", ativo and "ATIVADO" or "DESATIVADO")

            if ativo then
                iniciarLoop()
            end
        end
    end)
end

do
    -- ====== ANTI-AFK ======
    local Players = game:GetService("Players")
    local VirtualUser = game:GetService("VirtualUser")
    local StarterGui = game:GetService("StarterGui")

    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    StarterGui:SetCore("SendNotification", {
        Title = "AntiAFK ativado!",
        Text = ".",
        Button1 = "ok",
        Duration = 5
    })
end
