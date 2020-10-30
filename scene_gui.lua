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

function Transition_To_Points(current_points, new_points)
	for x = 1, #current_points do
		transition.moveTo(current_points[x], {x=new_points[x].x, y=new_points[x].y, time = 2000} )
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

	local heading = display.newText("Data Transformer", display.contentCenterY * 0.68, 25)
	heading:setFillColor(0.1, 0.5, 1)
	sceneGroup:insert(heading)

	--variables that are returned from Chart_And_Plot
	local chartGroup = display.newGroup()
	local current_points = {}
	local new_points = {}

	-- call for a chart - returns data in state it was entered
	data, chartGroup, current_points = chart:Chart_And_Plot(data)	
	--print_data(data)
	sceneGroup:insert(chartGroup)
	-- insert points	
	Insert_Points(current_points, chartGroup)

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

	local prev_func = {}
	prev_func[1] = "original"
	local redo_func = {}
	local undo_index = 1

	function btn_transform_clicked(event)
		local vals = transform_picker:getValues()
		local value = vals[1].value	
		
		local new_data = dm:Table_Copy(data)
		 -- had to put this here due to scope concern
		function Finalise_Transform(prev)
			chartGroup:removeSelf() -- very important to prevent memory leaks
			chartGroup = nil
			new_data, chartGroup, new_points = chart:Chart_And_Plot(new_data)	
			Insert_Points(current_points, chartGroup)
			Transition_To_Points(current_points, new_points)
			current_points = new_points
			local i = #prev_func + 1
			--print("Count prev func: " .. #prev_func .. " i = " .. i)
			prev_func[i] = prev
			undo_index = undo_index+ 1

		end		
		if value == "y-squared" then			
			new_data = transform:Transform_SquareY(new_data)
			Finalise_Transform("y-squared")
		elseif value== "exponential(y)" then
			new_data = transform:Transform_Exp(new_data)
			Finalise_Transform("exponential(y)")
		elseif value == "absolute(y)" then 
			new_data = transform:Transform_Absolute(new_data)
			Finalise_Transform("absolute(y)")
		elseif value == "cosine(y)" then
			new_data = transform:Transform_Cosine(new_data)
			Finalise_Transform("cosine(y)")
		elseif value == "hyperbolic cosine(y)" then
			new_data = transform:Transform_CosH(new_data)
			Finalise_Transform("hyperbolic cosine(y)")
		elseif value == "arc tangent(y)" then
			new_data = transform:Transform_Atan(new_data)
			Finalise_Transform("arc tangent(y)")
		elseif value == "mantissa exponent(y)" then
			new_data = transform:Transform_Mantissa(new_data)
			Finalise_Transform("mantissa exponent(y)")
		elseif value == "sine(y)" then
			new_data = transform:Transform_Sine(new_data)
			Finalise_Transform("sine(y)")
		elseif value == "hyperbolic tangent(y)" then
			new_data = transform:Transform_Tanh(new_data)
			Finalise_Transform("hyperbolic tangent(y)")
		elseif value == "original" then
			Finalise_Transform("original")
		end
	end

	function btn_undo_Clicked(event)
	print("Undo clicked. Index = " ..  undo_index)
		undo_index = undo_index - 1
		local value = prev_func[undo_index]
		local new_data = dm:Table_Copy(data)
		 -- had to put this here due to scope concern
		function Finalise_Transform(redo)
			chartGroup:removeSelf() -- very important to prevent memory leaks
			chartGroup = nil
			new_data, chartGroup, new_points = chart:Chart_And_Plot(new_data)	
			Insert_Points(current_points, chartGroup)
			Transition_To_Points(current_points, new_points)
			current_points = new_points
			local i = #redo_func + 1
			redo_func[i] = redo
		end	
		
		if value == "y-squared" then			
			new_data = transform:Transform_SquareY(new_data)
			Finalise_Transform("y-squared")
		elseif value== "exponential(y)" then
			new_data = transform:Transform_Exp(new_data)
			Finalise_Transform("exponential(y)")
		elseif value == "absolute(y)" then 
			new_data = transform:Transform_Absolute(new_data)
			Finalise_Transform("absolute(y)")
		elseif value == "cosine(y)" then
			new_data = transform:Transform_Cosine(new_data)
			Finalise_Transform("cosine(y)")
		elseif value == "hyperbolic cosine(y)" then
			new_data = transform:Transform_CosH(new_data)
			Finalise_Transform("hyperbolic cosine(y)")
		elseif value == "arc tangent(y)" then
			new_data = transform:Transform_Atan(new_data)
			Finalise_Transform("arc tangent(y)")
		elseif value == "mantissa exponent(y)" then
			new_data = transform:Transform_Mantissa(new_data)
			Finalise_Transform("mantissa exponent(y)")
		elseif value == "sine(y)" then
			new_data = transform:Transform_Sine(new_data)
			Finalise_Transform("sine(y)")
		elseif value == "hyperbolic tangent(y)" then
			new_data = transform:Transform_Tanh(new_data)
			Finalise_Transform("hyperbolic tangent(y)")
		elseif value == "original" then
			Finalise_Transform("original")
		end
	end

	-- create button
	local trans =  widget.newButton(
		{
			width = 100,
			height = 40,
			shape = "roundedRect",
			cornerRadius = 2,
			id = "trans",
			label = "Transform",			
			onRelease = btn_transform_clicked
		}
	)
	--undo and redo can go under here

	trans.x = display.contentCenterX * 1.5
	trans.y = display.contentCenterY * 1.5

	local undo = widget.newButton(
		{	
			width = 50,
			height = 36,
			shape = "roundedRect",
			cornerRadius = 3,
			id = "undo",
			label = "Undo",
			onRelease = btn_undo_Clicked
		}
	)

	undo.x = display.contentCenterX * 1.3
	undo.y = display.contentCenterY * 1.7
	
	sceneGroup:insert(transform_picker)		
	sceneGroup:insert(trans)
	sceneGroup:insert(undo)
end

scene:addEventListener("create", scene)
	
return scene
