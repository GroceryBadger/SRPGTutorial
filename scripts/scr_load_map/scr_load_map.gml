// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_load_map(map_number, grid_to_copy_to, list_of_battle_maps){

	var grid_to_copy_from = ds_grid_create(1, 1); //the height and width don't matter at creation
	
	if (list_of_battle_maps[| map_number] != undefined) && (list_of_battle_maps[| map_number] != "") {
		ds_grid_read(grid_to_copy_from, list_of_battle_maps[| map_number]);
		
		//Destroy all the lists in ds_terrain and resize it
		for (var yy = 0; yy < ds_grid_height(grid_to_copy_to); yy ++) {
			for (var xx = 0; xx < ds_grid_width(grid_to_copy_to); xx ++) {
				var list = grid_to_copy_to[# xx, yy];
				ds_list_destroy(list);
			}
		}
		
		//Grab the width and height of the temp grid
		var grid_width = ds_grid_width(grid_to_copy_from);
		var grid_height = ds_grid_height(grid_to_copy_from);
	
		ds_grid_resize(grid_to_copy_to, grid_width, grid_height);
		
		//Convert the strings into lists holding data and store that list in the relevant cell of grid_to_copy_to
		for (var yy = 0; yy < grid_height; yy ++) {
			for (var xx = 0; xx < grid_width; xx ++) {
				var list = ds_list_create();
				var list_str = grid_to_copy_from[# xx, yy];
				ds_list_read(list, list_str);
				
				grid_to_copy_to[# xx, yy] = list;
				show_debug_message(list);
			}
		}
	
		show_debug_message("Map " + string(map_number) + " Loaded");
		ds_grid_destroy(grid_to_copy_from);
	
		return grid_to_copy_to;
	}
	
	else {
		show_debug_message("Map failed to load");	
		return grid_to_copy_to;
	}
}