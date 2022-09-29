// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_save_game_data() {
	
	//This script will save the strings that the map holds
	ini_open("battle_map_strings.ini");
 
	for (var i = 0; i < ds_list_size(battle_map_list); i ++){
		ini_write_string("Data String", string(i), battle_map_list[| i]);
	}
 
	ini_write_real("Total Maps", "Value", ds_list_size(battle_map_list));
	ini_close();
	show_debug_message("scr_save_game_data finished");
}