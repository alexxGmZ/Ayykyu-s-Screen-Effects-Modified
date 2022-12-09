function on_mcm_load()
	op = {
		id = "screen_effects",
		sh = true,
		gr = {
			{id = "title", type = "slide", link = "ui_options_slider_player", text = "", size = {512, 50}, spacing = 20 },
			{id = "HEALTH_EFFECT",
				type = "check",
				val = 1,
				def = true,
			},
			{id = "STAMINA_EFFECT",
				type = "check",
				val = 1,
				def = true,
			},
			{id = "BLEEDING_EFFECT",
				type = "check",
				val = 1,
				def = true,
			},
			{id = "RADIATION_EFFECT",
				type = "check",
				val = 1,
				def = true,
			},
		}
	}
	return op
end
