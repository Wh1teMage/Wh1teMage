local Library    = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Players    = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UIS        = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TPService  = game:GetService("TeleportService")
local VUser      = game:GetService("VirtualUser")
local Lighting   = game:GetService("Lighting")
local TS         = game:GetService("TweenService")
local Debris     = game:GetService("Debris")

local pastebinDataBase = loadstring(game:HttpGet('https://pastebin.com/raw/SfyG7vCN'))()

local HWID = game:GetService('RbxAnalyticsService'):GetClientId()

local localVersion = 568438321513325458
local versionKey   = 1746

local keys = 
{
    '^*4H#$kGf',
    'jtg%($;kF',
}

local numberSystem = {'6', '9', '4', '2', '0', '5', '7', 'A', 'B', 'C', 'D', 'E', '@', '%', '-'} 

local passes = 0

local function toNS(num, NS)
    local newnum = {}
   
    while num > 0 do
     i = num%#NS
     table.insert(newnum, NS[i+1])
     num = (num/#NS)-(num/#NS)%1
    end
   
    return newnum
end

local function encrypt(numInNS, keyInNS)
    local newnum = {}
   
    for i, v in pairs(numInNS) do
     local key = keyInNS[(i%(#keyInNS-1))+1]
   
    if key == v then table.insert(newnum, 1) else table.insert(newnum, 0) end
    end
   
    return newnum
end

local function fromNS(numInNS, NS)
    local n = 0
   
    for i, v in pairs(numInNS) do
     n = n+v*((#NS)^i)
    end
   
    return n
end

local versionLength  = 0
local formatedVerion = toNS(fromNS(encrypt(toNS(localVersion, {0,1}), toNS(versionKey, {0,1})), {0, 1}), numberSystem)

for i, v in pairs(formatedVerion) do
    if pastebinDataBase['Version']:sub(i,i) ~= v then passes -= 1 break end
    versionLength += 1
end

if versionLength == #formatedVerion then passes += 1 end
if pastebinDataBase['HWIDs'][HWID] ~= nil then passes += 1 end
for i, v in pairs(keys) do if v == getrenv().exploitKey then passes += 1 break end end

while passes ~= 3 do warn('You are not whitelisted') task.wait() end

warn('Welcome back, '..game.Players.LocalPlayer.Name..'!')
warn(
    [[

        A brief description:

            You can modify your spells by clicking M in your Inventory

            You can chain your spells by clicking C in your Inventory

            Remember that you can create combinations with Pannel's functions

        Have fun with The Void!

        (If you have any more questions ask WhiteMage#0174)
    ]]
)

local types = pastebinDataBase['Types']
local CDs   = pastebinDataBase['CDs']

local elementsTypes = pastebinDataBase['ElementsTypes']
local projectiles   = pastebinDataBase['Projectiles']
local specialUsers  = pastebinDataBase['SpecialUsers']

local spells = 
{
    ['Modified'] = {},
    ['Chained']  = {}
}

local spellsLibrary = 
{
    ['Event']    = {},
    ['Function'] = {},
}

local ClassPlayers = 
{
    ['Enemies'] = {},
    ['Allies']  = {}
    
}

local DoClientMagic = Replicated['Remotes']['DoClientMagic']
local DoMagic       = Replicated['Remotes']['DoMagic']
local Combat        = Replicated['Remotes']['Combat']
local KeyReserve    = Replicated['Remotes']['KeyReserve']
local PlayerData    = Replicated['Remotes']['PlayerData']

if passes ~= 3 then while true do print('') end end

repeat task.wait() until game:IsLoaded()

local Player = {}

function Player.new(playerObj)

    if playerObj == nil then return end

	local newPlayer = {}
	local proxyPlayer = {}

	local detectingProperties = {}

	local mt = 
		{
			__index = function(self, key)
				return proxyPlayer[key]
			end,

			__newindex = function(self, key, value)

				if detectingProperties[key] ~= nil and detectingProperties[key]['function'] ~= nil then
					detectingProperties[key]['function'](key, proxyPlayer[key], value)
				end

				proxyPlayer[key] = value
			end
		}

	setmetatable(newPlayer, mt)

	function newPlayer:GetPropertyChangedSignal(property)
		
		local propertyTable = {}

		function propertyTable:Connect(f)
			propertyTable['function'] = f
		end

		function propertyTable:Disconnect()
			propertyTable['function'] = nil
		end
		
		detectingProperties[property] = propertyTable
		
		return propertyTable
	end

    function newPlayer:Destroy(name, type)
        ClassPlayers[type][name] = nil
        newPlayer = nil
    end
	
    newPlayer.Obj         = playerObj
    newPlayer.Character   = playerObj.Character or playerObj.CharacterAdded:Wait()
    newPlayer.PrimaryPart = playerObj.Character:WaitForChild('HumanoidRootPart', 5)
    newPlayer.Humanoid    = playerObj.Character:WaitForChild('Humanoid', 5)
    --newPlayer.Leaderstats = playerObj.leaderstats
    newPlayer.CFrame      = CFrame.new(0,0,0)
    newPlayer.ExtraCFrame = CFrame.new(0,0,0)
    newPlayer.Velocity    = Vector3.new(0,0,0)

    function newPlayer:HasShield() if newPlayer.Character:FindFirstChild('ForceField') == nil or getrenv()._G['PlayersData'][playerObj] == nil then return false else return true end end

    task.spawn(function()
        while Players[playerObj.Name] ~= nil do
            task.wait(.1)

            if newPlayer == nil then break end
            if newPlayer.Character == nil then newPlayer.Character = playerObj.CharacterAdded:Wait() end

            if newPlayer.Character.PrimaryPart == nil then continue end
            newPlayer.ExtraCFrame = newPlayer.CFrame
            newPlayer.CFrame = newPlayer.Character.PrimaryPart.CFrame
        end
    end)

    playerObj.CharacterAdded:Connect(function()
        if newPlayer == nil then return end
        newPlayer.Character = playerObj.Character or playerObj.CharacterAdded:Wait()

        newPlayer.PrimaryPart = playerObj.Character:WaitForChild('HumanoidRootPart', 5)
        newPlayer.Humanoid    = playerObj.Character:WaitForChild('Humanoid', 5)
    end)

    local velocityConnection

    pcall(function()
        velocityConnection = RunService.Heartbeat:Connect(function()
            if newPlayer == nil then velocityConnection:Disconnect() end
            if newPlayer.PrimaryPart == nil then return end
    
            local startTime     = os.clock()
            local startPosition = newPlayer.PrimaryPart.Position
    
            task.wait(.01)
    
            newPlayer.Velocity = (newPlayer.PrimaryPart.Position - startPosition)/(os.clock() - startTime)
        end)    
    end)

    local connection

    connection = Players.PlayerRemoving:Connect(function(player)
        if player ~= playerObj then return end

        newPlayer = {}
        connection:Disconnect()

    end)

	return newPlayer
end

local LocalPlayer = {}

function LocalPlayer.new(playerObj)

    local newLocalPlayer = Player.new(playerObj)

    newLocalPlayer.Camera    = workspace.CurrentCamera
    newLocalPlayer.PlayerGui = playerObj.PlayerGui
    newLocalPlayer.Mouse     = playerObj:GetMouse()

    newLocalPlayer.SelectedTarget = newLocalPlayer
    newLocalPlayer.ClosestTarget  = newLocalPlayer

    newLocalPlayer['MaxMana']     = getrenv()._G['PlayersData'][playerObj]['MaxMana']*10
    newLocalPlayer['Mana']        = newLocalPlayer['MaxMana']
    newLocalPlayer['WalkSpeed']   = 32
    newLocalPlayer['JumpPower']   = 50
    newLocalPlayer['MaxFlySpeed'] = 100
    newLocalPlayer['FlySpeed']    = 0
    newLocalPlayer['Spawnpoint']  = CFrame.new(0,0,0)
    newLocalPlayer['PreviousCF']  = CFrame.new(0,0,0)

    newLocalPlayer['Fly']      = false
    newLocalPlayer['InfJump']  = false
    newLocalPlayer['Noclip']   = false
    newLocalPlayer['Spectate'] = false
    newLocalPlayer['Follow']   = false

    newLocalPlayer['InfStamina']   = false
    newLocalPlayer['Invisibility'] = false
    newLocalPlayer['AntiBlind']    = false
    newLocalPlayer['AntiStun']     = false
    newLocalPlayer['Tracers']      = false
    newLocalPlayer['ResetOnMana']  = false
    newLocalPlayer['Aimbot']       = false
    newLocalPlayer['AutoPunch']    = false
    newLocalPlayer['AutoFarm']     = false
    newLocalPlayer['NoBulletsCD']  = false

    newLocalPlayer['HasFinishedRespawning'] = false

    newLocalPlayer['Controls'] = 
    {
        [Enum.KeyCode.W] = 0,
        [Enum.KeyCode.S] = 0,
        [Enum.KeyCode.A] = 0,
        [Enum.KeyCode.D] = 0,
    }

    local bodyVelocity = Instance.new("BodyVelocity")
    local bodyGyro     = Instance.new("BodyGyro")

    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.MaxTorque    = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Name     = 'bv'
    bodyGyro.Name         = 'bg'

    bodyVelocity.Parent = newLocalPlayer.Obj
    bodyGyro.Parent     = newLocalPlayer.Obj

    local function setControl(key, event, num)
        if newLocalPlayer['Controls'][key] == nil or event then return end
        newLocalPlayer['Controls'][key] = num
    end

    local function changeHumanoidWalkSpeed(hum)

        local connection

        connection = hum:GetPropertyChangedSignal'WalkSpeed':Connect(function()
            
            if newLocalPlayer.WalkSpeed >= 64 then
                newLocalPlayer.Humanoid.WalkSpeed = newLocalPlayer.WalkSpeed
            end

        end)

        hum.Died:Connect(function() connection:Disconnect() end)
    end

    local function deleteBodyMovers(char)

        local hum = char:WaitForChild('Humanoid')
        local connection

        connection = char.DescendantAdded:Connect(function(child)
            if (child:IsA('BodyPosition') or child:IsA('BodyVelocity')) and child.Name ~= 'bv' and child.MaxForce ~= Vector3.new(54000, 0, 54000) and newLocalPlayer.AntiStun == true then task.wait(.05) child:Destroy() end
        end)

        hum.Died:Connect(function() connection:Disconnect() end)
    end

    local function changeSpawnpoint(hum)
        local connection
        connection = hum.Died:Connect(function()
            if newLocalPlayer.Spawnpoint ~= CFrame.new(0,0,0) then newLocalPlayer.Spawnpoint = newLocalPlayer.CFrame end
            connection:Disconnect()
        end)
    end

    local function becomeInvisible(humrp)
        newLocalPlayer.PreviousCF = newLocalPlayer.CFrame
        humrp.CFrame = CFrame.new(math.random(10000000, 50000000), math.random(10000000, 50000000), math.random(10000000, 50000000))

        task.wait(.2)
        local humcl = humrp:Clone()
        humcl.Parent = humrp.Parent

        humrp.Name = "humrpclone"
        humcl.Name = "HumanoidRootPart"
        task.wait(.2)

        humcl.CFrame = newLocalPlayer.PreviousCF
        task.wait(.2)
    end

    UIS.InputBegan:Connect(function(input, event) setControl(input.KeyCode, event, 1) end)
    UIS.InputEnded:Connect(function(input, event) setControl(input.KeyCode, event, 0) end)

    function newLocalPlayer:FlyFunction(value)
        newLocalPlayer.Fly = value
        if value == false then return end

        task.spawn(function()
            
            local keys = newLocalPlayer['Controls']

            local bv
            local bg

            while newLocalPlayer.Fly == true do
                task.wait()
            
                if newLocalPlayer.Invisibility == true then newLocalPlayer.Character:WaitForChild('humrpclone', 10) end

                newLocalPlayer.Humanoid.PlatformStand = true

                bv = newLocalPlayer.PrimaryPart:FindFirstChild('bv')
                bg = newLocalPlayer.PrimaryPart:FindFirstChild('bg')

                if bv == nil then bodyVelocity:Clone().Parent = newLocalPlayer.PrimaryPart continue end
                if bg == nil then bodyGyro:Clone().Parent = newLocalPlayer.PrimaryPart continue end 

                bg.CFrame = newLocalPlayer.Camera.CFrame
                bv.Velocity = 
                    newLocalPlayer.Camera.CFrame.lookVector * newLocalPlayer.FlySpeed * (keys[Enum.KeyCode.W] - keys[Enum.KeyCode.S]) + 
                    newLocalPlayer.Camera.CFrame.rightVector * newLocalPlayer.FlySpeed * (keys[Enum.KeyCode.D] - keys[Enum.KeyCode.A])

                local speedMulti = math.abs(keys[Enum.KeyCode.W] - keys[Enum.KeyCode.S]) + math.abs(keys[Enum.KeyCode.D] - keys[Enum.KeyCode.A])
                if speedMulti == 0 then speedMulti = -1 end
                
                newLocalPlayer.FlySpeed += newLocalPlayer.MaxFlySpeed/30 * speedMulti
                newLocalPlayer.FlySpeed = math.clamp(newLocalPlayer.FlySpeed, 0 , newLocalPlayer.MaxFlySpeed)
            end

            bv:Destroy()
            bg:Destroy()

            newLocalPlayer.Humanoid.PlatformStand = false
            newLocalPlayer.Fly = false

        end)

    end

    function newLocalPlayer:NoclipFunction(value)
        newLocalPlayer.Noclip = value
        if value == false then return end

        local connection

        connection = RunService.Stepped:Connect(function()

            if newLocalPlayer.Noclip == false then connection:Disconnect() end

            for _, child in ipairs(newLocalPlayer.Character:GetChildren()) do
                if not (child.Name == 'Head' or child.Name == 'Torso') then continue end

                child.CanCollide = false
            end


        end)

    end

    function newLocalPlayer:InfJumpFunction(value)

        newLocalPlayer.InfJump = value
        if value == false then return end

        local connection

        connection = UIS.InputBegan:Connect(function(input, event)

            if newLocalPlayer.InfJump == false then connection:Disconnect() return end
            if event or input.KeyCode ~= Enum.KeyCode.Space then return end
    
            newLocalPlayer.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
            task.wait(.1)
            newLocalPlayer.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    
        end)
    
    end

    function newLocalPlayer:FollowFunction(value)
        newLocalPlayer.Follow = value
        if value == false then return end

        while newLocalPlayer.Follow == true do
            newLocalPlayer.Character.HumanoidRootPart.CFrame = newLocalPlayer.SelectedTarget.PrimaryPart.CFrame
            newLocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            task.wait()
        end
    end

    local spectateConnection = nil

    function newLocalPlayer:SpectateFunction(value)
        newLocalPlayer.Spectate = value
        if value == false then return end

        task.spawn(function()
            while newLocalPlayer.Spectate == true do
                newLocalPlayer.Camera.CameraSubject = newLocalPlayer.SelectedTarget.Character:WaitForChild('Humanoid', 2)
                task.wait(.1)
            end

            newLocalPlayer.Camera.CameraSubject = newLocalPlayer.Humanoid
        end)
    end

    function newLocalPlayer:TeleportFunction()
        newLocalPlayer.Character.HumanoidRootPart.CFrame = newLocalPlayer.SelectedTarget.PrimaryPart.CFrame
        newLocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end

    function newLocalPlayer:ClickTPFunction()
        newLocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newLocalPlayer.Mouse.Hit.Position + Vector3.new(0, 5, 0))
    end

    function newLocalPlayer:SpawnpointFunction(value)
        if value == false then newLocalPlayer.Spawnpoint = CFrame.new(0,0,0) return end
        newLocalPlayer.Spawnpoint = CFrame.new(0,1,0)
    end

    function newLocalPlayer:AutoPunchFunction(value)
        newLocalPlayer.AutoPunch = value
        if value == false then return end

        task.spawn(function()
            while newLocalPlayer.AutoPunch == true do
                Combat:FireServer(newLocalPlayer.ClosestTarget.Character)
                task.wait(.1)
            end
        end)

    end

    function newLocalPlayer:InvisibleFunction(value)
        newLocalPlayer.Invisibility = value

        if value == false then

            local humrp = newLocalPlayer.Character['HumanoidRootPart']
            newLocalPlayer.Character["humrpclone"].CFrame = humrp.CFrame
            newLocalPlayer.Character["humrpclone"].Name = "HumanoidRootPart"
    
            humrp:Destroy()

            return 
        end

        becomeInvisible(newLocalPlayer.PrimaryPart)
    end

    newLocalPlayer:GetPropertyChangedSignal('JumpPower'):Connect(function(key, old, new)
        newLocalPlayer.Humanoid.JumpPower = new
    end)

    newLocalPlayer:GetPropertyChangedSignal('WalkSpeed'):Connect(function(key, old, new)
        newLocalPlayer.Humanoid.WalkSpeed = new
    end)

    changeHumanoidWalkSpeed(newLocalPlayer.Humanoid)
    changeSpawnpoint(newLocalPlayer.Humanoid)
    deleteBodyMovers(newLocalPlayer.Character)

    newLocalPlayer.Obj.CharacterAdded:Connect(function()

        newLocalPlayer.Obj.CharacterAppearanceLoaded:Wait()

        newLocalPlayer.Humanoid.WalkSpeed = newLocalPlayer.WalkSpeed
        newLocalPlayer.Humanoid.JumpPower = newLocalPlayer.JumpPower

        newLocalPlayer:SpectateFunction(newLocalPlayer.Spectate)
        changeSpawnpoint(newLocalPlayer.Humanoid)
        changeHumanoidWalkSpeed(newLocalPlayer.Humanoid)
        deleteBodyMovers(newLocalPlayer.Character)

        if newLocalPlayer.Invisibility == true then becomeInvisible(newLocalPlayer.PrimaryPart) end
        if newLocalPlayer.Spawnpoint ~= CFrame.new(0,0,0) then newLocalPlayer.Character.HumanoidRootPart.CFrame = newLocalPlayer.Spawnpoint end

        while newLocalPlayer:HasShield() or getrenv()._G['safezoned'] == true do task.wait() end

        newLocalPlayer.HasFinishedRespawning = true
        local connection; connection = newLocalPlayer.Humanoid.Died:Connect(function() newLocalPlayer.HasFinishedRespawning = false; connection:Disconnect() end)
    end)

    local spawnConnection

    spawnConnection = newLocalPlayer.Humanoid.Died:Connect(function()
        if newLocalPlayer.Spawnpoint ~= CFrame.new(0,0,0) then newLocalPlayer.Spawnpoint = newLocalPlayer.CFrame end
        newLocalPlayer.HasFinishedRespawning = false
        spawnConnection:Disconnect()
    end)

    newLocalPlayer.HasFinishedRespawning = true

    return newLocalPlayer

end

local Enemy = {}

function Enemy.new(playerObj, localPlayer, spellsClass)
    
    if playerObj == localPlayer.Obj then return end

    local newEnemy = Player.new(playerObj)

    newEnemy.Type = 'Enemies'
    newEnemy.PredictedPosition = Vector3.new(0,0,0)

    function newEnemy:Distance() return (newEnemy.CFrame.Position - localPlayer.CFrame.Position).Magnitude end

    function newEnemy:MouseDistance() 
        position, inViewport = localPlayer.Camera:WorldToViewportPoint(newEnemy.CFrame.Position)
        if inViewport == false then return 9e9 end
        return (Vector2.new(localPlayer.Mouse.X, localPlayer.Mouse.Y + 35) - Vector2.new(position.X, position.Y)).Magnitude
    end

    function newEnemy:GetClosest()
        local closest = newEnemy

        for _, enemy in pairs(ClassPlayers['Enemies']) do
            if enemy:Distance() > closest:Distance() or ClassPlayers['Allies'][enemy.Obj.Name] ~= nil or enemy:HasShield() == true or enemy.Humanoid.Health <= 0 then continue end

            closest = enemy
        end

        return closest
    end

    function newEnemy:GetClosestToMouse()
        local closest = newEnemy

        for _, enemy in pairs(ClassPlayers['Enemies']) do
            if enemy:MouseDistance() > closest:MouseDistance() or enemy:HasShield() == true or enemy.Humanoid.Health <= 0 then continue end

            closest = enemy
        end

        return closest
    end

    ClassPlayers['Enemies'][newEnemy.Obj.Name] = newEnemy

    return newEnemy

end

local Ally = {}

function Ally.new(playerObj, localPlayer)
    
    local newAlly = Player.new(playerObj)

    newAlly.Type = 'Allies'

    function newAlly:Distance() return (newAlly.CFrame.Position - localPlayer.CFrame.Position).Magnitude end

    function newAlly:GetClosest()
        local closest = newAlly

        for _, ally in pairs(ClassPlayers['Allies']) do
            if ally:Distance() > closest:Distance() then continue end

            closest = ally
        end

        return closest
    end

    function newAlly:GetLowestOnHealth()
        local lowest = newAlly

        for _, ally in pairs(ClassPlayers['Allies']) do
            if ally.Humanoid.Health/ally.Humanoid.MaxHealth > lowest.Humanoid.Health/lowest.Humanoid.MaxHealth or ally.Humanoid.Health <= 0 then continue end

            lowest = ally
        end

        return lowest
    end

    ClassPlayers['Allies'][newAlly.Obj.Name] = newAlly

    return newAlly

end

local GUI = {}

function GUI.new(localPlayer)
    
    local newGUI = {}

    newGUI.SelectSlot = localPlayer.PlayerGui.Main.SelectSlot
    newGUI.Inventory  = localPlayer.PlayerGui.Main.Character.Available.ScrollingFrame.Frame
    newGUI.Members    = localPlayer.PlayerGui.Main.MembersFrame.Frame
    newGUI.ManaLabel  = localPlayer.PlayerGui.Main.SkillsBar.Energy.TextLabel

    newGUI.IsLoaded   = false

    local function writeTextOnGUI(text, obj, updateRate)
        local counter = 1
        
        while counter <= string.len(text) do
            obj.Text = string.sub(text, 1, counter)
            counter += 1
            task.wait(updateRate)
        end
        task.wait(.4)
    end
    

    function newGUI:TracePerson(Person)

        local billboardGui = Instance.new("BillboardGui")
        local textbox1     = Instance.new("TextBox")

        billboardGui.Size = UDim2.new(0, 200, 0, 40)
        billboardGui.Name = "billboardGui"
        billboardGui.MaxDistance = 5000
        billboardGui.StudsOffset = Vector3.new(0, 12, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Enabled     = false

        textbox1.BackgroundTransparency = 1
        textbox1.TextColor3 = Color3.fromRGB(0, 0, 0)
        textbox1.Name = "textbox1"
        textbox1.Size = UDim2.new(1, 0, 0.5, 0)
        textbox1.TextSize = 7
        textbox1.Text = Person.Obj.Name..' [Health : 1000]'
        textbox1.TextScaled = false

        local textbox2 = textbox1:Clone()

        textbox2.Position = UDim2.new(0, 0, 0.3, 0)
        textbox2.Name     = "textbox2"

        textbox2.Parent = billboardGui
        textbox1.Parent     = billboardGui
        billboardGui.Parent = Person.Obj

        local connection

        connection = RunService.RenderStepped:Connect(function()
            
            if Person.PrimaryPart == nil then return end

            local billgui = Person.PrimaryPart:FindFirstChild('billboardGui')
            if billgui == nil then Person.Obj.billboardGui:Clone().Parent = Person.PrimaryPart return end

            if Players:FindFirstChild(Person.Obj.Name) == nil then connection:Disconnect() return end
            if localPlayer.Tracers == false then billgui.Enabled = false return end

            billgui.Enabled = true
            Person.PrimaryPart.Transparency = .5
            Person.PrimaryPart.Size = Vector3.new(3, 5, 2)
            
            billgui.textbox1.TextColor3 = Color3.fromRGB(0, 0, 0)

            local name  = Person.Obj.Name

            if specialUsers[Person.Obj.Name] ~= nil then billgui.textbox1.TextColor3 = Color3.fromHSV(0, 1, 0.905); name = specialUsers[Person.Obj.Name]..' '..Person.Obj.Name end
            if ClassPlayers['Allies'][Person.Obj.Name] ~= nil then billgui.textbox1.TextColor3 = Color3.fromHSV(0.735, 1, 1) end

            local color = 1-(Person.Humanoid.Health/Person.Humanoid.MaxHealth)

            billgui.textbox1.Text = name..' [Health : '..tostring(Person.Humanoid.Health*10-(Person.Humanoid.Health*10)%1)..']'

            if getrenv()._G['PlayersData'][Person.Obj] == nil then return end

            local stamina = getrenv()._G['PlayersData'][Person.Obj]['Stamina']
            local mana    = getrenv()._G['PlayersData'][Person.Obj]['Mana']

            billgui.textbox2.Text  = '[Mana : '..tostring(mana*10-(mana*10)%1)..']'..' [Stamina : '..tostring(stamina*10-(stamina*10)%1)..']'
            billgui.textbox2.TextColor3 = Color3.fromHSV(0.735, 1, color)

        end)

    end

    function newGUI:ModifyImage(Image)

        if Image:FindFirstChild('Folder') ~= nil then Image['Folder']:Destroy() end
    
        local childFolder = Instance.new("Folder")
        childFolder.Parent = Image
    
        local UIGrid = Instance.new("UIGridLayout")
        UIGrid.CellSize = UDim2.new(0, 40, 0, 40)
        UIGrid.FillDirection = Enum.FillDirection.Vertical
        UIGrid.Parent = childFolder
    
        for _, name in {"Modified", "Chained"} do
            if spells[name][Image.Name] == nil then continue end
    
            local letter = Instance.new("TextLabel")
    
            letter.BackgroundTransparency = 1
            letter.TextStrokeTransparency = .4
    
            letter.TextScaled = true
            letter.TextColor3 = Color3.fromRGB(124, 33, 170)
            letter.FontFace   = Font.fromEnum(Enum.Font.Arcade)
            letter.ZIndex     = 100
            letter.Text       = string.sub(name, 1, 1)
    
            letter.Parent = childFolder
    
        end
    
    end

    function newGUI:GetSelectedMove()
        local available    = newGUI.Inventory:GetChildren()
        local selectedSlot = newGUI.SelectSlot

        local selectedObj  = available[2]

        for _, obj in ipairs(available) do

            if not obj:IsA('ImageButton') then continue end

            local distance = (selectedSlot.AbsolutePosition - Vector2.new(42, 42) - obj.AbsolutePosition).Magnitude
            if distance < (selectedSlot.AbsolutePosition - Vector2.new(42, 42) - selectedObj.AbsolutePosition).Magnitude then selectedObj = obj end
        end

        return selectedObj
    end

    function newGUI:SetupExploit()

        local blur 		= Instance.new("BlurEffect")
        local screenGui = Instance.new("ScreenGui")

        local frame  = Instance.new("Frame")
        local corner = Instance.new("UICorner")
        local tlabel = Instance.new("TextLabel")

        screenGui.Name = 'ExploitSetup'

        frame.BackgroundColor3 = Color3.fromRGB(44,44,44)
        frame.AnchorPoint = Vector2.new(.5, .5)
        frame.Position    = UDim2.new(.5, 0, .5, 0)
        frame.Size		  = UDim2.new(0, 0, 0 , 0)
        frame.Parent 	  = screenGui
        frame.ZIndex	  = 10

        corner.CornerRadius = UDim.new(0, 12)
        corner:Clone().Parent = frame

        local tlabel1 = tlabel:Clone()
        tlabel1.BackgroundColor3 = Color3.fromRGB(131, 4, 185)
        tlabel1.Size  = UDim2.new(1, 0, 0.45, 0)
        tlabel1.TextScaled = true
        tlabel1.TextColor3 = Color3.fromRGB(0,0,0)
        tlabel1.FontFace   = Font.fromEnum(Enum.Font.Arcade)
        tlabel1.Text = ''
        tlabel1.ZIndex = 10

        corner:Clone().Parent = tlabel1

        local tlabel2 = tlabel1:Clone()
        tlabel2.Size  = UDim2.new(1, 0, 0.55, 0)
        tlabel2.Position = UDim2.new(0, 0, 0.45, 0)
        tlabel2.TextColor3 = Color3.fromRGB(170, 85, 255)
        tlabel2.BackgroundTransparency = 1

        tlabel1.Parent = frame
        tlabel2.Parent = frame

        blur.Size = 0

        blur.Parent = Lighting
        screenGui.Parent = localPlayer.PlayerGui

        task.spawn(function()
            TS:Create(blur, TweenInfo.new(1,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = 24}):Play()
            task.wait(1)
            TS:Create(frame, TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0.17, 0, 0, 0)}):Play()
            task.wait(.5)
            TS:Create(frame, TweenInfo.new(.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.17, 0, 0.15, 0)}):Play()
            task.wait(.7)
    
            writeTextOnGUI('The Void', tlabel1, .07)
            writeTextOnGUI('Made by WhiteMage', tlabel2, .07)
    
            task.wait(1.6)
    
            tlabel1.Text = ''
            tlabel2.Text = ''
    
            TS:Create(frame, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(0.17, 0, 0, 0)}):Play()
            task.wait(.5)
            TS:Create(frame, TweenInfo.new(.7, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(.7)
            screenGui.Enabled = false
            task.wait(.5)
    
            TS:Create(blur, TweenInfo.new(1,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = 0}):Play()
            task.wait(1)

            newGUI.IsLoaded = true
        end)

    end

    function newGUI:GetPartyMembers()
        local members = {}

        if newGUI.Members:GetChildren() == nil then return members end

        for _, name in ipairs(newGUI.Members:GetChildren()) do
            if name.Text == localPlayer.Obj.Name or Players:FindFirstChild(name.Text) == nil then continue end
            members[name.Text] = Players[name.Text]
        end

        return members
    end

    localPlayer.PlayerGui.ChildAdded:Connect(function(child)
        if not ((child.Name == "ScreenGui" or child.Name == "ef" or child.Name == "efult") and localPlayer.AntiBlind == true) then return end

        child.Enabled = false
        localPlayer.PlayerGui.Chat.Enabled = true
    end)

    newGUI.ManaLabel:GetPropertyChangedSignal'Text':Connect(function()
        localPlayer.Mana = tonumber(string.match(newGUI.ManaLabel.Text, '%d+'))
    end)

    return newGUI

end

local Main = {}

function Main.new(localPlayer)

    local newMain = {}

    newMain.Hats = {}

    newMain.FlyingHats = false

    newMain.AngleOffset1 = 1
    newMain.AngleOffset2 = 2

    newMain.SinOffset1   = 2
    newMain.SinOffset2   = .7

    newMain.Distance     = 4
    newMain.SizeOffset   = 2
    newMain.Speed        = 1
    newMain.CFrameOffset = 180
    
    function newMain:SetupHats()
        newMain.Hats = {}

        for _, obj in ipairs(localPlayer.Character:GetChildren()) do
            if obj.Name == 'Handle' and obj:FindFirstChild('SpecialMesh') ~= nil then table.insert(newMain.Hats, obj) end
        end
    end

    function newMain:FlyingHatsFunction(value)
        newMain.FlyingHats = value
        if value == false then return end

        for index, hat in ipairs(newMain.Hats) do

            hat.CanCollide = false
            hat.Weld:Destroy()
            hat.AccessoryWeld:Destroy()
            
            local bodyPosition = Instance.new('BodyPosition')
            bodyPosition.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyPosition.P = 9e6
            bodyPosition.Parent = hat
            
            local bodyGyro = Instance.new('BodyGyro')
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.P = 9e4
            bodyGyro.Parent = hat
            
            local angle = 0

            task.spawn(function()
                while localPlayer.Character.Humanoid.Health > 0 and newMain.FlyingHats == true do
        
                    local humrp = localPlayer.Character:WaitForChild('HumanoidRootPart')
    
                    local currentAngle = angle + index * 360/#newMain.Hats
                    
                    local position = humrp.Position + Vector3.new(0, humrp.Size.Y/newMain.SizeOffset + math.sin(math.rad(currentAngle * newMain.AngleOffset1)) * newMain.SinOffset1 + math.sin(math.rad(currentAngle * newMain.AngleOffset2)) * newMain.SinOffset2, 0) +
                        (humrp.CFrame * CFrame.Angles(0, math.rad(currentAngle), 0)).LookVector * newMain.Distance
                        
                    local lookpos  = humrp.CFrame.lookVector
                    
                    bodyPosition.Position = position 
                    bodyGyro.CFrame = CFrame.new(position, humrp.Position) * CFrame.Angles(0, math.rad(newMain.CFrameOffset), 0)
                    angle += newMain.Speed
                    task.wait()
                end
            end)

        end

    end

    local part    = Instance.new('Part')
    part.Size     = Vector3.new(10, 1, 10)
    part.Position = Vector3.new(10000, -498, 100000)
    part.Anchored = true
    part.Material = Enum.Material.Glass
    part.Transparency = .7
    part.Parent   = workspace

    function newMain:AutoFarm(value)
        localPlayer.AutoFarm = value
        if value == false then return end

        task.spawn(function()

            local previousHP = localPlayer.Humanoid.Health

            while localPlayer.AutoFarm == true do
                localPlayer.PrimaryPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 3.5, 0))

                if previousHP > localPlayer.Humanoid.Health and localPlayer.Humanoid.Health ~= 0  then part.CanCollide = false task.wait(3) part.CanCollide = true  end

                previousHP = localPlayer.Humanoid.Health
                task.wait(.1)
            end
        end)

    end

    localPlayer.Obj.CharacterAdded:Connect(function()
        task.wait(3)
        newMain:SetupHats()
        newMain:FlyingHatsFunction(newMain.FlyingHats)
    end)

    --Add autofarm

    return newMain

end

local Spells = {}

function Spells.new(localPlayer)

    local newSpells = {}

    newSpells.SelectedType = 'Target'
    newSpells.SpellsType   = 'Swap'
    newSpells.SpellsTarget = localPlayer

    newSpells.MinimalMana  = 1000
    newSpells.ResetSeconds = 2

    newSpells.Velocity     = 450
    newSpells.AimbotOffset = Vector3.new(0,0,0)
    newSpells.PredictedPosition = Vector3.new(0,0,0)
    newSpells.TargetVelocity    = Vector3.new(0,0,0)

    newSpells.StartTime    = 0 
    newSpells.DeltaTime    = 0 

    newSpells.NoCD = false

    function newSpells:GetSpellsTargetByType()
        newSpells.SpellsTarget = localPlayer.SelectedTarget
        local randomPlayer = nil

        for _, plr in ipairs(Players:GetChildren()) do
            if plr == localPlayer.Obj or ClassPlayers['Enemies'][plr.Name] == nil then continue end
            randomPlayer = plr
            break
        end

        if newSpells.SelectedType == 'Closest' then
            newSpells.SpellsTarget = ClassPlayers['Enemies'][randomPlayer.Name]:GetClosest()

        elseif newSpells.SelectedType == 'Mouse' then
            newSpells.SpellsTarget = ClassPlayers['Enemies'][randomPlayer.Name]:GetClosestToMouse()

        elseif newSpells.SelectedType == 'Ally' then
            newSpells.SpellsTarget = newSpells:GetLowestTeammate()

        end

        --print(newSpells.SpellsTarget.Obj.Name, ClassPlayers['Enemies'][randomPlayer.Name], ClassPlayers['Allies'][randomPlayer.Name])
        localPlayer.ClosestTarget = newSpells.SpellsTarget
    end

    function newSpells:TPCharacterBySpellType(oldCFrame)

        if oldCFrame ~= nil and newSpells.SpellsType == 'Swap' then
            localPlayer.PrimaryPart.CFrame = oldCFrame
            return
        end

        if newSpells.SpellsType == 'Void' then 
            localPlayer.PrimaryPart.CFrame = CFrame.new(10000, -494.5, 100000)
        elseif newSpells.SpellsType == 'Float' then
            localPlayer.PrimaryPart.CFrame = CFrame.new(10000, 10000000, 100000)
        end
    end

    function newSpells:GetLowestTeammate()
        local teammate = localPlayer

        if ClassPlayers['Allies'] == {} then return teammate end

        for _, plr in pairs(ClassPlayers['Allies']) do
            if plr == nil then continue end
            teammate = plr:GetLowestOnHealth()
            break
        end

        return teammate
    end

    function newSpells:GetElement(spellColor)
        
        local spellColor = Color3.new(math.round(spellColor.R*100)/100, math.round(spellColor.G*100)/100, math.round(spellColor.B*100)/100)

        for element, color in pairs(elementsTypes) do
            local newColor = Color3.new(math.round(color.R*100)/100, math.round(color.G*100)/100, math.round(color.B*100)/100)
            if newColor == spellColor then return element end
        end
    end


    function newSpells:CaculatePosition(Args)
        Args[1]['Mouse'] = newSpells.PredictedPosition
        return Args
    end

    function newSpells:GetNextPositions()
        local p1
        local p2

        for i = 1, 4 do
            p1 = newSpells.SpellsTarget.Character.PrimaryPart.Position
            task.wait(.02)
            p2 = newSpells.SpellsTarget.Character.PrimaryPart.Position
        end

        return p1, p2
    end

    function newSpells:SkipCD(Args)
        local delta = os.clock() - newSpells.StartTime
        delta = math.max(delta-delta%.1, .1)
        
        newSpells.DeltaTime = delta^.5/projectiles[Args[2]]
        task.wait(newSpells.DeltaTime)
        
        if Args[2] == 'Crystalline Annihilation' then task.wait(2) end
        newSpells.NoCD = true
        if Args[2] == 'Howling Chain' then task.wait(1.5) end
        task.wait(.1)
        newSpells.NoCD = false
    end

    function newSpells:UltConnection(chainedSpell)
        task.spawn(function()
            local connection; connection = localPlayer.Obj.CharacterAdded:Connect(function()
                while localPlayer.HasFinishedRespawning == false do task.wait() end
                chainedSpell['CanBeUsed'] = true
                connection:Disconnect()
            end)
        end)
    end

    local remoteHook

    remoteHook = hookmetamethod(game, '__namecall', function(self, ...)
        local Args = {...}

        local name = getnamecallmethod()
        if (Args[1] == 'Running' or Args[1] == 'Flip') and localPlayer.InfStamina == true then return end
        if not (name == "FireServer" or name == "InvokeServer") then return remoteHook(self, unpack(Args)) end

        task.spawn(function() newSpells:GetSpellsTargetByType() end)

        if self.Name == "ClientData" and localPlayer.Aimbot == true then Args = newSpells:CaculatePosition(Args, newSpells, localPlayer) end
        if self.Name == "ClientData" and newSpells.NoCD == true then return remoteHook(self, nil) end
        
        local modifiedSpell = spells['Modified'][Args[2]]
        local chainedSpell  = spells['Chained'][Args[2]]
        local skippingSpell = projectiles[Args[2]]

        local canBeUsed

        if chainedSpell ~= nil and chainedSpell['CanBeUsed'] == true then 
            canBeUsed = true 
            chainedSpell['CanBeUsed'] = false 
            if chainedSpell['Type'] ~= 'Ult' then task.delay(chainedSpell['CD'] + newSpells.ResetSeconds, function() chainedSpell['CanBeUsed'] = true end) else newSpells:UltConnection(chainedSpell) end
        end

        if self.Name == "DoClientMagic" and modifiedSpell ~= nil and spellsLibrary['Event'][Args[2]] ~= nil then Args = spellsLibrary['Event'][Args[2]](Args, newSpells, localPlayer, canBeUsed) end
        if self.Name == "DoMagic" and modifiedSpell ~= nil and spellsLibrary['Function'][Args[2]] ~= nil then Args = spellsLibrary['Function'][Args[2]](Args, newSpells, localPlayer) end

        if self.Name == "DoClientMagic" and skippingSpell ~= nil and projectiles[Args[2]] ~= nil then newSpells.StartTime = os.clock() end
        if self.Name == 'DoMagic' and skippingSpell ~= nil and projectiles[Args[2]] ~= nil and localPlayer.NoBulletsCD == true then task.spawn(function() newSpells:SkipCD(Args) end) end

        if chainedSpell ~= nil and chainedSpell['Type'] == 'Ult' and canBeUsed == true then
            local delayArgs = Args
            if delayArgs == nil then delayArgs = {} end

            task.delay(.05, function()
                while localPlayer.Mana < localPlayer.MaxMana do task.wait() end

                while localPlayer.Mana > localPlayer.MaxMana - 400 do
                    DoClientMagic:FireServer('Darkness', 'Void of Terror')
                    DoMagic:InvokeServer('Darkness', 'Void of Terror')
                    task.wait(.1)
                end

                while localPlayer.Mana < 1000 do task.wait(.1) end
                if spells['Chained'][delayArgs[2]] == nil then return end
                DoClientMagic:FireServer(unpack(delayArgs))
                task.wait(.05)
                DoMagic:InvokeServer(unpack(delayArgs))
            end)

            Args = nil
        end

        if Args == nil then return end
        return remoteHook(self, unpack(Args))
    end)

    localPlayer:GetPropertyChangedSignal('Mana'):Connect(function(key, old, new)
        if new > newSpells.MinimalMana or localPlayer.ResetOnMana == false then return end

        task.delay(newSpells.ResetSeconds, function() localPlayer.Humanoid:TakeDamage(math.huge) end)
    end)

    RunService.RenderStepped:Connect(function()

        if localPlayer.Aimbot ~= true then newSpells.PredictedPosition = localPlayer.Mouse.Hit.Position return end
        if newSpells.SpellsTarget == nil or newSpells.SpellsTarget.Character:FindFirstChild('HumanoidRootPart') == nil or localPlayer.Character:FindFirstChild('HumanoidRootPart') == nil then return end

        local p1 = newSpells.SpellsTarget.Character.HumanoidRootPart.Position
        local p2 = localPlayer.Character.HumanoidRootPart.Position - p1

        local velocity = newSpells.SpellsTarget.Velocity
        if velocity == Vector3.new(0,0,0) then velocity = Vector3.new(.01, .01, .01) end

        local angle  = math.acos(velocity.Unit:Dot(p2.Unit))
        local angle2 = math.asin(velocity.Magnitude*math.sin(angle)/newSpells.Velocity)
        local predtime = p2.Magnitude/(velocity.Magnitude*math.cos(angle)+newSpells.Velocity*math.cos(angle2))
        
        if predtime == math.huge then return end

        newSpells.PredictedPosition = p1 + velocity * predtime
    end)

    task.spawn(function()
        while localPlayer ~= nil do

            for name, spellInfo in pairs(spells['Chained']) do
                if spellInfo.UI == nil or spellInfo.CanBeUsed == false then continue end

                local element = newSpells:GetElement(spellInfo.UI.BackgroundColor3)

                DoClientMagic:FireServer(element, name)
                DoMagic:InvokeServer(element, name)
            end
    
            task.wait(.1)
        end
    end)

    return newSpells

end

spellsLibrary['Event']['Blaze Column'] = function(Args, newSpells, localPlayer)

    local delayArgs = Args

    task.delay(.01, function()
        local distance  = newSpells.SpellsTarget:Distance()
        local oldCFrame = localPlayer.PrimaryPart.CFrame
        
        if distance > 200 then
            task.wait(.15)
            localPlayer.PrimaryPart.CFrame = newSpells.SpellsTarget.CFrame + Vector3.new(0,40,0)
        end

        task.wait(.3)

        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        DoMagic:InvokeServer(delayArgs[1], delayArgs[2], CFrame.new(p1 + v1*.15, p1 + v1*.15 + Vector3.new(0, -2, 0)))
        if distance > 200 then localPlayer.PrimaryPart.CFrame = oldCFrame end

    end)

    return Args

end

spellsLibrary['Event']['Vine Trap'] = spellsLibrary['Event']['Blaze Column']

spellsLibrary['Event']['Splitting Slime'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()
        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = CFrame.new(p1 + v1*.4 + Vector3.new(0, -30, 0))
        DoMagic:InvokeServer(unpack(delayArgs))
    end)
    
    return Args
end

spellsLibrary['Event']['Slime Buddies'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()
        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = CFrame.new(p1 + v1*.15)
        DoMagic:InvokeServer(unpack(delayArgs))
    end)
    
    return Args
end

spellsLibrary['Event']['Formidable Roar'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()
        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = 
        {
            [1] = CFrame.new(p1 + v1*.4),
            [2] = 175,
        }

        DoMagic:InvokeServer(unpack(delayArgs))
    end)
    
    return Args
end

spellsLibrary['Event']['Lightning Dispersion'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()
        delayArgs[3] = {['Grounded'] = true}
        DoMagic:InvokeServer(unpack(delayArgs))
    end)

    return Args
end

spellsLibrary['Event']['Rock Fist'] = spellsLibrary['Event']['Lightning Dispersion']

spellsLibrary['Event']['Lightning Bolt'] = function(Args, newSpells, localPlayer)

    task.delay(.01, function()
        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        local newOrigin = {["Origin"] = (p1 - localPlayer.Mouse.Hit.Position).Unit * 12 + p1 + v1*.2}
        DoMagic:InvokeServer(Args[1], Args[2], newOrigin)

    end)

    return Args
end

spellsLibrary['Event']['Gravital Globe'] = function(Args, newSpells, localPlayer)
    task.delay(.01, function() DoMagic:InvokeServer(Args[1], Args[2], {["lastPos"] = newSpells.SpellsTarget.PrimaryPart.Position}) end)
    return Args
end

spellsLibrary['Event']['Illusive Atake'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()

        local oldCFrame = localPlayer.CFrame
        newSpells:TPCharacterBySpellType()

        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = CFrame.new(p1 + v1*.2)
        DoMagic:InvokeServer(unpack(delayArgs))

        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)
    
    return Args
end

spellsLibrary['Event']['Disorder Ignition'] = function(Args, newSpells, localPlayer)

    delayArgs = Args

    task.spawn(function()
        local oldCFrame = localPlayer.CFrame
        
        delayArgs[3] = {['nearestPlayer'] = newSpells.SpellsTarget.Obj}

        for i=1, 5 do
            localPlayer.PrimaryPart.CFrame = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position + newSpells.SpellsTarget.Velocity*.3 + newSpells.SpellsTarget.PrimaryPart.CFrame.lookVector * -2)
            task.wait(.02)
        end

        DoMagic:InvokeServer(unpack(delayArgs))
        task.wait(3)
        newSpells:TPCharacterBySpellType(oldCFrame)
        task.wait(.03)
        localPlayer.PrimaryPart.Anchored = true
        task.wait(.2)
        KeyReserve:FireServer(Enum.KeyCode.Y)
        task.wait(1)
        localPlayer.PrimaryPart.Anchored = false
        task.wait(.1)
        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)

    return Args
end

spellsLibrary['Event']['Magma Drop'] = function(Args, newSpells, localPlayer)

    delayArgs = Args

    task.spawn(function()

        local oldCFrame = localPlayer.CFrame
        
        delayArgs[3] = {['nearestPlayer'] = newSpells.SpellsTarget.Obj, ['modified'] = true}

        for i=1, 5 do
            localPlayer.PrimaryPart.CFrame = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position + newSpells.SpellsTarget.Velocity*.3)
            task.wait(.02)
        end

        DoMagic:InvokeServer(unpack(delayArgs))
        task.wait(.5)
        localPlayer.PrimaryPart.CFrame = oldCFrame

    end)

    return Args
end

spellsLibrary['Event']['Temporal Trap'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Frozen Incursion'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Void of Terror'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Void Lightning'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Neutron Punch'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Soul Plunge'] = spellsLibrary['Event']['Magma Drop']
spellsLibrary['Event']['Fuming Whack'] = spellsLibrary['Event']['Magma Drop']

spellsLibrary['Event']['Lightning Barrage'] = function(Args, newSpells, localPlayer)
    delayArgs = Args

    task.delay(.01, function()

        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = {["Direction"] = CFrame.new(p1 + Vector3.new(0, 250, 0) + v1*.3, p1 + v1*.3)}
        DoMagic:InvokeServer(unpack(delayArgs))
    end)

    return Args
end

spellsLibrary['Event']['Echoes'] = function(Args, newSpells, localPlayer)

    delayArgs = Args

    task.delay(.01, function()

        local oldCFrame = localPlayer.CFrame
        localPlayer.PrimaryPart.CFrame = newSpells.SpellsTarget.PrimaryPart.CFrame + Vector3.new(0, 10, 0)

        task.wait(.15)

        local p1 = newSpells.SpellsTarget.PrimaryPart.Position
        local v1 = newSpells.SpellsTarget.Velocity

        delayArgs[3] = 
        {
            [1] = 2,
            [2] = p1 + v1*.1,
        }
        
        DoMagic:InvokeServer(unpack(delayArgs))

        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)

    return Args
end

spellsLibrary['Event']['Continuous Strikes'] = function(Args, newSpells, localPlayer)
    local delayArgs = Args

    task.spawn(function()
        local oldCFrame = localPlayer.CFrame
        local animator  = localPlayer.Character.Humanoid:FindFirstChild('Animator'):Destroy()

        delayArgs[3] = {}
        delayArgs[3]['Charge'] = '2'
        delayArgs[4] = true

        for i=1, 8 do
            local p1 = newSpells.SpellsTarget.PrimaryPart.Position

            localPlayer.PrimaryPart.CFrame = CFrame.new(p1)
            delayArgs[3]['CF'] = CFrame.new(p1)

            task.wait(.02)
        end

        DoMagic:InvokeServer(unpack(delayArgs))

        task.wait(.2)

        localPlayer.PrimaryPart.CFrame = oldCFrame

    end)

    return Args
end

spellsLibrary['Event']['Oblivion'] = function(Args, newSpells, localPlayer)

    local delayArgs = Args

    task.delay(.01, function()
        delayArgs[3] = CFrame.new(delayArgs[3])
        DoMagic:InvokeServer(unpack(delayArgs))
    end)

    return Args
end

spellsLibrary['Event']['Essence Relegation'] = function(Args, newSpells, localPlayer)
    local delayArgs = Args
    task.delay(.01, function() DoMagic:InvokeServer(unpack(delayArgs)) end)

    return Args
end

spellsLibrary['Event']['Double Ray'] = function(Args, newSpells, localPlayer)

    local delayArgs = Args

    task.delay(.01, function()
        delayArgs[3] = CFrame.new(localPlayer.PrimaryPart.Position, newSpells.SpellsTarget.PrimaryPart.Position)
        DoMagic:InvokeServer(unpack(delayArgs))
    end)

    return Args
end

spellsLibrary['Event']['Dying Star'] = spellsLibrary['Event']['Double Ray']

spellsLibrary['Event']['Unmatched Power of the Sun'] = function(Args, newSpells, localPlayer, canBeUsed)

    if canBeUsed == true then return Args end

    local delayArgs = Args

    task.spawn(function()
        local startTime = os.clock()
        local oldCFrame = localPlayer.PrimaryPart.CFrame
        
        localPlayer.PrimaryPart.CFrame = newSpells.SpellsTarget.CFrame + Vector3.new(0,40,0)
        task.wait(.2)
        delayArgs[3] = true
        DoMagic:InvokeServer(unpack(delayArgs))
        task.wait(.1)
        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)

    return Args
end

spellsLibrary['Event']['Ablaze Judgement'] = function(Args, newSpells, localPlayer)

    task.delay(.01, function()
        DoMagic:InvokeServer(unpack(Args))
    end)

    return Args
end

spellsLibrary['Event']['Swords Dance'] = function(Args, newSpells, localPlayer, canBeUsed)
    if canBeUsed == true then return Args end

    task.spawn(function()
        local oldCFrame = localPlayer.PrimaryPart.CFrame
        
        localPlayer.PrimaryPart.CFrame = newSpells.SpellsTarget.CFrame + Vector3.new(0,40,0)
        task.wait(.2)
        DoMagic:InvokeServer('Chaos', 'Swords Dance', 1000)
        task.wait(.2)
        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)

    return Args

end

spellsLibrary['Function']['Blaze Column'] = function(Args, newSpells, localPlayer)
    if Args[3] == nil then Args = nil end
    return Args
end

spellsLibrary['Function']['Vine Trap'] = spellsLibrary['Function']['Blaze Column']

spellsLibrary['Function']['Water Beam'] = function(Args, newSpells, localPlayer)
    local p1 = newSpells.SpellsTarget.PrimaryPart.Position
    local v1 = newSpells.SpellsTarget.Velocity

    Args[3] = {["Origin"] = (p1 - newSpells.PredictedPosition).Unit * 12 + p1 + v1*.3}

    return Args
end

spellsLibrary['Function']['Vine'] = spellsLibrary['Function']['Water Beam']
spellsLibrary['Function']['Auroral Blast'] = spellsLibrary['Function']['Water Beam']

spellsLibrary['Function']['Lightning Flash'] = function(Args, newSpells, localPlayer)
    Args[3] = {
        ["End"] = localPlayer.Mouse.Hit.Position,
        ["Origin"] = localPlayer.CFrame.Position
    }

    return Args

end

spellsLibrary['Function']['Formidable Roar'] = function(Args, newSpells, localPlayer)
    Args[3] = {[1] = newSpells.SpellsTarget.PrimaryPart.CFrame + newSpells.SpellsTarget.Velocity*.3, [2] = 9e9}
    return Args
end

spellsLibrary['Function']['Disorder Ignition'] = function(Args, newSpells, localPlayer)
    if Args[3]['rhit'] ~= nil then return nil end
    return Args
end

spellsLibrary['Function']['Amaurotic Lambent'] = function(Args, newSpells, localPlayer)
    Args[3] = {['lastPos'] = newSpells.SpellsTarget.PrimaryPart.CFrame.Position + newSpells.SpellsTarget.Velocity*.3}
    return Args
end

spellsLibrary['Function']['Genesis Ray'] = function(Args, newSpells, localPlayer)
    Args[3] = {['charge'] = 9e9, ['lv'] = Vector3.new(0,0,0)}
    return Args
end

spellsLibrary['Function']['Vigor Gyration'] = function(Args, newSpells, localPlayer)

    local p1 = newSpells.SpellsTarget.PrimaryPart.Position
    local v1 = newSpells.SpellsTarget.Velocity

    Args[3] = {}
    for i=1, 50 do table.insert(Args[3], CFrame.new(p1 + v1*.15 + newSpells.SpellsTarget.PrimaryPart.CFrame.UpVector * -3.5, p1 + v1*.15)) end

    return Args
end

spellsLibrary['Function']['Orbs of Enlightenment'] = function(Args, newSpells, localPlayer)

    local p1 = newSpells.SpellsTarget.PrimaryPart.Position
    local v1 = newSpells.SpellsTarget.Velocity

    Args[3] = {['Origin'] = p1 + v1*.15 + Vector3.new(0, -2, 0), ['Coordinates'] = {}}
    for i=1, 50 do table.insert(Args[3]['Coordinates'], CFrame.new(p1 + v1*.15)) end

    return Args
end

spellsLibrary['Function']['Magma Drop'] = function(Args, newSpells, localPlayer)
    if Args[3] == nil or Args[3]['modified'] == nil then return nil end
    return Args
end

spellsLibrary['Function']['Temporal Trap'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Frozen Incursion'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Void of Terror'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Void Lightning'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Neutron Punch'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Soul Plunge'] = spellsLibrary['Function']['Magma Drop']
spellsLibrary['Function']['Fuming Whack'] = spellsLibrary['Function']['Magma Drop']

spellsLibrary['Function']['Asteroid Belt'] = spellsLibrary['Function']['Vigor Gyration']

spellsLibrary['Function']['Rocks Avalanche'] = spellsLibrary['Function']['Orbs of Enlightenment']

spellsLibrary['Function']['Rainbowifier Maximizer'] = function(Args, newSpells, localPlayer)

    task.spawn(function()
        local startTime = os.clock()
        local oldCFrame = localPlayer.PrimaryPart.CFrame

        while os.clock() - startTime < 2 do
            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position + Vector3.new(0, 4, 0))
            localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            task.wait()
        end

        localPlayer.PrimaryPart.CFrame = oldCFrame
    end)

    return Args
end

spellsLibrary['Function']['Blue Arson'] = function(Args, newSpells, localPlayer)
    Args[3] = newSpells:GetLowestTeammate().PrimaryPart.Position
    return Args
end

spellsLibrary['Function']['Gleaming Harmony'] = spellsLibrary['Function']['Blue Arson']

spellsLibrary['Function']['Orbital Strike'] = function(Args, newSpells, localPlayer)
    Args[3] = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position + Vector3.new(0, 10, 0), newSpells.SpellsTarget.PrimaryPart.Position)
    return Args
end

spellsLibrary['Function']['Gravitational Field'] = function(Args, newSpells, localPlayer)
    Args[3] = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position + Vector3.new(0, 1000000, 0))
    return Args
