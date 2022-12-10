function on_mcm_load()
	op = {
		id = "screen_effects",
		sh = true,
		gr = {
			{id = "title", type = "slide", link = "ui_options_slider_player", text = "ui_mcm_screen_effects_title", size = {512, 50}, spacing = 20 },
			{id = "HEALTH_SATURATION_EFFECT",
				type = "check",
				val = 1,
				def = true,
			},
			{id = "DEFAULT_SATURATION",
				type = "track", val = 1,
				def = 1,
				min = 0.4,
				max = 2,
				step = 0.01
			},

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
