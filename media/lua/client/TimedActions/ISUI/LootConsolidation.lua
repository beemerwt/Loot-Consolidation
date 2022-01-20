
LootConsolidation = _G['LootConsolidation'] or {}
LootConsolidation.filterIcon = getTexture("media/ui/Container_Floor.png");

-- Each call to these functions iterates through one "container"
-- The selected container from the player at the moment of updating
local Inventory = {}

Inventory['begin'] = function(container)
  -- called after getting the Floor Container?
end

Inventory['beforeFloor'] = function(container)
  -- called before adding floor to container
end

Inventory['buttonsAdded'] = function(container)

end

Inventory['end'] = function(container)
  -- is the last call in the stack
end

function LootConsolidation.getNearbyDeadZombies(playerNum)
	if LootConsolidation.nearbyLootContainer == nil then
		LootConsolidation.nearbyLootContainer = {}
	end
	if LootConsolidation.nearbyLootContainer[playerNum+1] == nil then
		LootConsolidation.nearbyLootContainer[playerNum+1] = ItemContainer.new("nearby", nil, nil, 10, 10)
		LootConsolidation.nearbyLootContainer[playerNum+1]:setExplored(true)
	end
	return LootConsolidation.nearbyLootContainer[playerNum+1]
end

function LootConsolidation.refreshInventories(container, stage)
  Inventory[stage](container)
end

Events.OnRefreshInventoryWindowContainers.Add(LootConsolidation.refreshInventories)

