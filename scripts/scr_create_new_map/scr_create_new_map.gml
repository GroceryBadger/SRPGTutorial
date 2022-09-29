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
			
			//If it's the floor, set the value to 1, else set it to 0 - Reset the grid
			for (var i = 0; i < e_tile_data.last; i ++) {
				if(i == 0) list[| i] = 1; else list[| i] = 0;				
			}
		}
	}
	
	show_debug_message("New map created");
}