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
    "tiled",
    "tiled_slices",
}
local anim_priority = {
    "tiled",
    "character",
    "directional",
    "animated_direction",
    "text",
    "none",
    "animated",
}
local all_tags = {
    none = {
        {name = "neutral", animated = false, frame_num = 3, direction = char_tile_map.neutral},
    },
    directional = {
        {name = "right", animated = false, frame_num = 3, direction = char_tile_map.right},
        {name = "up",    animated = false, frame_num = 3, direction = char_tile_map.up},
        {name = "left",  animated = false, frame_num = 3, direction = char_tile_map.left},
        {name = "down",  animated = false, frame_num = 3, direction = char_tile_map.down},
    },
    animated = {
        {name = "neutral", animated = false, frame_num = 12, direction = char_tile_map.neutral},
    },
    animated_direction = {
        {name = "right", animated = true, frame_num = 12, direction = char_tile_map.right},
        {name = "up",    animated = true, frame_num = 12, direction = char_tile_map.up},
        {name = "left",  animated = true, frame_num = 12, direction = char_tile_map.left},
        {name = "down",  animated = true, frame_num = 12, direction = char_tile_map.down},
    },
    character = {
        {name = "right", animated = true, frame_num = 12, direction = char_tile_map.right},
        {name = "up",    animated = true, frame_num = 12, direction = char_tile_map.up},
        {name = "left",  animated = true, frame_num = 12, direction = char_tile_map.left},
        {name = "down",  animated = true, frame_num = 12, direction = char_tile_map.down},
        {name = "sleep_r", animated = false, frame_num = 3, direction = char_tile_map.sleep_r},
        {name = "sleep_u", animated = false, frame_num = 3, direction = char_tile_map.sleep_u},
        {name = "sleep_l", animated = false, frame_num = 3, direction = char_tile_map.sleep_l},
        {name = "sleep_d", animated = false, frame_num = 3, direction = char_tile_map.sleep_d},
    },
    text = {
        {name = "text", animated = false, frame_num = 3, direction = char_tile_map.neutral},
    },
    tiled = {
        {name = "neutral",animated = false, frame_num = 3, direction = char_tile_map.neutral},
        {name = "r",    animated = false, frame_num = 3, direction = char_tile_map.r},
        {name = "u",    animated = false, frame_num = 3, direction = char_tile_map.u},
        {name = "ru",   animated = false, frame_num = 3, direction = char_tile_map.ru},
        {name = "l",    animated = false, frame_num = 3, direction = char_tile_map.l},
        {name = "rl",   animated = false, frame_num = 3, direction = char_tile_map.rl},
        {name = "ul",   animated = false, frame_num = 3, direction = char_tile_map.ul},
        {name = "rul",  animated = false, frame_num = 3, direction = char_tile_map.rul},
        {name = "d",    animated = false, frame_num = 3, direction = char_tile_map.d},
        {name = "rd",   animated = false, frame_num = 3, direction = char_tile_map.rd},
        {name = "ud",   animated = false, frame_num = 3, direction = char_tile_map.ud},
        {name = "rud",  animated = false, frame_num = 3, direction = char_tile_map.rud},
        {name = "ld",   animated = false, frame_num = 3, direction = char_tile_map.ld},
        {name = "rld",  animated = false, frame_num = 3, direction = char_tile_map.rld},
        {name = "uld",  animated = false, frame_num = 3, direction = char_tile_map.uld},
        {name = "ruld", animated = false, frame_num = 3, direction = char_tile_map.ruld},
    },
    tiled_slices = {
        {name = "slices", animated = false, frame_num = 3, direction = 0},
    }
}
local slice_order = {
    "neutral", "r",   "rl",   "l",
    "d",       "rd",  "rld",  "ld",
    "ud",      "rud", "ruld", "uld",
    "u",       "ru",  "rul",  "ul"
}
local baba_png_pattern = "^(.*[^a-zA-Z0-9_])(([a-zA-Z0-9_]+)_(%d+)_(%d+)%.png)$"
local sprite = app.activeSprite

