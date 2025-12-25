--[[game:GetService("Players").LocalPlayer:Kick()
game:GetService("GuiService"):ClearError()]]
do
    if not LPH_OBFUSCATED then
        LPH_JIT = function(...)
            return ...;
        end;
        LPH_JIT_MAX = function(...)
            return ...;
        end;
        LPH_NO_VIRTUALIZE = function(...)
            return ...;
        end;
        LPH_NO_UPVALUES = function(f)
            return (function(...)
                return f(...);
            end);
        end;
        LPH_ENCSTR = function(...)
            return ...;
        end;
        LPH_ENCNUM = function(...)
            return ...;
        end;
        LPH_ENCFUNC = function(func, key1, key2)
            if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
            return func
        end
        LPH_CRASH = function()
            return print(debug.traceback());
        end;
    end;

    if not LPH_OBFUSCATED then
        SWG_DiscordUser = "swim"
        SWG_DiscordID = 1337
        SWG_SecondsLeft = 9999
        SWG_Note = "private"
        SWG_IsLifetime = true

        if not debug.isvalidlevel then
            setreadonly(debug, false)
            debug.isvalidlevel = function(s)
                local success = pcall(function()
                    return debug.getinfo(s + 3)
                end)
                return success
            end
            setreadonly(debug, true)
        end
    end
end
--- FABRICATED VALUES END!!!

local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _IsA = game.IsA
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local tostring = tostring
local unpack = unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local rawget = rawget

local cheat = {
    Library = nil,
    Toggles = nil,
    Options = nil,
    ThemeManager = nil,
    SaveManager = nil,
    connections = {
        heartbeats = {},
        renderstepped = {}
    },
    drawings = {},
    hooks = {}
}
cheat.utility = {} do
    cheat.utility.new_heartbeat = function(func)
        local obj = {}
        cheat.connections.heartbeats[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.heartbeats[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_renderstepped = function(func)
        local obj = {}
        cheat.connections.renderstepped[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.renderstepped[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_drawing = function(drawobj, args)
        local obj = Drawing.new(drawobj)
        for i, v in pairs(args) do
            obj[i] = v
        end
        cheat.drawings[obj] = obj
        return obj
    end
    cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
        if usecclosure then
            local old; old = hookfunction(f, newcclosure(function(...)
                return newf(old, ...)
            end))
            cheat.hooks[f] = old
            return old
        else
            local old; old = hookfunction(f, function(...)
                return newf(old, ...)
            end)
            cheat.hooks[f] = old
            return old
        end
    end)() end
    local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.heartbeats) do
            func(delta)
        end
    end))
    local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.renderstepped) do
            func(delta)
        end
    end))
    cheat.utility.unload = function()
        connection:Disconnect()
        connection1:Disconnect()
        for key, _ in pairs(cheat.connections.heartbeats) do
            cheat.connections.heartbeats[key] = nil
        end
        for key, _ in pairs(cheat.connections.renderstepped) do
            cheat.connections.heartbeats[key] = nil
        end
        for _, drawing in pairs(cheat.drawings) do
            drawing:Remove()
            cheat.drawings[_] = nil
        end
        for hooked, original in pairs(cheat.hooks) do
            if type(original) == "function" then
                hookfunction(hooked, clonefunction(original))
            else
                hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
            end
        end
    end
end

local aftermath = {
    remotes = {
        gunmelee = game:GetService("ReplicatedStorage").GunSystem.Event.GunEvent.GunMelee,
        gunfire = game:GetService("ReplicatedStorage").GunSystem.Event.GunEvent.GunFire,
        bullethole = game:GetService("ReplicatedStorage").GunSystem.Event.GunEvent.BulletHole
    },
    gundata = game:GetService("ReplicatedStorage").GunSystemAssets.GunData,
    sv_config = game:GetService("ReplicatedStorage").CustomCharacterConfigs.Configuration.Server
}
do
    local gottem = 0
    repeat
        gottem = 0
        for _, gc in getgc(true) do
            if type(gc) == "table" then
                local gpfwc = rawget(gc, "GetPlayerFromWorldCharacter")

                if (gpfwc and type(gpfwc) == "function") then
                    local list = getupvalues(gpfwc)[1]
                    if not (list and type(list) == "table") then continue end
                    gottem += 1
                    aftermath.entitylist = list
                    continue
                end
            end
        end
        task.wait(0.5)
    until gottem == 1
