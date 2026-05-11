---@class (exact) enemy_perk
---@field id string Perk ID.
---@field perk_name string In-game name.
---@field perk_desc string In-game description.
---@field icon string Path to 12x12 icon used in-world.
---@field weight number? Default 10.
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
		id = "critical_hit", --enemy can deal critical hits (need to fake it, player cannot be crit)
		perk_name = "$divine_right.perkname_crit_plus",
		perk_desc = "$divine_right.perkdesc_crit_plus",
		icon = "mods/divine_right/files/icons_generic/critical_hit.png",
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
		id = "swapper", --when damanged, this enemy swaps places with the attacker
		icon = "mods/divine_right/files/icons_generic/swapper.png",
		perk_name = "$divine_right.perkname_swapper",
		perk_desc = "$divine_right.perkdesc_swapper",
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
	{
		id = "recycle_hp", --damage taken is redistributed as healing for nearby allies
		icon = "mods/divine_right/files/icons_generic/recycle_hp.png",
		perk_name = "$divine_right.perkname_recycle_hp",
		perk_desc = "$divine_right.perkdesc_recycle_hp",
		weight = 0,
	},
	{
		id = "bleed_lava", --enemy bleeds lava and is immune to fire and lava, but takes damage from water
		icon = "mods/divine_right/files/icons_generic/bleed_lava.png",
		perk_name = "$divine_right.perkname_bleed_lava",
		perk_desc = "$divine_right.perkdesc_bleed_lava",
		max_stacks = 1,
		condition = function(self, context) --enemy must not already have natural lava blood or any other blood perk
			return context.blood_material ~= "lava" and not context.blood_perk
		end,
		func = function(self, entity_id, copies, x, y)
			local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent")
			if not dmc then print("NO DMC FOUND TO MODIFY FOR BLEED_LAVA PERK, CHECK ENTITY " .. entity_id) return end

			EntitySetDamageFromMaterial(entity_id, "lava", 0)
			EntitySetDamageFromMaterial(entity_id, "water", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "mud", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "water_swamp", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "water_salt", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "swamp", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "snow", 0.0005)
			EntitySetDamageFromMaterial(entity_id, "water_ice", 0.0005)

			ComponentSetValue2(dmc, "blood_material", "lava")
			ComponentSetValue2(dmc, "blood_spray_material", "lava")
			ComponentSetValue2(dmc, "wet_status_effect_damage", "0.3")

			ComponentObjectSetValue2(dmc, "damage_multipliers", "fire", 0)
			ComponentObjectSetValue2(dmc, "damage_multipliers", "explosion",
				math.min(ComponentObjectGetValue2(dmc, "damage_multipliers", "explosion"), .4)
			)
		end,
		func_remove = function()

		end
	},
	{
		id = "gambling_debt",
		icon = "mods/divine_right/files/icons_generic/gambling_debt.png",
		perk_name = "$divine_right.perkname_gambling_debt",
		perk_desc = "$divine_right.perkdesc_gambling_debt",
	},
	{
		id = "extra_hp",
		icon = "mods/divine_right/files/icons_generic/extra_hp.png",
		perk_name = "$divine_right.perkname_extra_hp",
		perk_desc = "$divine_right.perkdesc_extra_hp",
	},
	{
		id = "martyr",
		icon = "mods/divine_right/files/icons_generic/martyr.png",
		perk_name = "$divine_right.perkname_martyr",
		perk_desc = "$divine_right.perkdesc_martyr",
	},
	{
		id = "diamond_nuggets",
		icon = "mods/divine_right/files/icons_generic/diamond_nuggets.png",
		perk_name = "$divine_right.perkname_diamond_nuggets",
		perk_desc = "$divine_right.perkdesc_diamond_nuggets",
	},
	{
		id = "wet_aura",
		icon = "mods/divine_right/files/icons_generic/wet_aura.png",
		perk_name = "$divine_right.perkname_wet_aura",
		perk_desc = "$divine_right.perkdesc_wet_aura",
	},
	{
		id = "berserker",
		icon = "mods/divine_right/files/icons_generic/berserker.png",
		perk_name = "$divine_right.perkname_berserker",
		perk_desc = "$divine_right.perkdesc_berserker",
	},
	{
		id = "unstable_mass",
		icon = "mods/divine_right/files/icons_generic/unstable_mass.png",
		perk_name = "$divine_right.perkname_unstable_mass",
		perk_desc = "$divine_right.perkdesc_unstable_mass",
	},
	{
		_disabled = true,
		id = "",
		icon = "mods/divine_right/files/icons_generic/.png",
		perk_name = "$divine_right.perkname_",
		perk_desc = "$divine_right.perkdesc_",
	},
}

--this is useful for testing, but should be removed before mod release
local perks_to_remove = {}

do_mod_appends("mods/divine_right/files/enemy_perks_list.lua")
for index, perk in ipairs(perks) do
	perk.weight = perk.weight or 10
	if not ModDoesFileExist(perk.icon or "") then
		perk.icon = "mods/divine_right/files/enemy_perk_background.png"
	end

	-- if the condition is static and false, remove perk from list 
	if perk._disabled then perks_to_remove[#perks_to_remove+1] = index end
end

for i = 1, #perks_to_remove do
	table.remove(perks, perks_to_remove[#perks_to_remove-i+1])
end

return perks