function damage_received(_,_,perpetrator)
	if perpetrator then
		local entity_id = GetUpdatedEntityID()
		local x1,y1 = EntityGetTransform(entity_id)
		local x2,y2 = EntityGetTransform(perpetrator)
		EntitySetTransform(entity_id, x2, y2)
		EntitySetTransform(perpetrator, x1, y1)
	end
end