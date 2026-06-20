local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local CurrentCameraCFrame = Camera.CFrame

local BoolFolder = Instance.new("Folder")
BoolFolder.Name = "Bool Folder"
BoolFolder.Parent = ReplicatedStorage

local isDiedConnection
local isDead = false

local Window = WindUI:CreateWindow({
    Title = "Nigger hub | Devil Hunter",                -- window title
    Icon = "circle-off",                -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by WhiteDeath",            -- window subtitle. optional
    Folder = "NiggerHubDH",                -- folder to save keys and images

    Size = UDim2.fromOffset(580, 460),  -- window size
    MinSize = Vector2.new(560, 350),    -- minimal window size
    MaxSize = Vector2.new(850, 560),    -- maximum window size
    Transparent = true,                 -- window transparency
    Theme = "Rose",                     -- library theme
    Resizable = true,                   -- the ability to rezize window
    SideBarWidth = 200,                 -- sidebar (tabs) width
    HideSearchBar = true,               -- hide search bar
    ScrollBarEnabled = false,           -- scrollbars that are located to the right of the scroll frame

    BackgroundImageTransparency = 0.42, -- background image transparency
    Background = "rbxassetid://1234",   -- rbxassetid

    User = {                            -- user information located at the bottom left
        Enabled = true,                 -- can be toggled with Window.User:Enable() or Window.User:Disable()
        Anonymous = false,              -- can be toggled with Window.User:SetAnonymous(true) --(true or false)
        Callback = function()           -- callback on click. optional. it can be removed
            print("clicked to the 'user icon'")
        end,
    },
})

local function SaveFile(FileName, Content, DoAppend)
    if isfolder("NiggerHubDH") then
        if isfolder("NiggerHubDH/Config/") == false then
            makefolder("NiggerHubDH/Config/")
        end

        if isfile("NiggerHubDH/Config/"..FileName.."/") then
            if DoAppend then
               local originalcontent = ""
               originalcontent = readfile("NiggerHubDH/Config/"..FileName.."/")

               writefile("NiggerHubDH/Config/"..FileName.."/", originalcontent.."\n"..Content)
            else
                writefile("NiggerHubDH/Config/"..FileName.."/", Content)
            end
        else 
            writefile("NiggerHubDH/Config/"..FileName.."/", Content)
        end
    end
end

if isfile("NiggerHubDH/Config/Theme.config/") == false then
    SaveFile("Theme.config", "Rose", true)
end

local Theme = readfile("NiggerHubDH/Config/Theme.config/")

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house", -- lucide icon or "rbxassetid://" or URL. optional
})

local MovementTab = Window:Tab({
    Title = "Movement",
    Icon = "sport-shoe", -- lucide icon or "rbxassetid://" or URL. optional
})

