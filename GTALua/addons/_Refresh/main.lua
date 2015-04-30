fotwenty_blazeit = ScriptThread("fotwenty_blazeit") 


function fotwenty_blazeit:Run()
    local playerPedId = {0, 1, 2}
    
    while self:IsRunning() do
        if IsKeyDown(110) then
		for i= 1, 3 do
		natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MP_CHAR_ARMOUR_5_COUNT"), 420, true)
		natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_BOUGHT_EPIC_SNACKS"), 420, true)
        end
		print("420 Blazeit Fugut")
		end
            self:Wait(50)
    end
end

function fotwenty_blazeit:OnError()
    print("You done failed son!")
    self:Reset()
end

fotwenty_blazeit:Register()