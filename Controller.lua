---@diagnostic disable: undefined-global, undefined-field


local protocol = "bussyPhui9076@"

local filename = "DisplayTables.lua" -- filename to access for tables
local repo = "" -- github link


peripheral.find("modem", rednet.open)

rednet.host(protocol, "Controller")

local monitors = {}
local command = "start"

if not fs.exists(filename) then
    shell.run("wget ".. filename .." ".. repo)
end


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
			rednet.broadcast("Recieved ".. id, protocol)
		end
		id, message = rednet.receive(protocol, 1)
	end

    print("Monitors IDS: (Connected)\n" .. Dump(monitors))
    
    while true do
        local table1 = {
            Color= colors.blue,
        }
        local table2 = {
            Color= colors.red,
        }
        local table3 = {
            Color= colors.green,
        }
        rednet.broadcast(table1, protocol)
        sleep(1)
        rednet.broadcast(table2, protocol)
        sleep(1)
        rednet.broadcast(table3, protocol)
        sleep(1)
    end

end

print("Loaded! type help for list of commands")
while command ~= "stop" do

    command = io.read()
  if command == "test" then
        rednet.broadcast(rednet.lookup(protocol), protocol)
	elseif command == "run" then
        run()
	elseif command == "monitors" then
		    monitorsCheck()
	elseif command == "help" then
        print("stop - Stops the program \n run - starts up all of the display monitors (make sure the program -DisplayMonitor- runs on them as well)")
	elseif command == "stop" then
		print("bye bye")
  else
		print("invalid command.")
	end
end
rednet.unhost("Controller")
