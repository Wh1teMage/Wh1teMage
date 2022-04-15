local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TpServ = game:GetService("TeleportService")
local VUser = game:GetService("VirtualUser")

local lpl = game.Players.LocalPlayer
local ms = lpl:GetMouse()
local camera = workspace.CurrentCamera
local PlrGui = lpl.PlayerGui
local ls = lpl:WaitForChild("leaderstats", 40)

--GUI Setup

local colors = {
    SchemeColor = Color3.fromRGB(153, 80, 201),
    Background = Color3.fromRGB(72, 55, 109),
    Header = Color3.fromRGB(53, 44, 65),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(101, 78, 143)
}

local Gui = Library.CreateLib("The Void", colors)
local Main = Gui:NewTab("Main")
local Spells = Gui:NewTab("Spells")
local GuiSetup = Gui:NewTab("Gui")

local Mainfold = Main:NewSection("Main")
local Plrfold = Main:NewSection("Player")
local Tarfold = Main:NewSection("Target")
local Teamfold = Main:NewSection("Teammate")
local Expfold = Main:NewSection("Experimental")

local Mspells = Spells:NewSection("Main Spells")
local Uspells = Spells:NewSection("Ultimate Spells")
local Modspells = Spells:NewSection("Modified Spells")
--local Suspells = Spells:NewSection("Support Spells") --Under construction


local GuiColors = GuiSetup:NewSection("Colors")

for theme, color in pairs(colors) do
    GuiColors:NewColorPicker(theme, "Change your "..theme, color, function(color3)
        Library:ChangeColor(theme, color3)
    end)
end


--GUI Setup

--Events

local ClMagic = game:GetService("ReplicatedStorage").Remotes.DoClientMagic
local GMagic = game:GetService("ReplicatedStorage").Remotes.DoMagic
local Players = game:GetService("Players")
local Combat = game:GetService("ReplicatedStorage").Remotes.Combat

--Events

--I HATE THIS DUM DUM DUM DUUUU MUSIC
lpl.PlayerGui.Menu.Sound.Playing = false

--Variables

local target = lpl
local teammate = lpl
local autopunchrange = 10
local tarspec = false
local teamspec = false
local tarfol = false
local teamfol = false
local spawncf = lpl.Character.HumanoidRootPart.CFrame
local offset = 0
local noclip = false
local fly = false
local maxspeed = 100
local wspeed = 32
local uwait = 7

local ultchain = false
local ult = "Fire Ult"
local spawnp = false
local autopunch = false
local autofarmalt = false
local autofarmmain = false
local tracers = false
local invis = false
local infstam = false
local warp = false
local aimbot = false
local infjump = false
local antiafk = false
local antiblind = false
local save = false

local Clip
local Runinvis

--Variables

--Presets

local Prefold = Instance.new("Folder", workspace)

local billgui = Instance.new("BillboardGui")
local tb1 = Instance.new("TextBox")
local tb2 = Instance.new("TextBox")

billgui.Size = UDim2.new(0, 200, 0, 15)
billgui.Name = "bgui"
billgui.MaxDistance = 5000
billgui.StudsOffset = Vector3.new(0, 8, 0)
billgui.AlwaysOnTop = true

tb1.BackgroundTransparency = 1
tb1.TextColor3 = Color3.fromRGB(0, 0, 0)
tb1.Name = "tb1"
tb1.Size = UDim2.new(1, 0, 0.5, 0)
tb1.TextSize = 7
tb1.TextScaled = false
tb1.Parent = billgui

tb2.BackgroundTransparency = 1
tb2.Name = "tb2"
tb2.TextScaled = false
tb2.Size = UDim2.new(1, 0, 0.5, 0)
tb2.TextSize = 7
tb2.Position = UDim2.new(0, 0, 0.5, 0)
tb2.Parent = billgui

billgui.Parent = Prefold
billgui.Enabled = false

local part = Instance.new("Part")
part.Anchored, part.CanCollide = true, false
part.Size, part.Color = Vector3.new(1, 1, 1), Color3.fromRGB(255, 0, 0)
part.Material = Enum.Material.Neon
part.Position, part.Transparency = Vector3.new(0, 0, 0), 0.5
part.Name = "AimAssist"
part.Parent = workspace

local testPlatform = Instance.new("Part", workspace)
testPlatform.Name = lpl.Name.."platform"
testPlatform.Size = Vector3.new(200, 10, 200)
testPlatform.Transparency, testPlatform.Anchored = 0.5, true
testPlatform.Position = Vector3.new(5000, 500, 5000)

lpl.PlayerGui.ChildAdded:connect(function(child)
    child.Enabled = false
end)

local tracersgui = function(plr, char)

    local hum = char:WaitForChild("Humanoid")
    local humrp = char:FindFirstChild("HumanoidRootPart")
    local gui = humrp["bgui"]

    local oldpos = humrp.Position
    local newpos

    local guiupdate = RunS.Stepped:Connect(function()
        if workspace:FindFirstChild(plr.Name) and workspace:FindFirstChild(plr.Name):FindFirstChild("HumanoidRootPart") and tracers == true then
            if humrp:FindFirstChild("bgui") then
                humrp.Transparency = 0.5 --im too lazy to make this 
                local color = 1-(hum.Health/hum.MaxHealth)
                gui.tb2.Text = math.floor(hum.Health*10).."/"..math.floor(hum.MaxHealth*10)
                gui.tb2.TextColor3 = Color3.fromRGB(color*255, color*.4*255, color*.4*255)
            end

            if plr == target then
                newpos = humrp.Position
                part.Position = newpos + (newpos - oldpos) * math.sqrt((newpos-camera.CFrame.Position).Magnitude)*2
                oldpos = newpos
            end

        end
    end)
            
    hum.Died:connect(function()
        guiupdate:Disconnect()
        local gui = humrp["bgui"]
        gui.tb2.Text = "0/"..hum.MaxHealth*10
        gui.tb2.TextColor3 = Color3.fromRGB(255, 102, 102)
    end)
