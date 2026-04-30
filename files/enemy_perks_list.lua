local perks = {
	{
		id = "critical_hit",
		icon = "",
		condition = false,
		game_effect = nil,
		load_entity = nil,
		func = function(entity_id, copies, x, y)
		end,
		func_remove = function(entity_id, copies, x, y)
		end
	},
	{
		id = "swapper",
		icon = "",
		func = function(entity_id, copies, x, y)
			EntityAddComponent2(entity_id, "LuaComponent", {
				script_damage_received = "mods/divine_right/files/scripts/swapper.lua"
			})
		end,
		func_remove = function(entity_id)
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
end
return perks