local function check_tag_requirements(tag_type)
    local spr_tags = {}
    for i, tag in ipairs(sprite.tags) do
        local tag_name = tag.name

        if spr_tags[tag_name] == nil then
            spr_tags[tag_name] = 0
        end
        spr_tags[tag_name] = spr_tags[tag_name] + 1
    end
    
    for _, check_tag in ipairs(all_tags[tag_type]) do
        if spr_tags[check_tag.name] == nil then
            error(string.format("\"%s\" tiling type requires a tag named \"%s\" to be defined in the sprite.", tag_type, check_tag.name))
        elseif spr_tags[check_tag.name] > 1 then
            error(string.format("Cannot export with multiple tags named \"%s\". Please remove or rename each duplicate tag.", check_tag.name))
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
        local tag_name = string.lower(tag.name)
        
        local animated = -1
        for _, check_tag in ipairs(all_tags[spr_type]) do
            if check_tag.name == tag_name then
                if check_tag.animated then
                    animated = 1
                else
                    animated = 0
                end
            end
        end

        local text = false
        if tag_name == "text" and spr_type == "text" then
            text = true
        end

        if animated == 0 then
            local filename = spr_name
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

    for _, tag in ipairs(all_tags[tiling]) do
        for i=1,tag.frame_num do
            frame = sprite:newEmptyFrame(i)
        end
    end
    curr_frame_num = 1
    for _, check_tag in pairs(all_tags[tiling]) do
        local num_frames = check_tag.frame_num
        new_tag = sprite:newTag(curr_frame_num, curr_frame_num + num_frames-1)
        new_tag.name = check_tag.name

        curr_frame_num = curr_frame_num + num_frames
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

function predict_anim_type()
    if sprite then
        local tag_check = {}
        for _, option in ipairs(tiling_options) do
            tag_check[option] = 0
        end

        for i,tag in ipairs(sprite.tags) do
            for _, option in ipairs(tiling_options) do
                if option ~= "tiled_slices" then
                    for _, required_tag in ipairs(all_tags[option]) do
                        if tag.name == required_tag.name then
                            tag_check[option] = tag_check[option] + 1
                            break
                        end
                    end
                end
            end
        end

        -- Special case for tiled_slices animation style
        local valid_slice_count = 0
        for i, slice in ipairs(sprite.slices) do
            for _, slice_name_check in ipairs(slice_order) do
                if slice.name == slice_name_check then
                    valid_slice_count = valid_slice_count + 1
                    break
                end
            end
        end
        if valid_slice_count == #slice_order then
            return "tiled_slices"
        end

        for _, a in ipairs(anim_priority) do
            if tag_check[a] and tag_check[a] == #all_tags[a] then
                return a
            end
        end
    end
    return "none"
end

function import_baba_sprite(path, tiling)
    local dir_path, filename, obj_name, dir, frame_num = string.match(path, baba_png_pattern)
    if filename then
        local baseimage = Image{ fromFile=path }
        local sprite = Sprite(baseimage.width,baseimage.height)
        if tiling == "tiled_slices" then
            sprite.width = sprite.width * 4
            sprite.height = sprite.height * 4
        end

        local missing_files = {}
        sprite.filename = obj_name
        app.transaction(
            function()
                local layer = sprite.layers[1]
                local total_frames = 1
                sprite:deleteFrame(1)

                if tiling ~= "tiled_slices" then
                    for _, ref_tag in ipairs(all_tags[tiling]) do
                        local curr_dir_offset = 0
                        local start_tag = total_frames
                        for curr_frame=3,ref_tag.frame_num,3 do
                            local curr_dir = ref_tag.direction + curr_dir_offset
                            for i=1,3 do
                                local curr_path = dir_path..obj_name.."_"..tostring(curr_dir).."_"..tostring(i)..".png"
                                local frame = sprite:newFrame(total_frames)
                                total_frames = total_frames + 1

                                if not app.fs.isFile(curr_path) then
                                    table.insert(missing_files, curr_path)
                                else
                                    local image = Image{ fromFile = curr_path }
                                    sprite:newCel(layer, frame, image, Point(0,0))
                                end
                            end
                            curr_dir_offset = curr_dir_offset + 1
                        end 
                        local end_tag = total_frames-1
                        local new_tag = sprite:newTag(start_tag, end_tag)
                        new_tag.name = ref_tag.name
                    end
                else
                    for i=1,3 do
                        frame = sprite:newEmptyFrame(i)
                        sprite:newCel(layer, frame)
                    end
                    new_tag = sprite:newTag(1, 3)
                    new_tag.name = "slices"

                    for i, slice_name in ipairs(slice_order) do
                        local x = (i-1) % 4 * baseimage.width
                        local y = math.floor((i-1) / 4) * baseimage.width
                        local slice = sprite:newSlice(Rectangle(x,y,baseimage.width,baseimage.height))
                        slice.name = slice_name
                        slice.color = Color{r=0, g=0, b=255}
                        local slice_layer = sprite:newLayer()

                        local curr_dir = char_tile_map[slice_name]

                        for j=1,3 do
                            local curr_path = dir_path..obj_name.."_"..tostring(curr_dir).."_"..tostring(j)..".png"
                            local frame = sprite.frames[j]

                            if not app.fs.isFile(curr_path) then
                                table.insert(missing_files, curr_path)
                            else
                                local image = Image{ fromFile = curr_path }
                                sprite:newCel(slice_layer, frame, image, Point(x,y))
                            end
                        end
                    end

                    sprite:flatten()
                end
            end
        )

        if #missing_files > 0 then
            table.insert(missing_files, 1, "Sprite partially imported with missing files. Some of the frames will be empty. Make sure you have chosen the right animation style. (You chose \""..tiling.."\")")
            table.insert(missing_files, 2, "Missing files:")
            app.alert{text=missing_files}
        end
    end
