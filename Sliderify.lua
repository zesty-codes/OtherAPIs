--[[
  Made by zestycodes

	EXAMPLE:
	sliderify(
		[Frame] The frame that you want to make the hitbox;
		[GuiObject] The object that you want to get slided;
		[TextLabel] The object that you want to get text with the value;
		[Options] {
			max: number;
			min: number;
			prefix: string (example: "%4")
		};
		[Callback]: (any) -> number
	)
--]]
local lp = game:GetService("Players").LocalPlayer
local mos = lp:GetMouse()
local function sliderify(slidingFrame, slidingBar, options, callback)
	local api = {}
	local options = options or {
		min = 1,
		max = 12,
		prefix = "Value: "
	}
	local factor = 1
	if not options.prefix then
		options.prefix = "Value: "
	end
	local slidingBar = slidingBar
	local Value = 0
	local parentBar = slidingFrame
	local Label = Label
	local sliding = false
	task.spawn(function()
		parentBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				sliding = true
				while sliding do
					local v1 = math.clamp((mos.X - parentBar.AbsolutePosition.X) / (parentBar.AbsoluteSize.X), 0, 1)
					--local v2 = math.floor((((options.max - options.min) * v1) + options.min))
					--local v2 = math.floor(((options.max - options.min) * v1) + options.min) - factor / factor
					local v2 = math.round((options.min + (options.max - options.min) * v1))
					v2 = math.clamp(v2 * factor, options.min, options.max) / factor
					Value = v2
					Label.Text = tostring(v2)
					slidingBar.Size = UDim2.fromScale(v1, 1)
					game:GetService("RunService").RenderStepped:Wait()
				end
				sliding = false
			end
		end)
		parentBar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				sliding = false
			end
		end)
	end)
	function api:getValue()
		return Value
	end
	function api:setValue(x: number)
		Value = x
		Label.Text = tostring(options.prefix)..tostring(Value)
		slidingBar.Size = UDim2.fromScale(((Value - options.min) / (options.max - options.min)), 1)
	end
	return api
end
getgenv().sliderify = sliderify
return sliderify
