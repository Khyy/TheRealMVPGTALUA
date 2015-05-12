--[[
########################################################################################################
								||||The Real MVP Version 0.1a||||
								
Changelog 0.1a

* Cleaned the menu up to best resemble what I find flawless as fuck.
* Added a couple of selections that can be seen at the bottom functions
* Put in support for XP amounts below as well as stars and etc.
* Proper credits and version number added to menu. Clicking version will hit the console with a direct link to my repo.

Changelog 0.07:

* Updated to latest GTALUA 1.1.0 RELEASE version.
* Sorted the hashes and removed duplicates.
* Got rid of submenus. Ultimately was decided they're not needed for a release like this.
* Added DLC content through merge of latest hotkey binded menu.
* Prepared for final release.								

								
Changelog 0.06:

* Updated to latest GTALUA R90 Snapshot version.
* Categorized all of the unlocks, stat edits, etc. You're no longer forced into a full mod.
* Fixed stats not saving properly on profiles.
* Added/removed a couple of hashes that were and weren't needed.
* Introduced the seamless menu using GTALUA's new wrapper features.
########################################################################################################

Credits:

* Kyron | Lord.
* kmcgurty1 | For the menu base.
* gir489 | For the origins with Zero2Hero. Since been heavily modified.
* freakyy | For GTALUA and his support/allowing me early tests.

]]

main = ScriptThread("real_mvp")

-- Begin your adjustable amounts here. This was put in for easy use to those of you looking to customize the amount of XP and such earned.

lvlXP = 284550 -- The amount of XP to adjust. Apply the amount of XP needed per level to adjust your level.
globalXP = 284550 -- The amount of global XP. Combine all characters XP amount for this value.
timePlayed = 792000000 -- Time played in milliseconds. Maximum of 23 days unless you use increment.
starAmount = 2043 -- The amount of stars to adjust your RP generator fuckery (attained & evaded).
timesWanted = 2043 -- The amount of times wanted to adjust your RP generator fuckery.

--

