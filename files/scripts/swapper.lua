function damage_received(_,_,attacker)
	if attacker then
		local entity_id = GetUpdatedEntityID()
		if EntityHasTag(attacker, "no_swap") or EntityHasTag(entity_id, "no_swap") then return end
		GameEntityPlaySound(entity_id, "game_effect/teleport/tick")
		GameEntityPlaySound(attacker, "game_effect/teleport/tick")
		local x1,y1 = EntityGetTransform(entity_id)
		local x2,y2 = EntityGetTransform(attacker)
		EntitySetTransform(entity_id, x2, y2)
		EntitySetTransform(attacker, x1, y1)
	end
end