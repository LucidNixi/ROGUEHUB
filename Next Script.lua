-- Notification setup
game.StarterGui:SetCore("SendNotification", {
    Title = 'pablo OMG!';
    Text = 'by pabloo aka martial';
    Icon = 'rbxassetid://115097724597781';
    Duration = 2.5;
})


-- Global settings
_G.isActive = false
_G.beamColor = Color3.fromRGB(255,0,0)
_G.activationKey = "p"
_G.targetSwitchKey = 't'
_G.targetingMethod = "MousePos"

-- Service variables
local renderService = game:GetService("RunService")
local currentPlayer = game.Players.LocalPlayer
local userMouse = currentPlayer:GetMouse()
local selectedTarget

-- Function to get player's weapon
local function getWeapon()
    for _, item in pairs(selectedTarget.Character:GetChildren()) do
        if item and (item:FindFirstChild('Default') or item:FindFirstChild('Handle')) then
            return item
        end
    end
end

-- Function to display messages
local function displayMessage(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = 'System Alert';
        Text = text;
        Icon = 'rbxassetid://115097724597781'; 
        Duration = 2.5; 
    })
end

-- Function to find nearest player
local function findNearestPlayer()
    local minDistance = math.huge
    local nearestPlayer

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= currentPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = game.Workspace.CurrentCamera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
            local distance = (Vector2.new(userMouse.X, userMouse.Y) - Vector2.new(playerPosition.X, playerPosition.Y)).Magnitude

            if minDistance > distance then
                nearestPlayer = player
                minDistance = distance
            end
        end
    end

    return nearestPlayer
end

-- Toggle system on key press
userMouse.KeyDown:Connect(function(key)
    if key == _G.activationKey then
        _G.isActive = not _G.isActive
        displayMessage(_G.isActive and "System activated" or "System deactivated")
    end
end)

-- Switch target on key press
userMouse.KeyDown:Connect(function(key)
    if key == _G.targetSwitchKey then
        selectedTarget = findNearestPlayer()
        if selectedTarget then
            displayMessage("Now targeting: " .. selectedTarget.Name)
        else
            displayMessage("No valid target found.")
        end
    end
end)

-- Create a visual beam
local visualBeam = Instance.new("Beam")
visualBeam.Segments = 1
visualBeam.Width0 = 0.2
visualBeam.Width1 = 0.2
visualBeam.Color = ColorSequence.new(_G.beamColor)
visualBeam.FaceCamera = true

local startPoint = Instance.new("Attachment")
local endPoint = Instance.new("Attachment")
visualBeam.Attachment0 = startPoint
visualBeam.Attachment1 = endPoint
visualBeam.Parent = workspace.Terrain
startPoint.Parent = workspace.Terrain
endPoint.Parent = workspace.Terrain

-- Update visual beam and targeting
task.spawn(function()
    renderService.RenderStepped:Connect(function()
        local playerCharacter = currentPlayer.Character
        if not playerCharacter or not _G.isActive or not selectedTarget then
            visualBeam.Enabled = false
            return
        end

        if getWeapon() and selectedTarget.Character:FindFirstChild("BodyEffects") and selectedTarget.Character:FindFirstChild("Head") then
            visualBeam.Enabled = true
            startPoint.Position = selectedTarget.Character.Head.Position
            endPoint.Position = selectedTarget.Character.BodyEffects[_G.targetingMethod].Value
        else
            visualBeam.Enabled = false
        end
    end)
end)

-- Velocity modifier setup
getgenv().velocityModifierActive = false
getgenv().modifiedVelocity = Vector3.new(-124718414147,12409141,124719019741)
getgenv().modifierKey = "z"

local playerService = game:GetService("Players")
local renderService = game:GetService("RunService")
local inputService = game:GetService("UserInputService")

local activePlayer = playerService.LocalPlayer
local playerModel = activePlayer.Character
local rootPart = playerModel:FindFirstChild("HumanoidRootPart")

local heartbeatEvent = renderService.Heartbeat
local renderSteppedEvent = renderService.RenderStepped

