local nxml = dofile_once("mods/divine_right/nxml/nxml.lua") ---@type nxml


local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. "\n" .. ModTextFileGetContent("mods/divine_right/files/standard.csv") .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)


ModLuaFileAppend("data/scripts/perks/perk_reflect.lua", "mods/divine_right/files/add_perks_to_progress.lua")

function OnWorldInitialized()
	local enforce_perk_unlock_state = true
	if enforce_perk_unlock_state ~= nil then
		local perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")

		for _,perk in ipairs(perks) do
			local flag_name_persistent = "perk_picked_divine_right_" .. perk.id
			if enforce_perk_unlock_state then
				AddFlagPersistent(flag_name_persistent)
				GameAddFlagRun("new_" .. flag_name_persistent)
			else
				RemoveFlagPersistent(flag_name_persistent)
				GameRemoveFlagRun("new_" .. flag_name_persistent)
			end
		end
	end
end