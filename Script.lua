plr = game.Players.LocalPlayer
char = plr.Character
hum = char.Humanoid
hrp = char.HumanoidRootPart

rs = game.RunService

ToolEnabled = true
ToolUsing = false
Grab = false
GrabConnections = {}
GrabCharacters = {}
bullshitvariable = false
Grabbed = false

function checknotr15()
    return hum.RigType ~= Enum.HumanoidRigType.R15
end

if not checknotr15() then
    msg = Instance.new("Hint", workspace)
    msg.Text = "you're not r6"
    game.Debris:AddItem(msg, 2)
    return
end

Mesh = "http://www.roblox.com/asset/?id=11442510"
Texture = "http://www.roblox.com/asset/?id=11442524"

NpcKill = "https://github.com/InnocentViru/Black-Knife/raw/refs/heads/main/Thorn%20Ring%20(ominous_stab_harsh.ogg)%20-%20DELTARUNE%20Chapters%203+4%20OST%20-%20Aventuras%20Demais%20(youtube).mp3"

Slash = "rbxassetid://4958430453"
Impale = "rbxassetid://5754301788"
Bleed = "rbxassetid://71884701777530"

if not isfile("ThornRing.mp3") then
    writefile("ThornRing.mp3", game:HttpGet(NpcKill))
end

anims = {
    [1] = "rbxassetid://74897796",
    [2] = "rbxassetid://54432537",
    [3] = "rbxassetid://203876950",
    [4] = "rbxassetid://186934910",
    [5] = "rbxassetid://203875401"
}

pcall(function()
    plr.Backpack["Black Knife"]:Destroy()
end)
pcall(function()
    getgenv().roaringknight:Disconnect()
end)

plr.ReplicationFocus = workspace
getgenv().roaringknight = rs.Heartbeat:Connect(function()
    sethiddenproperty(plr, "MaxSimulationRadius", math.huge)
    sethiddenproperty(plr, "SimulationRadius", math.huge)
end)

Tool = Instance.new("Tool", plr.Backpack)
Tool.ToolTip = "niche reference"
Tool.Name = "Black Knife"
Tool.Grip = CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(90), math.rad(90), 0)

Handle = Instance.new("Part", Tool)
Handle.Name = "Handle"
Handle.Size = Vector3.new(1, 0.6, 6)
Handle.CanTouch = false

Highlight = Instance.new("Highlight", Handle)
Highlight.FillTransparency = 0
Highlight.FillColor = Color3.new(0,0,0)
Highlight.DepthMode = "Occluded"

ImpaleAtt = Instance.new("Attachment", Handle)
ImpaleAtt.Position = Vector3.new(0, 0, Handle.Size.Z / 3)
ImpaleAtt.CFrame = ImpaleAtt.CFrame * CFrame.Angles(math.rad(90), 0, 0)

SpecialMesh = Instance.new("SpecialMesh", Handle)
SpecialMesh.MeshId = Mesh
SpecialMesh.VertexColor = Vector3.new(0,0,0)
SpecialMesh.TextureId = Texture
SpecialMesh.Scale = Vector3.new(2.2,2.2,2.2)

vfx = Instance.new("ParticleEmitter", Handle)
vfx.Rate = 500
vfx.Speed = NumberRange.new(0,0)
vfx.Brightness = 10
vfx.Lifetime = NumberRange.new(.5, .5)
vfx.Color = ColorSequence.new(Color3.new(0,0,0))
vfx.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 1.2),
    NumberSequenceKeypoint.new(1, 0),
})
vfx.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
vfx.Rotation = NumberRange.new(-360, 360)

att1 = Instance.new("Attachment", Handle)
att2 = Instance.new("Attachment", Handle)
att1.Position = Vector3.new(0, 0, Handle.Size.Z / 1.75)
att2.Position = Vector3.new(0, 0, -(Handle.Size.Z / 4))

trail = Instance.new("Trail", Handle)
trail.Attachment0 = att1
trail.Attachment1 = att2
trail.Lifetime = .35
trail.Enabled = false
trail.Color = ColorSequence.new(Color3.new(0,0,0))
trail.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),    
    NumberSequenceKeypoint.new(1, 1),
})