activePlayer.CharacterAdded:Connect(function(newModel)
    playerModel = newModel
end)

local originalVelocity

-- Notification for modifier toggle
inputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z then
        velocityModifierActive = not velocityModifierActive
        displayMessage(velocityModifierActive and "Velocity modifier enabled" or "Velocity modifier disabled")
    end
end)

-- Apply velocity modifications
inputService.InputBegan:Connect(function(input)
    if not inputService:GetFocusedTextBox() and input.KeyCode == Enum.KeyCode.Z then
        task.spawn(function()
            while velocityModifierActive do
                if not rootPart or not rootPart.Parent then
                    repeat task.wait() rootPart = playerModel:FindFirstChild("HumanoidRootPart") until rootPart ~= nil
                else
                    originalVelocity = rootPart.Velocity
                    rootPart.Velocity = type(modifiedVelocity) == "vector" and modifiedVelocity or modifiedVelocity(originalVelocity)
                    renderSteppedEvent:Wait()
                    rootPart.Velocity = originalVelocity
                end
                heartbeatEvent:Wait()
            end
        end)
    end
end)

getgenv().delusion = {
    Aimbot = {
        Keybind = Enum.KeyCode.C,
        CamlockPrediction = 0.136,
        Prediction = 0.1347,

        Basic = true,
        TargetPart = "HumanoidRootPart",

        NearestPart = false,
        MultipleTargetPart = {"Head","HumanoidRootPart"},

        CameraSmoothing =1,
        CameraShake = 0,
        JumpOffset = -0.46
    },
    Safety = {
        AntiGroundShots = false,
    },
    Checks = {
        DisableOnTargetDeath = true,
        DisableOnPlayerDeath = true,
        CheckKoStatus = true,
    },
    Macro = {
        Enabled = false,
        SpeedGlitchKey = Enum.KeyCode.X,
    },
    EspSection = {
        ChamsESP = false,
        ChamsESPKeybind = Enum.KeyCode.T,
        ChamsColor1 = Color3.fromRGB(255, 255, 255),
        ChamsColor2 = Color3.fromRGB(255, 255, 255),
    },
    Misc = {
        RejoinServer = false,
    },
    Spin = {
        Enabled = true,
        SpinSpeed = 4900,
        Degrees = 360,
        Keybind = Enum.KeyCode.V,
    },
}


if (not getgenv().Loaded) then
local userInputService = game:GetService("UserInputService")

local function CheckAnti(Plr) -- // Anti-aim detection
    if Plr.Character.HumanoidRootPart.Velocity.Y < -70 then
        return true
    elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.X > 450 or Plr.Character.HumanoidRootPart.Velocity.X < -35) then
        return true
    elseif Plr and Plr.Character.HumanoidRootPart.Velocity.Y > 60 then
        return true
    elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.Z > 35 or Plr.Character.HumanoidRootPart.Velocity.Z < -35) then
        return true
    else
        return false
    end
end

local function getnamecall()
    if game.PlaceId == 2788229376 then
        return "UpdateMousePos"
    elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then
        return "MousePos"
    elseif game.PlaceId == 9825515356 then
        return "GetMousePos"
    end
end

function MainEventLocate()
    for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v.Name == "MainEvent" then
            return v
        end
    end
end

local Locking = false
local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Plr = nil -- Initialize Plr here

-- 360 on bind
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Toggle = false -- Initialize Toggle to false

local function OnKeyPress(Input, GameProcessedEvent)
    if Input.KeyCode == getgenv().delusion.Aimbot.Keybind and not GameProcessedEvent then 
        Toggle = not Toggle
    elseif Input.KeyCode == getgenv().delusion.Macro.SpeedGlitchKey then
        if getgenv().delusion.Macro.Enabled then 
            getgenv().delusion.Macro.SpeedGlitch = not getgenv().delusion.Macro.SpeedGlitch
            if getgenv().delusion.Macro.SpeedGlitch then
                repeat
                    game:GetService("RunService").Heartbeat:Wait()
                    keypress(0x49)
                    game:GetService("RunService").Heartbeat:Wait()
                    keypress(0x4F)
                    game:GetService("RunService").Heartbeat:Wait()
                    keyrelease(0x49)
                    game:GetService("RunService").Heartbeat:Wait()
                    keyrelease(0x4F)
                    game:GetService("RunService").Heartbeat:Wait()
                until not getgenv().delusion.Macro.SpeedGlitch
            end
        end
    end
