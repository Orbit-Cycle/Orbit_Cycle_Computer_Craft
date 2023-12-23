---@diagnostic disable: undefined-global, undefined-field

--[[
 -
--]]



peripheral.find("modem", rednet.open)
local mon = peripheral.find("monitor")

local startupMessage = "startupSpawnDisplays"

local currentDisplayTable

local protocol, controllerID

local id
local message = ""
local bigfont


-- #region DEBUG Functions
local function printTable(t)
    local printTable_cache = {}

    local function sub_printTable(t, indent)
        if (printTable_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            printTable_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_printTable(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_printTable(t, "  ")
        print("}")
    else
        sub_printTable(t, "  ")
    end
end
local function Dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- #endregion
-- #region Table To Monitors Decoders
local function resetMonitor()
    mon.setTextColor(colors.white)
    mon.setBackgroundColor(colors.black)
    mon.setCursorPos(1, 1)
    mon.setTextScale(1)
    mon.clear()
end


local function CenteredText(onX, onY, text, offsetx, offsety)
    local w, h = mon.getSize()
    local x, y = mon.getCursorPos()
    return (onX and math.floor(w / 2 - #text / 2 + 2) / offsetx or x), (onY and math.floor(h / 2 + 0.5) / offsety or y)
end

local function write(table, access)
    -- Set Background Color


    -- Set Text Color
    local validColor = table[access]["Color"] ~= nil and mon.isColor(table[access]["Color"])
    mon.setTextColor(validColor and table[access]["Color"] or mon.getTextColor())

    -- Set Text Scale
    if table["TextSize"] <= 5 then
        mon.setTextScale(table["TextSize"] and table["TextSize"] or mon.getTextScale())
    end

    --  Writes Text
    if table["TextSize"] <= 5 then
        if type(table[access]["Text"]) == "table" then
            local x,y = CenteredText(table[access]["CenteredX"], table[access]["CenteredY"], table[access]["Text"][1], 1.25,1.25)
            mon.setCursorPos(x, y)
            for i = 1, #table[access]["Text"], 1 do
                mon.write(table[access]["Text"][i])
                local _, py = mon.getCursorPos()
                mon.setCursorPos(x,py+1)
            end
        else
            local x,y = CenteredText(table[access]["CenteredX"], table[access]["CenteredY"], table[access]["Text"][i], 1, 1)
            mon.setCursorPos(x,y)
            mon.write(table[access]["Text"])
            local _, py = mon.getCursorPos()
            mon.setCursorPos(1,py+1)
        end
    else
        local x,y = CenteredText(table[access]["CenteredX"], table[access]["CenteredY"], table[access]["Text"][1], 1.95,1.25)
        mon.setCursorPos(x,y)
        bigfont.writeOn(mon, 2, table[access]["Text"], mon.getCursorPos())
    end

end



--[[
Writes table from type TitleScreen onto monitor.
Table:
{
    Type="TitleScreen",
    BackgroundColor = colors.red,
    Title = {
        Text = "Hello",
        TextSize = 14,
        CenteredX = true,
        CenteredY = true,
        Color = colors.blue,
        BackgroundColor = colors.white

	}
}
--]]
local function decodeTitleScreen(table)
    write(table, "Title")
end
local function decodeBasicList(table)
    write(table, "Title")
    write(table, "Lines")
end
local function decodeAdvertisement(table)

end
local decodeTypes = {
    TitleScreen = decodeTitleScreen,
    BasicList = decodeBasicList,
    Advertisement = decodeAdvertisement,
    reset = resetMonitor
}

-- #endregion


-- #region Runtime
local function decode(table)
    decodeTypes["reset"]()
    -- Change Background Color Of The Entire Monitor
    mon.setBackgroundColor(table["BackgroundColor"])
    print(table["BackgroundColor"])
    decodeTypes[table["Type"]](table)

end

local function display()
    print("Displaying")
    while true do

        repeat
            id, message = rednet.receive(protocol)
        until id == controllerID and message ~= nil
        currentDisplayTable = message


        rednet.broadcast("Recieved Table: " .. Dump(currentDisplayTable), protocol)
        --printTable(currentDisplayTable)
        --printTable(currentDisplayTable["Table"])
        if currentDisplayTable["Table"] ~= nil then
            decode(currentDisplayTable["Table"])

        end

    end
end
local function checkForController(message)
    if type(message) == type(startupMessage) then
        if string.match(message, startupMessage) then
            return true
        end
    end
    return false
end

local function startup()
    repeat
        id, message = rednet.receive()
	until checkForController(message)

    print("Starting up.")
    rednet.broadcast("Starting up.")
	local start = string.find(message, "-")
	protocol = string.sub(message, start+1)
    controllerID = rednet.lookup(protocol, "Controller")
    print("Protocol starts with: " .. protocol) -- string.sub(protocol, 0,4)

    if not fs.exists("bigfont") then
        shell.run("pastebin get 3LfWxRWh bigfont")
    end
    bigfont = require("bigfont")


	repeat
        rednet.send(controllerID, "DisplayMonitor", protocol)
		id, message = rednet.receive(protocol, 2)
	until message == "Recieved " .. os.getComputerID()

	display()
end

startup()

-- #endregion
