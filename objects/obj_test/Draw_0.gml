draw_set_font(fnt_editor);

for (var yy = 0; yy < ds_grid_height(ds_terrain_data); yy ++) {
	for (var xx = 0; xx < ds_grid_width(ds_terrain_data); xx ++) {
		
		#region DRAW CELL
		
		list = ds_terrain_data[# xx, yy];
		floor_ind = list[| e_tile_data.floor_index];
		height = list[| e_tile_data.height];
		spawn_tile = list[| e_tile_data.spawn_tile];
		unit = list[| e_tile_data.unit];
		unit_facing = list[| e_tile_data.unit_facing];
		con_index = list[| e_tile_data.conversation_index];
		
		draw_x = (xx - yy) * (iso_width / 2);
		
		//Draw a tile for every level of the cell, a cell with a height of "3" would mean this loop get run 4 time (0, 1, 2, 3) per step
		for (var draw_height = 0; draw_height <= height; draw_height ++) {
			
			//If we don't want to display all height, only draw cells UP TO current_height OR draw cells to their proper height if display_all_heights equals true
			if (display_all_heights == false && draw_height <= current_height) || (display_all_heights == true) {
				draw_y = (xx + yy) * (iso_height / 2) - (draw_height * ( iso_height / 2 ));	
				
				//We'll make a color and save it in "col" and use it to affect the color of whatever tile is drawn - this will make the different heights clearer
				var rgb_value = 150 + (draw_height * 9);
				var col = make_color_rgb( rgb_value, rgb_value, rgb_value);
				draw_sprite_ext(spr_iso_floor, floor_ind, draw_x, draw_y, 1, 1, 0, col, 1);
				
				//Draw deco
				if (draw_height == height) {
					//Only draw the decoration if we're at the highest tile
					var spr = global.cell_sprites[e_tile_data.decoration_index];
					var index = list[| e_tile_data.decoration_index];
					draw_sprite_ext(spr, index, draw_x, draw_y, 1, 1, 0, col, 1);
					
					#region UNIT
					
					ed_col = c_white;
					
					//UNIT
					if (unit != undefined && unit >= e_characters.fighter) {
						
						//DRAW UNIT
						var char_grid = global.character_stats[| unit];
						var spr = char_grid[# e_actor_sprites.idle, unit_facing];
						
						draw_sprite_ext(spr, 0, draw_x, draw_y, 1, 1, 0, ed_col, 1);
						
						//DRAW UNIT NAME
						draw_set_halign(fa_center);
						draw_set_valign(fa_middle);
						
						var name = string_copy(global.character_stats[# e_stats.name, unit], 1, 2);
						
						draw_text(draw_x, draw_y - sprite_get_height(spr_iso_actor_idle_w), name);
					}
					
					#endregion
				}
			}
		}
		
		#endregion
	}
}