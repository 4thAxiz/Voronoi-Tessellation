-- Author: 4thAxis
-- 04/05/21

local module = {}

--------------------------------------------------------------------
---------------------------  Imports  ------------------------------
--------------------------------------------------------------------

local RunService = game:GetService("RunService")

--------------------------------------------------------------------
--------------------------  Constants  -----------------------------
-------------------------------------------------------------------- 

local DefaultRows = 100
local DefaultColomns = 100
local DefaultCendriodPoints = 50

-------------------------------------------------------------------
------------------------ Helpers/Private  -------------------------
-------------------------------------------------------------------

local function DistanceBetween(Point1, Point2)
	return ((Point1.X-Point2.X)^2 + (Point1.Y-Point2.Y)^2 + (Point1.Z-Point2.Z)^2)
end


local function NewMetricSpace(Rows, Colomns)
	local MetricSpace = table.create(Rows * Colomns) 

	for X = 0, Rows do
		for Z = 0, Colomns do
			table.insert(MetricSpace, Vector3.new(X, 0, Z))
		end
	end

	return MetricSpace
end


local function CreateCentriods(Rows, Colomns)
	local CentroidPoints = table.create(DefaultCendriodPoints)

	for _ = 1, DefaultCendriodPoints do
		table.insert(CentroidPoints, Vector3.new(math.random(1, Rows),0 , math.random(1, Colomns)))
	end
	
	return CentroidPoints
end


local function GetRegions(Centriods)
	local Regions = {}
	
	for Point in ipairs(Centriods) do
		Regions[Point] = {}
	end
	
	return Regions
end


-------------------------------------------------------------------
--------------------------- Functions  ----------------------------
-------------------------------------------------------------------


function module.NewVoronoi(Settings)
	Settings = Settings or {
		Row = DefaultRows,
		Colomns = DefaultColomns,
		CentroidPoints = nil
	} 
	
	local Rows = Settings.Rows or DefaultRows
	local Colomns = Settings.Colomns or	DefaultColomns
	
	local CentroidPoints = Settings.CentroidPoints or CreateCentriods(Rows, Colomns)
	
	local MetricSpace = NewMetricSpace(Rows, Colomns)
	local Regions = GetRegions(CentroidPoints)
	
	
	local DistanceIndexPairs = {}
	local SortedDistance = {}
	
	for _, Point in ipairs(MetricSpace) do

		for Index, SpecialPoint in ipairs(CentroidPoints) do
			DistanceIndexPairs[Index] = {DistanceBetween(Point, SpecialPoint), Index}
			SortedDistance[Index] = DistanceBetween(Point, SpecialPoint)
		end

		table.sort(SortedDistance)
		local Lowest = SortedDistance[1]
		local Index

		for _, DistanceIndexPair in ipairs(DistanceIndexPairs) do
			if DistanceIndexPair[1] == Lowest then
				Index = DistanceIndexPair[2]
			end
		end
		
		table.insert(Regions[Index], Point)
	end
	
	return Regions
end


function module.Visualize(Regions, PartHeight)
	Regions = Regions or module.NewVoronoi()
	PartHeight = PartHeight or 1
	
	for _, Region in pairs(Regions) do
		local Color = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))

		for Index = 1, #Region do
			local Position = Region[Index]
			local Part = Instance.new("Part")

			Part.Position = Position
			Part.Color = Color
			Part.Anchored = true
			Part.Parent = workspace
			Part.Size = Vector3.new(1 ,PartHeight, 1)
		end
	end
end


return module
