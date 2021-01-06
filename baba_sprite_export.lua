local char_tile_map = 
{
    text=0, 
    neutral=0,
    right=0,
    up=8,
    left=16,
    down=24,
    sleep_l=15,
    sleep_r=31,
    sleep_u=7,
    sleep_d=23,
    R=1,
    U=2,
    RU=3,
    L=4,
    RL=5,
    UL=6,
    RUL=7,
    D=8,
    RD=9,
    UD=10,
    RUD=11,
    LD=12,
    RLD=13,
    ULD=14,
    RULD=15
}
local dir_tags = 
{ 
    right=true, 
    up=true, 
    left=true, 
    down=true
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
local tiling_options = {
    "none", 
    "text",
    "directional", 
    "animated",
    "animated_direction", 
    "character", 
    "tiled"
}

local sprite = app.activeSprite
if sprite == nil then
    error("Need to have a file opened and selected in the editor.")
end


local dir_name, filename = string.match(sprite.filename, "(.*)\\(.*)%.")

local all_layers = {}
for i,layer in ipairs(sprite.layers) do
    table.insert(all_layers, layer.name)
end

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

local function make_export_cmd(startFrame, endFrame, state_num, cmds, layer_option, text, spr_name)
    local outfile_format
    local out_layers = {}
    local out_dir = dir_name.."\\"..spr_name.."_out"

    if layer_option == "All Layers" then
        out_layers = all_layers
    elseif layer_option == "Visible Layers" then
        for i, layer in ipairs(all_layers) do
            if layer.isVisible then
                table.insert(out_layers, layer)
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

local function make_animated_export_cmd(startFrame, endFrame, state_num, cmds, layer, spr_name)
    if endFrame-startFrame+1 ~= 12 then
        error(string.format("Frame range %i, %i should be 12 frames long for an animated sprite", startFrame, endFrame))
    end
    for i=0,3 do
        local fromFrame = startFrame + i*3
        local toFrame = fromFrame + 2
        local spr_state = state_num+i
        make_export_cmd(fromFrame, toFrame, spr_state, cmds, layer, false, spr_name)
    end
end

local function make_static_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, spr_name)
    if endFrame-startFrame+1 ~= 3 then
        error(string.format("Frame range %i, %i should be 3 frames long for a static sprite", startFrame, endFrame))
    end
    make_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, spr_name)
end

local function export_spr(spr_type, layer, spr_name)
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
        end

        if animated == 0 then
            make_static_export_cmd(startFrame, endFrame, state_num, cmds, layer, text, spr_name)
            tag_count = tag_count + 1
        elseif animated == 1 then 
            make_animated_export_cmd(startFrame, endFrame, state_num, cmds, layer, spr_name)
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

local function check_tag_requirements(tag_type)
    local spr_tags = {}
    for i, tag in ipairs(sprite.tags) do
        local tag_name = string.lower(tag.name)

        if spr_tags[tag_name] == nil then
            spr_tags[tag_name] = 0
        end
        spr_tags[tag_name] = spr_tags[tag_name] + 1
    end
    local char_tags = {}
    if tag_type == "character" then
        for tag,_ in pairs(dir_tags) do
            char_tags[tag] = true
        end
        for tag,_ in pairs(sleep_tags) do
            char_tags[tag] = true
        end
    end

    local tags_to_check_for = 
    { 
        none={neutral=true},
        directional=dir_tags,
        animated_direction=dir_tags,
        animated={neutral=true},
        character=char_tags,
        text={text=true},
        tiled=tile_tags,
    }
    
    for tag, _ in pairs(tags_to_check_for[tag_type]) do
        if spr_tags[tag] == nil then
            error(string.format("\"%s\" tiling type requires a tag named \"%s\" to be defined in the sprite.", tag_type, tag))
        elseif spr_tags[tag] > 1 then
            error(string.format("Cannot export with multiple tags named \"%s\". Please remove or rename each duplicate tag.", tag))
        end
    end
end

local layer_options = {"All Layers", "Visible Layers"}
for i,v in ipairs(all_layers) do
    table.insert(layer_options, v)
end

local input = Dialog("Baba Sprite Export")
    :combobox{ id="tiling", label="Animation Style:", option="none", options=tiling_options}
    :entry{ id="name", text=filename, label="Sprite Name:"}
    :combobox{ id="layer", options=layer_options, option="Visible Layers", label="Layer:"}
    :label{text="Note: running this script will save the current file."}
    :button{ id="export", text="Export"}
    :button{ id="cancel", text="Cancel"}
    :show().data

if input.export then
    -- Before we execute this script, ensure the file gets saved to get the most recent results. 
    app.command.SaveFile()

    check_tag_requirements(input.tiling)
    export_spr(input.tiling, input.layer, input.name)
end