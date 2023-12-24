---@diagnostic disable: undefined-global, undefined-field

local table = {
    BackgroundColor = colors.blue,
    Color = colors.white,
	textSize = 3.5,
	text = {[1]="Click To Join",[2]="The Discord!"},
	link = "https://discord.gg/6WaKY6v3K7"
}
local monitor = peripheral.find("monitor")
local bigfont = require("bigfont")

local function CenteredText(text)
    local w, h = monitor.getSize()
    return math.floor(w / 2 - #text / 2 + 1),math.floor(h / 2)
end

while true do
	monitor.setCursorPos(1,1)
	print(table[BackgroundColor])
    monitor.setBackgroundColor(table["BackgroundColor"])
	monitor.clear()
    monitor.setTextColor(table["Color"])
	monitor.setTextScale(table["textSize"])
    local cx, cy, x, y
	
    cx, cy = CenteredText(table["text"][1])
	x,y = monitor.getCursorPos()
    monitor.setCursorPos(x, cy)

    monitor.write(table["text"][1])
	_,y = monitor.getCursorPos()
    monitor.setCursorPos(x, y+4)
    monitor.write(table["text"][2])
	

    
    local event, button, clickX, clickY = os.pullEvent("monitor_touch")
    print("click + " .. button)
	commands.exec('/tellraw @a[distance=1..10] {"text":"Click This to Join The Discord!","bold":true,"underlined":true,"color":"aqua","clickEvent":{"action":"open_url","value":"https://discord.gg/6WaKY6v3K7"}}')
	sleep(0.5)
end