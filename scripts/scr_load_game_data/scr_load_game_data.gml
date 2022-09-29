// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_load_game_data(){

	//This script will load the strings into the battle map list
	ini_open("battle_map_strings.ini");
 
	//How many maps were saved
	total_maps = ini_read_real("Total Maps", "Value", total_maps);
 
	for (var i = 0; i < total_maps; i ++){
		var str = ini_read_string("Data String", string(i), "");
		battle_map_list[| i] = str;
 
		show_debug_message(str);
	}
 
	ini_close();
 
	//If a map exists in the first slot, load it
	if (ds_list_size(battle_map_list) > 0){
		scr_load_map(0, ds_terrain_data, battle_map_list);
	}

}