end
local function get_current_gun(plr)
	if not plr then return "Fists" end
    local currentobj = _FindFirstChild(plr, "CurrentSelectedObject") and plr.CurrentSelectedObject.Value
    local gunname = currentobj and currentobj.Value
    return gunname and gunname.Name or "Fists"
end
LPH_NO_VIRTUALIZE(function()
    local esp_table = {}
    local workspace = cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
    local rservice = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local plrs = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local lplr = plrs.LocalPlayer
    local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)

    esp_table = {
        __loaded = false,
        settings = {
            enemy = {
                main_settings = {
                    textSize = 13,
                    textFont = Drawing.Fonts.System,
                    distancelimit = false,
                    maxdistance = 200,
                    boxStatic = false,
                    boxStaticX = 3.5,
                    boxStaticY = 5,
                    fadetime = 1,
                    team_check = false
                },

                enabled = true,
    
                box = false,
                box_fill = false,
                realname = true,
                displayname = false,
                health = false,
                dist = true,
                weapon = true,
                skeleton = true,
    
                box_outline = false,
                realname_outline = true,
                displayname_outline = true,
                health_outline = true,
                dist_outline = true,
                weapon_outline = true,
    
                box_color = { Color3.new(1, 1, 1), 1 },
                box_fill_color = { Color3.new(1, 0, 0), 0.5 },
                realname_color = { Color3.new(1, 1, 1), 1 },
                displayname_color = { Color3.new(1, 1, 1), 1 },
                health_color = { Color3.new(1, 1, 1), 1 },
                dist_color = { Color3.new(1, 1, 1), 1 },
                weapon_color = { Color3.new(1, 1, 1), 1 },
                skeleton_color = { Color3.new(1, 1, 1), 1 },
    
                box_outline_color = { Color3.new(), 1 },
                realname_outline_color = Color3.new(),
                displayname_outline_color = Color3.new(),
                health_outline_color = Color3.new(),
                dist_outline_color = Color3.new(),
                weapon_outline_color = Color3.new(),
    
                chams = false,
                chams_visible_only = false,
                chams_fill_color = { Color3.new(1, 1, 1), 0.5 },
                chamsoutline_color = { Color3.new(1, 1, 1), 0 }
            }
        }
    }

    local loaded_plrs = {}
    local entitylist = aftermath.entitylist

    local camera = workspace.CurrentCamera
    local viewportsize = camera.ViewportSize

    local VERTICES = {
        _Vector3new(-1, -1, -1),
        _Vector3new(-1, 1, -1),
        _Vector3new(-1, 1, 1),
        _Vector3new(-1, -1, 1),
        _Vector3new(1, -1, -1),
        _Vector3new(1, 1, -1),
        _Vector3new(1, 1, 1),
        _Vector3new(1, -1, 1)
    }
    local skeleton_order = {
        ["LeftFoot"] = "LeftLowerLeg",
        ["LeftLowerLeg"] = "LeftUpperLeg",
        ["LeftUpperLeg"] = "LowerTorso",
    
        ["RightFoot"] = "RightLowerLeg",
        ["RightLowerLeg"] = "RightUpperLeg",
        ["RightUpperLeg"] = "LowerTorso",
    
        ["LeftHand"] = "LeftLowerArm",
        ["LeftLowerArm"] = "LeftUpperArm",
        ["LeftUpperArm"] = "UpperTorso",
    
        ["RightHand"] = "RightLowerArm",
        ["RightLowerArm"] = "RightUpperArm",
        ["RightUpperArm"] = "UpperTorso",
    
        ["LowerTorso"] = "UpperTorso",
        ["UpperTorso"] = "Head"
    }
    local esp = {}
    esp.create_obj = function(type, args)
        local obj = Drawing.new(type)
        for i, v in args do
            obj[i] = v
        end
        return obj
    end
    
    local function isBodyPart(name)
        return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm")
    end

    local function getBoundingBox(parts)
        local min, max
        for i, part in parts do
            local cframe, size = part.CFrame, part.Size
    
            min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
            max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
        end

        local center = (min + max) * 0.5
        local front = _Vector3new(center.X, center.Y, max.Z)
        return _CFramenew(center, front), max - min
    end

    local function getStaticBoundingBox(part, size)
        return part.CFrame, size
    end
    
    local function worldToScreen(world)
        local screen, inBounds = _WorldToViewportPoint(camera, world)
        return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
    end
    
    local function calculateCorners(cframe, size)
        local corners = table.create(#VERTICES)
        for i = 1, #VERTICES do
            corners[i] = worldToScreen((cframe + size * 0.5 * VERTICES[i]).Position)
        end
    
        local min = _Vector2zeromin(camera.ViewportSize, unpack(corners))
        local max = _Vector2zeromax(Vector2.zero, unpack(corners))
        return {
            corners = corners,
            topLeft = _Vector2new(mathfloor(min.X), mathfloor(min.Y)),
            topRight = _Vector2new(mathfloor(max.X), mathfloor(min.Y)),
            bottomLeft = _Vector2new(mathfloor(min.X), mathfloor(max.Y)),
            bottomRight = _Vector2new(mathfloor(max.X), mathfloor(max.Y))
        }
    end

    local create_esp, create_item_esp, create_object_esp, destroy_esp;

    create_esp = function(plr_instance, worldmodel, wmname, character, root)
        local is_bot = type(plr_instance) == "table"

        loaded_plrs[wmname] = {
            obj = {
                box_fill = esp.create_obj("Square", { Filled = true, Visible = false }),
                box_outline = esp.create_obj("Square", { Filled = false, Thickness = 3, Visible = false }),
                box = esp.create_obj("Square", { Filled = false, Thickness = 1, Visible = false }),
                realname = esp.create_obj("Text", { Center = true, Visible = false, Text = plr_instance.Name }),
                displayname = esp.create_obj("Text", { Center = true, Visible = false, Text = plr_instance.Name == plr_instance.DisplayName and "" or plr_instance.DisplayName }),
                healthtext = esp.create_obj("Text", { Center = false, Visible = false }),
                dist = esp.create_obj("Text", { Center = true, Visible = false }),
                weapon = esp.create_obj("Text", { Center = true, Visible = false }),
            },
            chams_object = Instance.new("Highlight", container),
        }

        for required, _ in next, skeleton_order do
            loaded_plrs[wmname].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false })
        end

        local plr = loaded_plrs[wmname]
        local obj = plr.obj

        local box = obj.box
        local box_outline = obj.box_outline
        local box_fill = obj.box_fill
        local healthtext = obj.healthtext
        local realname = obj.realname
        local displayname = obj.displayname
        local dist = obj.dist
        local weapon = obj.weapon
        local cham = plr.chams_object

        local settings = esp_table.settings.enemy
        local main_settings = settings.main_settings

        local head = worldmodel and _FindFirstChild(worldmodel, "Head")

        local setvis_cache = false
        local fadetime = main_settings.fadetime
        local staticbox = false
        local staticbox_size = _Vector3new(main_settings.boxStaticX, main_settings.boxStaticY, main_settings.boxStaticX)
        local team_check = main_settings.team_check
        local fadethread

        function plr:forceupdate()
            fadetime = main_settings.fadetime
            staticbox = main_settings.boxStatic
            team_check = main_settings.team_check
            staticbox_size = _Vector3new(main_settings.boxStaticX, main_settings.boxStaticY, main_settings.boxStaticX)

            cham.DepthMode = settings.chams_visible_only and 1 or 0
            cham.FillColor = settings.chams_fill_color[1]
            cham.OutlineColor = settings.chamsoutline_color[1]
            cham.FillTransparency = settings.chams_fill_color[2]
            cham.OutlineTransparency = settings.chamsoutline_color[2]

            box.Color = settings.box_color[1]
            box_outline.Color = settings.box_outline_color[1]
            box_fill.Color = settings.box_fill_color[1]

            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Color = settings.realname_color[1]
            realname.Outline = settings.realname_outline
            realname.OutlineColor = settings.realname_outline_color

            displayname.Size = main_settings.textSize
            displayname.Font = main_settings.textFont
            displayname.Color = settings.displayname_color[1]
            displayname.Outline = settings.displayname_outline
            displayname.OutlineColor = settings.displayname_outline_color

            healthtext.Size = main_settings.textSize
            healthtext.Font = main_settings.textFont
            healthtext.Color = settings.health_color[1]
            healthtext.Outline = settings.health_outline
            healthtext.OutlineColor = settings.health_outline_color

            dist.Size = main_settings.textSize
            dist.Font = main_settings.textFont
            dist.Color = settings.dist_color[1]
            dist.Outline = settings.dist_outline
            dist.OutlineColor = settings.dist_outline_color

            weapon.Size = main_settings.textSize
            weapon.Font = main_settings.textFont
            weapon.Color = settings.weapon_color[1]
            weapon.Outline = settings.weapon_outline
            weapon.OutlineColor = settings.weapon_outline_color

            for required, _ in next, skeleton_order do
                local skeletonobj = obj["skeleton_" .. required]
                if skeletonobj then
                    skeletonobj.Color = settings.skeleton_color[1]
                end
            end

            box.Transparency = settings.box_color[2]
            box_outline.Transparency = settings.box_outline_color[2]
            box_fill.Transparency = settings.box_fill_color[2]
            realname.Transparency = settings.realname_color[2]
            displayname.Transparency = settings.displayname_color[2]
            healthtext.Transparency = settings.health_color[2]
            dist.Transparency = settings.dist_color[2]
            weapon.Transparency = settings.weapon_color[2]
            for required, _ in next, skeleton_order do
                obj["skeleton_" .. required].Transparency = settings.skeleton_color[2]
            end

            if setvis_cache then
                cham.Enabled = settings.chams
                box.Visible = settings.box
                box_outline.Visible = settings.box_outline
                box_fill.Visible = settings.box_fill
                realname.Visible = settings.realname
                displayname.Visible = settings.displayname
                healthtext.Visible = settings.health
                dist.Visible = settings.dist
                weapon.Visible = settings.weapon
                for required, _ in next, skeleton_order do
                    local skeletonobj = obj["skeleton_" .. required]
                    if (skeletonobj) then
                        skeletonobj.Visible = settings.skeleton
                    end
                end
            end
        end

        function plr:togglevis(bool, fade)
            if setvis_cache ~= bool then
                setvis_cache = bool
                if not bool then
                    for _, v in obj do v.Visible = false end
                    cham.Enabled = false
                else
                    cham.Enabled = settings.chams
                    box.Visible = settings.box
                    box_outline.Visible = settings.box_outline
                    box_fill.Visible = settings.box_fill
                    realname.Visible = settings.realname
                    displayname.Visible = settings.displayname
                    healthtext.Visible = settings.health
                    dist.Visible = settings.dist
                    weapon.Visible = settings.weapon
                    for required, _ in next, skeleton_order do
                        local skeletonobj = obj["skeleton_" .. required]
                        if (skeletonobj) then
                            skeletonobj.Visible = settings.skeleton
                        end
                    end
                end
            end
        end

        plr.connection = cheat.utility.new_renderstepped(function(delta)
            if not settings.enabled then
                return plr:togglevis(false)
            end
            if not (entitylist[wmname]) then
                --print('destroying', wmname, plr_instance.Name)
                return destroy_esp(wmname)
            end
            if (team_check) and (LocalPlayer.Team and plr_instance.Team and LocalPlayer.Team == plr_instance.Team) then
                --print('on team', LocalPlayer.Team, plr_instance.Team)
                return plr:togglevis(false)
            end

            head = worldmodel and _FindFirstChild(worldmodel, "Head")

            if not (head) then
                return plr:togglevis(false)
            end

            local _, onScreen = _WorldToViewportPoint(camera, head.Position)
            if not onScreen then
                return plr:togglevis(false)
            end

            local humanoid_distance = (camera.CFrame.Position - head.Position).Magnitude
            local humanoid_health = 100
            local humanoid_max_health = 100

            local corners, boundingcenter, boundingsize do
                
                if staticbox then
                    boundingcenter, boundingsize = getStaticBoundingBox(root or head, staticbox_size)
                else
                    local cache = {}
                    for _, part in worldmodel:GetChildren() do
                        if _IsA(part, "BasePart") and isBodyPart(part.Name) then
                            cache[#cache + 1] = part
                        end
                    end
                    if #cache <= 0 then return plr:togglevis(false) end
                    boundingcenter, boundingsize = getBoundingBox(cache)
                end

                corners = calculateCorners(boundingcenter, boundingsize)
            end

            plr:togglevis(true)

            cham.Adornee = worldmodel
            do
                local pos = corners.topLeft
                local size = corners.bottomRight - corners.topLeft
                box.Position = pos
                box.Size = size
                box_outline.Position = pos
                box_outline.Size = size
                box_fill.Position = pos
                box_fill.Size = size
            end
            do
                local pos = (corners.topLeft + corners.topRight) * 0.5 - Vector2.yAxis
                realname.Position = pos - (Vector2.yAxis * realname.TextBounds.Y) - _Vector2new(0, 2)
                displayname.Position = pos -
                Vector2.yAxis * displayname.TextBounds.Y -
                (realname.Visible and Vector2.yAxis * realname.TextBounds.Y or Vector2.zero)
            end
            do
                local pos = (corners.bottomLeft + corners.bottomRight) * 0.5
                dist.Text = mathround(humanoid_distance / 3) .. " meters"
                dist.Position = pos
                weapon.Text = is_bot and "unknown" or esp_table.get_gun(plr_instance)
                weapon.Position = pos + (dist.Visible and Vector2.yAxis * dist.TextBounds.Y - _Vector2new(0, 2) or Vector2.zero)
            end

            healthtext.Text = tostring(mathfloor(humanoid_health))
            healthtext.Position = corners.topLeft - _Vector2new(2, 0) - Vector2.yAxis * (healthtext.TextBounds.Y * 0.25) - Vector2.xAxis * healthtext.TextBounds.X

            if settings.skeleton then
                for _, part in next, worldmodel:GetChildren() do
                    local name = part.Name
                    local parent_part = skeleton_order[name]
                    local parent_instance = parent_part and _FindFirstChild(worldmodel, parent_part)
                    local line = obj["skeleton_" .. name]
                    if parent_instance and line then
                        local part_position, _ = _WorldToViewportPoint(camera, part.Position)
                        local parent_part_position, _ = _WorldToViewportPoint(camera, parent_instance.Position)
                        line.From = _Vector2new(part_position.X, part_position.Y)
                        line.To = _Vector2new(parent_part_position.X, parent_part_position.Y)
                    end
                end
            end
        end)

        plr:forceupdate()
    end

    destroy_esp = function(player)
        if not loaded_plrs[player] then return end
        loaded_plrs[player].connection:Disconnect()
        for i,v in loaded_plrs[player].obj do
            v:Remove()
        end
        if loaded_plrs[player].chams_object then
            loaded_plrs[player].chams_object:Destroy()
        end
        loaded_plrs[player] = nil
    end
    
    function esp_table.load()
        assert(not esp_table.__loaded, "[ESP] already loaded");

        --[[for wmname, v in entitylist do
            local player = v.Player
            if not (player and player ~= LocalPlayer) then continue end
            if (team_check) and (LocalPlayer.Team and LocalPlayer.Team == player.Team) then continue end
            local root = v.RootPart
            local worldmodel = v.WorldModel
            local character = v.Character
            local headcoll = character and _FindFirstChild(character, "ServerColliderHead")
            if not (root and worldmodel and character and headcoll) then continue end
            if type(player) == "table" then
                player = {
                    Name = character.Name .. " (bot)",
                    DisplayName = character.Name .. " (bot)"
                }
            end
            local part = _FindFirstChild(worldmodel, aimpart)
            if not (part) then continue end
            local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
            local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
            if onscreen and distance <= maximum_distance then
                plr_instance = player
                ermm_part = part
                collider = root
                head_collider = headcoll
                maximum_distance = distance
            end
            create_esp(plr_instance, worldmodel, wmname, character, root)
        end]]
        local function iterate_player_esp()
            for wmname, v in next, entitylist do
                local plr_instance = v.Player
                if not (plr_instance and plr_instance ~= LocalPlayer) then continue end

                local root = v.RootPart
                local worldmodel = v.WorldModel
                local character = v.Character

                if not (root and worldmodel and character) then continue end
                if (loaded_plrs[wmname]) then continue end

                if type(plr_instance) == "table" then
                    plr_instance = {
                        Name = character.Name .. " (bot)",
                        DisplayName = character.Name .. " (bot)",
                        Team = nil
                    }
                end

                create_esp(plr_instance, worldmodel, wmname, character, root)
            end
        end

        iterate_player_esp()
        
        esp_table.playerLoop    = cheat.utility.new_renderstepped(iterate_player_esp)
        esp_table.__loaded = true;
    end
    
    function esp_table.unload()
        assert(esp_table.__loaded, "[ESP] not loaded yet");
    
        for player, v in next, loaded_plrs do
            destroy_esp(player)
        end
    
        esp_table.playerLoop:Disconnect()
        
        esp_table.__loaded = false;
    end
    
    esp_table.get_gun = get_current_gun

    function esp_table.icaca()
        for _, v in loaded_plrs do
            task.spawn(function() v:forceupdate() end)
        end
    end

    cheat.EspLibrary = esp_table
end)();
local function get_closest_target(fov_size, aimpart, team_check)
    local ermm_part, plr_instance, collider, head_collider
    local maximum_distance = fov_size
    local mousepos = UserInputService:GetMouseLocation()
    local entitylist = aftermath.entitylist
    LPH_NO_VIRTUALIZE(function()
        for wmname, v in entitylist do
            local player = v.Player
            if not (player and player ~= LocalPlayer) then continue end

            local root = v.RootPart
            local worldmodel = v.WorldModel
            local character = v.Character

            if not (root and worldmodel and character) then continue end
            if type(player) == "table" then
                player = {
                    Name = character.Name .. " (bot)",
                    DisplayName = character.Name .. " (bot)"
                }
            end
            local part = _FindFirstChild(worldmodel, aimpart)
            if not (part) then continue end
            local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
            local distance = (_Vector2new(position.X, position.Y) - mousepos).Magnitude

            if onscreen and distance <= maximum_distance then
                plr_instance = player
                ermm_part = part
                collider = root
                head_collider = headcoll
                maximum_distance = distance
            end
        end
    end)()
    return ermm_part, plr_instance, collider
