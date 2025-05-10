-- while true do
--     print("---------------Mine BOT----------------")
--     write("Enter current level: ")
--     local currentLevel = read()
--     write("Enter face direction (L/R): ")
--     local faceDirection = read()
--     write("Enter the ore (I/D/R/N): ")
--     local ore = read()
--     write("Enter the cube dimention: ")
--     local dimention = read()
--     write("Enter the height of cube: ")
--     local height = read()
--     print("Press enter to start....")
--     read()
--     print("Starting to mine :)")
--     local loop = shell.run("mines",currentLevel,faceDirection,ore,dimention,height)
--     if loop then
--         break
--     end
-- end
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

--          +x0
--      -z1      +z3
--          -x2
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

function moveturtlexsteps(steps,direction)
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
end

function calibrate() -- to always face to +x
    local x,y,z = gps.locate()
    breakormoveforward()
    local cx,cy,cz = gps.locate()
    if cx - x == -1 then
        turnturtletodirection(2,0)
    elseif cz - z == 1 then
        turnturtletodirection(3,0)
    elseif cz - z == -1 then
        turnturtletodirection(1,0)
    end
end

function moveToLoc(x,y,z,direction)
    local cx,cy,cz = gps.locate()
    local currentLookDirection = 0
    print("To location -",x,y,z)
    print("Cr location -",cx,cy,cz)
    if x - cx >= 0 then
        moveturtlexsteps(x - cx,"forward")
    else
        turnturtletodirection(currentLookDirection,2)
        currentLookDirection = 2
        moveturtlexsteps(cx - x,"forward")
    end

    if y - cy >= 0 then
        moveturtlexsteps(y - cy,"up")
    else
        moveturtlexsteps(cy - y,"down")
    end

    if z - cz >= 0 then
        turnturtletodirection(currentLookDirection,3)
        currentLookDirection = 3
        moveturtlexsteps(z - cz,"forward")
    else
        turnturtletodirection(currentLookDirection,1)
        currentLookDirection = 1
        moveturtlexsteps(cz - z,"forward")
    end

    if direction == "L" then
        turnturtletodirection(currentLookDirection,1)
    else
        turnturtletodirection(currentLookDirection,3)
    end
end

------------------------------  Main -----------------------------------------
local modem = peripheral.find("modem")
local myNumber = os.getComputerID()
local direction
local x,y,z = "","",""
local arg1,arg2,arg3 = "","",""
fuellevel = turtle.getFuelLevel()
modem.open(myNumber)
while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == myNumber and type(message) == "string" then

        if string.match(message,"#botMarch") and string.find(message,"@") then
            local location = string.sub(message,string.find(message,"@") + 1)
            local change = 0
            for i = 1, #location do
                if string.sub(location,i,i) == " " then
                    change = change + 1
                elseif string.sub(location,i,i) == "!" then
                    change = change + 1
                elseif change == 0 then
                    x = x ..string.sub(location,i,i)
                elseif change == 1 then
                    y = y ..string.sub(location,i,i)
                elseif change == 2 then
                    z = z ..string.sub(location,i,i)
                elseif change == 3 then
                    arg1 = arg1 ..string.sub(location,i,i)
                elseif change == 4 then
                    arg2 = arg2 ..string.sub(location,i,i)
                else
                    arg3 = arg3 ..string.sub(location,i,i)
                end
            end
            local inx,iny,inz = tonumber(x),tonumber(y),tonumber(z)
            print("location :",inx,iny,inz)
            calibrate()
            moveToLoc(inx,iny,inz,direction)
            
            local result = shell.run("mines",iny,direction,arg1,arg2,arg3,replyChannel)
            x,y,z = gps.locate()
            if result then
                modem.transmit(replyChannel,myNumber,"Mine done at " .. x .. " " .. y .. " " .. z)
                local name = arg1
                local count = 0
                for i = 1, 16, 1 do
                    local item = turtle.getItemDetail(i)
                    if item ~= nil then
                        if arg1 == "D" and item.name == "minecraft:diamond" then
                            name = "Diamond"
                            count = count + item.count
                        elseif arg1 == "N" and item.name == "minecraft:ancient_debris" then
                            name = "Netherite"
                            count = count + item.count
                        elseif arg1 == "R" and item.name == "minecraft:redstone" then
                            name = "Redstone"
                            count = count + item.count
                        elseif arg1 == "I" and item.name == "minecraft:raw_iron" then
                            name = "Iron"
                            count = count + item.count
                        end
                    end
                end
                modem.transmit(replyChannel,myNumber,"Found " .. count .. " " .. name)
            else
                modem.transmit(replyChannel,myNumber,"Error occured at" .. x .. " " .. y .. " " .. z)
            end
            x,y,z = "","",""
        elseif string.match(message,"#bot") then
            direction = string.sub(message,5,5)
            print("bot direction set -",direction)
            turtlerefuel()
            modem.transmit(replyChannel,myNumber,"#botactive@" .. turtle.getFuelLevel())
        end
    end
end