function GUIinit()
	GUI = {}
	GUI.menu = {}
	GUI.buttons = {}
	GUI.navButtons = 	{
					["menuOpen"] = 
					{
						["keys"] = {},
						["menu"] = ""
					}, 
					["menuPrev"] = {["keys"] = {}},
					["navUp"] = {["keys"] = {}},
					["navDown"] = {["keys"] = {}},
					["select"] = {["keys"] = {}},
					["navBack"] = {["keys"] = {}}
				}
	GUI.activeButton = 1
	GUI.activeMenu = ""
	GUI.statusText = {["text"] = "", ["time"] = 0}

	function GUI.createMenu(menuName, prevMenu, title, xpos, ypos, xscale, yscale, buttonSpacing, textScale, font)
		if(GUI.menu[menuName] == nil) then
			GUI.menu[menuName] = {}
			lastOffset = ypos + yscale + buttonSpacing
		end

		GUI.menu[menuName] = {
			["prevMenu"] = prevMenu,
			["title"] = title,
			["xpos"] = xpos,
			["ypos"] = ypos,
			["xscale"] = xscale,
			["yscale"] = yscale,
			["spacing"] = buttonSpacing,
			["lastOffset"] = lastOffset,
			["numButtons"] = 0,
			["textScale"] = textScale,
			["font"] = font
		}
	end
	
	function GUI.addButton(parentMenu, text, funct, args, toggleable, textScale, font)
	
		if(GUI.buttons[parentMenu] == nil or GUI.buttons[parentMenu]["settings"] == nil) then
			GUI.buttons[parentMenu] = {["settings"] = {}}
		end

		local currButtonNum = #GUI.buttons[parentMenu].settings + 1
		GUI.menu[parentMenu].numButtons = currButtonNum

		if(toggleable) then
			toggledOn = false
		else
		    toggledOn = nil
		end

		GUI.buttons[parentMenu].settings[currButtonNum] = {
			["parentMenu"] = parentMenu,
			["text"] = text,
			["funct"] = funct,
			["args"] = args,
			["font"] = font,
			["xpos"] = GUI.menu[parentMenu].xpos,
			["ypos"] = GUI.menu[parentMenu].lastOffset,
			["xscale"] = GUI.menu[parentMenu].xscale,
			["yscale"] = GUI.menu[parentMenu].yscale,
			["textScale"] = textScale,
			["toggleable"] = toggleable,
			["toggledOn"] = toggledOn
		}

		GUI.menu[parentMenu]["lastOffset"] = (GUI.menu[parentMenu].lastOffset + GUI.menu[parentMenu].yscale + GUI.menu[parentMenu].spacing)
	end

	function GUI.setActiveMenu(menuName)
		GUI.activeButton = 1
		GUI.activeMenu = menuName
	end

	function GUI.updateStatusText(text, time)
		GUI.statusText = {["text"] = text, ["time"] = time}
	end

	function GUI.isButtonToggledOn()
		local activeButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]
		if(activeButton.toggleable) then
			return activeButton.toggledOn
		elseif(activeButton.toggleable == flse) then
			print("Button \"", GUI.buttons[GUI.activeMenu].settings[GUI.activeButton].text, "\" isn't toggleable!")
		    return nil
		end
	end

	function GUI.toggleButtonState()
		local activeButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]
		
		if(GUI.isButtonToggledOn() and activeButton.toggleable) then
			activeButton.toggledOn = false
		elseif(GUI.isButtonToggledOn() == false and activeButton.toggleable) then
			activeButton.toggledOn = true
		end
	end

	
	function GUI.removeButton()
	end
	
	
	function GUI.removeMenu()
	end

	function GUI.drawStatusText()

		if(nextDrawTime == nil or prevText ~= GUI.statusText.text) then
			nextDrawTime = natives.GAMEPLAY.GET_GAME_TIMER() + GUI.statusText.time
		end

		if(nextDrawTime > natives.GAMEPLAY.GET_GAME_TIMER()) then
			prevText = GUI.statusText.text
			natives.UI.SET_TEXT_FONT(1)
			natives.UI.SET_TEXT_SCALE(0.55, 0.55)
			natives.UI.SET_TEXT_COLOUR(255, 255, 255, 255)
			natives.UI.SET_TEXT_WRAP(0.0, 1.0)
			natives.UI.SET_TEXT_CENTRE(true)
			natives.UI.SET_TEXT_DROPSHADOW(1, 1, 1, 1, 1)
			natives.UI.SET_TEXT_EDGE(1, 0, 0, 0, 205)
			natives.UI._SET_TEXT_ENTRY("STRING")
			natives.UI._ADD_TEXT_COMPONENT_STRING(GUI.statusText.text)
			natives.UI._DRAW_TEXT(0.5, 0.005)
		else
			
			GUI.statusText = {["text"] = "", ["time"] = 0}
			nextDrawTime = nil
		end
	end

	function GUI.drawGUI()

		if(GUI.activeMenu ~= "" and GUI.activeMenu ~= nil) then
			local name = GUI.activeMenu

			if(GUI.menu[name] ~= nil) then
				
				local xpos = GUI.menu[name].xpos
				local ypos = GUI.menu[name].ypos
				local xscale = GUI.menu[name].xscale
				local yscale = GUI.menu[name].yscale
				
				local text = GUI.menu[name].title
				local textScale = GUI.menu[name].textScale
				local font = GUI.menu[name].font
				local colors = {["r"] = 94, ["g"] = 130, ["b"] = 194, ["o"] = 255} -- Title bar.

				addButtonText(text, xpos, ypos, textScale, font)
				natives.GRAPHICS.DRAW_RECT(xpos, ypos, xscale, yscale, colors.r, colors.g, colors.b, colors.o);

				if(GUI.buttons[name] ~= nil) then
					for i, v in pairs(GUI.buttons[name].settings) do
						local buttonSettings = GUI.buttons[name].settings[i]
						local xpos = buttonSettings.xpos
						local ypos = buttonSettings.ypos
						local xscale = buttonSettings.xscale
						local yscale = buttonSettings.yscale
						
						local font = buttonSettings.font
						local text = buttonSettings.text
						local textScale = buttonSettings.textScale
						local colors = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["o"] = 100} -- Menu bar

						if(buttonSettings.toggledOn == true) then
							text = buttonSettings.text .. " [ON]"
						elseif(buttonSettings.toggledOn == false) then
							text = buttonSettings.text .. " [OFF]"
						end
						
						if(i == GUI.activeButton) then
							colors = {["r"] = 75, ["g"] = 75, ["b"] = 75, ["o"] = 150} -- Highlight bar
						end

						addButtonText(text, xpos, ypos, textScale, font)
						natives.GRAPHICS.DRAW_RECT(xpos, ypos, xscale, yscale, colors.r, colors.g, colors.b, colors.o);
					end
				else
					print("No buttons associated with menu: ", GUI.activeMenu)
					GUI.setActiveMenu("")
				end
			else
				print("No menu created with the name: ", GUI.activeMenu)
				GUI.setActiveMenu("")
			end
		end
	end

	function addButtonText(text, xpos, ypos, textScale, font)
		if(text ~= nil and xpos ~= nil and ypos ~= nil and textScale ~= nil and font ~= nil) then
			natives.UI.SET_TEXT_FONT(font)
			natives.UI.SET_TEXT_SCALE(0.55, textScale)
			natives.UI.SET_TEXT_COLOUR(255, 255, 255, 200)
			natives.UI.SET_TEXT_CENTRE(true)
			natives.UI.SET_TEXT_DROPSHADOW(1, 1, 1, 1, 1)
			natives.UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
			natives.UI._SET_TEXT_ENTRY("STRING")
			natives.UI._ADD_TEXT_COMPONENT_STRING(text)
			natives.UI._DRAW_TEXT(xpos, ypos - 0.0125)
		else
			print("text: ", text, ", xpos: ", xpos, ", ypos: ", ypos, ", textScale: ", textScale, ", font: ", font)
		    print("There seems to be a nil value when trying to add text to button (see above)")
		    GUI.setActiveMenu("")
		end
	end

	function GUI.tick()

		GUI.drawStatusText()
		GUI.drawGUI()

		for i, key in pairs(GUI.navButtons.menuOpen.keys) do
			if(IsKeyDown(key)) then
				if(GUI.activeMenu == GUI.navButtons.menuOpen.menu) then
				
					GUI.setActiveMenu(GUI.menu[GUI.activeMenu].prevMenu)
				else
					
				    GUI.setActiveMenu(GUI.navButtons.menuOpen.menu)
				    GUI.currentSelection = 1
					getCredits()
				end
			end
		end

		
		for k, key in pairs(GUI.navButtons.navUp.keys) do
			if(IsKeyDown(key) and GUI.activeMenu ~= "") then
				GUI.activeButton = GUI.activeButton - 1

				
				if(GUI.activeButton <= 0) then
					GUI.activeButton = GUI.menu[GUI.activeMenu].numButtons
				end
			end
		end

		
		for k, key in pairs(GUI.navButtons.navDown.keys) do
			if(IsKeyDown(key) and GUI.activeMenu ~= "") then
				GUI.activeButton = GUI.activeButton + 1
				
				
				if(GUI.activeButton > GUI.menu[GUI.activeMenu].numButtons) then
					GUI.activeButton = 1
				end
			end
		end

		
		for k, key in pairs(GUI.navButtons.select.keys) do
			if(IsKeyDown(key) and GUI.activeMenu ~= "") then
				local currButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]
				
				
				if(type(currButton.funct) == "function" and type(currButton.args) == "table") then
					GUI.toggleButtonState()
					currButton.funct(currButton.args[1], currButton.args[2], currButton.args[3], currButton.args[4], currButton.args[5], currButton.args[6], currButton.args[7], currButton.args[8], currButton.args[9], currButton.args[10], currButton.args[11], currButton.args[12], currButton.args[13], currButton.args[14], currButton.args[15], currButton.args[16], currButton.args[17], currButton.args[18], currButton.args[19], currButton.args[20])

				elseif(type(currButton.funct) == "function" and type(currButton.args) == "string" or type(currButton.args) == "number"or type(currButton.args) == "boolean") then
					GUI.toggleButtonState()
					currButton.funct(currButton.args)
					
				elseif(currButton.args == nil) then
					GUI.toggleButtonState()
					currButton.funct()

				else
					print("function: ", currButton.funct, ", args: ", currButton.args)
					print("Error: button \"", GUI.buttons[GUI.activeMenu].settings[GUI.activeButton].text, "\" doesn't seem to have a function or the arguments are invalid. Are you calling it correctly?" )
				end
			end
		end

		for k, key in pairs(GUI.navButtons.navBack.keys) do
			if(IsKeyDown(key) and GUI.activeMenu ~= "") then
				GUI.setActiveMenu(GUI.menu[GUI.activeMenu].prevMenu)
			end
		end
	end

	return GUI
