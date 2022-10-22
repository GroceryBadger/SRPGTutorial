enum e_player_states {
	init,
	idle,
	walking
}

walking = false;
path_point = noone;
state = e_player_states.init;

//Grab the sprite for Butz
char_grid = global.char_sprite_grids[| e_characters.butz];