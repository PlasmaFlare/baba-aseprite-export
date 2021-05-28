local char_tile_map = 
{
    text=0, 
    neutral=0,

    right=0,
    up=8,
    left=16,
    down=24,

    right_a=0,
    up_a=0,
    left_a=0,
    down_a=0,

    sleep_r=31,
    sleep_u=7,
    sleep_l=15,
    sleep_d=23,
    
    diag_ur=4,
    diag_ul=12,
    diag_dl=20,
    diag_dr=28,

    r=1,
    u=2,
    ru=3,
    l=4,
    rl=5,
    ul=6,
    rul=7,
    d=8,
    rd=9,
    ud=10,
    rud=11,
    ld=12,
    rld=13,
    uld=14,
    ruld=15
}
local dir_tags = 
{ 
    right=true, 
    up=true, 
    left=true, 
    down=true
}
local arrow_tags = 
{ 
    right_a=true, 
    up_a=true, 
    left_a=true, 
    down_a=true
}
local sleep_tags = 
{
    sleep_l=true, 
    sleep_r=true, 
    sleep_u=true, 
    sleep_d=true
}
local tile_tags = 
{
    neutral=true,
    r=true,
    u=true,
    ru=true,
    l=true,
    rl=true,
    ul=true,
    rul=true,
    d=true,
    rd=true,
    ud=true,
    rud=true,
    ld=true,
    rld=true,
    uld=true,
    ruld=true
}
local diag_tags = {
    diag_ur=true,
    diag_ul=true,
    diag_dr=true,
    diag_dl=true
}
local tiling_options = {
    "none", 
    "text",
    "directional", 
    "animated",
    "animated_direction", 
    "character", 
    "tiled",
    "tiled_slices",
    -- "arrow",
    -- "diag",
}
local tag_order = {
    none =               {"neutral"},
    directional =        {"right","up","left","down"},
    animated_direction = {"right","up","left","down"},
    animated =           {"neutral"},
    character =          {"right","up","left","down","sleep_r","sleep_u","sleep_l","sleep_d"},
    text =               {"text"},
    tiled =              {"neutral","r","u","ru","l","rl","ul","rul","d","rd","ud","rud","ld","rld","uld","ruld"},
    arrow =              {"right_a","up_a","left_a","down_a"},
    diag =               {"diag_ur,diag_ul,diag_dr,diag_dl"},
}
local slice_order = {
    "neutral", "r",   "rl",   "l",
    "d",       "rd",  "rld",  "ld",
    "ud",      "rud", "ruld", "uld",
    "u",       "ru",  "rul",  "ul"
}

local tags_to_check_for = 
{ 
    none={neutral=true},
    directional=dir_tags,
    animated_direction=dir_tags,
    animated={neutral=true},
    character={},
    text={text=true},
    tiled=tile_tags,
    arrow=arrow_tags,
    diag=diag_tags,
    tiled_slices={slices=true},
}
for tag,_ in pairs(dir_tags) do
    tags_to_check_for.character[tag] = true
end
for tag,_ in pairs(sleep_tags) do
    tags_to_check_for.character[tag] = true
end
local sprite = app.activeSprite

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function contains(arr, elem)
    for _,a in pairs(arr) do
        if a == elem then 
            return true
        end
    end
    return false
end

local function check_tag_requirements(tag_type)
    local spr_tags = {}
    for i, tag in ipairs(sprite.tags) do
        local tag_name = string.lower(tag.name)

        if spr_tags[tag_name] == nil then
            spr_tags[tag_name] = 0
        end
        spr_tags[tag_name] = spr_tags[tag_name] + 1
    end
    
    for tag, _ in pairs(tags_to_check_for[tag_type]) do
        if spr_tags[tag] == nil then
            error(string.format("\"%s\" tiling type requires a tag named \"%s\" to be defined in the sprite.", tag_type, tag))
        elseif spr_tags[tag] > 1 then
            error(string.format("Cannot export with multiple tags named \"%s\". Please remove or rename each duplicate tag.", tag))
        end
    end

    if tag_type == "tiled_slices" then
        for _, slice in ipairs(sprite.slices) do
            local slice_name = string.lower(slice.name)
            if tile_tags[slice_name] == nil then
                error(string.format("\"%s\" tiling type requires a slice named \"%s\" to be defined in the sprite", tag_type, slice_name))
            end
        end
    end
