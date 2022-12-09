-- Original Author: AyyKyu
-- Modified by: Handsome_ooyeah

-- local isactcondset = false
-- local isactcondset2 = false
-- local isactcondset3 = false
-- local isactcondset4 = false
-- local radeffect = false

local DEFAULT_SATURATION = 1

local HEALTH_EFFECT
local HEALTH_BLUR_EFFECT

local STAMINA_EFFECT
local STAMINA_BLUR_EFFECT

local BLEEDING_EFFECT
local RADIATION_EFFECT

function load_settings()
	if not ui_mcm then
		return
	end

	HEALTH_EFFECT = ui_mcm.get("screen_effects/HEALTH_EFFECT")
	-- HEALTH_BLUR_EFFECT = ui_mcm.get("screen_effects/HEALTH_BLUR_EFFECT")
	STAMINA_EFFECT = ui_mcm.get("screen_effects/STAMINA_EFFECT")
	-- STAMINA_BLUR_EFFECT = ui_mcm.get("screen_effects/STAMINA_BLUR_EFFECT")
	BLEEDING_EFFECT = ui_mcm.get("screen_effects/BLEEDING_EFFECT")
	RADIATION_EFFECT = ui_mcm.get("screen_effects/RADIATION_EFFECT")
end

function actor_on_update()
	if not db.actor:alive() then
		return
	end

	-- initial effects variable
	local playerhealtheffect = ( 1 - db.actor.health )
	local playerhealthblureffect = ( 1 - db.actor.health - (db.actor.health * 0.9) )
	local playerpowereffect = ( 1 - db.actor.power )
	local playerbleedeffect = db.actor.bleeding

	-- get_console():execute("r__saturation " .. DEFAULT_SATURATION)

	if playerhealthblureffect < 0 then
		playerhealthblureffect = 0
	end

	-- Health Effects
	-- db.actor.health is the amount of health the player has
	-- 100% is 1
	if db.actor.health < 1 then
		-- multiply the saturation to the amount of health
		-- get_console():execute("r__saturation " .. (DEFAULT_SATURATION * db.actor.health))

		if playerhealthblureffect > 0 and isactcondset4 ~= true then
			level.add_pp_effector("snd_shock.ppe",19982,true)
			isactcondset4 = true
		end

		-- level.set_pp_effector_factor(19981,playerhealtheffect * 0.3)
		level.set_pp_effector_factor(19982,playerhealthblureffect * 0.125)

		if playerhealthblureffect == 0 and isactcondset4 ~= false then
			level.remove_pp_effector(19982)
			isactcondset4 = false
		end

		isactcondset = true
	end
	-- Health Effects

	-- Bleeding Effects
	-- db.actor.bleeding is a multiplier of the bleeding effects
	-- if db.actor.bleeding is 0 then the player is not bleeding
	if db.actor.bleeding > 0 then
		if isactcondset2 ~= true then
			level.add_pp_effector("bloody.ppe",1996,true)
		end
		level.set_pp_effector_factor(1996,playerbleedeffect)
		isactcondset2 = true
	end
	if db.actor.bleeding == 0 and isactcondset ~= false then
		level.remove_pp_effector(1996)
		isactcondset2 = false
	end
	-- Bleeding Effects

	-- Stamina Effects
	-- db.actor.power is the stamina
	-- 100% is 1
	if db.actor.power < 0.4 then
		if isactcondset3 ~= true then
			level.add_pp_effector("yantar_underground_psi.ppe",1997,true)
		end
		level.set_pp_effector_factor(1997,playerpowereffect * 0.4)
		isactcondset3 = true
	end
	if db.actor.power > 0.5 and isactcondset3 ~= false then
		level.remove_pp_effector(1997)
		isactcondset3 = false
	end
	-- Stamina Effects
end

function on_game_start()
	RegisterScriptCallback("on_option_change", load_settings)
	RegisterScriptCallback("actor_on_first_update", load_settings)
	RegisterScriptCallback( "actor_on_update", actor_on_update )
end