end

spellsLibrary['Function']['Continuous Strikes'] = function(Args, newSpells, localPlayer)
    if Args[4] == true then return Args end
    return nil
end

spellsLibrary['Function']['Spectral Embodiment'] = function(Args, newSpells, localPlayer)
    if Args[2] == 'Spectral Embodiment' and Args[3] ~= nil then return Args end

    task.delay(.05, function()
        local face = localPlayer.Character.Head:FindFirstChild('face')
        if face ~= nil then face:Destroy() end
        DoMagic:InvokeServer('Spirit', 'Spectral Embodiment', 'test')
    end)

    return nil
end

spellsLibrary['Function']['Divine Arrow'] = function(Args, newSpells, localPlayer)
    Args[3] = {
        ['charge'] = 9e9,
        ['mouse']  = newSpells.SpellsTarget.PrimaryPart.Position,
    }
    return Args
end

spellsLibrary['Function']['Sewer Burst'] = function(Args, newSpells, localPlayer)
    local pos = newSpells.SpellsTarget.PrimaryPart.Position

    Args[3] = 
    {
        ["Mouse"] = pos, 
        ["Camera"] = pos + Vector3.new(0, 100, 0), 
        ["Spawn"] = CFrame.new(pos), 
        ["Origin"] = CFrame.new(pos) 
    }
    return Args