end

local dir_name = ""
local filename = ""

local all_layers = {}
local predicted_anim_style = predict_anim_type()
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

local dlg = Dialog("Baba Sprite Import/Export/Generate Template")
local orig_bounds = nil

local enable_export = sprite ~= nil 

dlg:radio{ id="export", text="Export", label="Mode", selected=true,
    onclick=function()
        local bounds = dlg.bounds
        dlg.bounds = Rectangle(bounds.x, bounds.y, orig_bounds.width, orig_bounds.height)

        dlg:modify{id="tiling", visible=true, enabled=enable_export}
            :modify{id="name", visible=true, enabled=enable_export}
            :modify{id="layer", visible=true, enabled=enable_export}
            :modify{id="notify", visible=true, enabled=enable_export}
            :modify{id="file", visible=false, enabled=enable_export}
            :modify{id="filedesc", visible=false, enabled=enable_export}
            :modify{id="confirm", text="Export", enabled=enable_export}
            :modify{id="brief", text="Export the current Baba sprite."}
    end
}
dlg:radio{ id="import", text="Import",
    onclick=function()
        local bounds = dlg.bounds
        dlg.bounds = Rectangle(bounds.x, bounds.y, orig_bounds.width + 120, orig_bounds.height)

        dlg:modify{id="tiling", visible=true, enabled=true}
            :modify{id="name", visible=false, enabled=true}
            :modify{id="layer", visible=false, enabled=true}
            :modify{id="notify", visible=false, enabled=true}
            :modify{id="file", visible=true, enabled=true}
            :modify{id="filedesc", visible=true, enabled=true}
            :modify{id="confirm", text="Import", enabled=false}
            :modify{id="brief", text="Import a Baba sprite from a sequence of images."}
    end
}

dlg:radio{ id="template", text="Template",
    onclick=function()
        local bounds = dlg.bounds
        dlg.bounds = Rectangle(bounds.x, bounds.y, orig_bounds.width, orig_bounds.height)

        dlg:modify{id="tiling", visible=true, enabled=true}
            :modify{id="name", visible=true, enabled=true}
            :modify{id="layer", visible=false, enabled=true}
            :modify{id="notify", visible=false, enabled=true}
            :modify{id="file", visible=false, enabled=true}
            :modify{id="filedesc", visible=false, enabled=true}
            :modify{id="confirm", text="Generate", enabled=true}
            :modify{id="brief", text="Create a template baba sprite with export tags."}
    end
}

dlg:label{ id="brief", text="Export the current Baba sprite."}
dlg:separator{}

dlg :label { id="filedesc", text="Select any png in the baba sprite (filename has to be \"<name>_X_Y.png\")"}
dlg :file  { id="file", filetypes = {"png"},
        onchange=function()
            local filename = string.match(dlg.data.file, baba_png_pattern)
            local is_valid = filename ~= nil
            dlg:modify{id="confirm", enabled=is_valid}        
        end
    }

dlg :combobox { id="tiling", label="Animation Style:", option=predicted_anim_style, options=tiling_options}
    :entry    { id="name", text=filename, label="Sprite Name:"}
    :combobox { id="layer", options=layer_options, option="Visible Layers", label="Layer:"}
    :label    { id="notify", text="Note: running this script will save the current file."}
    :button   { id="confirm", text="Export", focus=true}
    :button   { id="cancel", text="Cancel", focus=false}

dlg:modify{id="tiling", visible=true, enabled=enable_export}
    :modify{id="name", visible=true, enabled=enable_export}
    :modify{id="layer", visible=true, enabled=enable_export}
    :modify{id="notify", visible=true, enabled=enable_export}
    :modify{id="file", visible=false, enabled=enable_export}
    :modify{id="filedesc", visible=false, enabled=enable_export}
    :modify{id="confirm", text="Export", enabled=enable_export}

orig_bounds = dlg.bounds

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
    elseif input.import then
        import_baba_sprite(input.file, input.tiling)
    end
end
