#region DRAW new_index +relevant sprite

if (editing_state == e_editing_states.map)
{
	var draw_x = display_get_gui_width() /2;
	var draw_y = display_get_gui_height() - 32;
	var scale = 2;

	//draw_sprite_ext(spr_floor, new_index, draw_x, draw_y, scale, scale, 0 , c_white, 1);
	var spr = global.cell_sprites[current_part];

	draw_sprite_ext(spr, new_index, draw_x, draw_y, scale, scale, 0 , c_white, 1);
}

#endregion

#region DRAW grid_x/y

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(0, 0, "grid_x: " + string(grid_x));
draw_text(0, 20, "grid_y: " + string(grid_y));

#endregion

#region DRAW mission editor GUI

if (editing_state == e_editing_states.mission) {

	draw_scale = 2;
	
	#region DRAW spawn point icons
	
	var spr_w = sprite_get_width(spr_iso_spawn_tiles) * draw_scale;
	var spr_h = sprite_get_height(spr_iso_spawn_tiles) * draw_scale;
	var start_x = spr_w;
	var start_y = display_get_gui_height() - spr_h;
	
	for (var team = 0; team < sprite_get_number(spr_iso_spawn_tiles); team ++) {
		var draw_x = start_x + (team * spr_w);
		var draw_y = start_y;
		var mx = device_mouse_x_to_gui(0); //mouse x based on the GUI layer
		var my = device_mouse_y_to_gui(0); //mouse y based on GUI layer
		
		if (abs(mx - draw_x) <= (spr_w /2) && abs (my - draw_y) <= (spr_h / 2) ) {
			var col = c_ltgray;
			if (mouse_check_button_pressed(mb_left)) {
				mouse_sprite = spr_iso_spawn_tiles;
				mouse_index = team;
			}
		}
		else col = c_white;
			
		draw_sprite_ext(spr_iso_spawn_tiles, team, draw_x, draw_y, draw_scale, draw_scale, 0, col, 1);
	}
	
	#endregion
	
	#region DRAW character
	
	var spr_w = sprite_get_width(spr_iso_actor) * draw_scale;
	var spr_h = sprite_get_height(spr_iso_actor) * draw_scale;
	
	draw_x = sprite_get_width(spr_iso_spawn_tiles) * 6;
	draw_y = display_get_gui_height() - sprite_get_height(spr_iso_actor);
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if (abs(mx - draw_x) <= (spr_w /2) && abs(my - draw_y) <= (spr_h / 2) ) {
		col = c_ltgray;
		if (mouse_check_button_pressed(mb_left)) {
			mouse_sprite = spr_iso_actor;
			mouse_index = e_facing.south;
		}
	}
	else col = c_white;
	
	draw_sprite_ext(spr_iso_actor, e_facing.south, draw_x, draw_y, draw_scale, draw_scale, 0, col, 1);
	
	#endregion
	
	#region DRAW AI_controller / Must_survive / Kill_to_win
	
	var list = ds_terrain_data[# grid_x, grid_y];
	
	if (list[| e_tile_data.unit] >= e_characters.fighter && list[| e_tile_data.unit] != undefined) {
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(0, 60, "AI Controlled: " + string(list[| e_tile_data.is_ai_controlled]));
		draw_text(0, 80, "Must Survive: " + string(list[| e_tile_data.must_survive_this_battle]));
		draw_text(0, 100, "Kill To Win: " + string(list[| e_tile_data.kill_this_unit_to_win]));
	}
	
	#endregion
	
}

#endregion