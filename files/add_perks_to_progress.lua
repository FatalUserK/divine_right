local dr_perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")


for index, perk in ipairs(dr_perks) do
	local not_progress
	if perk.perk_name:sub(1,1) ~= "$" then
		print("PERK [" .. perk.id .. "] NOT ADDED TO PROGRESS, NAME IS NOT TRANSLATION")
		not_progress = true
	elseif perk.not_progress then
		not_progress = true
	end

	if not not not not_progress then
		local perk_id = "divine_right_" .. perk.id

		RegisterPerk(
			perk_id,
			perk.perk_name,
			perk.perk_desc,
			perk.icon,
			perk.icon
		)
	end
end