pcall(function() gethui()["Grab_Ability"]:Destroy() end)

ScreenGui = Instance.new("ScreenGui", gethui())
ScreenGui.Name = "Grab_Ability"
TextButton = Instance.new("TextButton", ScreenGui)
UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", TextButton)
UIStroke = Instance.new("UIStroke", TextButton)

TextButton.Text = "Impale (Grab)"
TextButton.Size = UDim2.fromScale(.12, .12)
TextButton.AnchorPoint = Vector2.new(.5,.5)
TextButton.Position = UDim2.fromScale(.8, .5)
TextButton.Font = "Arcade"
TextButton.TextScaled = true
TextButton.TextColor3 = Color3.new(1,1,1)
TextButton.BackgroundColor3 = Color3.new(0,0,0)

UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = "Border"
UIStroke.Color = Color3.new(1,1,1)

function playanim(booleangrab)
    local random = anims[math.random(1, #anims)]
    local anim = Instance.new("Animation")
    anim.AnimationId = random
    local tr = hum:LoadAnimation(anim)
    tr:Play(0, 5, booleangrab and 1.5 or 1)
    tr.Ended:Wait()
end

function blood(phrp)
    for i = 1, 12 do
        local p = Instance.new("Part", workspace)
        p.Name = "blood" .. i
        p.Material = "Neon"
        p.Color = Color3.new(1,0,0)
        p.CFrame = phrp.CFrame
        p.Size = Vector3.one
        p.RotVelocity = Vector3.new(20,20,20)
        p.Velocity = Vector3.new(math.random(-100, 100), math.random(-200, 200), math.random(-100, 100))

        local at = Instance.new("Attachment", p)
        local at2 = Instance.new("Attachment", p)
        at.Position = Vector3.new(0, p.Size.Y / 2, 0)
        at2.Position = Vector3.new(0, -(p.Size.Y / 2), 0)
        local tra = Instance.new("Trail", p)
        tra.Attachment0 = at
        tra.Attachment1 = at2
        tra.Brightness = 10
        tra.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),    
            NumberSequenceKeypoint.new(1, 0),
        })
        tra.Color = ColorSequence.new(Color3.new(1,0,0))
        tra.Lifetime = 1.5
        tra.FaceCamera = true
        game.Debris:AddItem(p,6)
    end
end

function bleedsfx(p)
    local sound = Instance.new("Sound", p)
    sound.SoundId = Bleed
    sound.Volume = 5
    sound.PlayOnRemove = true
    sound:Destroy()
    sound = nil
end

function bleed(phrp, phum)
    for i = 1, 30 do
        if not phum or not phum.Parent or phum.Health <= 0 then break end
        local p = Instance.new("Part", workspace)
        p.Name = "blood" .. i
        p.Material = "Neon"
        p.Color = Color3.new(1,0,0)
        p.CFrame = phrp.CFrame * CFrame.new(0,0,-.5)
        p.Size = Vector3.new(.5,.5,.5)
        p.RotVelocity = Vector3.new(20,20,20)
        p.Velocity = Vector3.new(0, 10, 0)
        bleedsfx(p)

        local at = Instance.new("Attachment", p)
        local at2 = Instance.new("Attachment", p)
        at.Position = Vector3.new(0, p.Size.Y / 2, 0)
        at2.Position = Vector3.new(0, -(p.Size.Y / 2), 0)
        local tra = Instance.new("Trail", p)
        tra.Attachment0 = at
        tra.Attachment1 = at2
        tra.Brightness = 10
        tra.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),    
            NumberSequenceKeypoint.new(1, 0),
        })
        tra.Color = ColorSequence.new(Color3.new(1,0,0))
        tra.Lifetime = 1.5
        tra.FaceCamera = true
        game.Debris:AddItem(p,6)
        task.wait(.1)
    end
end

function killsfx(p)
    local sound = Instance.new("Sound", p)
    sound.SoundId = getcustomasset("ThornRing.mp3")
    sound.Volume = 5
    sound.PlayOnRemove = true
    sound:Destroy()
    sound = nil
end

