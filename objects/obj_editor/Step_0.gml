#region DETERMINE GRID_X/Y

//2D grid
//grid_x = floor(mouse_x / GRID_SIZE);
//grid_y = floor(mouse_y / GRID_SIZE);

//Isometric grid
grid_x = floor((mouse_x / iso_width) + (mouse_y / iso_height)); //New
grid_y = floor((mouse_y / iso_height) - (mouse_x / iso_width)); //New

actual_grid_x = grid_x; //Is the mouse on the map or not
actual_grid_y = grid_y; //Is the mouse on the map or not

//grid_x = clamp(grid_x, 0, hcells - 1); //Keep grid_x between 0 and 9
//grid_y = clamp(grid_y, 0, vcells - 1); //Keep grid_y between 0 and 9

//Cap grid x, y
grid_x = clamp(grid_x, 0, ds_grid_width(ds_terrain_data) - 1);
grid_y = clamp(grid_y, 0, ds_grid_height(ds_terrain_data) - 1);

#endregion

#region CHANGE new_index / Change Part (Basically are we editing the floor or decoration?)

	if (editing_state = e_editing_states.map) {

		if (keyboard_check_pressed(vk_right)) {
			//Change new index (of current sprite)
			if(keyboard_check(vk_shift) == false) {
				if(new_index + 1) < sprite_get_number(current_sprite) new_index ++;
				else new_index = 0;
			}
			else {
				#region change tile part (cycle between floor/decoration)
			
				if(current_part + 1) <= e_tile_data.decoration_index current_part++;
				else current_part = 0;
				current_sprite = global.cell_sprites[current_part]; //Update the current sprite
				new_index = 1; //reset image_index
			
				#endregion
			}
		}

		if (keyboard_check_pressed(vk_left)) {
			//Change new index (of current sprite)
			if(keyboard_check(vk_shift) == false) {
				if(new_index > 0) new_index --;
				else new_index = (sprite_get_number(current_sprite) - 1);
			}
			else {
				#region change tile part (cycle between floor/decoration)
			
				if(current_part - 1) >= 0 current_part--;
				else current_part = e_tile_data.decoration_index;
				current_sprite = global.cell_sprites[current_part]; //Update the current sprite
				new_index = 1; //reset image_index
			
				#endregion
			}
		}
	}

#endregion

#region PAINT THE MAP / PLACE UNIT / SPAWN TILE

