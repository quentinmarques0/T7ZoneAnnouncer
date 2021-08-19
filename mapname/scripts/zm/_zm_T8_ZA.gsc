/*
	Zone Announcer Script By Seth Norris & QuentinFTL v2.0

	This update allow you to use new animations, actually, 9 animations can be setup in your LUA :
			LeftRight
			RightLeft
			TopBottom
			BottomTop
			LeftBack
			RightBack
			TopBack
			BottomBack
			BlackOps4

	but I leave the tutorial inside the lua file !

	to start using the GSC & CSC scripts, just add them in your zone file,
	and add the usings into your_mapname gsc and csc.

	after it, you can change some variables in GSC by overriding a level variable
	where you can set a method (I'll give you an example now) :

			level.announcer_override_fn = &ZoneAnnouncer_Override; // before zm_usermap::main();

	and the method with actually every overriding methods (commented or not)

			function ZoneAnnouncer_Override()
			{
				//setup this with the same values in your LUA
				T8ZA::setFadeIn(2); 																				// Time for the UI to appear before freezing
				T8ZA::setFadeOut(1); 																				// Time for the UI to disappear after freezing
				T8ZA::setFreezeTime(7);																			// Time for the UI to freeze
				T8ZA::useFadeOut(true);																			// UI Use Fade Out (true or false)

				//T8ZA::set_name_for_undefined_zones("zone_tn", "Zone !");	// Set a zone name for zones with no script_string setup
				//T8ZA::setSound("your_sound");															// Sound played when player enter in a zone
			}

	Next, setup the Lua (go to the widget file).
*/
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\_zm_laststand;

#using scripts\zm\_zm_score;
#using scripts\zm\_zm_bgb;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;

#using scripts\zm\_zm_net;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;

#namespace T8ZA;

function autoexec init()
{
	callback::on_connect(&connected);
}

function connected()
{
	util::registerClientSys( "zoneName" );

	// ================ Begin: Variables You Can Change if You Like :Begin =====================
	level.announcer_hide_after_x_seconds 	= true; 			//to not see the text flashing, it must be true
	level.wait_more 						= 0.5; 				//Minimum time in a Room to start displaying hud
	level.announcer_hud_duration 			= 1;				//Duration of the Hud - set the correct value = to the hud
	level.announcer_hud_fade_in				= 1;				//Duration of the Fade In - set the correct value = to the hud
	level.announcer_hud_fade_out			= 1;				//Duration of the Fade Out - set the correct value = to the hud
	level.announcer_hud_sound				= undefined;		//Sound to play when entering new room
	// ================ End: Variables You Can Change if You Like :End =====================

	if(level.announcer_override_fn){
		[[level.announcer_override_fn]]();
	}

	self thread announcer_hud_think();
	self util::setClientSysState( "zoneName", "" );
	level thread mainz();
}

function mainz()
{
	wait .1;
}
//*****************************************************************************
//	Checks the zone the player is at, and if the hud for this zone was already displayed
//*****************************************************************************
function announcer_hud_think()
{
	level endon( "intermission" );

	self.zone = self get_player_zone();

	level waittill( "start_of_round" );
	wait(randomintrange(2,5));
	old_zone = undefined;

	while(1)
	{
		self.zone = self get_player_zone();

		zone_name = self ask_for_zone_name(	self.zone , "Name" );
		if(old_zone != zone_name){
			if(isdefined(self ask_for_zone_name( self.zone , "Snd" )))
			{
				self playsound( self ask_for_zone_name( self.zone , "Snd" ) );
			}
			else{
				if(isdefined(level.announcer_hud_sound)){
					self playsound( level.announcer_hud_sound );
				}
			}

			self util::setClientSysState( "zoneName", zone_name, self );
			old_zone = zone_name;
			if( level.announcer_hide_after_x_seconds == true)
				wait ( level.announcer_hud_duration + level.announcer_hud_fade_in + level.announcer_hud_fade_out );
			else
				wait (level.announcer_hud_fade_in);

			wait ( level.wait_more );
		}
		wait 0.05;
	}
}
//*****************************************************************************
//	This check where you are, and look for script_string on the zone
//*****************************************************************************
function ask_for_zone_name( zone, type )
{

	if(type == "Name"){
		value = "Unknown Location";
	}
	else{
		value = undefined;
	}
	zones = zone.volumes;// GetEntArray(zone,"targetname");
	for( i=0;i<zones.size;i++ ){
		if(self IsTouching(zones[i]))
		{
			if(type == "Name"){
				value = zones[i].script_string;
			}
			else{
				value = zones[i].script_sound;
			}
		}
	}

	return value;
}
/@
"Name: set_name_for_undefined_zones( <zone>, <name> )"
"Summary: Set a general name foreach zones with this targetname, which haven't script_string defined"
"Module: Zone"
"MandatoryArg: <zone> : targetname of the zone volume"
"MandatoryArg: <name> : name given to the zone volume"
"Example: T8ZA::set_name_for_undefined_zones( "start_zone", "Spawn Room" );"
@/
function set_name_for_undefined_zones( zone, name )
{

	value = "Unknown Location";
	zones = GetEntArray(zone,"targetname");
	for( i=0;i<zones.size;i++ ){
		if(!isdefined(zones[i].script_string))
		{
			zones[i].script_string = name;
		}
	}
}
function setFadeIn(fIn)
{
	level.announcer_hud_fade_in = fIn;
}

function setFadeOut(fOut)
{
	level.announcer_hud_fade_out = fOut;
}

function setFreezeTime(fTime)
{
	level.announcer_hud_duration = fTime;
}

function useFadeOut(fOutDo)
{
	level.announcer_hide_after_x_seconds = fOutDo;
}

function setSound(snd)
{
	level.announcer_hud_sound = snd;
}

//*****************************************************************************
//	Check the player Zone
//*****************************************************************************
function get_player_zone()
{
    return self zm_utility::get_current_zone( true );
}
