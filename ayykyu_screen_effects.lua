-- Original Author: AyyKyu
-- Modified by: Handsome_ooyeah (Reddit)

function on_game_start()
	RegisterScriptCallback( "actor_on_update", actor_on_update )
end

local isactcondset = false
local isactcondset2 = false
local isactcondset3 = false
local isactcondset4 = false
local radeffect = false

function actor_on_update(binder,delta)
	if not (db.actor:alive()) then
		return
	end
	
	-- initial effects variable
	local playerhealtheffect = ( 1 - db.actor.health )
	local playerhealthblureffect = ( 1 - db.actor.health - (db.actor.health * 0.9) )
	local playerpowereffect = ( 1 - db.actor.power )
	local playerbleedeffect = db.actor.bleeding

	-- Default Color Saturation, Range is 0 upto 2
	local default_saturation = 1
	get_console():execute("r__saturation " .. default_saturation)

	if playerhealthblureffect < 0 then
		playerhealthblureffect = 0
	end

	-- Health Effects
	-- db.actor.health is the amount of health the player has
	-- 100% is 1
	if db.actor.health < 1 then
		-- multiply the saturation to the amount of health
		get_console():execute("r__saturation " .. (default_saturation * db.actor.health))

		if isactcondset ~= true then
			level.add_pp_effector("black.ppe",19981,true)
		end

		if playerhealthblureffect > 0 and isactcondset4 ~= true then
			level.add_pp_effector("snd_shock.ppe",19982,true)
			isactcondset4 = true
		end
		
		level.set_pp_effector_factor(19981,playerhealtheffect * 0.3)
		level.set_pp_effector_factor(19982,playerhealthblureffect * 0.1)

		if playerhealthblureffect == 0 and isactcondset4 ~= false then
			level.remove_pp_effector(19982)
			isactcondset4 = false
		end

		isactcondset = true
	end
	if db.actor.health > 0.99 and isactcondset ~= false then
		level.remove_pp_effector(19981)
		isactcondset = false
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
	if db.actor.power <= 0.4 then
		if isactcondset3 ~= true then
			level.add_pp_effector("yantar_underground_psi.ppe",1997,true)
		end
		level.set_pp_effector_factor(1997,playerpowereffect * 0.8)
		isactcondset3 = true
	end
	if db.actor.power > 0.5 and isactcondset3 ~= false then
		level.remove_pp_effector(1997)
		isactcondset3 = false
	end
	-- Stamina Effects
	
	-- Radiation Effects
	-- db.actor.radiation is the radiation rate in the player
	-- 100% is 1
	if db.actor.radiation > 0 then
		if radeffect ~= true then
			level.add_pp_effector("thermal.ppe",1995,true)
			level.add_pp_effector("yantar_underground_psi.ppe",1999,true)
		end
		level.set_pp_effector_factor(1995,db.actor.radiation)
		level.set_pp_effector_factor(1999,db.actor.radiation)
		radeffect = true
	end
	if db.actor.radiation == 0 and radeffect ~= false then
		level.remove_pp_effector(1995)
		level.remove_pp_effector(1999)
		radeffect = false
	end
	-- Radiation Effects
end