if (mouse_check_button(mb_left)) {
	
	var list = ds_terrain_data[# grid_x, grid_y];
	
	//CHANGE INDEX OF TILE
	if (editing_state == e_editing_states.map) {
		list[| current_part] = new_index;
		list[| e_tile_data.height] = current_height;
	}
	
	//PLACE SPAWN TILE / UNIT
	if (editing_state == e_editing_states.mission) && mouse_check_button_pressed(mb_left) {
		
		//Place spawn point / unit on the map
		if (actual_grid_x == grid_x && actual_grid_y == grid_y) {
		
			if (mouse_sprite == spr_iso_spawn_tiles) {
			
				//Update list spawn_tile entry
				list[| e_tile_data.spawn_tile] = mouse_index;
				
				//Update Conversation Index entry
				if (list[| e_tile_data.conversation_index] == -1 || list[| e_tile_data.conversation_index] == undefined) {
					list[| e_tile_data.conversation_index] = unique_conversation_index;
					//Increase conversation index tracker by 1
					unique_conversation_index ++;
				}
			}
			
			else {
				//Only allow unit placement if there is a spawn tile already there
				if (mouse_sprite == spr_iso_actor) && (list[| e_tile_data.spawn_tile] != undefined && list[| e_tile_data.spawn_tile] > -1) {
					
					//Update unit entry
					list[| e_tile_data.unit] = e_characters.fighter;
					list[| e_tile_data.unit_facing] = mouse_index;
				
					//Update is_ai controlled
					if (list[| e_tile_data.spawn_tile] == 0) list [| e_tile_data.is_ai_controlled] = false
					else list [| e_tile_data.is_ai_controlled] = true;
				
					//Update must survive
					list[| e_tile_data.must_survive_this_battle] = false;
				
					//Update kill_to_win
					list[| e_tile_data.kill_this_unit_to_win] = false;

				}
			}	
		}
	}
}


#endregion

#region DELETE SPAWN POINTS / UNITS

if (mouse_check_button_pressed(mb_right) ) {
	if (editing_state == e_editing_states.mission) {
		
		//Clear Mouse sprite/index
		mouse_sprite = -1;
		mouse_index = -1;
		
		if (actual_grid_x == grid_x && actual_grid_y == grid_y) {
			var list = ds_terrain_data[# grid_x, grid_y];
			
			//Delete the unit if one is there, otherwise delete the spawn tile
			if (list[| e_tile_data.unit] != undefined && list[| e_tile_data.unit] >= 0) list[| e_tile_data.unit] = -1;
			else list[| e_tile_data.spawn_tile] = -1;
		}
	}
}

#endregion

#region ROTATE THE UNIT / CHANGE THE CLASS

if (editing_state == e_editing_states.mission) {
	var list = ds_terrain_data[# grid_x, grid_y];
	var class = list[| e_tile_data.unit];
	
	if (mouse_wheel_down() ) {
		//Rotate
		if (mouse_sprite == spr_iso_actor) {
			if (mouse_index + 1) < sprite_get_number(spr_iso_actor) mouse_index ++; else mouse_index = 0;	
		}
		//Change class/character
		if (mouse_sprite == -1 && class != undefined && class > 0) {
			if (class + 1) < e_characters.last list[| e_tile_data.unit] ++;
			else list[| e_tile_data.unit] = e_characters.fighter;
		}
	}
	
	if (mouse_wheel_up() ) {
		//Rotate
		if (mouse_sprite == spr_iso_actor) {
			if (mouse_index > 0) mouse_index --;
			else mouse_index = sprite_get_number(spr_iso_actor) -1;
		}
		//Change class/character
		if (mouse_sprite == -1 && class != undefined && class > 0) {
			if (class > e_characters.fighter) list[| e_tile_data.unit] --;
			else list[| e_tile_data.unit] = (e_characters.last -1);
		}
		
	}
	
}

#endregion

#region TOGGLE AI CONTROLLED / MUST SURVIVE / KILL TO WIN

if (editing_state == e_editing_states.mission && keyboard_check(vk_shift) ) {
	var list = ds_terrain_data[# grid_x, grid_y];
	
	//No point changing anything if there's no unit
	if (list[| e_tile_data.unit] >= e_characters.fighter) {
		
		//AI Controlled	
		if (keyboard_check_pressed(ord("1"))) {
			//If ai is controlled is not set to either true or false, set it to true or false on the spawn image index (0: player Team, 1: enemy team)	
			if (list[| e_tile_data.is_ai_controlled] != true && list[| e_tile_data.is_ai_controlled] != false) {
					if (list[| e_tile_data.spawn_tile] == 0) list[| e_tile_data.is_ai_controlled] = true;
					else list[| e_tile_data.is_ai_controlled] = false;
			}
			else list[| e_tile_data.is_ai_controlled] = !list[| e_tile_data.is_ai_controlled];
		}
		//Must Survive
		if (keyboard_check_pressed(ord("2"))) {
			//If must survive is not already set, default to FALSE
			if (list[| e_tile_data.must_survive_this_battle] != true && list[| e_tile_data.must_survive_this_battle] != false) {
					list[| e_tile_data.must_survive_this_battle] = false;
			}
			else list[| e_tile_data.must_survive_this_battle] = !list[| e_tile_data.must_survive_this_battle];
		}
		//Kill To Win
		if (keyboard_check_pressed(ord("3"))) {
			//If must survive is not already set, default to FALSE
			if (list[| e_tile_data.kill_this_unit_to_win] != true && list[| e_tile_data.kill_this_unit_to_win] != false) {
					list[| e_tile_data.kill_this_unit_to_win] = false;
			}
			else list[| e_tile_data.kill_this_unit_to_win] = !list[| e_tile_data.kill_this_unit_to_win];
		}
	}
}

#endregion

#region MOVE THE CAMERA

if (!keyboard_check(vk_shift)) {

	if (keyboard_check(ord("W"))) cy -= 10;
	if (keyboard_check(ord("S"))) cy += 10;
	if (keyboard_check(ord("A"))) cx -= 10;
	if (keyboard_check(ord("D"))) cx += 10;

	if (keyboard_check(ord("W")) || keyboard_check(ord("S")) || keyboard_check(ord("A")) || keyboard_check(ord("D"))) {
		camera_set_view_pos(view_camera[0], cx, cy);	
	}
}

#endregion

#region CHANGE THE HEIGHT

if (keyboard_check_pressed(vk_up)) {
	if(current_height + 1) < max_height current_height ++;
	else current_height = 0;
}

if (keyboard_check_pressed(vk_down)) {
	if(current_height > 0) current_height --;
	else current_height = (max_height - 1);
}

#endregion

#region CHANGE HEIGHT/WIDTH OF THE MAP

	if (editing_state == e_editing_states.map) {
	
		if (keyboard_check(vk_shift)) {
	
			#region Decrease Grid Height (fewer rows)
	
				if (keyboard_check_pressed(ord("W"))) {
					var grid_h = ds_grid_height(ds_terrain_data);
			
					if (grid_h > 1) {
						for (var xx = 0; xx < ds_grid_width(ds_terrain_data); xx ++) {
							var list_to_destroy = ds_terrain_data[# xx, (grid_h - 1) ];
							ds_list_destroy(list_to_destroy);
						}
				
						ds_grid_resize(ds_terrain_data, ds_grid_width(ds_terrain_data), grid_h - 1);
					}
			
				}
	
			#endregion
	
			#region Increase Grid Height (more rows)
	
				if (keyboard_check_pressed(ord("S"))) {
					var yy = ds_grid_height(ds_terrain_data);
					var grid_h = yy + 1;
					ds_grid_resize(ds_terrain_data, ds_grid_width(ds_terrain_data), grid_h);
			
					//Make lists for the new room
					for (var xx = 0; xx < ds_grid_width(ds_terrain_data); xx ++) {
						var list = ds_list_create();
				
						//Set initial cell data
						for (var i = 0; i < e_tile_data.last; i ++) {
							//Set floor_index to 1 and everything else to 0
							if (i == e_tile_data.floor_index) list[| i] = 1; else list[| i] = 0;		
							if (i >= e_tile_data.spawn_tile) list[| i] = -1;
						}
				
						ds_terrain_data[# xx, yy] = list;
					}
				}
		
			#endregion
		
			#region Decrease Grid Width (fewer columns)
	
				if (keyboard_check_pressed(ord("A"))) {
					var xx = ds_grid_width(ds_terrain_data) - 1;
			
					if (xx > 0) {
						for (var yy = 0; yy < ds_grid_height(ds_terrain_data); yy ++) {
							var list_to_destroy = ds_terrain_data[# xx, yy ];
							ds_list_destroy(list_to_destroy);
						}
				
						ds_grid_resize(ds_terrain_data, xx, ds_grid_height(ds_terrain_data));
					}
			
				}
	
			#endregion
	
			#region Increase Grid Width (more columns)
	
			if (keyboard_check_pressed(ord("D"))) {
				var xx = ds_grid_width(ds_terrain_data);
				var grid_w = xx + 1;
		
				ds_grid_resize(ds_terrain_data, grid_w, ds_grid_height(ds_terrain_data));
			
				//Make lists for the new room
				for (var yy = 0; yy < ds_grid_height(ds_terrain_data); yy ++) {
					var list = ds_list_create();
				
					//Set initial cell data
					for (var i = 0; i < e_tile_data.last; i ++) {
						//Set floor_index to 1 and everything else to 0
						if (i == e_tile_data.floor_index) list[| i] = 1; else list[| i] = 0;			
						if (i >= e_tile_data.spawn_tile) list[| i] = -1;
					}
				
					ds_terrain_data[# xx, yy] = list;
				}
			}
		
			#endregion

		}
	}

#endregion

#region TOGGLE DISPLAY ALL HEIGHTS

//If display all heights is false, cells will only be drawn UP TO whatever current_height equals
if (keyboard_check_pressed(vk_tab) ) display_all_heights = !display_all_heights;

#endregion

#region SAVE / LOAD / CREATE NEW / DELETE CURRENT MAP

//Save map
if (keyboard_check_pressed(vk_f5) ) battle_map_list[| current_map_number] = scr_save_map(current_map_number, ds_terrain_data);

//Load the map
if (ds_list_size(battle_map_list) > 0) {
	
	if (keyboard_check(vk_shift)) {
		//Load Previous Map	
		if (keyboard_check_pressed(ord("Q"))) { 
			//Change the map number
			if (current_map_number > 0) current_map_number --;
			else current_map_number = ( ds_list_size(battle_map_list) - 1 );
			
			//Load the grid from battle map list
			scr_load_map(current_map_number, ds_terrain_data, battle_map_list);
		}
		else {
			if (keyboard_check_pressed(ord("E"))) {
				if (current_map_number + 1) < ds_list_size(battle_map_list) current_map_number ++;
				else current_map_number = 0; 
				
				scr_load_map(current_map_number, ds_terrain_data, battle_map_list);
			}
		}
	}
}

//Create new map
if (keyboard_check_pressed(vk_enter) ) {
	scr_create_new_map(battle_map_list, ds_terrain_data);
}

//Delete the map
if (keyboard_check_pressed(vk_backspace) ) {
	//Delete grid string from list of battle maps
	current_map_number = scr_delete_map(current_map_number, battle_map_list);	
	
	if (ds_list_size(battle_map_list) > 0) {
		//Load the next map, if one's available
		ds_terrain_data = scr_load_map(current_map_number, ds_terrain_data, battle_map_list);
	}
	else scr_create_new_map(battle_map_list, ds_terrain_data);
}

#endregion