end

spellsLibrary['Function']['Space-Time Rupture'] = function(Args, newSpells, localPlayer)
    Args[3] = {['Origin'] = newSpells.SpellsTarget.CFrame.Position + Vector3.new(0, 10, 0)}
    return Args
end

spellsLibrary['Function']['Hyperang'] = function(Args, newSpells, localPlayer)
    Args[3] = CFrame.new(newSpells.SpellsTarget.PrimaryPart.Position, newSpells.SpellsTarget.PrimaryPart.Position + Vector3.new(0, -10, 0))
    return Args
end

spellsLibrary['Function']['Arcane Guardian'] = function(Args, newSpells, localPlayer)
    Args[3] = {['Position'] = newSpells.SpellsTarget.PrimaryPart.Position + newSpells.SpellsTarget.Velocity*.1 + Vector3.new(0, 25, 0)}
    return Args
end

spellsLibrary['Function']['The World'] = function(Args, newSpells, localPlayer)
    Args[3] = 
    {
        ["rpos"] = newSpells.SpellsTarget.PrimaryPart.Position + newSpells.SpellsTarget.Velocity*.1, 
        ["norm"] = Vector3.new(0,0,0), 
        ["rhit"] = workspace.Map.Part
    }

    return Args
end

spellsLibrary['Function']['Unmatched Power of the Sun'] = function(Args, newSpells, localPlayer)
    if Args[3] ~= true then return nil end
    Args[3] = newSpells.SpellsTarget.CFrame + Vector3.new(0, -200, 0)
    return Args
