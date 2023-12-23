---@diagnostic disable: undefined-global, undefined-field


local protocol = "bussyPhui9076@"

local filename = "DisplayTables"                                                                             -- Filename to access for tables // Change only for prefrence
local repo = "https://raw.githubusercontent.com/Michael-Hazan/Orbit_Cycle_CC/main/Tables/RulesTable.lua" -- Github link / wget available link to get tables from
local lockedrepo, token = false, "repotoken"                                                                             -- Make sure your github repository it open


local startupMessage = "startupSpawnDisplays" --


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
        error("Failure to get url (" .. url .. "), Reason: " .. reason)
    end
    http.request(url)
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

local function centerTextX(text, color, bgcolor)
    local w, _ = term.getSize()
    local _, y = term.getCursorPos()
    term.setCursorPos(math.floor(w / 2 - text:len() / 2 + .5), y)
    if color then term.setTextColor(color) end
    if bgcolor then term.setBackgroundColor(bgcolor) end
    term.write(text)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    print()
end

local function loadTables()
    local website = getHTTP(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename .. ".lua")
        print("Downloaded tables!\n")
        SlideTypes, SlideTables = require(filename)
        print("Loaded tables and types!\n")
    else
        print("Failed to get tables! Website not found.\n")
    end
end


-- runtime Function, activates all of the displays
local function run()
    print("Searching for monitors\n")
    local id, message
    repeat
        rednet.broadcast(startupMessage .. " -" .. protocol)
        id, message = rednet.receive(protocol)
    until message ~= nil and message == "DisplayMonitor"
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

    print("Monitors IDS: (Connected)\n" .. table.concat(Monitors, ", ") .. "\n")

    while true do
        for i = 1, #SlideTables, 1 do
            rednet.broadcast({ Table = SlideTables[i], Types = SlideTypes }, protocol)
            sleep(SlideTables[i]["Timeout"])
        end
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
local functions = {
    run = run,
    loadtables = loadTables,
    Monitors = function()
        print(Dump(Monitors) .. "\n")
    end,
    test = function()
        rednet.broadcast("Testing...", protocol)
    end,
    help = function()
        print(
            "\n" ..
            "stop - Stops the program \n" ..
            "run - starts up all of the display monitors (make sure the program -DisplayMonitor- runs on them as well)\n" ..
            "test - sends a test message\n" ..
            "monitors - gives a list of monitors IDS that are connected\n" ..
            "loadtables - redownloads the tables" ..
            ""
        )
    end,
    stop = function()
        print("bye bye!\n")
    end
}



if not fs.exists(filename) then
    if locked then
        if not token then
            print("Needs a token to access private repository.")
            return
        end
        repo = repo .. "?token=" .. token
    end

    local website = getHTTP(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename .. ".lua")

        print("Downloaded tables!\n")
        local SlidesInfo = require(filename) -- Getting tables and types
        --#region Setting tables accordingly
        SlideTypes = SlidesInfo["SlideTypes"]
        SlideTables = SlidesInfo["SlideTables"]
        --#endregion
        print("Loaded tables and types!\n\n")

        term.setTextColor(colors.yellow)
        print("Types: " .. table.concat(SlideTypes, " / ") .. "\n")
        print("Tables: " .. Dump(SlideTables) .. "\n")
    else
        print("Failed to get tables! Website not found.\n")
    end
else
    print("Tables already loaded\n")
end

centerTextX("Loaded! type help for list of commands", colors.green, colors.white)

run()
while command ~= "stop" do
    command = io.read()
    term.clear()
    term.setCursorPos(0, 0)
    functions[command]()
end

rednet.unhost()