end

local function predict_target(origin, position, velocity, projectile_speed, projectile_drop)
    local distance = (origin - position).Magnitude
    local time_to_hit = (distance / projectile_speed)
    local predicted_position = position + (velocity * time_to_hit)
    local delta = (predicted_position - position).Magnitude
    time_to_hit = time_to_hit + (delta / projectile_speed)
    return predicted_position + Vector3.yAxis * (projectile_drop * time_to_hit ^ 2)
end

local function full_prediction(target_position, target_collider)

    if not (target_position) then return end

    local currentgun = get_current_gun(LocalPlayer)
    local gun = _FindFirstChild(aftermath.gundata, currentgun)
    local stats = gun and _FindFirstChild(gun, "Stats")
    local bullet_settings = stats and _FindFirstChild(stats, "BulletSettings")
    if bullet_settings then
        local bullet_speed = _FindFirstChild(bullet_settings, "BulletSpeed")
        local bullet_drop  = _FindFirstChild(bullet_settings, "BulletGravity")
        local proj_speed   = bullet_speed and bullet_speed.Value or aftermath.sv_config.sv_default_bullet_speed.Value or 1500
        local proj_drop    = bullet_drop and bullet_drop.Value and aftermath.sv_config.sv_default_bullet_gravity.Value or 0
        local campos         = Camera.CFrame.Position
        local predicted      = predict_target(
            campos,
            target_position,
            target_collider and target_collider.AssemblyLinearVelocity or Vector3.zero,
            proj_speed, proj_drop
        )

        return predicted
    end

    return target_position
end

game:GetService("RunService").RenderStepped:Connect(function(delta)

    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end

    local part, player, collider = get_closest_target(600, "Head")
    if not (part and player and collider) then
        return --print('no part', part, player, collider)
    end

    local predicted = full_prediction(part.Position, collider)

    local pos = _WorldToViewportPoint(Camera, predicted)
    local mpos = UserInputService:GetMouseLocation()
    local diff = _Vector2new(pos.X - mpos.X, pos.Y - mpos.Y) 
    mousemoverel(diff.X, diff.Y)
end)

cheat.EspLibrary.load()