end

local setupgui = function(hum, humrp, plr)

    local gui = billgui:Clone()
    gui.Parent = humrp
    gui.Adornee = humrp
            
    gui.tb1.Text = plr.Name
    gui.tb2.Text = math.floor(hum.Health * 10).."/"..hum.MaxHealth * 10

end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if player == lpl then return end
        local phumrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        setupgui(hum, phumrp, player)
        if tracers == true then
            phumrp["bgui"].Enabled = true
            phumrp.Size = Vector3.new(3, 5, 3)
            phumrp.Transparency = 0.5
            phumrp.Color = Color3.fromRGB(163, 162, 165)

            tracersgui(player, char)
        end
    end)
end)

for i, v in pairs(game.Players:GetChildren()) do
    v.CharacterAdded:Connect(function(child)
        if v == lpl then 
            local test4
            if autofarmalt == true then
                wait(.5)
                child:WaitForChild("HumanoidRootPart").CFrame = workspace[teammate.Name].HumanoidRootPart.CFrame

                test4 = child:WaitForChild("Humanoid").HealthChanged:connect(function()
                    child:WaitForChild("Humanoid").Health = 0
                    test4:Disconnect()
                end)
    
            end
        else
            local phumrp = child:WaitForChild("HumanoidRootPart")
            local hum = child:WaitForChild("Humanoid")
    
            setupgui(hum, phumrp, v)
            if tracers == true  then
                phumrp["bgui"].Enabled = true
                phumrp.Size = Vector3.new(3, 5, 3)
                phumrp.Transparency = 0.5
                phumrp.Color = Color3.fromRGB(163, 162, 165)
                
                tracersgui(v, child)
            end
        end
    end)
end

lpl.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal'WalkSpeed':Connect(function()
    if wspeed > 64 then
        lpl.Character.Humanoid.WalkSpeed = wspeed
    end
end)

lpl.CharacterAdded:Connect(function(character)
    local hum = lpl.Character:WaitForChild("Humanoid")
    local humrp = lpl.Character:WaitForChild("HumanoidRootPart")
    local test
    local oldcf = CFrame.new(0, 0, 0)

    hum:GetPropertyChangedSignal'WalkSpeed':Connect(function()
        if wspeed > 64 then
            lpl.Character.Humanoid.WalkSpeed = wspeed
        end
    end)

    test = hum.HealthChanged:Connect(function(hp)
        if hum.Health < 20 and hum.Health > 0 and save == true and oldcf.Position.X == 0 then
            oldcf = humrp.CFrame
            humrp.CFrame = CFrame.new(testPlatform.Position + Vector3.new(0, 10, 0))
        elseif hum.Health <= 0 then
            test:Disconnect()
        elseif hum.Health > 30 and oldcf.Position.X ~= 0 then
            humrp.CFrame = oldcf
            oldcf = CFrame.new(0, 0, 0)
        end
    end)

    if ultchain == true then
        humrp.CFrame = CFrame.new(testPlatform.Position + Vector3.new(0, 10, 0))
        wait(1)
        local A_1 = "Lava"
        local A_2 = "Magma Drop"
        local A_3 = {}

        ClMagic:FireServer(A_1, A_2)
        GMagic:InvokeServer(A_1, A_2, A_3)
        wait(10.2)
        ClMagic:FireServer(A_1, A_2)
        GMagic:InvokeServer(A_1, A_2, A_3)
        wait(uwait) --use gmatch on gui to get mana
        local anothercf = humrp.CFrame
        if ult == "Fire Ult" then --I could convert everything to make my life easier but im too lazy

            A_1 = "Fire"
            A_2 = "Hell's Core"
            A_3 = CFrame.new(0, 0, 0)
            humrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
            wait(.3)

        elseif ult == "Time Ult" then

            A_1 = "Time"
            A_2 = "The World"
            A_3 = 
            {
                ["rpos"] = target.Character.HumanoidRootPart.Position, 
                ["norm"] = Vector3.new(0, 0, 0), 
                ["rhit"] = target.Character.Head
            }

        elseif ult == "Light Ult" then

            A_1 = "Light"
            A_2 = "Ablaze Judgement"
            A_3 = 
            {
                ["orbPos"] = target.Character.HumanoidRootPart.Position, 
                ["Origin"] = target.Character.HumanoidRootPart.Position
            }

        elseif ult == "Angel Ult" then

            A_1 = "Angel"
            A_2 = "Arcane Guardian"
            A_3 = 
            {
                ["Position"] = target.Character.HumanoidRootPart.Position + Vector3.new(0, 25, 0)
            }

        elseif ult == "Solar Ult" then

            A_1 = "Solar"
            A_2 = "Unmatched Power of the Sun"
            A_3 = CFrame.new(target.Character.HumanoidRootPart.Position)
            humrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
            wait(.3)

        elseif ult == "Tech Ult" then

            A_1 = "Technology"
            A_2 = "Virtual Zone"
            A_3 = 
            {
                [1] = target.Character.Head.Position,
                [2] = Vector3.new(0, 0, 0)
            }

        end
        ClMagic:FireServer(A_1, A_2)
        GMagic:InvokeServer(A_1, A_2, A_3)
        humrp.CFrame = anothercf
        wait(1)
        hum.Health = 0
    end

end)

