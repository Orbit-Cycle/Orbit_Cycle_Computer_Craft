---@diagnostic disable: undefined-global, undefined-field

local TitleScreen = {
    Type="TitleScreen",
    BackgroundColor = colors.lightBlue,
    TextSize = 5,
    Timeout = 5,
    Title = {
        Text = {
            [1] = "Welcome to",
            [2] = "Orbit Cycle!"
        },
        CenteredX = true,
        CenteredY = true,
        Color = colors.white,
    }
}
local FirstScreen = {
    Type="BasicList",
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


local Types = {
    [1] = "TitleScreen",
    [2] = "BasicList",
    [3] = "Advertisement",
    [4] = "Clickable",
    [5] = "Logo"
}

return {SlideTypes=Types, SlideTables={TitleScreen, FirstScreen}}