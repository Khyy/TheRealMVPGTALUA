real_mvp_rpgenfix = ScriptThread("real_mvp_rpgenfix") 


function real_mvp_rpgenfix:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(0x63) then
		-- KEY: Numpad3
		for i= 1, 3 do
	--
	-- Adjust your stars below. The 2043 is the number of stars attained, evaded, and times wanted. I suggest modifying them all namely the times wanted. As 2043 would equate to 1 star per wanted time.
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_STARS_ATTAINED"), 2043, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_STARS_EVADED"), 2043, true)
					natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_TIMES_WANTED_LEVEL"), 2043, true)
					
	-- End of hashes.

        end
		print("You have successfully fixed the RP Generator fuckery.")
		end
            self:Wait(50)
    end
end

function real_mvp_rpgenfix:OnError()
    print("You done failed son!")
    self:Reset()
end

real_mvp_rpgenfix:Register()