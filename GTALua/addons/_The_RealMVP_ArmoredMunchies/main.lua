real_mvp_armoredmunchies = ScriptThread("real_mvp_armoredmunchies") 


function real_mvp_armoredmunchies:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(0x69) then
		-- KEY: Numpad9
		for i= 1, 3 do
	--
	
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_ARMOUR_1_COUNT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_ARMOUR_2_COUNT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_ARMOUR_3_COUNT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_ARMOUR_4_COUNT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_ARMOUR_5_COUNT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CIGARETTES_BOUGHT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_1_BLUE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_1_RED"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_1_WHITE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_2_BLUE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_2_RED"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_2_WHITE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_3_BLUE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_3_RED"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_3_WHITE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_4_BLUE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_4_RED"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_FIREWORK_TYPE_4_WHITE"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_BOUGHT_EPIC_SNACKS"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_BOUGHT_HEALTH_SNACKS"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_BOUGHT_YUM_SNACKS"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_OF_BOURGE_BOUGHT"), 420, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_OF_ORANGE_BOUGHT"), 420, true)
					
	-- End of hashes.

        end
		print("You have successfully added 420yoloblazeit amounts of armour, fireworks, and food.")
		end
            self:Wait(50)
    end
end

function real_mvp_armoredmunchies:OnError()
    print("You done failed son!")
    self:Reset()
end

real_mvp_armoredmunchies:Register()