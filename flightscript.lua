local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local localplayer = plr

local flightToggle = false

local function startFlight()
    if workspace:FindFirstChild("Core") then
        workspace.Core:Destroy()
    end

    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)

    spawn(function()
        Core.Parent = workspace
        local Weld = Instance.new("Weld", Core)
        Weld.Part0 = Core
        Weld.Part1 = localplayer.Character.LowerTorso
        Weld.C0 = CFrame.new(0, 0, 0)
    end)

    workspace:WaitForChild("Core")

    local torso = workspace.Core

    local flying = true
    local speed = 10

    local keys = {a = false, d = false, w = false, s = false}

    local e1
    local e2

    local function start()
        local pos = Instance.new("BodyPosition", torso)
        local gyro = Instance.new("BodyGyro", torso)

        pos.Name = "EPIXPOS"
        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        pos.position = torso.Position

        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.cframe = torso.CFrame

        repeat
            wait()
            localplayer.Character.Humanoid.PlatformStand = true

            local new = gyro.cframe - gyro.cframe.p + pos.position

            if keys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed = speed + 0
            end

            if keys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed = speed + 0
            end

            if keys.d then
                new = new * CFrame.new(speed, 0, 0)
                speed = speed + 0
            end

            if keys.a then
                new = new * CFrame.new(-speed, 0, 0)
                speed = speed + 0
            end

            if speed > 10 then
                speed = 5
            end

            pos.position = new.p

            if keys.w then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad(speed * 0), 0, 0)
            elseif keys.s then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(math.rad(speed * 0), 0, 0)
            else
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame
            end
        until flying == false

        if gyro then gyro:Destroy() end
        if pos then pos:Destroy() end

        flying = false
        localplayer.Character.Humanoid.PlatformStand = false
        speed = 10
    end

    e1 = mouse.KeyDown:connect(function(key)
        if not torso or not torso.Parent then
            flying = false
            e1:disconnect()
            e2:disconnect()
            return
        end

        if key == "w" then
            keys.w = true
        elseif key == "s" then
            keys.s = true
        elseif key == "a" then
            keys.a = true
        elseif key == "d" then
            keys.d = true
        end
    end)

    e2 = mouse.KeyUp:connect(function(key)
        if key == "w" then
            keys.w = false
        elseif key == "s" then
            keys.s = false
        elseif key == "a" then
            keys.a = false
        elseif key == "d" then
            keys.d = false
        end
    end)

    start()
end

local function stopFlight()
    if flightToggle then
        for _, connection in pairs({e1, e2}) do
            if connection then
                connection:Disconnect()
            end
        end

        local torso = workspace:FindFirstChild("Core")
        if torso then
            torso:Destroy()
        end

        flightToggle = false
    end
end

return {
    startFlight = startFlight,
    stopFlight = stopFlight
}
