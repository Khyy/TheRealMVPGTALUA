real_mvp_leveler = ScriptThread("real_mvp_leveler") 


function real_mvp_leveler:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(0x65) then
		-- KEY: Numpad5
		for i= 1, 3 do
	--
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_XP_FM"), 2284550, true) -- Adjust your desired level here through XP required for the level.
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GLOBALXP"), 2284550, true) -- Adjust your combined (between all characters) XP earned.
					
	-- End of hashes.

        end
		print("Your level has successfully been adjusted.")
		end
            self:Wait(50)
    end
end

function real_mvp_leveler:OnError()
    print("You done failed son!")
    self:Reset()
end

real_mvp_leveler:Register()