end

spellsLibrary['Function']['Ablaze Judgement'] = function(Args, newSpells, localPlayer)
    Args[3] = 
    {
        ["orbPos"] = newSpells.SpellsTarget.CFrame.Position, 
        ["Origin"] = newSpells.SpellsTarget.CFrame.Position
    }

    return Args
end

spellsLibrary['Function']['Ethereal Acumen'] = function(Args, newSpells, localPlayer)
    Args[3] = newSpells.SpellsTarget.CFrame
    return Args
end

spellsLibrary['Function']['Swords Dance'] = function(Args, newSpells, localPlayer)
    if Args[3] == 1000 then return Args end
    return nil
end

spellsLibrary['Function']['Virtual Zone'] = function(Args, newSpells, localPlayer)

    Args[3] = 
    {
        [1] = newSpells.SpellsTarget.CFrame.Position + newSpells.SpellsTarget.Velocity*.1,
        [2] = Vector3.new(0, 0, 0)
    }

    return Args
end

spellsLibrary['Function']['Void Opening'] = function(Args, newSpells, localPlayer)
    Args[3] = {['pos'] = newSpells.SpellsTarget.CFrame.Position + newSpells.SpellsTarget.Velocity*.1}
    return Args
end

--//SETUP

local localPlayer = LocalPlayer.new(Players.LocalPlayer)
local gameGui     = GUI.new(localPlayer)
local spellsClass = Spells.new(localPlayer)
local mainClass   = Main.new(localPlayer)

