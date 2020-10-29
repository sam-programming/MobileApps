---------------------------------------------------------------------------------
-- Scene
---------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local dm = require( "data_management" )
local chart = require("chart")

local scene = composer.newScene()

-- Variables
-- do this in scene:show() == "will"
local data, err = dm:Get_Data("data.csv")--, system.ResourceDirectory)
-- make sure to do an error check here if err then do thing else do rest
--print("data: " .. data[2].x .. ' ' .. data[2].y .. ' ' .. data[2].flag)


-- the scene methods will be constructed here

-- create the border
function scene:create( event )	
	
	local sceneGroup = self.view
	local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	background.anchorX = 0
	background.anchorY = 0
	
	background:setFillColor(0.95, 0.95, 0.95)
	sceneGroup:insert(background)

	--variables that are returned from Chart_And_Plot
	local chartGroup = display.newGroup()
	local points = {}

	-- call for a chart
	chartGroup, points = chart:Chart_And_Plot(data)	
	sceneGroup:insert(chartGroup)

	-- create a button
	local button1 =  widget.newButton(
		{
			width = 130,
			height = 40,
			shape = "roundedRect",
			cornerRadius = 2,
			id = "btn1",
			label = "Btn1",			
			onEvent = handleButtonEvent
		}
	)
	button1.x = display.contentCenterX * 0.5
	button1.y = display.contentCenterY * 1.5
	sceneGroup:insert(chartGroup)
	--sceneGroup:insert(display_pane)
	sceneGroup:insert(button1)
end

scene:addEventListener("create", scene)
	
return scene

