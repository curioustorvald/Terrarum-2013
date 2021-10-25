function getMedian()
--get from nearest 4 blocks
end

function buildLightmap()
--iterate over whole map or rendered 2 chunks
	local lightTable = {}
	local mapDataTerrain = map.layer.Terrain
	local mapDataWall = map.layer.Wall
	local mapW, mapH = map.width, map.height
	
	for i=1,mapH do
		lightTable[i] = {}
		for j=1,mapW do
			lightTable[i][j] = 0
			j=j+1
		end
		i=i+1
	end
	
	-- Main loop --
	---------------
	--1. Global lighting
	for i=1,mapH do
		for j=1,mapW do
			--check whether the area is empty; no wall, no terrain block
			if mapDataWall[i][j] == nil and mapDataTerrain[i][j] == nil then
				lightTable[i][j] = globalLightLevel
			--what to do next?
			elseif
			
			end
			
			j=j+1
		end
		i=i+1
	end
	--2. Add ambient
	
end

function addLightSource(lightLevel,xpos,ypos)

end