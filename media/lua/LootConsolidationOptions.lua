
LootConsolidation = _G['LootConsolidation'] or {}

 -- Should remove zombies after they've been consolidated?
 LootConsolidation.shouldRemove = false;

 -- What shouldn't be consolidated? Can be an item name or type
LootConsolidation.consolidationFilters = { "Base.Stake", "Clothing" };