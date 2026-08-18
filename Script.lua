plr = game.Players.LocalPlayer
char = plr.Character
hum = char.Humanoid
hrp = char.HumanoidRootPart

rs = game.RunService

function checknotr15()
    return hum.RigType ~= Enum.HumanoidRigType.R15
end

if not checknotr15 then
    Instance.new("Hint", workspace).Text = "you're not r6"
    game.Debris:AddItem(workspace.Message, 4)
    return
end

Mesh = "http://www.roblox.com/asset/?id=11442510"
Texture = "http://www.roblox.com/asset/?id=11442524"

NpcKill = "https://github.com/InnocentViru/Black-Knife/raw/refs/heads/main/Thorn%20Ring%20(ominous_stab_harsh.ogg)%20-%20DELTARUNE%20Chapters%203+4%20OST%20-%20Aventuras%20Demais%20(youtube).mp3"
Slash = "rbxassetid://4958430453"

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
vfx.Rate = 100
vfx.Speed = NumberRange.new(0,0)
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
vfx.LightEmission = .5
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

function playanim()
    local random = anims[math.random(1, #anims)]
    local anim = Instance.new("Animation")
    anim.AnimationId = random
    local tr = hum:LoadAnimation(anim)
    tr:Play(0, 5, 1.5)
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
        h:TakeDamage(9e9)
        h:ChangeState("Died")
        h.Health = -1
        blood(p)
        killsfx(p)
    end
end

function slash()
    local sound = Instance.new("Sound", Handle)
    sound.SoundId = Slash
    sound.Volume = 5
    sound.PlayOnRemove = true

    Instance.new("ReverbSoundEffect", sound).DecayTime = 2.5
    sound:Destroy()
    sound = nil
end

Handle.Touched:Connect(function(p)
    local character = p:FindFirstAncestorOfClass("Model")
    if character and character ~= char then
        killnpc(character)
    end
end)

db = false
ToolEnabled = true

Tool.Activated:Connect(function()
    if db or not ToolEnabled then return end
    db = true     
    trail.Enabled = true
    Handle.CanTouch = true
    slash()

    playanim()
    delay(.2, function() db = false end)

    Handle.CanTouch = false
    trail.Enabled = false
end)

connection = hum.Died:Connect(function()
    connection:Disconnect() connection = nil
    getgenv().roaringknight:Disconnect() getgenv().roaringknight = nil
    pcall(function() Tool:Destroy() end)
    plr.ReplicationFocus = nil
end)

Instance.new("Hint", workspace).Text = "executed, made by VirusSX"
game.Debris:AddItem(workspace.Message, 4)