local playersDropDown

localPlayer.PlayerGui.Menu.Sound.Playing = false

gameGui:SetupExploit()
--gameGui.IsLoaded = true

gameGui.SelectSlot.SizeConstraint = 0
gameGui.SelectSlot.Size = UDim2.new(.38, 0, .1, 0)

for _, name in {"MODIFY SPELL", "CHAIN SPELL"} do
    local button = gameGui.SelectSlot.Grid["1"]:Clone()

    button.Text   = name
    button.Name   = name
    button.Parent = gameGui.SelectSlot.Grid

    if name == "MODIFY SPELL" then name = "Modified" else name = 'Chained' end

    button.MouseButton1Click:Connect(function()

        local selectedSpell = gameGui:GetSelectedMove()
        if name == 'Chained' then selectedSpell = {['Name'] = selectedSpell.Name, ['UI'] = selectedSpell, ['CanBeUsed'] = true, ['Type'] = types[selectedSpell.Image], ['CD'] = CDs[types[selectedSpell.Image]]} end

        if spells[name][selectedSpell.Name] ~= nil then 
            spells[name][selectedSpell.Name] = nil 
        else 
            spells[name][selectedSpell.Name] = selectedSpell
        end
        
        if name == 'Chained' then selectedSpell = selectedSpell['UI'] end
        gameGui:ModifyImage(selectedSpell)

    end)
