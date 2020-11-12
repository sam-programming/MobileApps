-----------------------------------------------------------------------------------------------------------------
-- Front page
-----------------------------------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

function scene:create( event )	
	
	local sceneGroup = self.view
	local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	background.anchorX = 0
	background.anchorY = 0
	
	background:setFillColor(0.95, 0.95, 0.95)
	sceneGroup:insert(background)

	local heading = display.newText("Data Transformer", display.contentCenterY * 0.68, 150)
    heading:setFillColor(0.1, 0.5, 1)
    heading.size = 35
   
    
    local select = display.newText("Select File: ", display.contentCenterY * 0.35, 
                        display.contentCenterX * 1.5)
    select:setFillColor(0.1, 0.1, 0.1)

    local col_data = 
	{
		{
			align = "left",
			width = 140,
			labelPadding = 5,
			startIndex = 1,
            labels = {"data.csv", "data2.csv"}
        }
    }  

    --create a picker wheel
	local data_picker = widget.newPickerWheel(
		{
			x = display.contentCenterX + 50 ,
			y = display.contentCenterY,
			columns = col_data,			
			style = "resizable",
			width = 140,
			rowHeight = 25,
			fontSize = 15			
		}
    )    

    function btn_continue_clicked(event)
        vals = data_picker:getValues()
        value = vals[1].value
        local options = {
            params = {
                dataset = value
            }
        }
        composer.gotoScene("scene_gui", options)
    end

    local continue = widget.newButton(
		{
			width = 100,
			height = 40,
			shape = "roundedRect",
			cornerRadius = 2,
			id = "cont",
			label = "Continue",			
			onRelease = btn_continue_clicked
		}
    )
    continue.x = display.contentCenterX 
    continue.y = display.contentCenterY * 1.5     

    
    sceneGroup:insert(data_picker)
    sceneGroup:insert(continue)
    sceneGroup:insert(select)
    sceneGroup:insert(heading)
end

scene:addEventListener("create", scene)
	
return scene