function death(type, message, attacker, drop_items)
    local x,y = EntityGetTransform(GetUpdatedEntityID())
    EntityLoad("data/entities/projectiles/deck/black_hole_big.xml", x, y)
end