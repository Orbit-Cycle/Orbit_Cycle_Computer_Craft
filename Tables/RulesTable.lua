---@diagnostic disable: undefined-global, undefined-field
local TitleScreen = {
    Type="",
    BackgroundColor = colors.red,
    Title = {
        Text = "Hello",
        Centered = false,
        Color = colors.blue,
		
	}
}

local Types = {
    [1] = "TitleScreen",
    [2] = "BasicList",
    [3] = "Advertisement"
}

return {Types, {TitleScreen}}