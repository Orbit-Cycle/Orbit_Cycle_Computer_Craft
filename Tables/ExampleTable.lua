---@diagnostic disable: undefined-global, undefined-field


--[[ Notes:
 - Text Scale (TextSize) starts at 0.5 and ends at 5 (scale can be any multiple of 0.5)
   anything higher then 5 will use Wojbie bigfont API to create an enormous text (be careful, it is BIG)
]]
local TitleScreen = {
    Type = "TitleScreen",
    BackgroundColor = colors.lightBlue,
    TextSize = 5,
    Timeout = 5,
    Title = {
        Text = "Welcome",
        CenteredX = true,
        CenteredY = true,
        Color = colors.white,
    }
}
local FirstScreen = {
    Type = "BasicList",
    BackgroundColor = colors.blue,
    TextSize = 2,
    Timeout = 30,
    Title = {
        Text = "Rules:",
        CenteredX = false,
        Color = colors.white,
    },
    Lines = {
        Text = {
            [1] = "1. No racism, sexism, or homophobia",
            [2] = "directed at a player.",
            [3] = "2. Do not bring real world political",
            [4] = "issues into the game world.",
            [5] = "3.Do not abuse claim protection",
            [6] = "with mods that get around claim",
            [7] = "protection.",
            [8] = "4. Respect everyone's privacy and",
            [9] = "anonymity.",
            [10] = "5. No spamming in chat,",
            [11] = "No promoting non minecraft related ",
            [12] = "content in chat."
        },
        CenteredX = false,
        Color = colors.white,
    }
}
local Clickable

local Types = {
    [1] = "TitleScreen",
    [2] = "BasicList",
    [3] = "Advertisement",
    [4] = "Clickable",
    [5] = "Logo"
}
-- The order of which the tables are 
return {SlideTypes=Types, SlideTables={TitleScreen, BasicList}}