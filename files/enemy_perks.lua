dofile_once("mods/divine_right/files/utilities.lua")

local perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")
local ng_plus_iter = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT")) or 0
local dr_comp

function EnemyApplyPerk(entity_id, x, y, perk)
	if perk.func then
		perk.func(entity_id)
	end
end

function EnemyGrantRandomPerks(entity_id, x, y)
	SetRandomSeed(entity_id - y, x)

	local perks_to_grant = 1
	for i = 1, ng_plus_iter do
		if Random() < .5 then perks_to_grant = perks_to_grant + 1 end
	end

	local function add_perk(n)
		if Random() < .3 then
			return add_perk(n + 1)
		end
		return n
	end

	perks_to_grant = perks_to_grant + add_perk(0)

	if perks_to_grant == 0 then return 0 end
	for i = 1, perks_to_grant do
		--EnemyApplyPerk(RandomFromTableConditional(perks))
	end

	EnemyApplyPerk(entity_id, x, y, perks[#perks])
end



local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

function init()
	for index, varcomp in ipairs(EntityGetComponent(entity_id, "VariableStorageComponent") or {}) do
		if ComponentGetValue2(varcomp, "name") == "divine_rights" then print(entity_id) return end
	end

	dr_comp = EntityAddComponent2(entity_id, "VariableStorageComponent", {
		name = "divine_rights"
	})

	EnemyGrantRandomPerks(entity_id, x, y)
end