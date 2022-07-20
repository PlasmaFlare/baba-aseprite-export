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
    ruld=15,

    rue=16,
    rule=17,
    rude=18,
    rulde=19,
    ulq=20,
    rulq=21,
    uldq=22,
    ruldq=23,
    ruleq=24,
    ruldeq=25,
    ldz=26,
    rldz=27,
    uldz=28,
    ruldz=29,
    ruldez=30,
    uldqz=31,
    ruldqz=32,
    ruldeqz=33,
    rdc=34,
    rudc=35,
    rldc=36,
    ruldc=37,
    rudec=38,
    ruldec=39,
    ruldqc=40,
    ruldeqc=41,
    rldzc=42,
    ruldzc=43,
    ruldezc=44,
    ruldqzc=45,
    ruldeqzc=46,
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
local diag_tile_tags = {
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
    ruld=true,


    ruldq=true,
    rldc=true,
    rldz=true,
    rulde=true,
    ruldeq=true,
    ruldqc=true,
    ruldzc=true,

    rudc=true,
    ruldezc=true,
    ruldqzc=true,
    uldz=true,
    rdc=true,
    rldzc=true,
    ldz=true,
    ruldec=true,

    rude=true,
    ruldeqc=true,
    ruldeqz=true,
    uldq=true,
    rudec=true,
    ruldeqzc=true,
    uldqz=true,
    ruldez=true,

    ruldz=true,
    rule=true,
    rulq=true,
    ruldc=true,
    rue=true,
    ruleq=true,
    ulq=true,
    ruldqz=true,
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
    "diag_tiled_slices",
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
        {name = "neutral", animated = true, frame_num = 12, direction = char_tile_map.neutral},
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
    },
    diag_tiled_slices = {
        {name = "slices", animated = false, frame_num = 3, direction = 0},
    },
}
local slice_order = {
    "neutral", "r",   "rl",   "l",  
    "d",       "rd",  "rld",  "ld", 
    "ud",      "rud", "ruld", "uld",
    "u",       "ru",  "rul",  "ul"  
}
local slice_order_diag = {
    "neutral", "r",   "rl",   "l",      "ruldq", "rldc",    "rldz",     "rulde",        "ruldeq", "ruldqc",   "ruldzc",   "",
    "d",       "rd",  "rld",  "ld",     "rudc",  "ruldezc", "ruldqzc", "uldz",          "rdc",    "rldzc",    "ldz",      "ruldec",
    "ud",      "rud", "ruld", "uld",    "rude",  "ruldeqc", "ruldeqz", "uldq",          "rudec",  "ruldeqzc", "uldqz",    "ruldez",
    "u",       "ru",  "rul",  "ul",     "ruldz", "rule",    "rulq",     "ruldc",        "rue",    "ruleq",    "ulq",      "ruldqz",
}
local baba_png_pattern = "^(.*[^a-zA-Z0-9_])(([a-zA-Z0-9_]+)_(%d+)_(%d+)%.png)$"
local sprite = app.activeSprite
local on_windows = app.fs.pathSeparator == "\\"

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
        local slice_names = {}
        for _, slice in ipairs(sprite.slices) do
            local slice_name = string.lower(slice.name)
            slice_names[slice_name] = true
        end

        for _, check_tag in ipairs(tile_tags) do
            if slice_names[check_tag] == nil then
                error(string.format("\"%s\" tiling type requires a slice named \"%s\" to be defined in the sprite", tag_type, slice_name))
            end
        end
    end

    if tag_type == "diag_tiled_slices" then
        local slice_names = {}
        for _, slice in ipairs(sprite.slices) do
            local slice_name = string.lower(slice.name)
            slice_names[slice_name] = true
        end

        for _, check_tag in ipairs(diag_tile_tags) do
            if slice_names[check_tag] == nil then
                error(string.format("\"%s\" tiling type requires a slice named \"%s\" to be defined in the sprite", tag_type, slice_name))
            end
        end
    end
end