end

local function make_export_cmd(startFrame, endFrame, state_num, cmds, layer_option, text, spr_name, out_dir)
    local outfile_format
    local out_layers = {}

    if layer_option == "All Layers" then
        for _, layer in ipairs(sprite.layers) do
            table.insert(out_layers, layer.name)
        end
    elseif layer_option == "Visible Layers" then
        for _, layer in ipairs(sprite.layers) do
            if layer.isVisible then
                table.insert(out_layers, layer.name)
            end
        end
    else
        table.insert(out_layers, layer_option)
    end

    
    local layer_arg = ""
    for i,layer in ipairs(out_layers) do
        layer_arg = layer_arg .. "--layer \""..layer.."\" "
    end

    if text then
        outfile_format = string.format("\"%s\\text_%s_%i_{frame1}.png\"", out_dir, spr_name, state_num)
    else
        outfile_format = string.format("\"%s\\%s_%i_{frame1}.png\"", out_dir, spr_name, state_num)
    end
    local cmd = [["%s" -b "%s" %s --frame-range %i,%i --save-as %s]]
    -- local cmd = "D:\\Documents\\Aseprite\\Aseprite -b \"%s\" %s --frame-range %i,%i --save-as %s"
    -- local cmd = "\""..app.fs.appPath.."\" -b \"%s\" %s --frame-range %i,%i --save-as %s"
    cmd = string.format(cmd, app.fs.appPath, sprite.filename, layer_arg, startFrame-1, endFrame-1, outfile_format)
    table.insert(cmds, cmd)
end

local function make_animated_export_cmd(startFrame, endFrame, state_num, cmds, layer, spr_name, out_dir)
    if endFrame-startFrame+1 ~= 12 then
        error(string.format("Frame range %i, %i should be 12 frames long for an animated sprite", startFrame, endFrame))
    end
    for i=0,3 do
        local fromFrame = startFrame + i*3
        local toFrame = fromFrame + 2
        local spr_state = state_num+i
        make_export_cmd(fromFrame, toFrame, spr_state, cmds, layer, false, spr_name, out_dir)
    end
end

local function make_static_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, spr_name, out_dir)
    if endFrame-startFrame+1 ~= 3 then
        error(string.format("Frame range %i, %i should be 3 frames long for a static sprite", startFrame, endFrame))
    end
    make_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, spr_name, out_dir)
end

local function export_spr(spr_type, layer, spr_name, dir_name)
    local cmds = {}
    local tag_count = 0
    local out_dir = dir_name.."\\"..spr_name.."_out"
    os.execute("mkdir \""..out_dir.."\"")

    for i, tag in ipairs(sprite.tags) do
        local startFrame = tag.fromFrame.frameNumber
        local endFrame = tag.toFrame.frameNumber
        local state_num = char_tile_map[tag.name]
        local animated = -1
        local text = false
        local tag_name = string.lower(tag.name)

        if dir_tags[tag_name] then
            if spr_type == "character" or spr_type == "animated_direction" then
                animated = 1
            elseif spr_type == "directional" then
                animated = 0
            end
        elseif sleep_tags[tag_name] and spr_type == "character" then
            -- Sleep sprites
            animated = 0
        elseif tag_name == "neutral" then
            if spr_type == "none" or spr_type == "tiled" then
                animated = 0
            elseif spr_type == "animated" then
                animated = 1
            end
        elseif tile_tags[tag_name] and spr_type == "tiled" then
            animated = 0
        elseif tag_name == "text" and spr_type == "text" then
            animated = 0
            text = true
        elseif arrow_tags[tag_name] then
            animated = 0
        elseif diag_tags[tag_name] then
            animated = 1
        end

        if animated == 0 then
            local filename = spr_name
            if spr_type == "arrow" and arrow_tags[tag_name] then
                filename = filename..string.sub(tag_name, 1, #tag_name-2)
            end
            make_static_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, filename, out_dir)
            tag_count = tag_count + 1
        elseif animated == 1 then 
            make_animated_export_cmd(startFrame, endFrame, state_num, cmds, layer, spr_name, out_dir)
            tag_count = tag_count + 1
        end
    end

    local cmd = [[type NUL && ]] .. table.concat(cmds, " & ")
    os.execute(cmd)
    

    local confirm_dlg = Dialog()
                :label{ label=tag_count.." Tag(s) exported" }
                :label{ label="Output Directory: "..out_dir }
                :button{ id="ok", text="OK" }
                :button{ id="dir", text="Open Export Directory"}
                :show().data

    if confirm_dlg.dir then 
        os.execute("explorer \""..out_dir.."\"")
    end
