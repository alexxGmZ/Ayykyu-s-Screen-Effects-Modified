-- Original Author: AyyKyu
-- Modified by: Handsome_ooyeah

local isactcondset = false
local isactcondset2 = false
local isactcondset3 = false
local isactcondset4 = false
local radeffect = false

local DEFAULT_SATURATION = 1

local HEALTH_SATURATION_EFFECT
local HEALTH_EFFECT
local STAMINA_EFFECT
local BLEEDING_EFFECT
local RADIATION_EFFECT

function load_settings()
	if not ui_mcm then
		return
	end

	DEFAULT_SATURATION = ui_mcm.get("screen_effects/DEFAULT_SATURATION")
	HEALTH_SATURATION_EFFECT = ui_mcm.get("screen_effects/HEALTH_SATURATION_EFFECT")
	HEALTH_EFFECT = ui_mcm.get("screen_effects/HEALTH_EFFECT")
	STAMINA_EFFECT = ui_mcm.get("screen_effects/STAMINA_EFFECT")
	BLEEDING_EFFECT = ui_mcm.get("screen_effects/BLEEDING_EFFECT")
	RADIATION_EFFECT = ui_mcm.get("screen_effects/RADIATION_EFFECT")
end

function actor_on_update()
	if not db.actor:alive() then
		return
	end

	local health_amount = db.actor.health
	local stamina_amount = db.actor.power
	local bleeding_amount = db.actor.bleeding
	local radiation_amount = db.actor.radiation

	-- initial effects variable
	local playerhealtheffect = 1 - health_amount
	local playerhealthblureffect = ( 1 - health_amount - (health_amount * 0.9) )
	local playerpowereffect = ( 1 - stamina_amount )
	local playerbleedeffect = bleeding_amount

	-- get_console():execute("r__saturation " .. DEFAULT_SATURATION)

	if playerhealthblureffect < 0 then
		playerhealthblureffect = 0
	end

	-- Health Saturation Effect
	if HEALTH_SATURATION_EFFECT then
		-- multiply the saturation to the amount of health
		get_console():execute("r__saturation " .. DEFAULT_SATURATION * health_amount)
	end

	-- Health Effects
	-- db.actor.health is the amount of health the player has
	-- 100% is 1
	if HEALTH_EFFECT and health_amount < 1 then
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
	if not HEALTH_EFFECT then
		level.remove_pp_effector(19982)
		isactcondset4 = false
	end

	-- Bleeding Effects
	-- db.actor.bleeding is a multiplier of the bleeding effects
	-- if db.actor.bleeding is 0 then the player is not bleeding
	if BLEEDING_EFFECT and bleeding_amount > 0 then
		if isactcondset2 ~= true then
			level.add_pp_effector("bloody.ppe",1996,true)
		end
		level.set_pp_effector_factor(1996,playerbleedeffect)
		isactcondset2 = true
	end
	if bleeding_amount == 0 and isactcondset ~= false then
		level.remove_pp_effector(1996)
		isactcondset2 = false
	end
	if not BLEEDING_EFFECT then
		level.remove_pp_effector(1996)
		isactcondset2 = false
	end

	-- Stamina Effects
	-- db.actor.power is the stamina
	-- 100% is 1
	if STAMINA_EFFECT and stamina_amount <= 0.3 then
		if isactcondset3 ~= true then
			level.add_pp_effector("yantar_underground_psi.ppe",1997,true)
		end
		level.set_pp_effector_factor(1997,playerpowereffect * 0.4)
		isactcondset3 = true
	end
	if stamina_amount > 0.5 and isactcondset3 ~= false then
		level.remove_pp_effector(1997)
		isactcondset3 = false
	end
	if not STAMINA_EFFECT then
		level.remove_pp_effector(1997)
		isactcondset3 = false
	end

	-- Radiation Effects
	-- db.actor.radiation is the radiation rate in the player
	-- 100% is 1
	if RADIATION_EFFECT and radiation_amount > 0 then
		if radeffect ~= true then
			level.add_pp_effector("thermal.ppe",1995,true)
			level.add_pp_effector("yantar_underground_psi.ppe",1999,true)
		end
		level.set_pp_effector_factor(1995,db.actor.radiation)
		level.set_pp_effector_factor(1999,db.actor.radiation)
		radeffect = true
	end
	if radiation_amount == 0 and radeffect ~= false then
		level.remove_pp_effector(1995)
		level.remove_pp_effector(1999)
		radeffect = false
	end
	if not RADIATION_EFFECT then
		level.remove_pp_effector(1995)
		level.remove_pp_effector(1999)
		radeffect = false
	end
end

function on_game_start()
	RegisterScriptCallback("on_option_change", load_settings)
	RegisterScriptCallback("actor_on_first_update", load_settings)
	RegisterScriptCallback("actor_on_update", actor_on_update)
end

