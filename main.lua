-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local data = {}

local data_manage = require("data_management")
local composer = require( "composer" )
local chart = require("chart")

composer.gotoScene( "scene_gui" )

--local data, err = data_manage:Get_Data("data.csv", system.ResourceDirectory)
