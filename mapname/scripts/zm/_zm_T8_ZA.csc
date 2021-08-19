#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm_weapons;

#namespace T8ZA;

function autoexec init()
{
	util::register_system( "zoneName", &zonesName );
}

function zonesName( n_local_client_num, str_state, str_old_state )
{
	self CF( n_local_client_num, str_old_state, str_state, false, undefined, "zoneNameInHUD", false);
	model = GetUIModel( GetUIModelForController( n_local_client_num ), "zoneNameInHUD" );
	SetUIModelValue( model, str_state );
}

function CF( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), fieldname );
	SetUIModelValue( model, newval );
}
