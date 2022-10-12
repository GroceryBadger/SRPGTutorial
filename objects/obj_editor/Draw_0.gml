for(var yy = 0; yy < ds_grid_height(ds_terrain_data); yy ++){
	for(var xx = 0; xx < ds_grid_width(ds_terrain_data); xx ++){
		
		#region DRAW CELL
		
		list = ds_terrain_data[# xx, yy];
		floor_ind = list[| e_tile_data.floor_index];
		height = list[| e_tile_data.height];
		spawn_tile = list[| e_tile_data.spawn_tile];
		unit = list[| e_tile_data.unit];
		unit_facing = list[| e_tile_data.unit_facing];
		con_index = list[| e_tile_data.conversation_index];

		//Isometric draw x,y
		draw_x = (xx - yy) * (iso_width / 2);

		//Draw a tile for EVERY level of the cell
		for (var draw_height = 0; draw_height <= height; draw_height ++) {
			
			//If we don't want to display all heights, only draw cells up to current height
			if (display_all_heights == false && draw_height <= current_height) || (display_all_heights == true) {

				draw_y = (xx + yy) * (iso_height / 2) - (draw_height * (iso_height / 2));
			
				var rgb_value = 150 + (draw_height * 9);
				var col = make_color_rgb(rgb_value, rgb_value, rgb_value);
				draw_sprite_ext(spr_iso_floor, floor_ind, draw_x, draw_y, 1, 1, 0, col, 1);
			
				//Draw decoration
				if (draw_height == height) {
					//Only draw the decoration if we're at the highest tile
					var spr = global.cell_sprites[e_tile_data.decoration_index];
					var index = list[| e_tile_data.decoration_index];
					draw_sprite_ext(spr, index, draw_x, draw_y, 1, 1, 0, col, 1);
					
					#region DRAW SPAWN TILE / UNIT
					
					//Set the color (highlight the spawn/tile unit if the mouse is over it)
					if (xx == grid_x && yy == grid_y) ed_col = c_yellow;
					else ed_col = c_white;
					
					if (spawn_tile != undefined && spawn_tile > -1) draw_sprite_ext(spr_iso_spawn_tiles, spawn_tile, draw_x, draw_y, 1, 1, 0, ed_col, 1);
					
					//UNIT
					if (unit != undefined && unit >= e_characters.fighter) {
						//DRAW UNIT
						var spr = global.ac_spr[# e_actor_sprites.stationary, unit];
						draw_sprite_ext(spr, unit_facing, draw_x, draw_y, 1, 1, 0, ed_col, 1);
						
						//DRAW UNIT name
						draw_set_halign(fa_center);
						draw_set_valign(fa_middle);
						//var name = global.character_stats[# e_stats.name, unit]; //Full Name
						var name = string_copy(global.character_stats[# e_stats.name, unit], 1, 2); // First 2 characters of name
						
						draw_text(draw_x, draw_y - sprite_get_height(spr_iso_actor), name);
						
						//Show unique conversation index for the spawn tile
						draw_text(draw_x, draw_y - (sprite_get_height(spr_iso_actor) + 14), string(con_index));
					}
					
					#endregion
				}
			}
		}
		
		#endregion
		
		#region DRAW CURSOR
		
		if (xx == grid_x && yy == grid_y && actual_grid_x == grid_x && actual_grid_y == grid_y) {
		
			if (editing_state == e_editing_states.map) {
				#region MAP
				
				for (var draw_height = 0; draw_height <= current_height; draw_height ++) {
					draw_y = (xx + yy) * (iso_height / 2) - (draw_height * (iso_height / 2));
					draw_sprite(spr_iso_cursor, 0, draw_x, draw_y);
				
					#region DRAW A BLUEPRINT FOR DECORATION EDITING
				
					if (current_part == e_tile_data.decoration_index) {
						var spr = global.cell_sprites[current_part];
						draw_sprite_ext(spr, new_index, draw_x, draw_y, 1, 1, 0, c_yellow, 1);
					}
				
					#endregion
				}
				
				#endregion
				
			}
			else {
				#region MISSION
				
				if (mouse_sprite != -1) {
					draw_y = (xx + yy) * (iso_height / 2) - (height * (iso_height / 2) );
					
					draw_sprite_ext(mouse_sprite, mouse_index, draw_x, draw_y, 1, 1, 0, c_white, 0.5);
				}
				
				#endregion
			}
			
		}
		#endregion
	}
}

//if the mouse is not over the map and it's supposed to show a sprite, draw it
if(actual_grid_x != grid_x || actual_grid_y != grid_y) && (mouse_sprite != -1) draw_sprite(mouse_sprite, mouse_index, mouse_x, mouse_y);


