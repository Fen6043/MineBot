function ping(sentToNumber, direction)
    while true do
        modem.transmit(sentToNumber,myNumber,"#bot" .. direction)
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if replyChannel == sentToNumber and channel == myNumber and string.match(message,"#botactive") then
            term.setTextColor(colors.green)
            print("Bot" .. replyChannel .. " active at " .. distance .. " fuel: " .. string.sub(message,string.find(message,"@")+1))
            term.setTextColor(colors.white)
            if direction == "L" then
                botL = replyChannel
            else
                botR = replyChannel
            end
            count = count + 1
            return
        end
    end
end

function pingTimer(sentToNumber)
    term.setTextColor(colors.yellow)
    os.sleep(2)
    term.setTextColor(colors.red)
    print("Bot".. sentToNumber .." not active")
    term.setTextColor(colors.white)
end

function getMessage()
    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if channel == myNumber and (replyChannel == botL or replyChannel == botR) and type(message) == "string" then
            if replyChannel == botL then
                term.setTextColor(colors.yellow)
            else
                term.setTextColor(colors.cyan)
            end
            print("Turtle " ..replyChannel.. ":" .. message .. "\n")
            term.setTextColor(colors.white)
        end
    end
end
-------------------------------------Main-----------------------------------------------------
arg1 = arg[1]
arg2 = arg[2]
arg3 = arg[3]
modem = peripheral.find("modem")
myNumber = os.getComputerID()
count = 0
modem.open(myNumber)
local direction = "L"
botL,botR = 0,0
local x, y, z = gps.locate()

for i = 0, 10, 1 do
    parallel.waitForAny(function() ping(i,direction) end, function() pingTimer(i) end)
    if count >= 2 then
        break
    elseif count == 1 then
        direction = "R"
    end
end

if count <2 then
    print("no 2 bot active")
else
    term.setTextColor(colors.orange)
    print("Bots marching to location :",math.floor(x),math.floor(y-1),math.floor(z))
    print("--------------------------")
    term.setTextColor(colors.white)
    modem.transmit(botL,myNumber,"#botMarch@" .. math.floor(x+2) .. " " .. math.floor(y-1) .. " " .. math.floor(z) .. "!" .. arg1 .. "!" .. arg2 .. "!" .. arg3)
    modem.transmit(botR,myNumber,"#botMarch@" .. math.floor(x+1) .. " " .. math.floor(y-1) .. " " .. math.floor(z) .. "!" .. arg1 .. "!" .. arg2 .. "!" .. arg3)
    getMessage()
    --shell.run("zhat")
end
