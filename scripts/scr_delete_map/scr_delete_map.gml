// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_delete_map(map_number, list_of_battle_maps){

	ds_list_delete(list_of_battle_maps, map_number);
	
	if (map_number >= ds_list_size(list_of_battle_maps) ) map_number = (ds_list_size(list_of_battle_maps) - 1);
	
	return map_number;
	
	show_debug_message ("Map deleted");
}