end

localPlayer.Obj.PlayerScripts.ChildAdded:Connect(function(child)
    if child.Name == 'DiscScript' then Debris:AddItem(child, 3) end
end)

localPlayer.Obj.Idled:Connect(function()
    VUser:CaptureController()
	VUser:ClickButton2(Vector2.new(0.5,0.5))
end)

workspace['.Ignore']['.LocalEffects'].ChildAdded:Connect(function(child)
    if child.Name == 'LightDisc' or child.Name == 'BoltPart' or string.match(child.Name, 'Sound') ~= nil then Debris:AddItem(child, 3) end
end)

workspace['.Ignore']['.Attacks'].ChildAdded:Connect(function(child)
    if child.Name == 'HowlingVisage' then Debris:AddItem(child, 5) end
end)

gameGui.Inventory.ChildAdded:Connect(function(child)
    gameGui:ModifyImage(child)
end)

local function DropDownPlayers()
    local plrs = {}

    for _, plr in ipairs(Players:GetChildren()) do
        table.insert(plrs, plr.Name)
    end

    return plrs
end

local function TransferAllies()
    local members = gameGui:GetPartyMembers()

    for _, member in pairs(members) do
        if ClassPlayers['Allies'][member.Name] ~= nil or member == localPlayer.Obj or ClassPlayers['Enemies'][member.Name] ~= nil then continue end
        local p = Ally.new(member, localPlayer)
        gameGui:TracePerson(p)
    end

