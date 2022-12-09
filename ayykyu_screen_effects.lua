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
	HEALTH_BLUR_EFFECT = ui_mcm.get("screen_effects/HEALTH_BLUR_EFFECT")
	STAMINA_EFFECT = ui_mcm.get("screen_effects/STAMINA_EFFECT")
	STAMINA_BLUR_EFFECT = ui_mcm.get("screen_effects/STAMINA_BLUR_EFFECT")
	BLEEDING_EFFECT = ui_mcm.get("screen_effects/BLEEDING_EFFECT")
	RADIATION_EFFECT = ui_mcm.get("screen_effects/RADIATION_EFFECT")
end

function actor_on_update()
	if not (db.actor:alive()) then
		return
	end

	local health = db.actor.health
	local stamina = db.actor.power
	local bleeding = db.actor.bleeding
	local radiation = db.actor.radiation

	if HEALTH_EFFECT then
		local health_blur_effect = (1 - health - (health * 0.9))
		get_console():execute("r__saturation " .. default_saturation * health)

		if health_blur_effect > 0 then
			level.add_pp_effector("snd_shock.ppe",19982,true)
			level.set_pp_effector_factor(19982,playerhealthblureffect * 0.1)
		else
			level.remove_pp_effector(19982)
		end
	end

	if STAMINA_EFFECT then
		if stamina < 0.4 then
			level.add_pp_effector("yantar_underground_psi.ppe",1997,true)
			level.set_pp_effector_factor(1997,playerpowereffect * 0.8)
		else
			level.remove_pp_effector("yantar_underground_psi.ppe",1997,true)
		end
	end

	if BLEEDING_EFFECT then
		if bleeding > 0 then
			level.add_pp_effector("bloody.ppe",1996,true)
			level.set_pp_effector_factor(1996,playerbleedeffect)
		else
			level.remove_pp_effector(1996)
		end
	end

	if RADIATION_EFFECT then
		if radiation > 0 then
			level.add_pp_effector("thermal.ppe",1995,true)
			level.add_pp_effector("yantar_underground_psi.ppe",1999,true)
			level.set_pp_effector_factor(1995,db.actor.radiation)
			level.set_pp_effector_factor(1999,db.actor.radiation)
		else
			level.remove_pp_effector(1995)
			level.remove_pp_effector(1999)
		end
	end
end

function on_game_start()
	RegisterScriptCallback("on_option_change", load_settings)
	RegisterScriptCallback("actor_on_first_update", load_settings)
	RegisterScriptCallback( "actor_on_update", actor_on_update )
end

