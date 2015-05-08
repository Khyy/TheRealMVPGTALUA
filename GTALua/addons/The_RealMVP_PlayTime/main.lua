real_mvp_playtime = ScriptThread("real_mvp_playtime") 


function real_mvp_playtime:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(0x66) then
		-- KEY: Numpad6
		for i= 1, 3 do
	--
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_TOTAL_PLAYING_TIME"), 792000000, true) -- Adjust your play time here in milliseconds. Default is 9 days.
					
	-- End of hashes.

        end
		print("You have successfully adjusted your playtime.")
		end
            self:Wait(50)
    end
end

function real_mvp_playtime:OnError()
    print("You done failed son!")
    self:Reset()
end

real_mvp_playtime:Register()