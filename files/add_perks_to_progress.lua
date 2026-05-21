local perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")
local enforce_perk_unlock_state = true


for index, perk in ipairs(perks) do
	if perk.perk_name:sub(1,1) ~= "$" then print("PERK [" .. perk.id .. "] NOT ADDED TO PROGRESS, NAME IS NOT TRANSLATION") goto continue end
	local perk_id = "divine_right_" .. perk.id

	RegisterPerk(
		perk_id,
		perk.perk_name,
		perk.perk_desc,
		perk.icon,
		perk.icon
	)
	::continue::
end