end

UserInputService.InputBegan:Connect(OnKeyPress)

UserInputService.InputBegan:Connect(function(keygo, ok)
    if (not ok) then
        if (keygo.KeyCode == getgenv().delusion.Aimbot.Keybind) then
            Locking = not Locking
            if Locking then
                Plr = getClosestPlayerToCursor()
            elseif not Locking then
                if Plr then
                    Plr = nil
                end
            end
        end
    end
end)

function getClosestPlayerToCursor()
    local closestDist = math.huge
    local closestPlr = nil
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= Client and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if cameraVisible then
                local distToMouse = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distToMouse < closestDist then
                    closestPlr = v
                    closestDist = distToMouse
                end
            end
        end
    end
    return closestPlr
end

function getClosestPartToCursor(Player)
    local closestPart, closestDist = nil, math.huge
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character.Humanoid.Health ~= 0 and Player.Character:FindFirstChild("HumanoidRootPart") then
        for i, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                local distToMouse = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distToMouse < closestDist and table.find(getgenv().delusion.Aimbot.MultipleTargetPart, part.Name) then
                    closestPart = part
                    closestDist = distToMouse
                end
            end
        end
        return closestPart
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if Plr and Plr.Character then
        if getgenv().delusion.Aimbot.NearestPart == true and getgenv().delusion.Aimbot.Basic == false then
            getgenv().delusion.Aimbot.TargetPart = tostring(getClosestPartToCursor(Plr))
        elseif getgenv().delusion.Aimbot.Basic == true and getgenv().delusion.Aimbot.NearestPart == false then
            getgenv().delusion.Aimbot.TargetPart = getgenv().delusion.Aimbot.TargetPart
        end
    end
end)

local function getVelocity(Player)
    local Old = Player.Character.HumanoidRootPart.Position
    wait(0.145)
    local Current = Player.Character.HumanoidRootPart.Position
    return (Current - Old) / 0.145
end

local function GetShakedVector3(Setting)
    return Vector3.new(math.random(-Setting * 1e9, Setting * 1e9), math.random(-Setting * 1e9, Setting * 1e9), math.random(-Setting * 1e9, Setting * 1e9)) / 1e9;
end

local v = nil
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    if Plr ~= nil and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        v = getVelocity(Plr)
    end
end)

local mainevent = game:GetService("ReplicatedStorage").MainEvent

Client.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child:FindFirstChild("MaxAmmo") then
        child.Activated:Connect(function()
            if Plr and Plr.Character then
                local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().delusion.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position
                if not CheckAnti(Plr) then
                    mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().delusion.Aimbot.Prediction))
                else
                    mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().delusion.Aimbot.Prediction))
                end
            end
        end)
    end
end)

