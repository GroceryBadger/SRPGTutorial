enum e_facing {
	west, 
	north, 
	east, 
	south,
}

//This is a reflection of the csv file
enum e_characters {
	leave_empty,
	fighter,
	archer,
	mage,
	priest,
	warrior,
	knight,
	ranger,
	sniper,
	wizard,
	sorcerer,
	healer,
	monk,
	butz,
	sarah,
	brian,
	davos,
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

#region SETUP THE SPRITE GRID

//Animations for the character
enum e_actor_sprites {
	stationary,
	last,
}

global.ac_spr = ds_grid_create(e_actor_sprites.last, e_characters.last);

global.ac_spr[# e_actor_sprites.stationary, e_characters.fighter] = spr_iso_fighter;
global.ac_spr[# e_actor_sprites.stationary, e_characters.archer] = spr_iso_archer;
global.ac_spr[# e_actor_sprites.stationary, e_characters.mage] = spr_iso_mage;
global.ac_spr[# e_actor_sprites.stationary, e_characters.priest] = spr_iso_priest;
global.ac_spr[# e_actor_sprites.stationary, e_characters.warrior] = spr_iso_warrior;
global.ac_spr[# e_actor_sprites.stationary, e_characters.knight] = spr_iso_knight;
global.ac_spr[# e_actor_sprites.stationary, e_characters.ranger] = spr_iso_ranger;
global.ac_spr[# e_actor_sprites.stationary, e_characters.sniper] = spr_iso_sniper;
global.ac_spr[# e_actor_sprites.stationary, e_characters.wizard] = spr_iso_wizard;
global.ac_spr[# e_actor_sprites.stationary, e_characters.sorcerer] = spr_iso_sorcerer;
global.ac_spr[# e_actor_sprites.stationary, e_characters.healer] = spr_iso_healer;
global.ac_spr[# e_actor_sprites.stationary, e_characters.monk] = spr_iso_monk;
global.ac_spr[# e_actor_sprites.stationary, e_characters.butz] = spr_iso_butz;
global.ac_spr[# e_actor_sprites.stationary, e_characters.sarah] = spr_iso_sarah;
global.ac_spr[# e_actor_sprites.stationary, e_characters.brian] = spr_iso_brian;
global.ac_spr[# e_actor_sprites.stationary, e_characters.davos] = spr_iso_davos;

#endregion