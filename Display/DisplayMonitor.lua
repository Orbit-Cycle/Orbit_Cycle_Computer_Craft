---@diagnostic disable: undefined-global, undefined-field

peripheral.find("modem", rednet.open)
local mon = peripheral.find("monitor")
local protocol
local controllerID
local monitorNum = 0

local id
local message = ""


local function display()
	print("Displaying")
    while true do
		repeat
        	id, message = rednet.receive(protocol)
        until id == controllerID
		mon.setBackgroundColor(message["Color"])
	end
end

local function startup()
	repeat
        id, message = rednet.receive()
		print(string.match(message, "startupSpawnDisplays"))
	until string.match(message, "startupSpawnDisplays")

    print("Starting up")
	local start = string.find(message, "-")
	protocol = string.sub(message, start+1)
    controllerID = rednet.lookup(protocol, "Controller")
    print("Protocol starts with: ".. protocol) -- string.sub(protocol, 0,4)

	
	repeat
        rednet.send(controllerID, "DisplayMonitor", protocol)
		id, message = rednet.receive(protocol, 2)
	until message == "Recieved " .. os.getComputerID()

	display()
end

startup()

