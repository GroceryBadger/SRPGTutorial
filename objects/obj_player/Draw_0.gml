draw_self();

if (state == e_player_states.idle && path_point != noone){
	
	#region DRAW VALID PATHS
	
	for (var i = 0; i < ds_list_size(path_point.connects_to); i ++){
		
		connecting_path_point = path_point.connects_to[| i];
		connecting_id = path_array[connecting_path_point];
		
		//Draw Line
		draw_set_colour(c_red);
		draw_line(path_point.x, path_point.y, connecting_id.x, connecting_id.y);
	}
	
	#endregion

}
