-----------------------------------------------------------------------------------------------------------------
-- Transform module
----------------------------------------------------------------------------------------------------------------    
    
local transform = {}

local dm = require("data_management")

function transform:Transform_SquareY(data)    
    for x = 1, #data do
		data[x].y = data[x].y * data[x].y
	end
	return data
end

function transform:Transform_Exp(data)
	for x = 1, #data do
		data[x].y = math.exp(data[x].y)
	end
	return data
end

function transform:Transform_Absolute(data)
	for x = 1, #data do
		data[x].y = math.abs(data[x].y)
	end
	return data
end

function transform:Transform_Cosine(data)
	for x = 1, #data do
		data[x].y = math.cos(data[x].y)
	end
	return data
end

function transform:Transform_CosH(data)
	for x = 1, #data do
		data[x].y = math.cosh(data[x].y)
	end
	return data
end

function transform:Transform_Atan(data)
	for x = 1, #data do
		data[x].y = math.atan(data[x].y)
	end
	return data
end

function transform:Transform_Mantissa(data)
	for x = 1, #data do
		data[x].y = math.frexp(data[x].y)
	end
	return data
end

function transform:Transform_Sine(data)
	for x = 1, #data do
		data[x].y = math.sin(data[x].y)
	end
	return data
end

function transform:Transform_Tanh(data)
	for x = 1, #data do
		data[x].y = math.tanh(data[x].y)
	end
	return data
end

return transform
