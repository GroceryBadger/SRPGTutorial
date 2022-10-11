//Go to the next entry of the conversation
if (keyboard_check_pressed(vk_enter)) {
	if (conversation_entry + 1) < ds_grid_height(conversation)	 {
		conversation_entry ++;
		text = conversation[# 0, conversation_entry];
		speaker = real(string_digits(text));
		
		//Remove digits from string
		for ( var i = 1; i < string_length(text); i ++) {
			var char = string_char_at(text, i);
			if (string_digits(char) != "") text = string_delete(text, i, 1);
		}
		
		unit = scr_center_on_speaker(speaker, ds_terrain_data);
		unit_name = global.character_stats[# e_stats.name, unit];
	}
}