MovementTab:Section({
    Title = "Walk",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

MovementTab:Divider()


local HumanoidWalkSpeedValue = Humanoid.WalkSpeed

print("WalkSpeed:", false)

local OriginalHWS = Humanoid.WalkSpeed

local function ChangeTitle(VarName, Text)
    if VarName.SetTitle then
        VarName:SetTitle(tostring(Text))
    else
        print(tostring(VarName).."'s Title Cannot Be Set Because Its Not A Fetaure Of WindUI")
    end
end

local HumanoidWalkSpeedDrag

HumanoidWalkSpeedDrag = MovementTab:Slider({
    Title = "WalkSpeed: "..math.round(OriginalHWS),
    Value = { Min = 1, Max = 200, Default = OriginalHWS },
    Step = 1, -- integer steps
    Callback = function(value)
        print("Speed:", value)
        HumanoidWalkSpeedValue = value
        ChangeTitle(HumanoidWalkSpeedDrag, "WalkSpeed: "..value)
    end
})

local WalkSpeedBool = false

local HumanoidWalkSpeedButton
local HumanoidWalkSpeedLoopToggle

local HWSConnection = nil

HumanoidWalkSpeedLoopToggle = MovementTab:Toggle({
    Title = "Loop WalkSpeed: Off",
    Callback = function(state)
        print("Loop WalkSpeed:", state)
        if HWSConnection then
            HWSConnection:Disconnect()
        end

        HWSConnection = nil

        if state then
            OriginalHWS = Humanoid.WalkSpeed
            HumanoidWalkSpeedButton:Lock()
            ChangeTitle(HumanoidWalkSpeedButton,"Set WalkSpeed")
            WalkSpeedBool = false
            HWSConnection = RunService.RenderStepped:Connect(function()
                Humanoid.WalkSpeed = HumanoidWalkSpeedValue
            end)
        else
            Humanoid.WalkSpeed = OriginalHWS
            HumanoidWalkSpeedButton:Unlock()
        end

        if state then
            ChangeTitle(HumanoidWalkSpeedLoopToggle, "Loop WalkSpeed: On")
        else
            ChangeTitle(HumanoidWalkSpeedLoopToggle, "Loop WalkSpeed: Off")
        end
    end
})

HumanoidWalkSpeedButton = MovementTab:Button({
    Title = "Set WalkSpeed",
    Callback = function()
        WalkSpeedBool = not WalkSpeedBool
        if WalkSpeedBool then
            OriginalHWS = Humanoid.WalkSpeed
            ChangeTitle(HumanoidWalkSpeedButton,"Revert WalkSpeed")
            HumanoidWalkSpeedLoopToggle:Lock()
            ChangeTitle(HumanoidWalkSpeedLoopToggle,"Loop WalkSpeed: Off")
            Humanoid.WalkSpeed = HumanoidWalkSpeedValue
        else
            Humanoid.WalkSpeed = OriginalHWS
            ChangeTitle(HumanoidWalkSpeedButton,"Set WalkSpeed")
            HumanoidWalkSpeedLoopToggle:Unlock()
        end
    end
})

MovementTab:Divider()

local TeleportWalkDistance = 1

print("TeleportWalk:", false)

local TeleportWalkDistanceDrag

TeleportWalkDistanceDrag = MovementTab:Slider({
    Title = "Tp Walk Distance: "..1,
    Value = { Min = 0, Max = 10, Default = 1 },
    Step = 1, -- integer steps
    Callback = function(value)
        print("Tp Walk Distance:", value)
        TeleportWalkDistance = value
        ChangeTitle(TeleportWalkDistanceDrag, "Tp Walk Distance: "..value)
    end
})

local TeleportWalkToggle

local TWConnection = nil

TeleportWalkToggle = MovementTab:Toggle({
    Title = "Tp Walk: Off",
    Callback = function(state)
        print("Tp Walk:", state)

        if state then
            RunService:BindToRenderStep("Tp Walk", Enum.RenderPriority.Camera.Value - 1, function(DeltaTime)
                local CameraCFrame = Camera.CFrame
                local CameraMoveDirection = CameraCFrame:VectorToObjectSpace(Humanoid:GetMoveVelocity())
                local WorldMoveDirection = CameraCFrame:VectorToWorldSpace(CameraMoveDirection)

                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + WorldMoveDirection * DeltaTime * TeleportWalkDistance
            end)
        else
            RunService:UnbindFromRenderStep("Tp Walk")
        end

        if state then
            ChangeTitle(TeleportWalkToggle, "Tp Walk: On")
        else
            ChangeTitle(TeleportWalkToggle, "Tp Walk: Off")
        end
    end
})


MovementTab:Section({
    Title = "Gravity",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

MovementTab:Divider()

local Flying = false

local GravityValue = false
local Gravity = Workspace.Gravity
local GravityV = Workspace.Gravity
local OriginalGravity = Workspace.Gravity
local GravityConnection
local GC

local GravitySlider
local GravityButton

GravitySlider = MovementTab:Slider({
    Title = "Gravity: "..(1),
    Value = { Min = 0.0, Max = 10.0, Default = (1.0)},
    Step = 0.1, -- integer steps
    Callback = function(value)
        print("Gravity: ", value)
        GravityV = (value * OriginalGravity)
        if value == math.round(value) then 
            ChangeTitle(GravitySlider, "Gravity: "..math.round(value))
        else
            ChangeTitle(GravitySlider, "Gravity: "..value)
        end
    end
})

GravityButton = MovementTab:Button({
    Title = "Set Gravity",
    Callback = function()
        GravityValue = not GravityValue
        if GravityValue then
            ChangeTitle(GravityButton,"Revert Gravity")
            GC = RunService.RenderStepped:Connect(function()
                if Flying == false then
                    Gravity = GravityV
                end
            end)
        else

            Gravity = OriginalGravity

            if GC then
                GC:Disconnect()
                GC = nil
            end

            Workspace.Gravity = OriginalGravity
            ChangeTitle(GravityButton,"Set Gravity")
        end
    end
})

MovementTab:Section({
    Title = "Jump",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

MovementTab:Divider()

local JumpHeightValue = Humanoid.JumpPower

print("JumpHeight:", false)

local OriginalHJH = Humanoid.JumpPower

local JumpHeightDrag

JumpHeightDrag = MovementTab:Slider({
    Title = "JumpHeight: "..math.round(OriginalHJH),
    Value = { Min = 1, Max = 200, Default = OriginalHJH },
    Step = 1, -- integer steps
    Callback = function(value)
        print("Speed:", value)
        JumpHeightValue = value
        ChangeTitle(JumpHeightDrag, "JumpHeight: "..value)
    end
})

local JumpHeightBool = false

local JumpHeightButton
local JumpHeightLoopToggle

local HJHConnection = nil

JumpHeightLoopToggle = MovementTab:Toggle({
    Title = "Loop JumpHeight: Off",
    Callback = function(state)
        print("Loop JumpHeight:", state)
        if HJHConnection then
            HJHConnection:Disconnect()
        end

        HJHConnection = nil

        if state then
            OriginalHJH = Humanoid.JumpPower
            JumpHeightButton:Lock()
            ChangeTitle(JumpHeightButton, "Set JumpHeight")
            JumpHeightBool = false
            HJHConnection = RunService.RenderStepped:Connect(function()
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = JumpHeightValue
            end)
        else
            Humanoid.JumpPower = OriginalHJH
            JumpHeightButton:Unlock()
        end
        
        if state then
            ChangeTitle(JumpHeightLoopToggle, "Loop JumpHeight: On")
        else
            ChangeTitle(JumpHeightLoopToggle, "Loop JumpHeight: Off")
        end
    end
})

JumpHeightButton = MovementTab:Button({
    Title = "Set JumpHeight",
    Callback = function()
        JumpHeightBool = not JumpHeightBool
        if JumpHeightBool then
            OriginalHJH = Humanoid.JumpPower
            Humanoid.JumpPower = JumpHeightValue
            ChangeTitle(JumpHeightButton,"Revert JumpHeight")
            JumpHeightLoopToggle:Lock()
            ChangeTitle(JumpHeightLoopToggle,"Loop JumpHeight: Off")
        else
            Humanoid.JumpPower = OriginalHJH
            ChangeTitle(JumpHeightButton,"Set JumpHeight")
            JumpHeightLoopToggle:Unlock()
        end
    end
})

MovementTab:Divider()

local InfiniteJumpValue = false
local InfiniteJumpConnection
local CanJump = true
local JumpCooldown = 0.14

local InfiniteJumpSlider
local InfiniteJumpButton

InfiniteJumpSlider = MovementTab:Slider({
    Title = "Cooldown: "..(0.14),
    Value = { Min = 0.01, Max = 0.14, Default = (0.14)},
    Step = 0.01, -- integer steps
    Callback = function(value)
        print("Cooldown: ", value)
        JumpCooldown = (value)
        if value == math.round(value) then 
            ChangeTitle(InfiniteJumpSlider, "Cooldown: "..math.round(value))
        else
            ChangeTitle(InfiniteJumpSlider, "Cooldown: "..value)
        end
    end
})

InfiniteJumpButton = MovementTab:Button({
    Title = "Enable Infinite Jump",
    Callback = function()
        InfiniteJumpValue = not InfiniteJumpValue
        if InfiniteJumpValue then
            ChangeTitle(InfiniteJumpButton,"Disable Infinite Jump")
            InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if CanJump then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    CanJump = false
                    task.wait(JumpCooldown)
                    CanJump = true
                end
            end)
        else
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
                InfiniteJumpConnection = nil
            end

            ChangeTitle(InfiniteJumpButton,"Enable Infinite Jump")
        end
    end
})

MovementTab:Section({
    Title = "Fly",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

MovementTab:Divider()

local FlySpeed = 1

local function GetSounds(Sound)
    if HumanoidRootPart:WaitForChild(tostring(Sound), 2) then
        return true
    else
        return false
    end
end

local RunningSound = nil 

if GetSounds("Running") then
    RunningSound = HumanoidRootPart:FindFirstChild("Running")
end

local RunningSoundOriginalVolume = nil

if RunningSound ~= nil then
    RunningSoundOriginalVolume = RunningSound.Volume
end

local FlyConnection

local FlySpeedSlider
local FlyToggle

FlySpeedSlider = MovementTab:Slider({
    Title = "Fly Speed: "..(1),
    Value = { Min = 1, Max = 100, Default = (1)},
    Step = 1, -- integer steps
    Callback = function(value)
        print("Fly Speed: ", value)
        FlySpeed = (value) 
        ChangeTitle(FlySpeedSlider, "Fly Speed: "..(value))
    end
})

FlyToggle = MovementTab:Toggle({
    Title = "Fly: Off",
    Callback = function(state)
        print("Fly:", state)
        Flying = state 
        
        if Flying == false then
            Gravity = OriginalGravity
        end

        if state then
            ChangeTitle(FlyToggle, "Fly: ".."On")
            
            if RunningSound ~= nil then
                RunningSound.Volume = 0
            end

            local MoveDirection

            Gravity = 0

            local Animate = Character:FindFirstChild("Animate")
            if Animate then
                Animate.Disabled = true
            end


            FlyConnection = RunService.RenderStepped:Connect(function() task.wait()
                if not isDead then
                    CurrentCameraCFrame = (Camera and Camera.CFrame)
                    MoveDirection = Vector3.new()



                    MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.W) and (CurrentCameraCFrame.LookVector) * (FlySpeed * 6) or Vector3.new())
                    MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.S) and (CurrentCameraCFrame.LookVector) * (FlySpeed * 6) or Vector3.new())
                    MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.A) and (CurrentCameraCFrame.RightVector) * (FlySpeed * 6) or Vector3.new())
                    MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.D) and (CurrentCameraCFrame.RightVector) * (FlySpeed * 6) or Vector3.new())
                    MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, 6 * FlySpeed, 0) or Vector3.new())

                    local x, y, z = CurrentCameraCFrame:ToEulerAnglesXYZ()

                    HumanoidRootPart.CFrame = (CFrame.new(HumanoidRootPart.CFrame.Position) * CFrame.Angles(x,y,z))

                    if MoveDirection.Magnitude > 0 then
                        print(tostring(MoveDirection))
                        HumanoidRootPart.Velocity = ((MoveDirection))
                    else
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) 
                    end
                end
            end)

        else
            ChangeTitle(FlyToggle, "Fly: ".."Off")
            FlyConnection:Disconnect()
            FlyConnection = nil
            if RunningSound ~= nil then
                RunningSound.Volume = RunningSoundOriginalVolume
            end
            
            local Animate = Character:FindFirstChild("Animate")
            if Animate then
                Animate.Disabled = false
            end
        end


    end
})