local test1

test1 = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    if getnamecallmethod() == "FireServer" and (Args[1] == "Flip" or Args[1] == "Running") and infstam == true then return end
    return test1(self, ...)
end)

lpl.Idled:connect(function()
    if antiafk == true then
        VUser:Button2Down(Vector2.new(0,0), camera.CFrame)
        wait(1)
        VUser:Button2Up(Vector2.new(0,0), camera.CFrame)
    end
 end)

local rayparams = RaycastParams.new(workspace.Map, Enum.RaycastFilterType.Blacklist)

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and infjump == true and input.KeyCode == Enum.KeyCode.Space then
        lpl.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
        wait(.1)
        lpl.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

PlrGui.ChildAdded:Connect(function(child)
    wait()
    if antiblind == true and (child.Name == "ScreenGui" or child.Name == "ef" or child.Name == "efult") then
        wait()
        child.Enabled = false
    end
    PlrGui.Chat.Enabled = true
end)

--Try to build a house

--Presets

--Target & Teammate

Tarfold:NewTextBox("Target", "All attacks will be used on this player", function(value)
    if game.Players:FindFirstChild(value) then
        target = game.Players[value]
        print("Target: ", target)
    end
end)

Tarfold:NewToggle("Spectate", "Start/End Spectating", function(value)

    tarspec = value

    if tarspec == true then
        camera.CameraSubject = workspace[target.Name].Humanoid
        local oldtarget = target
        target.CharacterAdded:connect(function(char)
            if tarspec == true and target == oldtarget then
                camera.CameraSubject = char:WaitForChild("Humanoid")
            end
        end)
        
        lpl.CharacterAdded:connect(function()
            if tarspec == true and target == oldtarget then
                wait(1)
                camera.CameraSubject = target.Character:WaitForChild("Humanoid")
            end
        end)

    else
        camera.CameraSubject = lpl.Character.Humanoid

        lpl.CharacterAdded:Disconnect()
    end

end)

Tarfold:NewToggle("Follow", "Start/End Following", function(value)
    
    tarfol = value

    local coro = coroutine.wrap(function()
        while tarfol == true do

            lpl.Character:WaitForChild("HumanoidRootPart").CFrame = workspace[target.Name]:WaitForChild("HumanoidRootPart").CFrame
    
            wait()
        end
    end)

    coro()

end)

Tarfold:NewButton("Teleport", "You will be teleported to this player instantly", function()
    lpl.Character.HumanoidRootPart.CFrame = workspace[target.Name].HumanoidRootPart.CFrame
end)



Teamfold:NewTextBox("Teammate", "All support spells will be used on this player", function(value)
    if game.Players:FindFirstChild(value) then
        teammate = game.Players[value]
        print("Teammate: ", teammate)
    end
end)

Teamfold:NewToggle("Spectate", "Start/End Spectating", function(value)

    teamspec = value

    if teamspec == true then
        camera.CameraSubject = workspace[teammate.Name].Humanoid
        local oldteam = teammate

        teammate.CharacterAdded:connect(function(char)
            if teamspec == true and oldteam == teammate then
                camera.CameraSubject = char:WaitForChild("Humanoid")
            end
        end)
        
        lpl.CharacterAdded:connect(function()
            if teamspec == true and oldteam == teammate then
                wait(1)
                camera.CameraSubject = teammate.Character:WaitForChild("Humanoid")
            end
        end)

    else
        camera.CameraSubject = lpl.Character.Humanoid
    end

end)

Teamfold:NewToggle("Follow", "Start/End Following", function(value)
    
    teamfol = value

    local coro = coroutine.wrap(function()
        while teamfol == true do

            lpl.Character:WaitForChild("HumanoidRootPart").CFrame = workspace[teammate.Name]:WaitForChild("HumanoidRootPart").CFrame
    
            wait()
        end
    end)

    coro()

end)

Teamfold:NewButton("Teleport", "You will be teleported to this player instantly", function()
    lpl.Character.HumanoidRootPart.CFrame = workspace[teammate.Name].HumanoidRootPart.CFrame
end)

--Player

Mainfold:NewSlider("AP offset", "Adds vectors to AutoPunch", 20, 0, function(value)
    offset = value
end)

Mainfold:NewSlider("AP range", "AutoPunch range", 2000, 10, function(value)
    autopunchrange = value
end)

Mainfold:NewToggle("Auto Punch", "Punches target or nearest player", function(value)

    autopunch = value

    local coro = coroutine.wrap(function()
        while autopunch == true do

            local range = autopunchrange
            local found = 1

            if target ~= lpl then 
                found = target
            else
                for i, v in pairs(game.Players:GetChildren()) do

                    local pos1 = workspace[v.name].HumanoidRootPart.Position
                    local pos2 = lpl.Character.HumanoidRootPart.Position
                    local magn = (pos1-pos2).Magnitude
                    
    
                    if magn < range and v ~= lpl and not workspace[v.name].HumanoidRootPart:FindFirstChild("ForceField") then
                        found = v
                        range = magn
                    end
        
                end
            end

            if found ~= 1 then
                
                found = workspace[found.Name]

                local humrp1 = lpl.Character:WaitForChild("HumanoidRootPart")
                local humrp2 = workspace[found.Name]:WaitForChild("HumanoidRootPart")
                
                local pos1 = humrp2.Position
                wait(.01)
                local pos2 = humrp2.Position
                local pos = pos2 - pos1

                humrp1.CFrame = humrp2.CFrame + pos * offset
                humrp1.Velocity = Vector3.new(0, 0, 0)
            end
    
            Combat:FireServer(found)
            wait(.3)

        end
    end)

    coro()

end)