function killnpc(character)
    local h = character:FindFirstChild("Humanoid")
    local p = character:FindFirstChild("HumanoidRootPart")
    if h and p and not game.Players:GetPlayerFromCharacter(character) 
    and p.ReceiveAge == 0 and h.Health > 0 then
        if not Grab then
            h:TakeDamage(9e9)
            h:ChangeState("Died")
            h.Health = -1
            blood(p)
            killsfx(p)
        end
    end
end

function impalesfx()
    local sound = Instance.new("Sound", Handle)
    sound.SoundId = Impale
    sound.Volume = 5
    sound.PlayOnRemove = true
    sound:Destroy()
    sound = nil
end

function grabnpc(character)
    local h = character:FindFirstChild("Humanoid")
    local p = character:FindFirstChild("HumanoidRootPart")
    local success = false

    if h and p and not game.Players:GetPlayerFromCharacter(character) 
    and p.ReceiveAge == 0 and h.Health > 0 and not GrabCharacters[1] 
    and not GrabConnections[1] then
        GrabCharacters[1] = character
        success = true
        Grabbed = true
        task.spawn(bleed, p, h)
        impalesfx()
        GrabConnections[1] = rs.Heartbeat:Connect(function()
            if Tool.Parent == char and p.ReceiveAge == 0 then
                p.CFrame = CFrame.new(ImpaleAtt.WorldPosition) * CFrame.Angles(math.rad(90), 0, 0)
                p.Velocity = Vector3.zero
            end
        end)
    end

    return success
end

function grab(character)
    local success = grabnpc(character)
    if success and Grab then
        local start = tick()        
        repeat task.wait() until tick() - start > 10 or not Grab or bullshitvariable
        GrabConnections[1]:Disconnect()
        GrabCharacters[1] = nil
        table.clear(GrabCharacters)
        table.clear(GrabConnections)    
        Grabbed = false
    end
end

function slash(booleangrab)
    local sound = Instance.new("Sound", Handle)
    sound.SoundId = Slash
    sound.Volume = 5
    sound.PlayOnRemove = true
    sound.Pitch = booleangrab and 1 or .8

    Instance.new("ReverbSoundEffect", sound).DecayTime = 2.5
    sound:Destroy()
    sound = nil
end

Handle.Touched:Connect(function(p)    
    local character = p:FindFirstAncestorOfClass("Model")
    if character and character ~= char then
        if not Grab then 
            killnpc(character)
        else 
            grab(character)
        end
    end
end)

db = false
db2 = false

Tool.Activated:Connect(function()
    if db or db2 or not ToolEnabled or Grab then return end
    db = true     
    trail.Enabled = true
    Handle.CanTouch = true
    slash(true)
    ToolUsing = true

    playanim(true)
    delay(.2, function() db = false ToolUsing = false end)

    Handle.CanTouch = false
    trail.Enabled = false
end)


TextButton.MouseButton1Click:Connect(function()
    if GrabConnections[1] then        
        bullshitvariable = true
        return
    end
    if not db2 and not ToolUsing and not GrabConnections[1] 
    and Tool.Parent == char then
        db2 = true        
        ToolEnabled = false

        Grab = true        
        Handle.CanTouch = true
        bullshitvariable = false
        trail.Enabled = true

        slash(false)        
        playanim(false)
        Handle.CanTouch = false         
        trail.Enabled = false

        local r = tick()
        spawn(function()
            repeat task.wait() until tick() - r > (Grabbed and 10 or 1) or bullshitvariable 
            if bullshitvariable then
                task.wait(.8)
                db2 = false             
                Grab = false
                ToolEnabled = true
            else
                db2 = false             
                Grab = false
                ToolEnabled = true
            end
        end)
    end
end)

connection = hum.Died:Connect(function()
    connection:Disconnect() connection = nil
    getgenv().roaringknight:Disconnect() getgenv().roaringknight = nil
    pcall(function() Tool:Destroy() end)
    plr.ReplicationFocus = nil
    ScreenGui:Destroy() ScreenGui = nil
end)

msg = Instance.new("Message", workspace)
msg.Text = "executed, made by VirusSX"
game.Debris:AddItem(msg, 4)
setclipboard("https://discord.gg/5xEktGhuDF")