end

local function TransferEnemies()
    local enemies = Players:GetPlayers()

    for _, enemy in ipairs(enemies) do
        if ClassPlayers['Allies'][enemy.Name] ~= nil or enemy == localPlayer.Obj or ClassPlayers['Enemies'][enemy.Name] ~= nil then continue end
        local p = Enemy.new(enemy, localPlayer, spellsClass)
        gameGui:TracePerson(p)
    end

    if playersDropDown == nil then return end
    playersDropDown:Refresh(DropDownPlayers())
end

TransferAllies()
TransferEnemies()

gameGui.Members.ChildAdded:Connect(function(child)
    if ClassPlayers['Enemies'][child.Text] ~= nil then ClassPlayers['Enemies'][child.Text]:Destroy(child.Text, 'Enemies') end

    TransferAllies()
end)

gameGui.Members.ChildRemoved:Connect(function(child)
    if ClassPlayers['Allies'][child.Text] ~= nil then ClassPlayers['Allies'][child.Text]:Destroy(child.Text, 'Allies') end

    TransferAllies()
    TransferEnemies()
end)

Players.ChildAdded:Connect(function()
    TransferEnemies()
end)

Players.PlayerRemoving:Connect(function(child)

    for _, type in ipairs({'Enemies', 'Allies'}) do
        if ClassPlayers[type][child.Name] == nil then continue end
        ClassPlayers[type][child.Name]:Destroy(child.Name, type)
    end

    task.wait(.5)
    TransferEnemies()
end)

