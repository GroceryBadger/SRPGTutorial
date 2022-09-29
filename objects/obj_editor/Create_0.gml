/// @description Insert description here
// You can write your code in this editor

#region SETUP TILE ENUMERATOR

enum e_tile_data {
	floor_index,
	decoration_index,
	height,
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

#endregion