local function open_dir_with_exported_sprites_in_explorer(out_dir)
    -- Really hacky way of opening the file explorer that is OS independent
    local out_files = app.fs.listFiles(out_dir)
    if #out_files > 0 then
        local sample_file = nil
        for _, f in ipairs(out_files) do
            if app.fs.fileExtension(f) == "png" then
                sample_file = f
                break
            end
        end

        if sample_file then
            local curr_sprite = app.activeSprite
            
            -- There's a possibility that opening the sample file will cause the "Open a sequence of files" dialog to appear.
            -- Disable it only for opening the sample file
            local old_sequence_pref = app.preferences.open_file.open_sequence
            app.preferences.open_file.open_sequence = 2 -- Set it to no

            app.open(app.fs.joinPath(out_dir, sample_file)) -- Open a sample png that was exported. Aseprite will then focus on this png.
            app.command.OpenInFolder() -- Opens the folder containing the sample png, effectively opening the folder with the exported sprites
            app.command.CloseFile() -- Close the sample png
            app.activeSprite = curr_sprite -- Focus back on the original aseprite file

            app.preferences.open_file.open_sequence = old_sequence_pref -- Restore the original setting
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
        outfile_format = app.fs.joinPath(out_dir, string.format("text_%s_%i_{frame1}.png", spr_name, state_num))
    else
        outfile_format = app.fs.joinPath(out_dir, string.format("%s_%i_{frame1}.png", spr_name, state_num))
    end
    local cmd = [["%s" -b "%s" %s --frame-range %i,%i --save-as "%s"]]
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
    local out_dir = app.fs.joinPath(dir_name, spr_name.."_out")
    app.fs.makeAllDirectories(out_dir)

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

    local cmd = ""
    if on_windows then
        cmd = [[type NUL && ]]
    end
    cmd = cmd..table.concat(cmds, " & ")
    os.execute(cmd)
    

    local confirm_dlg = Dialog()
                :label{ label=tag_count.." Tag(s) exported" }
                :label{ label="Output Directory: "..out_dir }
                :button{ id="ok", text="OK" }
                :button{ id="dir", text="Open Export Directory"}
                :show().data

    if confirm_dlg.dir then
        open_dir_with_exported_sprites_in_explorer(out_dir)
    end
end

function export_spr_slices(spr_name, layer, dir_name, gen_diagonals)
    local cmds = {}
    local out_dir = app.fs.joinPath(dir_name, spr_name.."_out")
    app.fs.makeAllDirectories(out_dir)

    local tags_to_check = tile_tags
    if gen_diagonals then
        tags_to_check = diag_tile_tags
    end

    local slice_count = 0
    for i, tag in ipairs(sprite.tags) do
        if string.lower(tag.name) == "slices" then
            for l, slice in ipairs(sprite.slices) do
                if tags_to_check[slice.name] then
                    make_slice_export_cmd(cmds, spr_name, layer, tag.fromFrame.frameNumber, tag.toFrame.frameNumber, slice.name, char_tile_map[slice.name], out_dir) 
                    slice_count = slice_count + 1
                end
            end
        end
    end

    local cmd_set = {}
    local base_cmd = ""
    if on_windows then
        base_cmd = [[type NUL && ]]
    end
    local curr_cmd = {}
    local curr_cmd_len = #base_cmd
    for i=1,#cmds do
        -- Apparently there is a max command line length that varies depending on OS. The smallest max I found was 4096 from linux. So I'll go with a max of 4000
        if curr_cmd_len + #cmds[i] > 4000 then
            table.insert(cmd_set, curr_cmd)
            curr_cmd = {}
            curr_cmd_len = #base_cmd
        end

        table.insert(curr_cmd, cmds[i])
        curr_cmd_len = curr_cmd_len + #cmds[i]
    end

    if #curr_cmd > 0 then
        table.insert(cmd_set, curr_cmd)
    end

    for _, c in ipairs(cmd_set) do
        local cmd = ""
        if on_windows then
            cmd = [[type NUL && ]]
        end 
        local cmd = cmd .. table.concat(c, " & ")
        os.execute(cmd)
    end
    

    local confirm_dlg = Dialog()
                :label{ label=slice_count.." Slices(s) exported" }
                :label{ label="Output Directory: "..out_dir }
                :button{ id="ok", text="OK" }
                :button{ id="dir", text="Open Export Directory"}
                :show().data

    if confirm_dlg.dir then 
        open_dir_with_exported_sprites_in_explorer(out_dir)
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

    local outfile_format = app.fs.joinPath(out_dir, string.format("%s_%i_{frame1}.png", spr_name, state_num))
    local cmd = [["%s" -b "%s" %s --frame-range %i,%i --slice %s --save-as "%s"]]
    cmd = string.format(cmd, app.fs.appPath, sprite.filename, layer_arg, startFrame-1, endFrame-1, sliceName, outfile_format)

    table.insert(cmds, cmd)
end

function generate_template(tiling, name)
    if tiling == "tiled_slices" then
        generate_tiled_slice_template(name, false)
    elseif tiling == "diag_tiled_slices" then
        generate_tiled_slice_template(name, true)
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

