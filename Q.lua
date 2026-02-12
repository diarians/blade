-- Spam tecla Q - bladeball
-- aperta F8 para ativar/desativar

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local ativo = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        ativo = not ativo
        print("Spam Q:", ativo and "ATIVADO" or "DESATIVADO")
        
        if ativo then
            task.spawn(function()
                while ativo do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    task.wait(0.02) -- 20 ms
                end
            end)
        end
    end
end)
