---------------------------------------------------------------------------------
-- Scene
---------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local dm = require( "data_management" )
local chart = require("chart")
local transform = require("transform")

local scene = composer.newScene()


-- Variables
-- do this in scene:show() == "will"
local data, err = dm:Get_Data("data.csv")--, system.ResourceDirectory)
-- make sure to do an error check here if err then do thing else do rest
--print("data: " .. data[2].x .. ' ' .. data[2].y .. ' ' .. data[2].flag)

--debug function 
function print_data(data)
	for x=1, #data do
		print("Data[x].y = " .. data[x].y)
	end
end

function Insert_Points(points, group)
	for x = 1, #points do
		points[x].isVisible = true
		group:insert(points[x])
	end
end

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
	local new_points = {}

	-- call for a chart - returns data in state it was entered
	data, chartGroup, points = chart:Chart_And_Plot(data)	
	--print_data(data)
	sceneGroup:insert(chartGroup)

	-- insert points	
	Insert_Points(points, chartGroup)

	-- columns for picker wheel	
	local col_data = 
	{
		{
			align = "left",
			width = 140,
			labelPadding = 5,
			startIndex = 1,
			--columnColor = 
			labels = {"original", "y-squared", "absolute(y)", "exponential(y)", "cosine(y)", 
						"hyperbolic cosine(y)", "arc tangent(y)", "mantissa exponent(y)", "sine(y)", "hyperbolic tangent(y)" }
		}
	}

	--create a picker wheel
	local transform_picker = widget.newPickerWheel(
		{
			x = display.contentCenterX * 0.52,
			y = display.contentCenterY * 1.49,
			columns = col_data,			
			style = "resizable",
			width = 140,
			rowHeight = 25,
			fontSize = 15			
		}	
	)

	function btn_transform_clicked(event)
		local value = transform_picker:getValues()
		local new_data = dm:Table_Copy(data)
		
		if value[1].value == "y-squared" then
			new_data = transform:Transform_SquareY(new_data)
			
			chartGroup:removeSelf() -- very important
			chartGroup = nil
			new_data, chartGroup, new_points = chart:Chart_And_Plot(new_data)	
			for x = 1, #new_points do
				new_points[x].isVisible = true
				chartGroup:insert(new_points[x])
			end		
		end			
	end

	-- create button
	local button1 =  widget.newButton(
		{
			width = 100,
			height = 40,
			shape = "roundedRect",
			cornerRadius = 2,
			id = "btn1",
			label = "Transform",			
			onRelease = btn_transform_clicked
		}
	)
	--undo and redo can go under here

	button1.x = display.contentCenterX * 1.5
	button1.y = display.contentCenterY * 1.5

	
	sceneGroup:insert(transform_picker)		
	--sceneGroup:insert(button1)
end

scene:addEventListener("create", scene)
	
return scene
