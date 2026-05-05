---@class (exact) enemy_perk
---@field id string Perk ID.
---@field ui_name string In-game name.
---@field description string In-game description.
---@field icon string Path to 12x12 icon used in-world.
---@field weight number? Default 10.
---@field progress_icon string? Path to 12x12 icon used in progress menu. If blank, mod will automatically add a red border to the perk.
---@field max_stacks number? Max number of times an enemy can roll this perk, infinite if nil.
---@field condition bool|function? If set, condition must pass in order for the perk to be chosen. Function can be used here to additionally modify the perk itself, including probability
---@field game_effect string? If set, will add a `GameEffectComponent` to the perk entity with `game_effect` as its ID.
---@field load_entity string? If set, will load target entity as the base for the perk entity as a child to the perk owner.
---@field func function? The function that's run when the perk is added.
---@field func_remove function? The function that's run when the perk is removed.
---
---Generic optional vals used for some stuff
---@field blood_perk bool?


---@type enemy_perk[]
local perks = {
	{
		id = "critical_hit",
		ui_name = "",
		description = "",
		icon = "",
		progress_icon = nil,
		max_stacks = 3,
		condition = nil,
		game_effect = nil, --load game effect
		load_entity = nil,
		func = function(entity_id, copies, x, y)
		end,
		func_remove = function(entity_id, copies, x, y)
		end
	},
	{
		id = "swapper",
		icon = "",
		ui_name = "",
		description = "",
		progress_icon = "",
		max_stacks = 1,
		func = function(self, entity_id, copies, x, y)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_damage_received = "mods/divine_right/files/scripts/swapper.lua"
			})
		end,
		func_remove = function(self, entity_id) --func remove may not require `self`, will retract this param if i end up never using it
			for _,comp in ipairs(EntityGetComponent(entity_id, "LuaComponent") or {}) do
				if ComponentGetValue2(comp, "script_damage_received") == "mods/divine_right/files/scripts/swapper.lua" then
					EntityRemoveComponent(entity_id, comp)
					return
				end
			end
		end
	},
}



do_mod_appends("mods/divine_right/files/enemy_perks_list.lua")
for index, perk in ipairs(perks) do
	perk.weight = perk.weight or 10
	if not ModDoesFileExist(perk.icon or "") then
		perk.icon = "mods/divine_right/files/perk_bg.png"
		if not ModDoesFileExist(perk.progress_icon or "") then
			perk.icon = "mods/divine_right/files/perk_progress_bg.png"
		end
	elseif not ModDoesFileExist(perk.progress_icon or "") then
		
	end
end
return perks