dofile_once("mods/divine_right/files/utilities.lua")

local perks = dofile_once("mods/divine_right/files/enemy_perks_list.lua")
local ng_plus_iter = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT")) or 0
local drh

function EnemyApplyPerk(entity_id, x, y, perk)
	if perk.func then
		perk:func(entity_id)
	end
end

local function PickRandomPerk(perk_list, additional_context)
	local context = {
		int_possessed_perks = 0, --the number of perks the target already possesses before adding a new one
		current_perks = {},
		perks_to_add = 1, --presume only one perk is being added if additional_context doesn't override
	}

	if additional_context then
		for key, value in pairs(additional_context) do
			context[key] = value
		end
	end


	local valid_perks = {}
	for _, entry in ipairs(perk_list) do
		if (type(entry.condition) == "function" and not entry:condition(context)) --if condition has failed (runs first for pre-processing purposes)
			or (context.current_perks[entry.id] and context.current_perks[entry.id] >= entry.max_stacks) --if current stacks is equal to or more than max stacks
		then goto continue end
		valid_perks[#valid_perks+1] = entry
		::continue::
	end

	if #valid_perks == 0 then print("NO PERKS MEET CONDITIONS") return nil,context end

	local total_weight = 0
	for _, entry in ipairs(valid_perks) do
		total_weight = total_weight + entry.weight
	end

	local rnd = Randomf(0, total_weight)
	for _, entry in ipairs(valid_perks) do
		if rnd <= entry.weight then
			return entry,context
		else rnd = rnd - entry.weight end
	end
	return valid_perks[#valid_perks],context --Randomf has OOB issue
end


function EnemyGrantRandomPerks(entity_id, x, y)
	SetRandomSeed(entity_id - y, x)

	--50% chance to add 1 perk per NG+
	local perks_to_grant = 1
	for i = 1, ng_plus_iter do
		if Random() < .5 then perks_to_grant = perks_to_grant + 1 end
	end

	--recursively roll a 30% chance
	local function add_perk(n)
		if Random() < .3 then
			return add_perk(n + 1)
		end
		return n
	end

	perks_to_grant = perks_to_grant + add_perk(0)

	if perks_to_grant == 0 then return 0 end
	local context = {}
	for i = 1, perks_to_grant do
		local new_perk,new_context = PickRandomPerk(perks, context)
		context = new_context
		EnemyApplyPerk(new_perk)
	end

	--EnemyApplyPerk(entity_id, x, y, perks[#perks])
end



local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

function init()
	for index, child in ipairs(EntityGetAllChildren(entity_id) or {}) do
		if EntityGetName(child) == "divine_rights_handler" then
			drh = child
		end
	end

	if drh == nil then
		drh = EntityLoad("mods/divine_right/files/divine_rights_handler.xml")
		EntityAddChild(entity_id, drh)
	end

	EnemyGrantRandomPerks(entity_id, x, y)
end