Mainfold:NewToggle("Tracers", "HP, name and hitbox", function(value)
    
    tracers = value

    if value == true then
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= lpl then
                local humrp = v.Character.HumanoidRootPart
                local hum = v.Character.Humanoid

                humrp.Size = Vector3.new(3, 5, 3)
                humrp.Transparency = 0.5
                humrp.Color = Color3.fromRGB(163, 162, 165)

                if not humrp:FindFirstChild("bgui") then
                    setupgui(hum, humrp, v)
                end

                humrp["bgui"].Enabled = true
                tracersgui(v, v.Character)
            end
        end
    else
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= lpl then
                local humrp = v.Character.HumanoidRootPart
                humrp.Size = Vector3.new(2, 2, 1)
                humrp.Transparency = 1

                humrp.bgui.Enabled = false
            end
        end
    end

end)

Mainfold:NewButton("Rejoin", "rejoin to the same server", function()
    TpServ:Teleport(game.PlaceId, lpl)
end)

Mainfold:NewButton("Platform", "Teleports you at the platform", function()
    lpl.Character.HumanoidRootPart.CFrame = testPlatform.CFrame + Vector3.new(0, 10, 0)
end)

Plrfold:NewToggle("Noclip", "Allows you clip though objects", function(value)
    
    noclip = value

    Clip = RunS.Stepped:Connect(function()

        if noclip == false then
            Clip:Disconnect()
        end

        for i, v in pairs(lpl.Character:GetChildren()) do
            if v:IsA("BasePart") and (v.Name == "Head" or v.Name == "Torso") then
                if noclip == true then
                    v.CanCollide = false
                else
                    v.CanCollide = true
                end
            end
        end    
    end)

    
end)

Plrfold:NewToggle("Fly", "Fly + anti stun", function(value)

    fly = value

    local coro = coroutine.wrap(function()

        local humrp = lpl.Character.HumanoidRootPart
        local hum = lpl.Character.Humanoid

        local bg = Instance.new('BodyGyro')
        local bv = Instance.new('BodyVelocity')

        bg.Parent = humrp
        bv.Parent = humrp

        bg.Name = "Fly"
        bv.Name = "Fly"

        local control = {l = 0, r = 0, u = 0, d = 0} --r will be negative, d will be negative
        local speed = 0

        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = humrp.CFrame

        bv.Velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        hum.PlatformStand = true

        UIS.InputBegan:Connect(function(key, IsTyping)
            if IsTyping == true then return end
            if key.KeyCode == Enum.KeyCode.W then
                control.u = 1
            elseif key.KeyCode == Enum.KeyCode.S then
                control.d = -1
            elseif key.KeyCode == Enum.KeyCode.A then
                control.l = 1
            elseif key.KeyCode == Enum.KeyCode.D then
                control.r = -1
            end
        end)

        UIS.InputEnded:Connect(function(key, IsTyping)
            if IsTyping == true then return end
            if key.KeyCode == Enum.KeyCode.W then
                control.u = 0
            elseif key.KeyCode == Enum.KeyCode.S then
                control.d = 0
            elseif key.KeyCode == Enum.KeyCode.A then
                control.l = 0
            elseif key.KeyCode == Enum.KeyCode.D then
                control.r = 0
            end
        end)

        while fly == true do
            wait()

            bg.CFrame = camera.CFrame

            if control.l + control.r ~= 0 or control.u + control.d ~= 0 then

                speed += 1 + (maxspeed/30)
                if speed > maxspeed then
                    speed = maxspeed
                end

                bv.Velocity = camera.CFrame.LookVector * speed * (control.u + control.d) + camera.CFrame.RightVector * speed * -(control.r + control.l)
            else

                speed = speed - (maxspeed/30)
                if speed < 0 then
                    speed = 0
                end

                bv.Velocity = Vector3.new(0, 0, 0)
            end

        end

        hum.PlatformStand = false
        bv:Destroy()
        bg:Destroy()

    end)

    if fly == true then
        coro()
        --Add T-Pose XD
    end
    
end)

Plrfold:NewToggle("Inf Jump", "Allows you to jump infinitely", function(value)
    infjump = value
end)

Plrfold:NewKeybind("Click TP", "Teleporting to the mouse position", Enum.KeyCode.World0, function()
    lpl.Character.HumanoidRootPart.CFrame = CFrame.new(ms.Hit.p + Vector3.new(0, 10, 0))
end)

Plrfold:NewSlider("FlySpeed", "Regulate fly speed", 2000, 0, function(value)
    maxspeed = value
end)

Plrfold:NewSlider("WalkSpeed", "Regulate WalkSpeed", 1000, 32, function(value)
    wspeed = value

    lpl.Character:WaitForChild("Humanoid").WalkSpeed = value
end)


Plrfold:NewSlider("JumpPower", "Regulate JumpPower", 1000, 50, function(value)
    lpl.Character.Humanoid.JumpPower = value
end)

--Player



--Spells

