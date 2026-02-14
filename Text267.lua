-- ======================
-- CAT ESP (TOGGLE)
-- ======================

if _G.CAT_ESP then
	_G.CAT_ESP = false
	print("CAT ESP: OFF")

	if _G.CAT_ESP_DATA then
		for model, highlight in pairs(_G.CAT_ESP_DATA) do
			if highlight then
				pcall(function()
					highlight:Destroy()
				end)
			end
		end
	end

	return
end

_G.CAT_ESP = true
_G.CAT_ESP_DATA = {}
print("CAT ESP: ON")

-- ======================
-- SERVICIOS
-- ======================
local humFolder = workspace:WaitForChild("Hum")
local ESPs = _G.CAT_ESP_DATA

-- ======================
-- FUNCIONES
-- ======================
local function getMainPart(model)
	return model:FindFirstChild("HumanoidRootPart")
		or model:FindFirstChildWhichIsA("BasePart")
end

local function createESP(targetModel)
	if not _G.CAT_ESP then return end
	if not targetModel then return end
	if ESPs[targetModel] then return end

	local mainPart = getMainPart(targetModel)
	if not mainPart then return end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = targetModel
	highlight.FillColor = Color3.fromRGB(255,140,0)
	highlight.OutlineColor = Color3.fromRGB(255,140,0)
	highlight.FillTransparency = 0.4
	highlight.OutlineTransparency = 0
	highlight.Parent = workspace

	local size = targetModel:GetExtentsSize()
	local offsetY = size.Y/2 + 1.5

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = mainPart
	billboard.Size = UDim2.new(0,120,0,30)
	billboard.StudsOffset = Vector3.new(0, offsetY, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = highlight

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.Text = targetModel.Name
	text.TextColor3 = Color3.fromRGB(255,140,0)
	text.TextStrokeTransparency = 0
	text.TextStrokeColor3 = Color3.new(0,0,0)
	text.TextSize = 30
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	ESPs[targetModel] = highlight
end

local function removeESP(model)
	if ESPs[model] then
		pcall(function()
			ESPs[model]:Destroy()
		end)
		ESPs[model] = nil
	end
end

-- ======================
-- LOOP (ACTUALIZA CADA 1 SEGUNDO)
-- ======================

task.spawn(function()
	while _G.CAT_ESP do
		
		local activeModels = {}

		for _, obj in pairs(humFolder:GetDescendants()) do
			if obj:IsA("Model") 
				and (obj.Name == "Man1" or obj.Name == "CatSit") 
				and obj.Parent 
				and obj.Parent.Name == "Cat" then
				
				activeModels[obj] = true
				createESP(obj)
			end
		end

		for model,_ in pairs(ESPs) do
			if not activeModels[model] then
				removeESP(model)
			end
		end

		task.wait(1) -- 🔥 actualiza cada 1 segundo
	end
end)
