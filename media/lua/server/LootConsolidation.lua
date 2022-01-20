
LootConsolidation = _G['LootConsolidation'] or {}

if isClient() then return end
local Commands = {}

function Commands.getDeadZombieItemsInCell(cell)
  local zombies = cell:getZombieList();

  for i=0,zombies:size()-1 do
    if zombies:get(i):isDead() then
      return "Consolidated";
    end
  end
end

function Commands.requestItems(player, args)
  local test = LootConsolidation.getDeadZombieItemsInCell(player:getCell());
  print(test);
end

-- Params:
-- IsoZombie zombie (extends IsoGameCharacter, IsoMovingObject, IsoObject)
function LootConsolidation.OnZombieDead(zombie, args)
  print("LootConsolidation OnZombieDead");
  print("Zombie: " .. tostring(zombie))

  local cell = zombie:getCell();
  local items = LootConsolidation.getDeadZombieItemsInCell(cell)
end

function LootConsolidation.OnClientCommand(module, command, player, args)
  if module ~= "LootConsolidation" then return end

  print("Client command dispatched for LootConsolidation");

  if Commands[command] then
    Commands[command](player, args)
  end
end

Events.OnZombieDead.Add(LootConsolidation.OnZombieDead)
Events.OnClientCommand.Add(LootConsolidation.OnClientCommand)