end

--########################################################################
--functions for the buttons when pressed

function raceUnlocks()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_RACES_WON"), 100,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_SLIPSTREAMS_IN_RACE"), 110,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_TURBO_STARTS_IN_RACE"), 90,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINSEARACE"), 10,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINAIRRACE"), 1,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_RACES_FASTEST_LAP"), 50,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMRALLYWONDRIVE"), 10,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_USJS_FOUND"), 50,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_USJS_COMPLETED"), 50,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_RACES_WON"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_RACES_LOST"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TIMES_RACE_BEST_LAP"), 101, true)
    end
	end
    self:Wait(50)
	end
	
	function achievementUnlocks()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMATTGANGHQ"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMFULLYMODDEDCAR"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMKILL3ANDWINGTARACE"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMMOSTKILLSSURVIVE"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMPICKUPDLCCRATE1ST"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMRACEWORLDRECHOLDER"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINALLRACEMODES"), true, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINEVERYGAMEMODE"), true, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADVRIFLE_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADVRIFLE_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_APPISTOL_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_APPISTOL_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTRIFLE_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTRIFLE_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTSHTGN_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTSHTGN_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTSMG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ASLTSMG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_20_KILLS_MELEE"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_25_KILLS_STICKYBOMBS"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_50_KILLS_GRENADES"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_CAR_BOMBS_ENEMY_KILLS"), 25, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_ENEMYDRIVEBYKILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMBBETWIN"), 50000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMHORDWAVESSURVIVE"), 21, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMKILLBOUNTY"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMRALLYWONDRIVE"), 10,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMRALLYWONDRIVE"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMREVENGEKILLSDM"), 60, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINAIRRACE"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FMWINSEARACE"), 10,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_DM_TOTALKILLS"), 500, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_DM_WINS"), 63, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_GOLF_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_GTA_RACES_WON"), 12, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_RACES_FASTEST_LAP"), 101, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_SHOOTRANG_CT_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_SHOOTRANG_GRAN_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_SHOOTRANG_RT_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_SHOOTRANG_TG_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_TDM_MVP"), 60, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_TDM_WINS"), 13, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_FM_TENNIS_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_HOLD_UP_SHOPS"), 20, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_NO_ARMWRESTLING_WINS"), 21, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_RACES_WON"), 101, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_AWD_SECURITY_CARS_ROBBED"), 40, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CMBTMG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CMBTMG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CMBTPISTOL_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CMBTPISTOL_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CRBNRIFLE_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CRBNRIFLE_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DB_PLAYER_KILLS"), 1000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_GRENADE_ENEMY_KILLS"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_GRNLAUNCH_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_GRNLAUNCH_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_HVYSNIPER_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_HVYSNIPER_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_KILLS_PLAYERS"), 1000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_LAP_DANCED_BOUGHT"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MICROSMG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MICROSMG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MINIGUNS_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MINIGUNS_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_SLIPSTREAMS_IN_RACE"), 110,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NUMBER_TURBO_STARTS_IN_RACE"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_PISTOL_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_PISTOL_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_PLAYER_HEADSHOTS"), 623, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_PUMP_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_PUMP_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_RACES_WON"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_RACES_WON"), 50,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_RPG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_RPG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SAWNOFF_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SMG_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SMG_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SNIPERRFL_ENEMY_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SNIPERRFL_KILLS"), 600, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_USJS_COMPLETED"), 50, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_USJS_FOUND"), 50,true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_DM_TOTAL_DEATHS"), 412, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TENNIS_MATCHES_WON"), 2, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TIMES_FINISH_DM_TOP_3"), 36, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TIMES_RACE_BEST_LAP"), 101, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_DEATHMATCH_LOST"), 23, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_RACES_LOST"), 36, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_RACES_WON"), 101, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_TOTAL_TDEATHMATCH_WON"), 63, true)
    end
	end
    self:Wait(50)
	end
	
	function apparelUnlocks()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHESGV_BS_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_10"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_10"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_11"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_11"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_12"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_12"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_13"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_8"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_ADMIN_CLOTHES_GV_BS_9"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_BERD_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_DECL"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_FEET_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_5"), -1, true);
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_HAIR_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_JBIB_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_6"), -1, true);
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_LEGS_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_OUTFIT"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_10"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_8"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_PROPS_9"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL2_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_SPECIAL_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_TEETH"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_TEETH_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_TEETH_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_ACQUIRED_TORSO"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_BERD_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_DECL"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_FEET_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_HAIR_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_JBIB_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_LEGS_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_OUTFIT"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_10"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_8"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_PROPS_9"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL2_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_SPECIAL_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_TEETH"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_TEETH_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_TEETH_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CLTHS_AVAILABLE_TORSO"), -1, true)
    end
	end
    self:Wait(50)
	end
	
	function dlcUnlocks()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_0"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_1"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_10"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_11"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_12"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_13"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_14"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_15"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_16"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_17"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_18"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_19"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_2"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_21"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_22"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_23"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_24"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_24"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_25"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_26"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_27"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_28"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_29"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_3"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_30"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_31"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_32"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_33"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_34"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_35"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_36"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_37"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_38"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_39"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_4"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_40"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_5"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_6"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_7"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_8"), -1, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_DLC_APPAREL_ACQUIRED_9"), -1, true)
    end
	end
    self:Wait(50)
	end
	
	function armorMunchies()

	while self:IsRunning() do
	for i= 1, 3 do
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
    end
	end
    self:Wait(50)
	end
	
	function maxStats()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_STAM"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_STRN"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_LUNG"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_DRIV"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_FLY"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_SHO"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_SCRIPT_INCREASE_STL"), 100, true)
    end
	end
    self:Wait(50)
	end
	
	function cheatOffenses()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_FLOAT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OVERALL_BADSPORT"), 0, true)
	natives.STATS.STAT_SET_BOOL(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CHAR_IS_BADSPORT"), false, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_BECAME_BADSPORT_NUM"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_BAD_SPORT_BITSET"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHEAT_BITSET"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_REPORT_STRENGTH"), 32, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_COMMEND_STRENGTH"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_FRIENDLY"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_HELPFUL"), 100, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GRIEFING"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OFFENSIVE_LANGUAGE"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_OFFENSIVE_UGC"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_VC_HATE"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GAME_EXPLOITS"), 0, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_ISPUNISHED"), 0, true)
    end
	end
    self:Wait(50)
	end
	
	function levelEdit()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_CHAR_XP_FM"), lvlXP, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_GLOBALXP"), globalXP, true)
    end
	end
    self:Wait(50)
	end
	
	function playTime()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_TOTAL_PLAYING_TIME"), timePlayed, true)
    end
	end
    self:Wait(50)
	end
	
	function rpgenFix()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_STARS_ATTAINED"), starAmount, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_STARS_EVADED"), starAmount, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_NO_TIMES_WANTED_LEVEL"), timesWanted, true)
    end
	end
    self:Wait(50)
	end
	
	function earnedFix()

	while self:IsRunning() do
	for i= 1, 3 do
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_TOTAL_EVC"), 9000000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MPPLY_TOTAL_EVC"), 9000000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MP" .. playerPedId[i] .. "_MPPLY_TOTAL_SVC"), 9000000, true)
    end
	end
    self:Wait(50)
	end
	
	function crewFix() -- Experimental, don't know if it will work.

	while self:IsRunning() do
	for i= 1, 3 do       
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_LOCAL_XP_0"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_LOCAL_XP_1"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_LOCAL_XP_2"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_LOCAL_XP_3"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_LOCAL_XP_4"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_GLOBAL_XP_0"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_GLOBAL_XP_1"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_GLOBAL_XP_2"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_GLOBAL_XP_3"), 900000, true)
	natives.STATS.STAT_SET_INT(natives.GAMEPLAY.GET_HASH_KEY("MPPLY_CREW_GLOBAL_XP_4"), 900000, true)
    end
	end
    self:Wait(50)
	end
	
