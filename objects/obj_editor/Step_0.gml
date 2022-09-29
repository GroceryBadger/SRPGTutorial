#region DETERMINE GRID_X/Y

//2D grid
//grid_x = floor(mouse_x / GRID_SIZE);
//grid_y = floor(mouse_y / GRID_SIZE);

//Isometric grid
grid_x = floor((mouse_x / iso_width) + (mouse_y / iso_height)); //New
grid_y = floor((mouse_y / iso_height) - (mouse_x / iso_width)); //New

//grid_x = clamp(grid_x, 0, hcells - 1); //Keep grid_x between 0 and 9
//grid_y = clamp(grid_y, 0, vcells - 1); //Keep grid_y between 0 and 9

grid_x = clamp(grid_x, 0, ds_grid_width(ds_terrain_data) - 1);
grid_y = clamp(grid_y, 0, ds_grid_height(ds_terrain_data) - 1);

#endregion

#region CHANGE new_index

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

#endregion

#region PAINT THE MAP

if (mouse_check_button(mb_left)) {
	//ds_terrain_data[# grid_x, grid_y] = new_index;	
	var list = ds_terrain_data[# grid_x, grid_y];
	list[| current_part] = new_index;
	list[| e_tile_data.height] = current_height;
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
			}
				
			ds_terrain_data[# xx, yy] = list;
		}
	}
		
	#endregion

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
if (keyboard_check_pressed(vk_enter) ) scr_create_new_map(battle_map_list, ds_terrain_data);

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