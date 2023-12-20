---@diagnostic disable: undefined-global, undefined-field


local protocol = "bussyPhui9076@"

local filename = "DisplayTables" -- filename to access for tables
local repo = "https://raw.githubusercontent.com/Michael-Hazan/Orbit_Cycle_CC/main/Tables/RulesTable.lua" -- github link

-- monitors IDS
local Monitors = {}

local SlideTypes, SlideTables


local function Contains(table, val)
    for i = 1, #table, 1 do
        if table[i] == val then
            return true
        end
    end
    return false
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

local function getHTTP(url)
    local valid, reason = http.checkURL(url)
    if not valid then
        error("Failure to get url ("..url.."), Reason: ".. reason)
    end
    http.request( url )
    local event 
    while true do
      event = { os.pullEventRaw() }
      if (event[1] == "http_success") then
            break
      elseif (event[1] == "http_failure") then
            error("No response from server.", 2)
            
      end
    end

    return event[3].readAll()
end

local function centerTextXY(text, color, bgcolor)
    local w, h = term.getSize()
    local x,y = term.getCursorPos()
    term.setCursorPos(math.floor(w / 2 - text:len() / 2 + .5), y)
    if color then term.setTextColor(color) end
    if bgcolor then term.setBackgroundColor(bgcolor) end
    term.write(text)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    print()
    sleep(1)
end

local function loadTables()
    local website = getHTTP(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename.. ".lua")
        print("Downloaded tables!\n")
        SlideTypes, SlideTables = require(filename)
        print("Loaded tables and types!\n")
    else
        print("Failed to get tables! Website not found.\n")
    end
end


-- runtime Function, activates all of the displays
local function run()
    rednet.broadcast("startupSpawnDisplays -" .. protocol)
    sleep(0.5)
    print("Searching for monitors\n")
    local id, message = rednet.receive(protocol)
    local i = 1
    while message ~= nil do
        if message == "DisplayMonitor" then
            if not Contains(Monitors, id) then
                Monitors[i] = id
                i = i + 1
            end
            rednet.broadcast("Recieved " .. id, protocol)
        end
        id, message = rednet.receive(protocol, 1)
    end

    print("Monitors IDS: (Connected)\n" .. Dump(Monitors).. "\n")

    while true do
        local table1 = {
            Color = colors.blue,
        }
        local table2 = {
            Color = colors.red,
        }
        local table3 = {
            Color = colors.green,
        }
        rednet.broadcast(table1, protocol)
        sleep(1)
        rednet.broadcast(table2, protocol)
        sleep(1)
        rednet.broadcast(table3, protocol)
        sleep(1)
    end
end

--
-- RUN TIME CODE --
--

-- opens rednet
peripheral.find("modem", rednet.open)
rednet.host(protocol, "Controller")

-- current command
local command = "start"

-- functions to commands
local functions =  {
    run = run,
    loadtables = loadTables,
    Monitors = function()
        print(Dump(Monitors).."\n")
    end,
    test = function()
        rednet.broadcast("Testing...", protocol)
    end,
    help = function()
        print(
            "\n"..
            "stop - Stops the program \n"..
            "run - starts up all of the display monitors (make sure the program -DisplayMonitor- runs on them as well)\n"..
            "test - sends a test message\n"..
            "monitors - gives a list of monitors IDS that are connected\n"..
            "loadtables - redownloads the tables"..
            "\n\n"
        )
    end,
    stop = function()
        print("bye bye!\n")
    end
}



if not fs.exists(filename) then
    local website = getHTTP(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename.. ".lua")
        print("Downloaded tables!\n")
        SlideTypes, SlideTables = require(filename)
        print("Loaded tables and types!\n\n")
        term.setTextColor(colors.yellow)
        print("Types: " .. Dump(SlideTypes).."\n")
        print()
        print("Tables: " .. Dump(SlideTables).."\n")
    else
        print("Failed to get tables! Website not found.\n")
    end
else
    print("Tables already loaded\n")
end

sleep(1)
centerTextXY("Loaded! type help for list of commands", colors.green, colors.white)
while command ~= "stop" do
    command = io.read()
    functions[command]()
end


rednet.unhost()
