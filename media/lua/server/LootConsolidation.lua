
LootConsolidation = _G['LootConsolidation'] or {}

LootConsolidation.Options = {
  -- Should remove zombies after they've been consolidated?
  shouldRemove = true,

  -- Search radius every time a zombie is killed
  radius = 2,

  -- Should the items consolidate by dropping to the "Floor"
  --  otherwise, they consolidate to a specific zombie.
  dropToFloor = true,

  -- Should we consolidate only items dropped from zombies
  onlyZombies = true,

  -- What shouldn't be consolidated? Can be an item name or type
  -- All "Clothing" is, by default, not consolidated.
  consolidationFilters = { "Stake", "Clothing", "nil" },
}

function LootConsolidation.isValidItem(item)
  print(tostring(item:getName()) .. " Category " .. tostring(item:getDisplayCategory()));
  for _,type in ipairs(LootConsolidation.Options.consolidationFilters) do
    if item:getDisplayCategory() == nil or item:getDisplayCategory() == type or item:getName() == type then
      return false
    end
  end

  return true
end

function LootConsolidation.transferItem(item, srcContainer, destContainer)
  if isClient() then
    destContainer:addItemOnServer(item);
    srcContainer:removeItemOnServer(item);
  else
    destContainer:addItem(item);
    srcContainer:Remove(item);
  end

  item:setAttachedSlot(-1);
  item:setAttachedSlotType(nil);
  item:setAttachedToModel(nil);

  srcContainer:setDrawDirty(true);
  srcContainer:setHasBeenLooted(true);
  destContainer:setDrawDirty(true);
end

function LootConsolidation.consolidateTo(zombie, radius)
  local cell = zombie:getCell();
  local sqs = {}

  local cx = zombie:getX();
  local cy = zombie:getY();
  local cz = zombie:getZ();

  for dy=-radius,radius do
    for dx=-radius,radius do
      local square = cell:getGridSquare(cx + dx, cy + dy, cz)
      if square then
        table.insert(sqs, square)
      end
    end
  end

  local destContainer = zombie:getInventory();

  for _,gs in ipairs(sqs) do
    -- stop moving items thru walls...
    local currentSq = zombie:getCurrentSquare()
    if gs ~= currentSq and currentSq and currentSq:isBlockedTo(gs) then
      gs = nil
    end

    if gs ~= nil then
      local deadBodies = gs:getDeadBodys();
      if deadBodies ~= nil then
        if deadBodies:size() ~= 0 then
          for i = 1, deadBodies:size() do
            local deadBody = deadBodies:get(i-1);
            if deadBody:isZombie() or not LootConsolidation.Options.onlyZombies then
              local srcContainer = deadBody:getContainer();
              local x = 0
              
              while x < srcContainer:getItems():size() do
                local item = srcContainer:getItems():get(x)
                if LootConsolidation.isValidItem(item) then
                  LootConsolidation.transferItem(item, srcContainer, destContainer);
                else
                  x = x + 1
                end
              end

              if LootConsolidation.Options.shouldRemove then
                deadBody:removeFromSquare();
                deadBody:removeFromWorld();
              end
            end
          end
        end
      end
    end
  end

  print("Loot Consolidated")
end

function LootConsolidation.OnZombieDead(zombie)
  local radius = LootConsolidation.Options.radius or 1;
  LootConsolidation.consolidateTo(zombie, radius);
end


Events.OnZombieDead.Add(LootConsolidation.OnZombieDead)