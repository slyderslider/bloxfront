-- BloxFront (2026-10-26): own soundtrack, three Pixabay tracks (Pixabay Content License: free to use in
-- games, no attribution required; credited anyway). Uploaded by tools/assets/upload_music.py, all
-- normalised to about -23 LUFS (quiet background level; AudioDirector adds its own music_volume_db).
-- tracks: key -> {id, length (s), title, pack}; moods: playlists by mood, the first title track is the
-- opener. Played whole (intro to ending) and crossfaded by AudioDirector. menu_loop is the 10 s loop
-- repeated seamlessly to about 2 minutes, so the crossfade comes rarely.
return {
	credit = "Music by zec53, Syouki Takahashi and sonic289 (Pixabay)",
	license = "Pixabay Content License",
	tracks = {
		menu_loop = { id = "rbxassetid://102793180804899", length = 122.88, title = "Funeral Electro Background Loop", pack = "zec53" },
		strategist = { id = "rbxassetid://86175445825124", length = 157.32, title = "Strategist 2", pack = "Syouki Takahashi" },
		main_theme = { id = "rbxassetid://134552591821800", length = 199.99, title = "Game Music Main Theme", pack = "sonic289" },
	},
	moods = {
		title = { "menu_loop" },
		wait = { "menu_loop" },
		calm = { "strategist", "main_theme" },
		war = { "main_theme", "strategist" },
		victory = { "main_theme" },
		defeat = { "strategist" },
	},
}