mainClass:SetupHats()

while gameGui.IsLoaded == false do task.wait() end

--//SETUP



--//EXPLOIT GUI


local Window = Library.CreateLib("The Void ".."v"..0.5, "GrapeTheme")

local MainTab   = Window:NewTab("Main")
local SpellsTab = Window:NewTab("Spells")
local HatsTab   = Window:NewTab("Hats")
--local BetaTab   = Window:NewTab("Beta")

local MainSection   = MainTab:NewSection("Main")
local PlayerSection = MainTab:NewSection("Player")
local TargetSection = MainTab:NewSection("Target")

local SpellsMainSection = SpellsTab:NewSection("Main")
local HatsMainSection   = HatsTab:NewSection("Main")

--local BetaMainSection   = BetaTab:NewSection("Main")

PlayerSection:NewToggle('Noclip', 'test', function(value)
    localPlayer:NoclipFunction(value)
end)

PlayerSection:NewToggle('Fly', 'test', function(value)
    localPlayer:FlyFunction(value)
end)

PlayerSection:NewToggle('Inf Jump', 'test', function(value)
    localPlayer:InfJumpFunction(value)
end)

PlayerSection:NewKeybind('Click TP', 'test', Enum.KeyCode.World0, function()
    localPlayer:ClickTPFunction()
end)

PlayerSection:NewSlider('Fly Speed', 'test', 1000, 50, function(value)
    localPlayer.MaxFlySpeed = value
end)

PlayerSection:NewSlider('WalkSpeed', 'test', 1000, 32, function(value)
    localPlayer.WalkSpeed = value
end)

PlayerSection:NewSlider('JumpPower', 'test', 1000, 50, function(value)
    localPlayer.JumpPower = value
end)

MainSection:NewToggle('Tracers', 'test', function(value)
    localPlayer.Tracers = value
end)

MainSection:NewToggle('Anti Blind', 'test', function(value)
    localPlayer.AntiBlind = value
end)

MainSection:NewToggle('Anti Stun', 'test', function(value)
    localPlayer.AntiStun = value
end)

MainSection:NewToggle('Invisible', 'test', function(value)
    localPlayer:InvisibleFunction(value)
end)

MainSection:NewToggle('Auto Punch', 'test', function(value)
    localPlayer:AutoPunchFunction(value)
end)

MainSection:NewToggle('Auto Farm', 'test', function(value)
    mainClass:AutoFarm(value)
end)

MainSection:NewToggle('Spawnpoint', 'test', function(value)
    localPlayer:SpawnpointFunction(value)
end)

MainSection:NewToggle('Inf Stamina', 'test', function(value)
    if value == true then PlayerData:FireServer('Running', false) end
    localPlayer.InfStamina = value
end)

MainSection:NewButton('Rejoin', 'test', function(value)
    TPService:Teleport(game.PlaceId, localPlayer.Obj)
end)

playersDropDown = TargetSection:NewDropdown('Select Target', 'test', DropDownPlayers(), function(value)
    localPlayer.SelectedTarget = ClassPlayers['Enemies'][value] or ClassPlayers['Allies'][value]
end)

TargetSection:NewToggle('Spectate', 'test', function(value)
    localPlayer:SpectateFunction(value)
end)

TargetSection:NewToggle('Follow', 'test', function(value)
    localPlayer:FollowFunction(value)
end)

TargetSection:NewButton('Teleport', 'test', function()
    localPlayer:TeleportFunction()
end)

SpellsMainSection:NewDropdown('Select Type', 'test', {'Target', 'Closest', 'Mouse', 'Ally'}, function(value)
    spellsClass.SelectedType = value
end)

SpellsMainSection:NewDropdown('Select Spell Type', 'test', {'Swap', 'Void', 'Float'}, function(value)
    spellsClass.SpellsType = value
end)

SpellsMainSection:NewToggle('Inf Bullets', 'test', function(value)
    localPlayer.NoBulletsCD = value
end)

SpellsMainSection:NewToggle('Aimbot', 'test', function(value)
    localPlayer.Aimbot = value
end)

SpellsMainSection:NewToggle('Reset On Mana', 'test', function(value)
    localPlayer.ResetOnMana = value
end)

SpellsMainSection:NewSlider('Mana Value', 'test', 1500, 0, function(value)
    spellsClass.MinimalMana = value
end)

SpellsMainSection:NewSlider('Reset Time', 'test', 500, 0, function(value)
    spellsClass.ResetSeconds = value/100
end)

SpellsMainSection:NewSlider('Velocity', 'test', 2000, 0, function(value)
    spellsClass.Velocity = value
end)

HatsMainSection:NewToggle('Flying Hats', 'test', function(value)
    mainClass:FlyingHatsFunction(value)
end)

HatsMainSection:NewSlider('Angle1', 'test', 100, 0, function(value)
    mainClass.AngleOffset1 = value/10
end)

HatsMainSection:NewSlider('Angle2', 'test', 100, 0, function(value)
    mainClass.AngleOffset2 = value/10
end)

HatsMainSection:NewSlider('Sin1', 'test', 100, 0, function(value)
    mainClass.SinOffset1 = value/10
end)

HatsMainSection:NewSlider('Sin2', 'test', 100, 0, function(value)
    mainClass.SinOffset2 = value/10
end)

HatsMainSection:NewSlider('Distance', 'test', 100, 0, function(value)
    mainClass.Distance = value/10
end)

HatsMainSection:NewSlider('Size Offset', 'test', 100, 20, function(value)
    mainClass.SizeOffset = value/10
end)

HatsMainSection:NewSlider('Speed', 'test', 100, 0, function(value)
    mainClass.Speed = value/10
end)

HatsMainSection:NewSlider('CFrame', 'test', 360, 0, function(value)
    mainClass.CFrameOffset = value
end)


--//EXPLOIT GUI