Mspells:NewButton("Blaze Column", "Blaze Column will be used on the target", function()
    
    local A_1 = "Fire"
    local A_2 = "Blaze Column"

    local humrp = workspace[target.Name].HumanoidRootPart
    
    local oldcf = lpl.Character.HumanoidRootPart.CFrame

    lpl.Character.HumanoidRootPart.CFrame = CFrame.new(humrp.Position + Vector3.new(0, 40, 0))
    wait(.15)

    local newpos = humrp.Position
    wait(.01)
    local p1 = humrp.Position
    local speed = p1-newpos

    ClMagic:FireServer(A_1, A_2, newpos)
    GMagic:InvokeServer(A_1, A_2, CFrame.new(newpos + speed * 10))

    lpl.Character.HumanoidRootPart.CFrame = oldcf

end)


Mspells:NewButton("Temporal Trap", "Temporal Trap will be used on the target", function()

    local A_1 = "Time"
    local A_2 = "Temporal Trap"
    local humrp = workspace[target.Name].HumanoidRootPart
    local oldcf = lpl.Character.HumanoidRootPart.CFrame

    local coro = coroutine.wrap(function()
        for i=1, 10 do
            lpl.Character.HumanoidRootPart.CFrame = humrp.CFrame
            wait(.025)
        end
        lpl.Character.HumanoidRootPart.CFrame = oldcf
    end)

    coro()
    wait(.2)

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2)

end)

Mspells:NewButton("Disorder Ignition", "Temporal Trap will be used on the target", function()

    local A_1 = "Chaos"
    local A_2 = "Disorder Ignition"
    local A_3 = 
    {
        ["nearestHRP"] = workspace[target.Name].Head, 
        ["nearestPlayer"] = target, 
        ["rpos"] = workspace[target.Name].Head.Position, 
        ["norm"] = Vector3.new(0, 0, 0), 
        ["rhit"] = lpl.Character["Left Arm"]
    }
    local humrp = workspace[target.Name].HumanoidRootPart
    local oldcf = lpl.Character.HumanoidRootPart.CFrame

    local coro = coroutine.wrap(function()
        for i=1, 100 do
            lpl.Character.HumanoidRootPart.CFrame = humrp.CFrame
            wait(.03)
        end
        lpl.Character.HumanoidRootPart.CFrame = oldcf
    end)

    coro()
    wait(.2)

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)
    wait(2)
    lpl.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    lpl.Character.HumanoidRootPart.CFrame = oldcf
end)

Mspells:NewKeybind("Disorder Ignition Bind", "Allows you to change deafult bind for Disorder Ignition", Enum.KeyCode.Y, function()
    local A_1 = Enum.KeyCode.Y
    local Event = game:GetService("ReplicatedStorage").Remotes.KeyReserve
    Event:FireServer(A_1)
end)

--Spells



--EXPERIMENTAL

Expfold:NewToggle("Invisibility", "Other players cant see you", function(value)
    
    invis = value

    if invis ==  true then
        
        local oldcf = lpl.Character["HumanoidRootPart"].CFrame
        lpl.Character["HumanoidRootPart"].CFrame = testPlatform.CFrame + Vector3.new(0, 10, 0)

        wait(.2)
        local humcl = lpl.Character:WaitForChild("HumanoidRootPart"):Clone()
        humcl.Parent = lpl.Character

        lpl.Character["HumanoidRootPart"].Name = "humrpclone"
        humcl.Name = "HumanoidRootPart"
        wait(.2)

        humcl.CFrame = oldcf

    else
        local humrp = lpl.Character["HumanoidRootPart"]
        lpl.Character["humrpclone"].CFrame = humrp.CFrame
        lpl.Character["humrpclone"].Name = "HumanoidRootPart"

        humrp:Destroy()
    end

end)

Expfold:NewToggle("Stamina", "Infitity Stamina", function(value)
    infstam = value
end)

Expfold:NewToggle("Spawnpoint", "Allows you to spawn on a special point", function(value)
    spawnp = value
    spawncf = lpl.Character:WaitForChild("HumanoidRootPart").CFrame

    lpl.CharacterAdded:connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:connect(function()
            spawncf = char:WaitForChild("HumanoidRootPart").CFrame
        end)

        if spawnp == false then return end

        char:WaitForChild("HumanoidRootPart").CFrame = spawncf

    end)

end)

Expfold:NewToggle("Autofarm(Main)", "Start/End Autofarming as main", function(value)
    autofarmmain = value

    local coro = coroutine.wrap(function()
        while autofarmmain == true do

            local A_1 = "Ice"
            local A_2 = "Flurry Heave"
            local A_3 = 
            {
                ["ThrowingArm"] = 2
            }

            local newtarget = workspace[lpl.Name].HumanoidRootPart.Position
            local vector, inViewport = camera:WorldToViewportPoint(newtarget)

            if inViewport then
                if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    mousemoveabs(vector.x, vector.y + 22)  
                end
            end

            ClMagic:FireServer(A_1, A_2)
            GMagic:InvokeServer(A_1, A_2, A_3)

            wait(5)

            if ls.Level.value >= 225 and ls.Shards.value >= 10000 then
                local Event = game:GetService("ReplicatedStorage").Remotes.IncreaseCap
                Event:FireServer()
            end

        end
    end)

    coro()
end)

Expfold:NewToggle("Autofarm(Alt)", "Start/End Autofarming as alt", function(value)
    autofarmalt = value
end)

