#region DRAW CONVERSATION

draw_set_font(fnt_conversation);
var font_size = font_get_size(fnt_conversation);

draw_set_halign(fa_center);
draw_set_valign(fa_top);

var sep = font_size * 1.4;
var w = 300;
t_height = string_height_ext(text, sep, w) + 20;

var xx = display_get_gui_width() / 2;
var yy = display_get_gui_height() - t_height;

//Name 
draw_set_font(fnt_names);
draw_set_color(c_red);
draw_text(xx, yy - (font_size + 20), unit_name);

//Text 
draw_set_font(fnt_conversation);
draw_set_color(c_white);
draw_text_ext(xx, yy, text, sep, w);

#endregion