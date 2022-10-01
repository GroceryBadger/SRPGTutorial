/// @description Insert description here
// You can write your code in this editor

#region SETUP TILE ENUMERATOR

enum e_tile_data {
	floor_index,
	decoration_index,
	height,
	spawn_tile,               //-1 for no spawn, 0 is player 1 is enemy
	conversation_index,       //Each spawn tile will have a unique conversation per map
	unit,                     //Either a class or a spacial character
	unit_facing,              //West/North/East/South
	is_ai_controlled,         //True/False
	must_survive_this_battle, //True/False If true, if this unit dies it's game over
	kill_this_unit_to_win,    //True/False By killing this unit, the battle is won
	last,

}

#endregion

#region SETUP A GRID

hcells = 10;
vcells = 10;

ds_terrain_data = ds_grid_create(hcells, vcells);

for (var yy = 0; yy < vcells; yy ++) {
	for (var xx = 0; xx < hcells; xx ++) {
		
		//Set all cell values to "1" - this is the image index of spr_floor that we're going to draw
		//ds_terrain_data[# xx, yy] = 1
		
		var list = ds_list_create();
		
		//Set initial cell data for each list
		for (var i = 0; i < e_tile_data.last; i++) {
			if(i == e_tile_data.floor_index) list[| i] = 1; else list[| i] = 0;	
			if(i >= e_tile_data.spawn_tile) list[| i] = -1;
		}
		
		ds_terrain_data[# xx, yy] = list;
		
		show_debug_message(list);
	}
}

#endregion

#region SETUP SPRITE ARRAY

global.cell_sprites[e_tile_data.floor_index] = spr_iso_floor;
global.cell_sprites[e_tile_data.decoration_index] = spr_iso_decoration;
#endregion

#region EXTRA VARIABLES

grid_x = 0; //Where is the mouse on the grid?
grid_y = 0; //Where is the mouse on the grid?
new_index = 1; //We'll use this variable to change the cell indexes
iso_width = sprite_get_width(spr_iso_width_height);
iso_height = sprite_get_height(spr_iso_width_height);

//Center the camera on the map
cx = (iso_width/2) - (camera_get_view_width(view_camera[0]) / 2);
cy = -(camera_get_view_height(view_camera[0]) / 4);
camera_set_view_pos(view_camera[0], cx, cy);

current_height = 0;
max_height = 12;

current_part = e_tile_data.floor_index;
current_sprite = global.cell_sprites[current_part];

display_all_heights = true;

current_map_number = 0; //Which map "number are we editing?
battle_map_list = ds_list_create(); //This will hold the string that convert into a grid with each cell
total_maps = 0;

#region MISSION EDITOR

mouse_sprite = -1; //Is the mouse holding a sprite or not
mouse_index = 0; //Index of the sprite that the mouse is to display
unique_conversation_index = 0; //This number inceases every time a spawn tile is put down. The number does not decrease if a spawn tile is deleted

#endregion

#endregion

#region EDITING STATES

enum e_editing_states {
	map, 
	mission,
}

editing_state = e_editing_states.mission;

#endregion

scr_load_game_data();