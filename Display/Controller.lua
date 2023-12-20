---@diagnostic disable: undefined-global, undefined-field


local protocol = "bussyPhui9076@"

local filename = "DisplayTables.lua" -- filename to access for tables
local repo = "https://raw.githubusercontent.com/Michael-Hazan/Orbit_Cycle_CC/main/Tables/RulesTable.lua?token=GHSAT0AAAAAACLQTGHDPFW7UQ3NWQDARC7YZMBZFBA" -- github link

-- monitors IDS
local monitors = {}


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
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function loadTables()
    local website = http.get(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename)
        print("Downloaded tables!")
    else
        print("Failed to get tables! Website not found.")
    end
end


-- runtime Function, activates all of the displays 
local function run()
    rednet.broadcast("startupSpawnDisplays -" .. protocol)
    sleep(0.5)
    print("Searching for monitors")
    local id, message = rednet.receive(protocol)
    local i = 1
    while message ~= nil do
        if message == "DisplayMonitor" then
            if not Contains(monitors, id) then
                monitors[i] = id
                i = i + 1
            end
            rednet.broadcast("Recieved " .. id, protocol)
        end
        id, message = rednet.receive(protocol, 1)
    end

    print("Monitors IDS: (Connected)\n" .. Dump(monitors))

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
    monitors = function()
        print(Dump(monitors))
    end,
    test = function()
        rednet.broadcast("Testing...", protocol)   
    end,
    help = function()
        print(
            "stop - Stops the program \n"..
            "run - starts up all of the display monitors (make sure the program -DisplayMonitor- runs on them as well)\n"..
            "test - sends a test message\n"..
            "monitors - gives a list of monitors IDS that are connected\n"..
            "loadtables - redownloads the tables"
        )
    end,
    stop = function()
        print("bye bye!")
    end
}



if not fs.exists(filename) then
    local website = http.get(repo)
    if website then
        shell.run("wget " .. repo .. " " .. filename)
        print("Downloaded tables!")
    else
        print("Failed to get tables! Website not found.")
    end
else
    print("Tables already loaded")
end


print("Loaded! type help for list of commands")
while command ~= "stop" do
    command = io.read()
    if command == "test" then
        rednet.broadcast(rednet.lookup(protocol), protocol)
    elseif command == "run" then
        run()
    elseif command == "monitors" then
        print(Dump(monitors))
    elseif command == "help" then
        print(
        "stop - Stops the program \n run - starts up all of the display monitors (make sure the program -DisplayMonitor- runs on them as well)")
    elseif command == "stop" then
        print("bye bye")
    else
        print("invalid command.")
    end
end


rednet.unhost("Controller")
