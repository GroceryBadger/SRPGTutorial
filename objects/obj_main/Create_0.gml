#region character_enums + grid

enum e_facing {
	west, 
	north, 
	east, 
	south,
}

//This is a reflection of the csv file
enum e_characters {
	leave_empty,
	archer,
	brian,
	butz,
	davos,
	fighter,
	healer,
	knight,
	mage,
	monk,
	priest,
	ranger,
	sarah,
	sniper,
	sorcerer,
	warrior,
	wizard,
	last,
}

enum e_stats {
	name,
	in_players_team,
	is_ai_controlled,
	must_survive_this_battle,
	class,
	kill_this_unit_to_win,
	hp_max,
	hp_current,
	mp_max,
	mp_current,
	level,
	xp,
	strength,
	intelligence,
	defense,
	wisdom,
	accuracy,
	agility,
	block_chance_melee,
	block_chance_ranged,
	fire_resist,
	ice_resist,
	//Gear
	left_hand,
	right_hand,
	chect,
	accessory,
	item_1,
	item_2,
	last,	
}

global.character_stats = load_csv("classes_and_characters.csv");

#endregion

#region SETUP SPRITE ARRAY

global.cell_sprites[e_tile_data.floor_index] = spr_iso_floor;
global.cell_sprites[e_tile_data.decoration_index] = spr_iso_decoration;

#endregion

#region SETUP THE SPRITE GRID

//Animations for the character
enum e_actor_sprites {
	idle,
	last,
}

global.char_sprite_grids = ds_list_create();
sprite_count = 0;

for (var character = 0; character < e_characters.last; character ++)
{
	var grid = ds_grid_create(e_actor_sprites.last, e_characters.last);

	for(var dir = 0; dir < 4; dir ++)
	{
		grid[# e_actor_sprites.idle, dir] = sprite_count;
		sprite_count ++;

	}
	
	global.char_sprite_grids[| character] = grid;
}

#endregion

#region SETUP MISSIONS

enum e_mission_params {
	map,
	conversation_csv,
	last,
}

global.mission_grid = ds_grid_create(e_mission_params.last, 3);

global.mission_grid[# e_mission_params.map, 0] = 0; //Store the index of the map we want to load for a mission
global.mission_grid[# e_mission_params.conversation_csv, 0] = "conversation_1.csv";

#endregion

#region STATES

enum e_game_states {
	editing,
	testing,
	game,
}

game_state = e_game_states.game;

if (game_state == e_game_states.editing) room_goto(rm_editor);
if (game_state == e_game_states.testing) room_goto(rm_testing);
if (game_state == e_game_states.game) room_goto(rm_world_map);

#endregion