real_mvp_badsport = ScriptThread("real_mvp_badsport") 


function real_mvp_badsport:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(0x64) then
		-- KEY: Numpad4
		for i= 1, 3 do
	--
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_BAD_SPORT_BITSET"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHEAT_BITSET"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_BECAME_BADSPORT_NUM"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_COMMEND_STRENGTH"), 100, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_FRIENDLY"), 100, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GAME_EXPLOITS"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GRIEFING"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_HELPFUL"), 100, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_ISPUNISHED"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OFFENSIVE_LANGUAGE"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OFFENSIVE_UGC"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OVERALL_CHEAT"), 0, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_REPORT_STRENGTH"), 32, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_VC_HATE"), 0, true)
					
	-- End of hashes.

        end
		print("You have successfully removed all reports, flags, and bad sport.")
		end
            self:Wait(50)
    end
end

function real_mvp_badsport:OnError()
    print("You done failed son!")
    self:Reset()
end

real_mvp_badsport:Register()