Client.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:FindFirstChild("MaxAmmo") then
            child.Activated:Connect(function()
                if Plr and Plr.Character then
                    local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().delusion.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position
                    if not CheckAnti(Plr) then
                        mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().delusion.Aimbot.Prediction))
                    else
                        mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().delusion.Aimbot.Prediction))
                    end
                end
            end)
        end
    end)
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if Plr ~= nil and Plr.Character then
        local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().delusion.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().delusion.Aimbot.TargetPart].Position
        if not CheckAnti(Plr) then
            local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().delusion.Aimbot.CamlockPrediction) + GetShakedVector3(getgenv().delusion.Aimbot.CameraShake))
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().delusion.Aimbot.CameraSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        else
            local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().delusion.Aimbot.CamlockPrediction) + GetShakedVector3(getgenv().delusion.Aimbot.CameraShake))
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().delusion.Aimbot.CameraSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end
    end
    if getgenv().delusion.Checks.CheckKoStatus == true and Plr and Plr.Character then
        local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
        local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
        if Plr.Character.Humanoid.Health < 1 or KOd or Grabbed then
            if Locking == true then
                Plr = nil
                Locking = false
            end
        end
    end
    if getgenv().delusion.Checks.DisableOnTargetDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
        if Plr.Character.Humanoid.health < 1 then
            if Locking == true then
                Plr = nil
                Locking = false
            end
        end
    end
    if getgenv().delusion.Checks.DisableOnPlayerDeath == true and Client.Character and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.health < 1 then
        if Locking == true then
            Plr = nil
            Locking = false
        end
    end
    if getgenv().delusion.Safety.AntiGroundShots == true and Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        pcall(function()
            local TargetVelv5 = Plr.Character.HumanoidRootPart
    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, math.abs(TargetVelv5.Velocity.Y * 0.36),
     TargetVelv5.Velocity.Z)
            TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, math.abs(TargetVelv5.Velocity.Y * 0.36), TargetVelv5.Velocity.Z)
        end)
    end
end)

if getgenv().delusion.EspSection.ChamsESP == true then

local UserInputService = game:GetService("UserInputService")
local ToggleKey = getgenv().delusion.EspSection.ChamsESPKeybind

local FillColor = getgenv().delusion.EspSection.ChamsColor1
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = getgenv().delusion.EspSection.ChamsColor2
local OutlineTransparency = 0

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local isEnabled = false

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = FillColor
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Storage
    
    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)
end

local function EnableHighlight()
    isEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        Highlight(player)
    end
end

local function DisableHighlight()
    isEnabled = false
    for _, highlight in ipairs(Storage:GetChildren()) do
        highlight:Destroy()
    end
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == ToggleKey then
        if isEnabled then
            DisableHighlight()
        else
            EnableHighlight()
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if isEnabled then
        Highlight(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    local highlight = Storage:FindFirstChild(player.Name)
    if highlight then
        highlight:Destroy()
    end
    local connection = connections[player]
    if connection then
        connection:Disconnect()
    end
end)


if isEnabled then
    EnableHighlight()
end
end

if getgenv().delusion.Misc.RejoinServer == true then
local TeleportService = game:GetService("TeleportService")

local function RejoinSameServer()
    local success, errorMessage = pcall(function()
        local placeId = game.PlaceId
        local jobId = game.JobId
        TeleportService:TeleportToPlaceInstance(placeId, jobId)
    end)

    if not success then
        warn("Failed to rejoin: " .. errorMessage)
    end
end

wait(0)
RejoinSameServer()
end

if getgenv().delusion.Spin.Enabled == true then
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local Toggle = getgenv().delusion.Spin.Enabled
    local RotationSpeed = getgenv().delusion.Spin.SpinSpeed
    local Keybind = getgenv().delusion.Spin.Keybind
    
    local function OnKeyPress(Input, GameProcessedEvent)
        if Input.KeyCode == Keybind and not GameProcessedEvent then 
            Toggle = not Toggle
        end
    end
    
    UserInputService.InputBegan:Connect(OnKeyPress)
    
    local LastRenderTime = 0
    local TotalRotation = 0
    
    local function RotateCamera()
        if Toggle then
            local CurrentTime = tick()
            local TimeDelta = math.min(CurrentTime - LastRenderTime, 0.01)
            LastRenderTime = CurrentTime
    
            local RotationAngle = RotationSpeed * TimeDelta
            local Rotation = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(RotationAngle))
            Camera.CFrame = Camera.CFrame * Rotation
    
            TotalRotation = TotalRotation + RotationAngle
            if TotalRotation >= getgenv().delusion.Spin.Degrees then 
                Toggle = false
                TotalRotation = 0
            end
        end
    end
    
    RunService.RenderStepped:Connect(RotateCamera)
    end

getgenv().Loaded = true -- end of the script
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Delusion",
        Text = "Updated Table",
        Duration = 0.001
    })
end
