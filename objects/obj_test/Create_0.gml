iso_width = sprite_get_width(spr_iso_width_height);
iso_height = sprite_get_height(spr_iso_width_height);
display_all_heights = true;

mission_to_load = 0; //Which mission is being played?
conversation_entry = 0; //This entry will increase by 1 until it reached the height of the conversation csv

//SETUP GRID
total_maps = 0;
battle_map_list = ds_list_create();

ds_terrain_data = ds_grid_create(1, 1); //tile grid
var list = ds_list_create();
ds_terrain_data[# 0, 0] = list;
map_index_to_load = global.mission_grid[# e_mission_params.map, mission_to_load];

//SETUP CONVERSATION
var csv = global.mission_grid[# e_mission_params.conversation_csv, mission_to_load];
conversation = load_csv(csv);

text = conversation[# 0, conversation_entry];
speaker = real(string_digits(text));

//Remove digits from string
//Update this to handle 2 numbers at the front and that's it
for (var i = 1; i < string_length(text); i++)
{
	var char = string_char_at(text, i);
	if (string_digits(char) != "") text = string_delete(text, i, 1);
}

scr_load_game_data();
scr_load_map(map_index_to_load, ds_terrain_data, battle_map_list);

//Center map on first talker
unit = scr_center_on_speaker(speaker, ds_terrain_data);
unit_name = global.character_stats[# e_stats.name, unit];