end

function export_spr_slices(spr_name, layer, dir_name)
    local cmds = {}
    local out_dir = dir_name.."\\"..spr_name.."_out"
    os.execute("mkdir \""..out_dir.."\"")

    for i, tag in ipairs(sprite.tags) do
        if string.lower(tag.name) == "slices" then
            for l, slice in ipairs(sprite.slices) do
                if tile_tags[slice.name] then
                    make_slice_export_cmd(cmds, spr_name, layer, tag.fromFrame.frameNumber, tag.toFrame.frameNumber, slice.name, char_tile_map[slice.name], out_dir) 
                end
            end
        end
    end

    local cmd = [[type NUL && ]] .. table.concat(cmds, " & ")
    os.execute(cmd)
    

    local confirm_dlg = Dialog()
                :label{ label="Output Directory: "..out_dir }
                :button{ id="ok", text="OK" }
                :button{ id="dir", text="Open Export Directory"}
                :show().data

    if confirm_dlg.dir then 
        os.execute("explorer \""..out_dir.."\"")
    end
end

function make_slice_export_cmd(cmds, spr_name, layer_option, startFrame, endFrame, sliceName, state_num, out_dir)
    local out_layers = {}
    if layer_option == "All Layers" then
        for _, layer in ipairs(sprite.layers) do
            table.insert(out_layers, layer.name)
        end
    elseif layer_option == "Visible Layers" then
        for _, layer in ipairs(sprite.layers) do
            if layer.isVisible then
                table.insert(out_layers, layer.name)
            end
        end
    else
        table.insert(out_layers, layer_option)
    end

    
    local layer_arg = ""
    for i,layer in ipairs(out_layers) do
        layer_arg = layer_arg .. "--layer \""..layer.."\" "
    end

    local outfile_format = string.format("\"%s\\%s_%i_{frame1}.png\"", out_dir, spr_name, state_num)
    local cmd = [["%s" -b "%s" %s --frame-range %i,%i --slice %s --save-as %s]]
    cmd = string.format(cmd, app.fs.appPath, sprite.filename, layer_arg, startFrame-1, endFrame-1, sliceName, outfile_format)

    table.insert(cmds, cmd)
end

function generate_template(tiling, name)
    if tiling == "tiled_slices" then
        generate_tiled_slice_template(name)
    else
        generate_tag_template(tiling, name)
    end
end

function generate_tag_template(tiling, name)
    local sprite = Sprite(24,24)
    sprite.filename = name

    local one_set_per_tag_tilings = {none=true, text=true, directional=true, tiled=true, diag=true, arrow=true}
    local four_set_per_tag_tilings = {animated=true, animated_direction=true, character=true}

    local frames_per_set = 1
    if four_set_per_tag_tilings[tiling] then
        frames_per_set = 4
    end
    local tags_to_generate = tags_to_check_for[tiling]

    for tag,_ in pairs(tags_to_check_for[tiling]) do
        if sleep_tags[tag] then
            for i=1,3 do
                frame = sprite:newEmptyFrame(i)
            end
        else
            for i=1,frames_per_set*3 do
                frame = sprite:newEmptyFrame(i)
            end
        end
    end
    curr_frame_num = 1
    for _,tag in pairs(tag_order[tiling]) do
        new_tag = sprite:newTag(curr_frame_num, curr_frame_num + frames_per_set*3-1)
        new_tag.name = tag
        curr_frame_num = curr_frame_num + frames_per_set*3
    end
end