Expfold:NewToggle("Autowarp", "Warps you to the savepoint every .5 seconds", function(value)
    warp = value

    while warp == true do
        local humrp = lpl.Character.HumanoidRootPart
        humrp.CFrame = CFrame.new(testPlatform.Position + Vector3.new(0, 10, 0))
        wait(.5)
    end
end)

Expfold:NewToggle("Savemode", "Saves you if you are under 200 hp", function(value)
    save = value

    if value == true then
        local hum = lpl.Character:WaitForChild("Humanoid")
        local test5
        local oldcf = CFrame.new(0, 0, 0)
        
        test5 = hum.HealthChanged:Connect(function(hp)
            if hum.Health < 20 and hum.Health > 0 and save == true and oldcf.Position.X == 0 then
                oldcf = lpl.Character.HumanoidRootPart.CFrame
                lpl.Character.HumanoidRootPart.CFrame = CFrame.new(testPlatform.Position + Vector3.new(0, 10, 0))
            elseif hum.Health <= 0 then
                test5:Disconnect()
            elseif hum.Health > 30 and oldcf.Position.X ~= 0 then
                lpl.Character.HumanoidRootPart.CFrame = oldcf
                oldcf = CFrame.new(0, 0, 0)
            end
        end)
    end

end)

Expfold:NewToggle("Antiafk", "Allows you to afk infinitely", function(value)
    antiafk = value
end)

Expfold:NewToggle("Antiblind", "Allows not to be blinded", function(value)
    antiblind = value
end)

Expfold:NewKeybind("Aimlock", "Locks your mouse on the enemy", Enum.KeyCode.World0, function()
    aimbot = not aimbot
    local oldpos = workspace[target.Name].HumanoidRootPart.Position
    local newpos

    local coro = coroutine.wrap(function()
        local humrp = lpl.Character.HumanoidRootPart
        while aimbot == true do
            newpos = workspace[target.Name].HumanoidRootPart.Position

            local newtarget = workspace[target.Name].HumanoidRootPart.Position
            local vector, inViewport = camera:WorldToViewportPoint(newtarget)

            if not inViewport then
                aimbot = not aimbot
                break
            end
            
            if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                mousemoveabs(vector.x, vector.y + 22)  
            end

            oldpos = newpos
            wait()
        end
    end)

    coro()
end)

Expfold:NewButton("Server Hop", "join to a different server", function()
    --I have 0 idea how this thing works, but im fine with this fact
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false

    local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
    end)

    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
    end

    local function TPReturner()
        local Site
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end

        local ID = ""

        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0

        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    
    local function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end

    Teleport()
    --just dont touch this thing
end)









--SPELLS

local test2

local blaze
local vine
local waterbeam
local lightningbullets
local bolt
local rocktp
local flashtp
local spiritbullets
local lightbullets
local lightbeam
local lightmassive
local plasmamassive
local crystalheal
local timetrap --??
local timemassive 
local gravshield
local darknessmassive
local spectrumtp
local pheonixmassive
local soundbeam
local explosiontp
local chaosgrab --instakill --??
local illusionbeam
local illusionmassive --instakill
local acidtp --instakill
local acidmassive
local angelbeam
local slimemassive
local slimeheal
local slimeshield --??
local techbullet
local techbeam
local techtp --??
local solarbeam --??
local angelult --probably the best cheat ult
local slimeult --killall button

local start = false
local chain = false

local tpattack = function(humrp, tarhumrp, oldcf, speed, Args1, Args2)

    if (tarhumrp.Position - humrp.Position).Magnitude > 200 then
        humrp.CFrame = CFrame.new(tarhumrp.Position + Vector3.new(0, 50, 0))
    end

    local A_3 = CFrame.new(tarhumrp.Position + speed)
    
    delay(.2, function()
        GMagic:InvokeServer(Args1, Args2, A_3)
        humrp.CFrame = oldcf
    end)
end

local beamattack = function(humrp, tarhumrp, speed, Args1, Args2)
    local A_3 = 
    { ["Origin"] = tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12 + speed}

    delay(.03, function()
        GMagic:InvokeServer(Args1, Args2, A_3)
    end)

end