local function getgitpath(gameid)
    local mainBuild = "https://raw.githubusercontent.com/nitrolden-dot/Ginger/refs/heads/main"

    if gameid then
        local weblocation = (mainBuild.."/games/"..gameid..".lua")
        local ifgamescript = game:HttpGet(weblocation)

        if ifgamescript then
            return ifgamescript
        else
            return false
        end
    else
        return false
    end
end

_G.NiggerWindow = Window
_G.NiggerChangeTitle = ChangeTitle

local GameTab = Window:Tab({
    Title = "Game",
    Icon = "gamepad-2", -- lucide icon or "rbxassetid://" or URL. optional
    CustomEmptyPage = { -- custom empty page when no elements are added to the tab. optional
		Icon = "lucide:smile", -- icon for empty page. optional
		Title = "This game has not been added yet!", -- title for empty page. optional
		Desc = "If you want this to be added then suggest it \n in the suggestions channel along with some info \n  on what you want us to add to it!", -- description for empty page. optional
	},
})

_G.NiggerGameTab = GameTab

local GameID = game.GameId
local ifscriptforgame = getgitpath(GameID)

if ifscriptforgame then
    GameTab:Section({
        Title = "Main",
        Box = false,
        TextTransparency = 0.05,
        TextXAlignment = "Center",
        TextSize = 17, -- Default Size
        Opened = true,
    })

    GameTab:Divider()

    loadstring(ifscriptforgame)()