function generate_tiled_slice_template(name)
    local sprite = Sprite(96,96)
    sprite.filename = name

    local image = Image(24 * 4, 24 * 4)

    for i, slice_name in ipairs(slice_order) do
        local x = (i-1) % 4 * 24
        local y = math.floor((i-1) / 4) * 24
        local slice = sprite:newSlice(Rectangle(x,y,24,24))
        slice.name = slice_name
        slice.color = Color{r=0, g=0, b=255}

        local guideline_color = Color{r=0, g=0, b=0}

        for w=-2,1 do
            for h=-2,1 do
                image:drawPixel(x + 12 + w, y + 12 + h, guideline_color)
            end
        end

        if slice_name ~= "neutral" then
            for d in slice_name:gmatch"." do
                local xmin = -2
                local xmax = 1
                local ymin = -2
                local ymax = 1
                if d == "r" then
                    xmax = 23
                elseif d == "u" then
                    ymin = 0
                elseif d == "l" then
                    xmin = 0
                elseif d == "d" then
                    ymax = 23
                end
                for w=xmin,xmax do
                    for h=ymin,ymax do
                        image:drawPixel(x + 12 + w, y + 12 + h, guideline_color)
                    end
                end
            end
        end
    end

    local guideline_layer = sprite:newLayer()
    guideline_layer.name = "guideline (delete/hide when exporting)"
    guideline_layer.isContinuous = true
    guideline_layer.opacity = 100
    guideline_layer.stackIndex = 1

    for i=1,3 do
        frame = sprite:newEmptyFrame(i)
        sprite:newCel(guideline_layer, i, image, Point{0, 0})
    end
    new_tag = sprite:newTag(1, 3)
    new_tag.name = "slices"


end


local dir_name = ""
local filename = ""

local all_layers = {}
if sprite then
    dir_name, filename = string.match(sprite.filename, "(.*)\\(.*)%.")

    for i,layer in ipairs(sprite.layers) do
        table.insert(all_layers, layer.name)
    end
end

local layer_options = {"All Layers", "Visible Layers"}
for i,v in ipairs(all_layers) do
    table.insert(layer_options, v)
end

local dlg = Dialog("Baba Sprite Export/Generate Template")
local enable_export = sprite ~= nil 

dlg:radio{ id="export", text="Export", label="Mode", selected=true,
    onclick=function()
        dlg:modify{id="tiling", visible=true, enabled=enable_export}
            :modify{id="name", visible=true, enabled=enable_export}
            :modify{id="layer", visible=true, enabled=enable_export}
            :modify{id="notify", visible=true, enabled=enable_export}
            :modify{id="confirm", text="Export", enabled=enable_export}
    end
}
dlg:radio{ id="template", text="Template",
    onclick=function()
        dlg:modify{id="tiling", visible=true, enabled=true}
            :modify{id="name", visible=true, enabled=true}
            :modify{id="layer", visible=false, enabled=true}
            :modify{id="notify", visible=false, enabled=true}
            :modify{id="confirm", text="Generate", enabled=true}
    end
}
dlg:separator{}

dlg:combobox { id="tiling", label="Animation Style:", option="none", options=tiling_options}
    :entry    { id="name", text=filename, label="Sprite Name:"}
    :combobox { id="layer", options=layer_options, option="Visible Layers", label="Layer:"}
    :label    { id="notify", text="Note: running this script will save the current file."}
    :button   { id="confirm", text="Export"}
    :button   { id="cancel", text="Cancel"}

dlg:modify{id="tiling", visible=true, enabled=enable_export}
    :modify{id="name", visible=true, enabled=enable_export}
    :modify{id="layer", visible=true, enabled=enable_export}
    :modify{id="notify", visible=true, enabled=enable_export}
    :modify{id="confirm", text="Export", enabled=enable_export}


local input = dlg:show().data

if input.confirm then
    if input.export then
        -- Before we execute this script, ensure the file gets saved to get the most recent results. 
        app.command.SaveFile()
    
        check_tag_requirements(input.tiling)

        if input.tiling ~= "tiled_slices" then
            export_spr(input.tiling, input.layer, input.name, dir_name)
        else
            export_spr_slices(input.name, input.layer, dir_name)
        end
    elseif input.template then
        generate_template(input.tiling, input.name)
    end
end
