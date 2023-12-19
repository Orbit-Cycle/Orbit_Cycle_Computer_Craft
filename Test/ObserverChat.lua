---@diagnostic disable: undefined-global, undefined-field

local protocol = "bussyPhui9076@"
local id, message

peripheral.find("modem", rednet.open)
print(rednet.isOpen())

while true do
    local e, param1, param2, param3 = os.pullEvent()
    if e == 'key' then
    	if  param1 == 259 then
        	term.clear()
          print("-- redacted --")
   		end
    else
		id, message = rednet.receive(protocol, 0.5)
    	if message ~= nil then
        	print(("Computer %d : %s"):format(id, message))
    	end
    end

end