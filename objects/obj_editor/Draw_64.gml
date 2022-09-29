#region DRAW new_index 

var draw_x = display_get_gui_width() /2;
var draw_y = display_get_gui_height() - 32;
var scale = 2;

//draw_sprite_ext(spr_floor, new_index, draw_x, draw_y, scale, scale, 0 , c_white, 1);
var spr = global.cell_sprites[current_part];

draw_sprite_ext(spr, new_index, draw_x, draw_y, scale, scale, 0 , c_white, 1);

#endregion

#region DRAW grid_x/y

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(0, 0, "grid_x: " + string(grid_x));
draw_text(0, 20, "grid_x: " + string(grid_y));

#endregion