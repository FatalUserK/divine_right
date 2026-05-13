local nxml = dofile_once("mods/divine_right/nxml/nxml.lua") ---@type nxml

local list = {
	"data/entities/animals/lukki/lukki_tiny.xml",
	"data/entities/animals/lukki/lukki_longleg.xml",
	"data/entities/animals/lukki/lukki_creepy_long.xml",
	"data/entities/animals/lukki/lukki_creepy.xml",
	"data/entities/animals/lukki/lukki_dark.xml",
	"data/entities/buildings/snowcrystal.xml",
	"data/entities/buildings/hpcrystal.xml",
	"data/entities/animals/illusions/dark_alchemist.xml",
	"data/entities/animals/illusions/shaman_wind.xml",
	"data/entities/animals/parallel/alchemist/parallel_alchemist.xml",
	"data/entities/animals/boss_ghost/boss_ghost_polyp.xml",
	"data/entities/animals/boss_spirit/islandspirit.xml",
	"data/entities/animals/boss_fish/fish_giga.xml",
	"data/entities/animals/parallel/tentacles/parallel_tentacles.xml",
	"data/entities/animals/special/minipit.xml",
	"data/entities/animals/boss_gate/gate_monster_a.xml",
	"data/entities/animals/boss_gate/gate_monster_b.xml",
	"data/entities/animals/boss_gate/gate_monster_c.xml",
	"data/entities/animals/boss_gate/gate_monster_d.xml",
}

dofile_once("data/scripts/perks/perk_list.lua")
print("aaaaaaaaaaaaaaaa")
print(#perk_list)

local exists = 0
local no_exists = 0
for name in string.gmatch(ModTextFileGetContent("data/ui_gfx/animal_icons/_list.txt"):gsub("\r", ""), '([^\n]+)') do
	local value = "data/entities/animals/" .. name .. ".xml"
	local found
	if ModDoesFileExist(value) then
		list[#list+1] = value
		exists = exists + 1
		found = true
	end

	local value2 = "data/entities/animals/" .. name .. "/" .. name .. ".xml"
	if ModDoesFileExist(value2) then
		list[#list+1] = value2
		found = true
	end

	if not found then
		no_exists = no_exists + 1
	end
end

local luacomp = nxml.new_element("LuaComponent", {
	script_source_file = "mods/divine_right/files/enemy_perks.lua",
	execute_on_added = "1",
	call_init_function = "1",
	remove_after_executed = "1",
})

for index, target in ipairs(list) do
	for xml in nxml.edit_file(target) do
		xml:add_child(luacomp)
	end
end


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