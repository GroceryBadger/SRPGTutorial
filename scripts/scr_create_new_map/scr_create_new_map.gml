// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_create_new_map(list_of_battle_maps, grid_to_reset){
	
	current_map_number = ds_list_size(list_of_battle_maps);
	
	var grid_width = ds_grid_width(grid_to_reset);
	var grid_height = ds_grid_height(grid_to_reset);
	
	//Convert the data in the lists into a string
	for (var yy = 0; yy < grid_height; yy ++) {
		for (var xx = 0; xx < grid_width; xx ++) {
			//Clear each list	
			var list = grid_to_reset[# xx, yy];
			
			//Set initial cell data for each list
			for (var i = 0; i < e_tile_data.last; i ++){
				//set floor_index to 1 and everything else to 0
				if (i == e_tile_data.floor_index) list[| i] = 1; else list[| i] = 0;
				if (i >= e_tile_data.spawn_tile) list[| i] = -1;																	    
			}
		}
	}

	//We want to reset this variable if we make a new map
	unique_conversation_index = 0;																										

	show_debug_message("New map created");
}