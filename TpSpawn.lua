-- F5 pro tp
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local tpAtivo = false

local saved = {}

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid(char)
	return char:WaitForChild("Humanoid")
end

local function getRoot(char)
	return char:WaitForChild("HumanoidRootPart")
end

local function freezeCharacter()
	local char = getChar()
	local hum = getHumanoid(char)

	saved.WalkSpeed = hum.WalkSpeed
	saved.JumpPower = hum.JumpPower
	saved.AutoRotate = hum.AutoRotate

	hum.WalkSpeed = 0
	hum.JumpPower = 0
	hum.AutoRotate = false
end

local function unfreezeCharacter()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	hum.WalkSpeed = saved.WalkSpeed or 16
	hum.JumpPower = saved.JumpPower or 50
	hum.AutoRotate = (saved.AutoRotate ~= nil) and saved.AutoRotate or true
end

local function waitBallSpawn()
	local map = workspace:WaitForChild("Map")

	while tpAtivo do
		local blackHole = map:FindFirstChild("BlackHole")
		if blackHole then
			local ball = blackHole:FindFirstChild("BALLSPAWN")
			if ball then return ball end
		end

		local ballAny = map:FindFirstChild("BALLSPAWN", true)
		if ballAny then return ballAny end

		task.wait(0.2)
	end

	return nil
end

player.CharacterAdded:Connect(function()
	if tpAtivo then
		task.wait(0.1)
		freezeCharacter()
	end
end)

local function startLoop()
	task.spawn(function()
		freezeCharacter()

		-- delay de 10 segundos
		task.wait(10)
		if not tpAtivo then
			unfreezeCharacter()
			return
		end

		local ballSpawn = waitBallSpawn()
		if not tpAtivo or not ballSpawn then
			unfreezeCharacter()
			return
		end

		while tpAtivo do
			local char = getChar()
			local root = getRoot(char)

			root.CFrame = ballSpawn.CFrame + ballSpawn.CFrame.LookVector * 9
			task.wait(0.2)
		end

		unfreezeCharacter()
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode ~= Enum.KeyCode.F5 then return end

	tpAtivo = not tpAtivo
	print("Loop TP:", tpAtivo and "ATIVADO" or "DESATIVADO")

	if tpAtivo then
		startLoop()
	else
		unfreezeCharacter()
	end
end)