function getCredits()
	GUI.updateStatusText("Credits: Kyron, kmcgurty, sweetmonster, gir489", 5000)
end

function getVer()
	print(" Check https://github.com/Khyy/TheRealMVPGTALUA for latest releases ")
end

-- Menu buttons for calls to functions.
function mainInit()

	GUI = GUIinit()
--
	GUI.createMenu("main", "", "** RealMVP by Kyron (MPGH) **", 0.07, 0.05, 0.125, 0.0325, 0.001, .35, 1)
--
	GUI.addButton("main", "Version 1.0", getVer, "**You are using version 1.0**", false, 0.35, 1)
	GUI.addButton("main", "Level Edit", levelEdit, "**Level MODIFIED**", false, 0.55, 1)
	GUI.addButton("main", "Playtime Edit", playTime, "**Playtime ADJUSTED**", false, 0.55, 1)
	GUI.addButton("main", "Earned Edit", earnedFix, "**Earned ADJUSTED**", false, 0.55, 1)
	GUI.addButton("main", "CrewXP Edit", crewFix, "**CrewXP ADJUSTED**", false, 0.55, 1)
	GUI.addButton("main", "Max Stats", maxStats, "**Character Stats MAXIMIZED**", false, 0.55, 1)
	GUI.addButton("main", "LSC Unlocks", raceUnlocks, "**Los Santos Customs UNLOCKED**", false, 0.55, 1)
	GUI.addButton("main", "Achievements", achievementUnlocks, "**Los Santos Customs UNLOCKED**", false, 0.55, 1)
	GUI.addButton("main", "Armor Munchies", armorMunchies, "**420YoloBlazeIt Munchies & Armor ADDED**", false, 0.55, 1)
	GUI.addButton("main", "Apparel", apparelUnlocks, "**Clothing ACQUIRED/UNLOCKED**", false, 0.55, 1)
	GUI.addButton("main", "Apparel (DLC)", dlcUnlocks, "**DLC Clothing ACQUIRED/UNLOCKED**", false, 0.55, 1)
	GUI.addButton("main", "Bad/Cheat Removal", cheatOffenses, "**Badsport/Reports/Flags REMOVED**", false, 0.55, 1)
	GUI.addButton("main", "Stars Fixer", rpgenFix, "**RPGenerator faggotry FIXED**", false, 0.55, 1)
	
end

function main:Run()

	mainInit()
	
	local playerPedId = {0, 1, 2}
	--list of key codes https://msdn.microsoft.com/en-us/lib...=vs.85%29.aspx
	local numpadec = 0x6E
	local numpad2 = 0x62
	local numpad8 = 0x68
	local numpad5 = 0x65
	local numpad9 = 0x69
	local numpad0 = 0x60
	GUI.navButtons = {
						["menuOpen"] = 
						{
							["keys"] = {numpadec, numpad9},
							["menu"] = "main"
						},
						["navUp"] 	 = {["keys"] = {numpad8}}, 
						["navDown"]  = {["keys"] = {numpad2}}, 
						["select"] 	 = {["keys"] = {numpad5}}, 
						["navBack"]  = {["keys"] = {numpad0}}
					}

	while self:IsRunning() do
	
		GUI.tick()
		--

		self:Wait(0)
	end
end
function main:OnError() end
main:Register()