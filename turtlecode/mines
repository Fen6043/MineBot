--version 0.8.0
--          z
--          -    y
--          -   -
--          - -
--          - - - - - x
-- mines 98 L I 30 4
function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true -- Value found
        end
    end
    return false -- Value not found
end

function turtlerefuel()
    if(turtle.getFuelLevel() < 10) then
        for i = 1, 16, 1 do
            local item = turtle.getItemDetail(i)
            if (item ~= nil and (item.name == "minecraft:coal" or item.name == "minecraft:lava_bucket")) then
                turtle.select(i)
                local refueled,err = turtle.refuel(1)
                if refueled then
                    fuellevel = turtle.getFuelLevel()
                    print("turtle refueled to level - ", fuellevel)
                    break
                else
                    error(err)
                end
            end
        end
    end
end

function checkfuelstat()
    local fueltype = {
        ["minecraft:coal"] = 80,
        ["minecraft:lava_bucket"] = 1000
    }
    local fuellevel = 0
    local totalsteps = ((((xy*xy)+(xy-2))/2)*z) + (2*tolevelsteps) + bufferFuel + (2*xy + z)-- mine spiral(+buffer as z + buffer) + height/depth
    for i = 1, 16, 1 do
        local item = turtle.getItemDetail(i)
        if (item ~= nil and (item.name == "minecraft:coal" or item.name == "minecraft:lava_bucket")) then
            fuellevel = fuellevel + (item.count*fueltype[item.name])
        end
    end
    
    local totalfuelsteps = fuellevel + turtle.getFuelLevel()
    if totalfuelsteps < totalsteps then
        local msg = "not enough fuel, need " .. math.ceil((totalsteps-totalfuelsteps)/80) .. " more coal or " .. math.ceil((totalsteps-totalfuelsteps)/1000) .." lava bucket"
        print(msg)
        if modem ~= nil then
            modem.transmit(replyChannel,myNumber,msg)
        end
        return false
    else
        return true
    end
end

function dropitems()
    for i = 2, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil and contains(todropitems,item.name) then
            turtle.dropDown()
        end
    end
end

function sortinventory()
    for i = 1, 15, 1 do
        for j = i + 1, 16, 1 do
            local itemi = turtle.getItemDetail(i)
            local itemj = turtle.getItemDetail(j)
            if itemi ~= nil then
                break
            end
            if itemi ~= nil and itemj ~= nil and (itemi.name == itemj.name) then
                turtle.select(j)
                job = turtle.transferTo(i)
                if job then
                    print("sorted inv")
                else
                    print("not sorted",itemj.name)
                end
            end
        end
    end
end

function breakormoveforward()
    local result, err
    local has_block, data = turtle.inspect()
    while has_block do
        if string.match(data.name,"computercraft:turtle") then
            print("turtle detected")
            os.sleep(1)
            has_block, data = turtle.inspect()
        else
            break
        end
    end
    if(turtle.detect()) then
        result, err = turtle.dig("right")
        while turtle.detect() do -- if there are gravel present
            local has_block, data = turtle.inspect()
            if has_block and data.name == "pneumaticcraft:oil" then
                break
            end
            result, err = turtle.dig("right")
        end
        turtle.forward()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    else
        turtle.forward()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    end

    if (not result and err~=nil) then
        error(err)
    end
end

function breakormoveup()
    local result, err
    local has_block, data = turtle.inspectUp()
    while has_block do
        if string.match(data.name,"computercraft:turtle") then
            print("turtle detected")
            os.sleep(1)
            has_block, data = turtle.inspectUp()
        else
            break
        end
    end
    if(turtle.detectUp()) then
        result, err = turtle.digUp("right")
        while  turtle.detectUp() do -- if there are gravel present
            local has_block, data = turtle.inspect()
            if has_block and data.name == "pneumaticcraft:oil" then
                break
            end
            result, err = turtle.digUp("right")
        end
        turtle.up()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    else
        turtle.up()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    end

    if (not result and err~=nil) then
        error(err)
    end
end

