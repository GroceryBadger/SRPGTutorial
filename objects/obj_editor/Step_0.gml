#region DETERMINE GRID_X/Y

//2D grid
//grid_x = floor(mouse_x / GRID_SIZE);
//grid_y = floor(mouse_y / GRID_SIZE);

//Isometric grid
grid_x = floor((mouse_x / iso_width) + (mouse_y / iso_height)); //New
grid_y = floor((mouse_y / iso_height) - (mouse_x / iso_width)); //New

grid_x = clamp(grid_x, 0, hcells - 1); //Keep grid_x between 0 and 9
grid_y = clamp(grid_y, 0, vcells - 1); //Keep grid_y between 0 and 9

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

if (keyboard_check(ord("W"))) cy -= 10;
if (keyboard_check(ord("S"))) cy += 10;
if (keyboard_check(ord("A"))) cx -= 10;
if (keyboard_check(ord("D"))) cx += 10;

if (keyboard_check(ord("W")) || keyboard_check(ord("S")) || keyboard_check(ord("A")) || keyboard_check(ord("D"))) {
	camera_set_view_pos(view_camera[0], cx, cy);	
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

#region TOGGLE DISPLAY ALL HEIGHTS

//If display all heights is false, cells will only be drawn UP TO whatever current_height equals
if (keyboard_check_pressed(vk_tab) ) display_all_heights = !display_all_heights;

#endregion