test2 = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    if getnamecallmethod() == "FireServer" and start == true and self.Name == "DoClientMagic" then

        local A_3
        local tarhumrp = workspace[target.Name].HumanoidRootPart
        local humrp = lpl.Character.HumanoidRootPart
        local oldcf = humrp.CFrame
        local speed = tarhumrp.Velocity

        if Args[2] == "Blaze Column" and blaze == true then
            tpattack(humrp, tarhumrp, oldcf, speed/3, Args[1], Args[2])
        elseif Args[2] == "Lightning Bolt" and bolt == true then
            beamattack(humrp, humrp, Vector3.new(0, 0, 0), Args[1], Args[2]) --this can be changed
        elseif Args[2] == "Rock Fist" and rocktp == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], { ["Grounded"] = true})
            end)
        elseif Args[2] == "Amaurotic Lambent" and lightmassive == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], { ["lastPos"] = tarhumrp.Position})
            end)
        elseif Args[2] == "Plasma Implosion" and plasmamassive == true then
            humrp.CFrame = CFrame.new(tarhumrp.Position + Vector3.new(0, 30, 0))
            delay(.2, function()
                GMagic:InvokeServer(Args[1], Args[2], CFrame.new(tarhumrp.Position + speed/3))
                humrp.CFrame = oldcf
            end)
        elseif Args[2] == "Gravital Globe" and gravshield == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], { ["lastPos"] = tarhumrp.Position})
            end)
        elseif Args[2] == "Echoes" and soundbeam == true then
            humrp.CFrame = CFrame.new(tarhumrp.Position + Vector3.new(0, 50, 0))
            delay(.2, function()
                GMagic:InvokeServer(Args[1], Args[2], {3, tarhumrp.Position})
                humrp.CFrame = oldcf
            end)
        elseif Args[2] == "Refraction" and illusionbeam == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], CFrame.new(tarhumrp.Position + Vector3.new(0, 50, 0), tarhumrp.Position))
            end)
        elseif Args[2] == "Divine Arrow" and angelbeam == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], { ["mouse"] = ms.Hit.p, ["charge"] = 9e9 }) --only with mousep
            end)
        elseif Args[2] == "Splitting Slime" and slimemassive == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], CFrame.new(tarhumrp.Position + Vector3.new(0, -20, 0) + speed/2))
            end)
        elseif Args[2] == "Slime Buddies" and slimeheal == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], CFrame.new(tarhumrp.Position))
            end)
        elseif Args[2] == "Orbital Strike" and techbeam == true then
            delay(.03, function()
                GMagic:InvokeServer(Args[1], Args[2], CFrame.new(tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12, ms.Hit.p))
            end)
        end

        return test2(self, ...)

    elseif getnamecallmethod() == "InvokeServer" and start == true and self.Name == "DoMagic" then

        local A_3
        local tarhumrp = workspace[target.Name].HumanoidRootPart
        local humrp = lpl.Character.HumanoidRootPart
        local oldcf = humrp.CFrame
        local speed = tarhumrp.Velocity

        if Args[2] == "Lightning Barrage" and lightningbullets == true then
            Args[3] = { ["Direction"] = CFrame.new(tarhumrp.Position + Vector3.new(0, 250, 0) + speed/2, tarhumrp.Position + speed/2) }
        elseif Args[2] == "Lightning Flash" and flashtp == true then
            Args[3] = {
                ["End"] = ms.Hit.p,
                ["Origin"] = humrp.Position
            }
        elseif Args[2] == "Vigor Gyration" and spiritbullets == true then
            Args[3] = {}
            for i=1, 50 do
                table.insert(Args[3], CFrame.new(tarhumrp.Position))
            end
        elseif Args[2] == "Orbs of Enlightenment" and lightbullets == true then
            Args[3] = { ["Origin"] = Vector3.new(0, 0, 0), ["Coordinates"] = {}}
            for i=1, 50 do
                table.insert(Args[3]["Coordinates"], CFrame.new(tarhumrp.Position))
            end
        elseif Args[2] == "Genesis Ray" and timemassive == true then
            Args[3] = { ["charge"] = 9e9, ["lv"] = Vector3.new(0, 0, 0) }
        elseif Args[2] == "Hyperang" and techbullet == true then
            Args[3] = CFrame.new(tarhumrp.Position + speed/4)
        elseif Args[2] == "Gleaming Harmony" and crystalheal == true then
            Args[3] = workspace[teammate.Name].HumanoidRootPart.CFrame.Position
        elseif Args[2] == "Rainbow Shockwave" and spectrumtp == true then
            Args[3] = { ["Dir"] = CFrame.new(tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12, ms.Hit.p)}
            delay(.4, function()
                humrp.CFrame = oldcf
            end)
        elseif Args[2] == "Blue Arson" and pheonixmassive == true then 
            Args[3] = workspace[teammate.Name].HumanoidRootPart.CFrame.Position
        elseif Args[2] == "Sewer Burst" and acidmassive == true then 
            local pos = tarhumrp.Position
            Args[3] = 
            {
                ["Mouse"] = pos, 
                ["Camera"] = pos + Vector3.new(0, 100, 0), 
                ["Spawn"] = CFrame.new(pos), 
                ["Origin"] = CFrame.new(pos) 
            }
        elseif Args[2] == "Septic Splatter" and acidtp == true then 
            delay(.1, function()
                for i=1, 10 do
                    humrp.CFrame = tarhumrp.CFrame
                    wait(.05)
                end
                humrp.CFrame = oldcf
            end)
        elseif Args[2] == "Illusive Atake" and illusionmassive == true then
            Args[3] = CFrame.new(tarhumrp.Position)
        elseif Args[2] == "Water Beam" and waterbeam == true then
            Args[3] = {["Origin"] = tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12 + speed/3}
        elseif Args[2] == "Auroral Blast" and lightbeam == true then
            Args[3] = {["Origin"] = tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12 + speed/3}
        elseif Args[2] == "Vine" and vine == true then
            Args[3] = {["Origin"] = tarhumrp.Position + (tarhumrp.Position - ms.Hit.p).Unit * 12 + speed/3}
        end

        if Args[3] ~= nil then
            return test2(self, Args[1], Args[2], Args[3])
        else
            return test2(self, ...)
        end


    else

        return test2(self, ...)

    end

end)

Modspells:NewToggle("Modification", "Allows you to start the mods and also fix them", function(value)
    start = value
end)

Modspells:NewToggle("Blaze Column", "Allows you to spawn massive in the enemy", function(value)
    blaze = value
end)

Modspells:NewToggle("Vine", "Allows you to spawn tp in the enemy", function(value)
    vine = value
end)

Modspells:NewToggle("Water Beam", "Allows you to spawn beam in the enemy", function(value)
    waterbeam = value
end)

Modspells:NewToggle("Rock Fist", "Allows you to spawn tp instantly", function(value)
    rocktp = value
end)