function generate_tiled_slice_template(name, gen_diagonals)
    local tile_width = 4
    local tile_height = 4
    if gen_diagonals then
        tile_width = 12
    end

    local width = tile_width * 24
    local height = tile_height * 24

    local sprite = Sprite(width,height)
    sprite.filename = name

    local image = Image(width, height)

    local order = slice_order
    if gen_diagonals then
        order = slice_order_diag
    end

    for i, slice_name in ipairs(order) do
        if #slice_name > 0 then
            local x = (i-1) % tile_width * 24
            local y = math.floor((i-1) / tile_width) * 24
            local slice = sprite:newSlice(Rectangle(x,y,24,24))
            slice.name = slice_name
            slice.color = Color{r=0, g=0, b=255}

            local guideline_color = Color{r=0, g=0, b=0}

            for w=-4,3 do
                for h=-4,3 do
                    image:drawPixel(x + 12 + w, y + 12 + h, guideline_color)
                end
            end

            if slice_name ~= "neutral" then
                for d in slice_name:gmatch"." do
                    local xmin = -4
                    local xmax = 3
                    local ymin = -4
                    local ymax = 3
                    if d == "r" then
                        xmax = 11
                    elseif d == "u" then
                        ymin = -12
                    elseif d == "l" then
                        xmin = -12
                    elseif d == "d" then
                        ymax = 11

                    -- Diagonals
                    elseif d == "e" then
                        xmax = 11
                        ymin = -12
                    elseif d == "q" then
                        xmin = -12
                        ymin = -12
                    elseif d == "z" then
                        xmin = -12
                        ymax = 11
                    elseif d == "c" then
                        ymax = 11
                        xmax = 11
                    end

                    for w=xmin,xmax do
                        for h=ymin,ymax do
                            image:drawPixel(x + 12 + w, y + 12 + h, guideline_color)
                        end
                    end
                end
            end
        end
    end

    local guideline_layer = sprite:newLayer()
    guideline_layer.name = "guideline (delete/hide when exporting)"
    guideline_layer.isContinuous = true
    guideline_layer.opacity = 255
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
        local sprite = Sprite(baseimage.width,baseimage.height, ColorMode.RGB)

        local tile_width = 1
        local tile_height = 1
        if tiling == "tiled_slices" then
            tile_width = 4
            tile_height = 4
        elseif tiling == "diag_tiled_slices" then
            tile_width = 12
            tile_height = 4
        end
        sprite.width = sprite.width * tile_width
        sprite.height = sprite.height * tile_height

        local missing_files = {}
        sprite.filename = obj_name
        app.transaction(
            function()
                local layer = sprite.layers[1]
                local total_frames = 1
                sprite:deleteFrame(1)

                if tiling ~= "tiled_slices" and tiling ~= "diag_tiled_slices" then
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
                                    -- We load the src file into its own sprite before copying to a new image. This is to handle different color encodings other than RGB.
                                    -- The policy is that I want to work with RGB files only.
                                    local srcsprite = Sprite{ fromFile = curr_path }
                                    local image = Image(srcsprite.width, srcsprite.height, ColorMode.RGB)
                                    image:drawSprite(srcsprite)
                                    srcsprite:close()

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

                    local order = slice_order
                    if tiling == "diag_tiled_slices" then
                        order = slice_order_diag
                    end

                    for i, slice_name in ipairs(order) do
                        if #slice_name > 0 then
                            local x = (i-1) % tile_width * baseimage.width
                            local y = math.floor((i-1) / tile_width) * baseimage.width
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
                                    -- We load the src file into its own sprite before copying to a new image. This is to handle different color encodings other than RGB.
                                    -- The policy is that I want to work with RGB files only.
                                    local srcsprite = Sprite{ fromFile = curr_path }
                                    local image = Image(srcsprite.width, srcsprite.height, ColorMode.RGB)
                                    image:drawSprite(srcsprite)
                                    srcsprite:close()
                                    
                                    sprite:newCel(slice_layer, frame, image, Point(x,y))
                                end
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
    dir_name, filename = string.match(sprite.filename, "(.*)"..app.fs.pathSeparator.."(.*)%.")

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
    :label    { id="notify", text="Note: Make sure you saved your file as an .ase/.aseprite file before exporting."}
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

        if input.tiling ~= "tiled_slices" and input.tiling ~= "diag_tiled_slices" then
            export_spr(input.tiling, input.layer, input.name, dir_name)
        else
            local gen_diagonals = input.tiling == "diag_tiled_slices"
            export_spr_slices(input.name, input.layer, dir_name, gen_diagonals)
        end
    elseif input.template then
        generate_template(input.tiling, input.name)
    elseif input.import then
        import_baba_sprite(input.file, input.tiling)
    end
end
