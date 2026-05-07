local perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")
local enforce_perk_unlock_state = true


for index, perk in ipairs(perks) do
	if perk.ui_name:sub(1,1) ~= "$" then print("PERK " .. perk.id .. " NOT ADDED TO PROGRESS, NAME IS NOT TRANSLATION") goto continue end
	local perk_id = "divine_right_" .. perk.id
	perk_list[#perk_list+1] = {
		id = perk_id,
		ui_name = perk.ui_name,
		ui_description = perk.description,
		perk_icon = perk.icon,
		ui_icon = perk.icon,
		max_in_perk_pool = 0,
		not_in_default_perk_pool = true,
	}

	if enforce_perk_unlock_state ~= nil then
		local flag_name_persistent = "perk_picked_" .. perk_id
		if enforce_perk_unlock_state then
			AddFlagPersistent(flag_name_persistent)
			GameAddFlagRun("new_" .. flag_name_persistent)
		else
			RemoveFlagPersistent(flag_name_persistent)
			GameRemoveFlagRun("new_" .. flag_name_persistent)
		end
	end
	::continue::
end