function breakormovedown()
    local result, err
    local has_block, data = turtle.inspectDown()
    while has_block do
        if string.match(data.name,"computercraft:turtle") then
            print("turtle detected")
            os.sleep(1)
            has_block, data = turtle.inspectDown()
        else
            break
        end
    end
    if(turtle.detectDown()) then
        result, err = turtle.digDown("right")
        -- while turtle.detectDown() do -- if there are gravel present
        --     local has_block, data = turtle.inspect()
        --     if has_block and data.name == "pneumaticcraft:oil" then
        --         break
        --     end
        --     result, err = turtle.digDown("right")
        -- end
        turtle.down()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    else
        turtle.down()
        fuellevel = fuellevel - 1
        if fuellevel < 10 then
            turtlerefuel()
        end
    end

    if (not result and err~=nil) then
        error(err)
    end
end

function turnturtle(turn)
    if turn == "R" then
        turtle.turnRight()
        facedirection = facedirection - 1
        if facedirection == -1 then
            facedirection = 3
        end
    elseif turn == "L" then
        turtle.turnLeft()
        facedirection = (facedirection + 1) % 4
    elseif turn == "B" then
        turtle.turnLeft()
        turtle.turnLeft()
        facedirection = (facedirection + 2) % 4
    end
end

function turnturtletodirection(currentDirection,faceDirectionP)
    while true do
        if currentDirection == faceDirectionP then
            break
        end
        turtle.turnLeft()
        currentDirection = (currentDirection + 1) % 4
    end
    facedirection = faceDirectionP
end

function detectMoreOre(upOrdown)
    if bufferFuel <= 0 then -- Exit if there are no buffer fuel
        return
    end

    local countIndex = 0
    local blockNames = {"minecraft:diamond_ore","minecraft:iron_ore","minecraft:redstone_ore","minecraft:coal_ore","minecraft:gold_ore","minecraft:deepslate_redstone_ore","minecraft:deepslate_diamond_ore","minecraft:deepslate_iron_ore","minecraft:deepslate_coal_ore","minecraft:deepslate_gold_ore","stellaris:steel_ore","mekanism:osmium_ore","minecraft:ancient_debris"}
    if upOrdown == "up" then
        local has_block, block = turtle.inspectUp()
        while has_block and contains(blockNames,block.name) do
            breakormoveup()
            bufferFuel = bufferFuel - 2
            countIndex = countIndex + 1
            if bufferFuel <= 0 then -- Exit if there are no buffer fuel
                break
            end
            has_block, block = turtle.inspectUp()
        end
        while countIndex > 0 do
            breakormovedown()
            countIndex = countIndex - 1
        end
    else
        local has_block, block = turtle.inspectDown()
        while has_block and contains(blockNames,block.name) do
            breakormovedown()
            bufferFuel = bufferFuel - 2
            countIndex = countIndex + 1
            if bufferFuel <= 0 then -- Exit if there are no buffer fuel
                break
            end
            has_block, block = turtle.inspectDown()
        end
        while countIndex > 0 do
            breakormoveup()
            countIndex = countIndex - 1
        end
    end
end

function moveturtlexsteps(steps,direction,mode)
    if mode == "N" then
        if direction == "up" then
            for i = 1, steps, 1 do
                breakormoveup()
            end
        elseif direction == "forward" then
            for i = 1, steps, 1 do
                breakormoveforward()
            end
        elseif direction == "down" then
            for i = 1, steps, 1 do
                breakormovedown()
            end
        end
    else if mode == "S" then
        if direction == "forward" then
            for i = 1, steps, 1 do
                breakormoveforward()
                if facedirection == 0 then
                    endpointx = endpointx - 1
                elseif facedirection == 1 then
                    endpointy = endpointy - 1
                elseif facedirection == 2 then
                    endpointx = endpointx + 1
                elseif facedirection == 3 then
                    endpointy = endpointy + 1
                end
                if toggleUp then
                    detectMoreOre("down")
                    for j = 1, z, 1 do
                        breakormoveup()
                    end
                    detectMoreOre("up")
                    toggleUp = false
                else
                    detectMoreOre("up")
                    for j = 1, z, 1 do
                        breakormovedown()
                    end
                    detectMoreOre("down")
                    toggleUp = true
                end
                --Drop Items
                local item = turtle.getItemDetail(16)
                if item ~= nil then
                    dropitems()
                    sortinventory()
                    turtle.select(1)
                end
            end
        end
    end

    end