end


task.wait()

local OptimizationOTab = Window:Tab({
    Title = "Optimization",
    Icon = "earth", -- lucide icon or "rbxassetid://" or URL. optional
})

OptimizationOTab:Section({
    Title = "Main",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

OptimizationOTab:Divider()

print("Global Shadows:", false)

local GlobalShadowsToggle

GlobalShadowsToggle = OptimizationOTab:Toggle({
    Title = "Global Shadows: Off",
    Callback = function(state)
        print("Global Shadows:", state)
        
        if state then
            ChangeTitle(GlobalShadowsToggle, "Global Shadows: On")
        else
            ChangeTitle(GlobalShadowsToggle, "Global Shadows: Off")
        end

        Lighting.GlobalShadows = not state
    end
})

local OriginalMaterials = {}
local OriginalMaterialVarient = {}
local OriginalParts = {}

for i, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        if not OriginalMaterials[v] then
            OriginalMaterials[v] = v.Material
        end
        if OriginalParts[v] == nil then
            OriginalParts[v] = v
        end
    end
end

local AllPlasticToggle
print("All Plastic:", false)

local AllPlasticBool = false

AllPlasticToggle = OptimizationOTab:Toggle({
    Title = "Plastic Materials: Off",
    Callback = function(state)
        print("All Plastic:", state)

        AllPlasticBool = state

        if state then
            ChangeTitle(AllPlasticToggle, "Plastic Materials: On")
        else
            ChangeTitle(AllPlasticToggle, "Plastic Materials: Off")
        end

        for part, material in pairs(OriginalMaterials) do
            if part and part.Parent and part:IsA("BasePart") then
                part.Material = state and Enum.Material.Plastic or material
            end
        end

    end
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings", -- lucide icon or "rbxassetid://" or URL. optional
})

SettingsTab:Section({
    Title = "Settings",
    Box = false,
    TextTransparency = 0.05,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
})

SettingsTab:Divider()



local function SetTheme(Theme, Extra)
    local ExtraColors = {
        Dark = {24, 33, 39},
        Light = {216, 221, 222},
        Rose = {47, 24, 28},
        Plant = {24, 43, 36},
        Red = {40, 27, 30},
        Indigo = {29, 29, 62},
        Sky = {14, 40, 56},
        Violet = {34, 25, 75},
        Amber = {35, 31, 23},
        Emerald = {11, 35, 38},
        Midnight = {20, 32, 48},
        Crimson = {22, 22, 26},
        MonokaiPro = {34, 39, 53},
        CottonCandy = {39, 31, 63},
        Mellowsi = {32, 21, 9},
        Rainbow = {199, 20, 50},
    } 

    
    local color3table = ExtraColors[Theme]
    if not color3table then return end

    local color = Color3.fromRGB(color3table[1], color3table[2], color3table[3])

    for i, v in ipairs(Extra) do
        v:SetColor(color)
    end
    
end

local FPSTag
local PingTag

local ThemesDropdown = SettingsTab:Dropdown({
    Title = "Select Theme",
    Values = {
        "Light",
        "Dark",
        "Rose",
        "Plant",
        "Red",
        "Indigo",
        "Sky",
        "Violet",
        "Amber",
        "Emerald",
        "Midnight",
        "Crimson",
        "Monokai Pro",
        "Cotton Candy",
        "Mellowsi",
        "Rainbow"
    },
    Value = Theme,
    Multi = false,
    Locked = false,
    Callback = function(selected)
        print("Theme Selected:", selected)

        local ThemeOverrides = {
            ["Cotton Candy"] = "CottonCandy",
            ["Monokai Pro"] = "MonokaiPro",
        }

        if ThemeOverrides[selected] then
            selected = ThemeOverrides[selected]
        end

        WindUI:SetTheme(tostring(selected))
        SetTheme(selected, {FPSTag, PingTag})
        SaveFile("Theme.config", selected, false)
    end
})

-- FPS Tag
FPSTag = Window:Tag({
    Title = "FPS: 0",
    Color = Color3.fromRGB(47, 24, 28),
})
 
local lastUpdate = tick()
local frameCount = 0
 
local FPSUpdater = RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    
    if now - lastUpdate >= 1 then
        local fps = math.floor(frameCount / (now - lastUpdate))
        FPSTag:SetTitle("FPS: " .. fps)
        
        frameCount = 0
        lastUpdate = now
    end
end)

-- Ping Tag
PingTag = Window:Tag({
    Title = "Ping: 0ms",
    Color = Color3.fromRGB(47, 24, 28),
})

 
task.spawn(function()
    while true do
        local success, ping = pcall(function()
            local Stats = game:GetService("Stats")
            local pingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            return math.floor(pingValue)
        end)
        
        if success and ping then
            PingTag:SetTitle("Ping: " .. ping .. "ms")
        end
        
        task.wait(2)
    end
end)

SetTheme(Theme, {FPSTag, PingTag})

-- [Checks] --
isDiedConnection = Humanoid.Died:Connect(function()
    isDead = true
    Gravity = OriginalGravity
end)


GravityConnection = RunService.RenderStepped:Connect(function()
    Workspace.Gravity = Gravity
end)

Player.CharacterAdded:Connect(function()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Camera = Workspace.CurrentCamera

    JumpHeightBool = false
    WalkSpeedBool = false
    
    RunningSound = nil

    if GetSounds("Running") then
        RunningSound = HumanoidRootPart:FindFirstChild("Running")
        RunningSoundOriginalVolume = RunningSound.Volume
    end

    isDead = false
    isDiedConnection:Disconnect()
    
    isDiedConnection = Humanoid.Died:Connect(function()
        isDead = true
        Workspace.Gravity = OriginalGravity
    end)

    JumpHeightLoopToggle:Unlock()
    HumanoidWalkSpeedLoopToggle:Unlock()
    ChangeTitle(JumpHeightButton,"Set JumpHeight")
    ChangeTitle(HumanoidWalkSpeedButton,"Set WalkSpeed")
end)

local connectionspc = {}

local function PlasticCheckPropertyChanged(part)
    if not part:IsA("BasePart") then
        return
    end

    if connectionspc[part] then
        connectionspc[part]:Disconnect()
    end

    connectionspc[part] =
    part:GetPropertyChangedSignal("Material"):Connect(function()
        if AllPlasticBool then
            if part.Material ~= Enum.Material.Plastic then
                part.Material = Enum.Material.Plastic
            end
        end
    end)

end

local PlasticAddConnection = workspace.DescendantAdded:Connect(function(child)
    if child:IsA("BasePart") then
        if OriginalMaterials[child] == nil then
            if child.Material ~= Enum.Material.Plastic and AllPlasticBool then
                OriginalMaterials[child] = child.Material
            end
        end
        if AllPlasticBool then
            child.Material = Enum.Material.Plastic
        else
            if OriginalMaterials[child] then
                child.Material = OriginalMaterials[child]
            end
        end
        if not connectionspc[child] then
            PlasticCheckPropertyChanged(child) 
        end
    end
end)

local PlasticRemoveConnection = workspace.DescendantRemoving:Connect(function(child)
    OriginalMaterials[child] = nil

    if connectionspc[child] then
        connectionspc[child]:Disconnect()
        connectionspc[child] = nil
        return
    end
end)

for i, v in pairs(OriginalParts) do
    PlasticCheckPropertyChanged(v)
end