Modspells:NewToggle("Lightning Bolt", "Allows you to spawn beam instantly", function(value)
    bolt = value
end)

Modspells:NewToggle("Lightning Barrage", "Allows you to spawn bullets in the enemy", function(value)
    lightningbullets = value
end)

Modspells:NewToggle("Lightning Flash", "Allows you to use flash with inf range", function(value)
    flashtp = value
end)

Modspells:NewToggle("Vigor Gyration", "Allows you to spawn bullets instantly", function(value)
    spiritbullets = value
end)

Modspells:NewToggle("Orbs of Enlightenment", "Allows you to spawn bullets instantly", function(value)
    lightbullets = value
end)

Modspells:NewToggle("Auroral Blast", "Allows you to spawn beam in the enemy", function(value)
    lightbeam = value
end)

Modspells:NewToggle("Amaurotic Lambent", "Allows you to spawn massive in the enemy", function(value)
    lightmassive = value
end)

Modspells:NewToggle("Plasma Implosion", "Allows you to spawn massive in the enemy", function(value)
    plasmamassive = value
end)

Modspells:NewToggle("Gleaming Harmony", "Allows you to spawn heal instantly", function(value)
    crystalheal = value
end)

Modspells:NewToggle("Genesis Ray", "Allows you to spawn inf time massive", function(value)
    timemassive = value
end)

Modspells:NewToggle("Gravital Globe", "Allows you to spawn shield in the enemy", function(value)
    gravshield = value
end)

Modspells:NewToggle("Rainbow Shockwave", "Allows you to spawn tp in the enemy", function(value)
    spectrumtp = value
end)

Modspells:NewToggle("Blue Arson", "Allows you to spawn massive in the enemy", function(value)
    pheonixmassive = value
end)

Modspells:NewToggle("Echoes", "Allows you to spawn beam in the enemy", function(value)
    soundbeam = value
end)

Modspells:NewToggle("Refraction", "Allows you to spawn beam in the enemy", function(value)
    illusionbeam = value
end)

Modspells:NewToggle("Illusive Atake", "Allows you to spawn massive in the enemy", function(value)
    illusionmassive = value
end)

Modspells:NewToggle("Septic Splatter", "Allows you to spawn tp in the enemy", function(value)
    acidtp = value
end)

Modspells:NewToggle("Sewer Burst", "Allows you to spawn massive in the enemy", function(value)
    acidmassive = value
end)

Modspells:NewToggle("Divine Arrow", "Allows you to spawn beam instantly", function(value)
    angelbeam = value
end)

Modspells:NewToggle("Splitting Slime", "Allows you to spawn massive in the enemy", function(value)
    slimemassive = value
end)

Modspells:NewToggle("Slime Buddies", "Allows you to spawn heal in the enemy", function(value)
    slimeheal = value
end)

Modspells:NewToggle("Hyperang", "Allows you to spawn bullet in the enemy", function(value)
    techbullet = value
end)

Modspells:NewToggle("Orbital Strike", "Allows you to spawn beam in the enemy", function(value)
    techbeam = value
end)

Uspells:NewToggle("Ult Chain", "Start/End ult chaining", function(value)
    ultchain = value

    if ultchain == true then
        lpl.Character.Humanoid.Health = 0
    end
end)

Uspells:NewSlider("Ult offset", "Time between grab and ult", 10, 0, function(value)
    uwait = value
end)

Uspells:NewDropdown("Select ult", "Select ult for chaining", {"Fire Ult", "Time Ult", "Light Ult", "Angel Ult", "Tech Ult", "Solar Ult"}, function(value)
    ult = value
end)

Uspells:NewButton("Light Ult", "Use Light Ult on person", function()
    
    local A_1 = "Light"
    local A_2 = "Ablaze Judgement"
    local A_3 = 
    {
        ["orbPos"] = target.Character.HumanoidRootPart.Position, 
        ["Origin"] = target.Character.HumanoidRootPart.Position
    }

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)

end)

Uspells:NewButton("Angel Ult", "Use Angel Ult on person", function()

    local A_1 = "Angel"
    local A_2 = "Arcane Guardian"
    local A_3 = 
    {
        ["Position"] = target.Character.HumanoidRootPart.Position + Vector3.new(0, 25, 0)
    }

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)

end)

Uspells:NewButton("Time Ult", "Use Time Ult on person", function()
    
    local A_1 = "Time"
    local A_2 = "The World"
    local A_3 = 
    {
        ["rpos"] = target.Character.HumanoidRootPart.Position, 
        ["norm"] = Vector3.new(0, 0, 0), 
        ["rhit"] = target.Character.Head
    }

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)
end)

Uspells:NewButton("Tech Ult", "Use Tech Ult on person", function()
    
    local A_1 = "Technology"
    local A_2 = "Virtual Zone"
    local A_3 = 
    {
        [1] = target.Character.Head.Position,
        [2] = Vector3.new(0, 0, 0)
    }

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)
end)

Uspells:NewButton("Solar Ult", "Use Solar Ult on person", function()
    
    local humrp = lpl.Character.HumanoidRootPart
    local oldcf = humrp.CFrame

    local A_1 = "Solar"
    local A_2 = "Unmatched Power of the Sun"
    local A_3 = CFrame.new(target.Character.HumanoidRootPart.Position)
    humrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
    wait(.3)

    ClMagic:FireServer(A_1, A_2)
    GMagic:InvokeServer(A_1, A_2, A_3)

    humrp.CFrame = oldcf
end)

--SPELLS