end

----------------------------------------------MAIN FUNC------------------------------------------------------------------
modem = peripheral.find("modem")
currentlevel = tonumber(arg[1])
bot = arg[2]            --L/R
local ore = arg[3]
xy = tonumber(arg[4]) or 1
z = tonumber(arg[5]) or 1
replyChannel = tonumber(arg[6]) or 0
myNumber = os.getComputerID()
fuellevel = 0
totalstepsturtletook = 0
toggleUp = true
bufferFuel = 100

orelevels = {
    ["D"] = -58,
    ["R"] = -58,
    ["I"] = 15,
    ["N"] = 14
}

todropitems = {"minecraft:cobblestone","minecraft:tuff","minecraft:dripstone_block","xycraft_world:kivi","minecraft:cobbled_deepslate","minecraft:smooth_basalt","minecraft:granite","minecraft:andesite","minecraft:diorite","minecraft:pointed_dripstone","minecraft:dirt","minecraft:netherrack","minecraft:gravel","projectvibrant"}
requiredore = {
    ["I"] = "minecraft:raw_iron",
    ["D"] = "minecraft:diamond",
    ["R"] = "minecraft:redstone",
    ["N"] = "minecraft:ancient_debris"
}

if currentlevel == nil then
    error("enter the current level as argument [args1]",0)
end
if not contains({"L","R"},bot) then
    error("Please enter a valid direction [R/L][arg2]",0)
end

if ore == nil or not contains({"D","R","I","N"},ore) then
    error("Invalid ore type [D - Diamond,R - Redstone,I - Iron,N - Ancient Debri][args3]",0)
end

if xy<=1 or z<=1 then
    write("mine yourself why use robot. \n Goodbye")
    for i = 1, 3, 1 do
        write(".")
        os.sleep(1)
    end
    os.shutdown()
end

endpointx = 0
endpointy = 0
--          +y 3 
--  -X 0            2 +x
--          -y 1
facedirection = 0
if bot == "R" then
    facedirection = 2
end
-- go to ore level
tolevelsteps = currentlevel - orelevels[ore]

if tolevelsteps<0 then
    error("cannot go to the level",0)
end

-- check fuel level
while true do
    if checkfuelstat() then
        break
    else
        print("Add fuel then press Enter...")
        read()
    end
end
modem.transmit(replyChannel,myNumber," mining...")
moveturtlexsteps(tolevelsteps,"down","N")

-- mine spiral 
local leftindex = xy -1
local rightindex = xy -2

if bot == "L" then
    for i = 1, leftindex, 1 do
        moveturtlexsteps(i,"forward","S")
        turnturtle("L")
         -- cleaning inventory
        local item = turtle.getItemDetail(16)
        if item ~= nil then
            dropitems()
            sortinventory()
            turtle.select(1)
        end
    end
    moveturtlexsteps(leftindex,"forward","S")
else
    for i = 1, rightindex, 1 do
        moveturtlexsteps(i,"forward","S")
        turnturtle("L")
        -- cleaning inventory
        local item = turtle.getItemDetail(16)
        if item ~= nil then
            dropitems()
            sortinventory()
            turtle.select(1)
        end
    end
    moveturtlexsteps(rightindex,"forward","S")  
end

-- come back to start point of spiral mine
if not toggleUp then
    moveturtlexsteps(z,"down","N")
end
if endpointx < 0 then
    turnturtletodirection(facedirection,2)
    endpointx = endpointx * -1
    moveturtlexsteps(endpointx,"forward","N")
else
    turnturtletodirection(facedirection,0)
    moveturtlexsteps(endpointx,"forward","N")
end

if endpointy < 0 then
    turnturtletodirection(facedirection,3)
    endpointy = endpointy * -1
    moveturtlexsteps(endpointy,"forward","N")
else
    turnturtletodirection(facedirection,1)
    moveturtlexsteps(endpointy,"forward","N")
end
-- move up to starting point
moveturtlexsteps(tolevelsteps,"up","N")
if bot == "L" then
    turnturtletodirection(facedirection,0)
else
    turnturtletodirection(facedirection,2)
end
breakormoveforward()