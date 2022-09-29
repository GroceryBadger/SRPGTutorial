for(var yy = 0; yy < vcells; yy ++){
	for(var xx = 0; xx < hcells; xx ++){
		
		#region DRAW CELL
		
		var list = ds_terrain_data[# xx, yy];
		floor_ind = list[| e_tile_data.floor_index];
		height = list[| e_tile_data.height];
		
		//2D draw x,y
		//draw_x = xx * GRID_SIZE;
		//draw_y = yy * GRID_SIZE;
		//draw_sprite(spr_floor, index, draw_x, draw_y);
		
		//Isometric draw x,y
		draw_x = (xx - yy) * (iso_width/2);

		//Draw a tile for EVERY level of the cell
		for (var draw_height = 0; draw_height <= height; draw_height ++) {
			
			//If we don't want to display all heights, only draw cells up to current height
			if (display_all_heights == false && draw_height <= current_height) || (display_all_heights == true) {

				draw_y = (xx + yy) * (iso_height / 2) - (draw_height * (iso_height / 2));
			
				var rgb_value = 150 + (draw_height * 9);
				var col = make_color_rgb(rgb_value, rgb_value, rgb_value);
				draw_sprite_ext(spr_iso_floor, floor_ind, draw_x, draw_y, 1, 1, 0, col, 1);
			
				if (draw_height == height) {
					//Only draw the decoration if we're at the highest tile
					var spr = global.cell_sprites[e_tile_data.decoration_index];
					var index = list[| e_tile_data.decoration_index];
					draw_sprite_ext(spr, index, draw_x, draw_y, 1, 1, 0, col, 1);
				}
			}
		}
		
		#region TESTING - show the numbers
		
		////2D numbers
		////draw_set_halign(fa_left);
		////draw_set_valign(fa_top);
		
		////Isometric numbers
		//draw_set_halign(fa_center);
		//draw_set_valign(fa_middle);
		
		//draw_set_colour(c_gray);
		////draw_text(draw_x, draw_y, string(floor_ind));
		
		//var list = ds_terrain_data[# xx, yy];
		//draw_text(draw_x, draw_y, string(list));
		
		#endregion
		
		#endregion
		
		#region DRAW CURSOR
		
		//2d cursor
		//if(xx == grid_x && yy == grid_y) {
		//	draw_sprite(spr_cursor, 0, draw_x, draw_y);
		//}
		
		//Isometric cursor
		if (xx == grid_x && yy == grid_y) {
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
		}
		
		#endregion
	}
}
