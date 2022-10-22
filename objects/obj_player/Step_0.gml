if (state == e_player_states.init)
{
	#region INIT
	
	//Create Array to store path ids and their point
	with (obj_world_point) {
		//Whatever the path point of this world_point is, save its id to that entry in the players array	
		other.path_array[path_point] = id;
	}
	
	//CHECK WHICH PATH POINT WE'RE ON
	path_point = collision_point(x, y, obj_world_point, false, true);
	
	//MAKE SURE THAT THE ARRAY IS CREATED PROPERLY
	for (var i = 0; i < array_length_1d(path_array); i++) {
		show_debug_message("path_array[" + string(path_array[i]) + "]");
	}
	
	state = e_player_states.idle;
	
	#endregion
}

if (state == e_player_states.idle)
{
	#region IDLE
	
	//Make all world points have an image of 0 (this will reset any highlighed world points when the mouse is not actually over it any more)
	with obj_world_point image_index = 0;
	
	//Highlight a point we can move to
	mouse_over_path = collision_point(mouse_x, mouse_y, obj_world_point, false, false);
	
	//If the mouse is over a world_point and that worl_point's path point is in the list of the world_point, that player is currently syanding on, highlight it
	if (mouse_over_path != noone && ds_list_find_index(path_point.connects_to, mouse_over_path.path_point) != -1) {
		mouse_over_path.image_index = 1;
		
		if (mouse_check_button_pressed(mb_left)) {
			move_towards_point(mouse_over_path.x, mouse_over_path.y, 1);
			state = e_player_states.walking;
			
			#region SET SPRITE
			
			var dir = point_direction(x, y, mouse_over_path.x, mouse_over_path.y);
			show_debug_message("dir: " + string(dir));
			if (dir >= 90 && dir < 180) sprite_index = char_grid[# e_actor_sprites.idle, e_facing.west];
			if (dir >= 0 && dir < 90) sprite_index = char_grid[# e_actor_sprites.idle, e_facing.north];
			if (dir >= 270 && dir < 360) sprite_index = char_grid[# e_actor_sprites.idle, e_facing.east];
			if (dir >= 180 && dir < 270) sprite_index = char_grid[# e_actor_sprites.idle, e_facing.south];
			
			#endregion
		}
	}
	
	#endregion
}

if (state == e_player_states.walking)
{
	#region WALKING
	
	if (abs(x - mouse_over_path.x) <= 1 && abs(y - mouse_over_path.y) <= 1) {
		speed = 0;
		path_point = collision_point(x, y, obj_world_point, false, true);
		state = e_player_states.idle;
	}
	
	#endregion
}
