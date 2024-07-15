

falloff_models = [
	audio_falloff_exponent_distance,
	audio_falloff_exponent_distance_clamped,
	audio_falloff_exponent_distance_scaled,
	audio_falloff_inverse_distance,
	audio_falloff_inverse_distance_clamped,
	audio_falloff_inverse_distance_scaled,
	audio_falloff_linear_distance,
	audio_falloff_linear_distance_clamped,
	audio_falloff_none,
];
model_names = [
	"exponent distance",
	"exponent distance clamped",
	"exponent distance scaled",
	"inverse distance",
	"inverse distance clamped",
	"inverse distance scaled",
	"linear distance",
	"linear distance clamped",
	"none",
];

//options
falloff_model = audio_falloff_exponent_distance;
ref_dist = 50;
max_dist = 100;
factor = 1;

//graph options
max_shown_dist = 500;
max_shown_gain = 2;



get_gain = function(distance) {
	//get the gain at a distance
	
	var gain = 1;
	
	var reference_distance = ref_dist;
	var maximum_distance = max_dist;
	var falloff_factor = factor;
	var listener_distance = distance;
	
	///equations: https://manual.gamemaker.io/monthly/en/#t=GameMaker_Language%2FGML_Reference%2FAsset_Management%2FAudio%2Faudio_falloff_set_model.htm
	switch (falloff_model){
		
		case audio_falloff_exponent_distance:
			gain = power(listener_distance / reference_distance,(-falloff_factor))
		break;
		
		case audio_falloff_exponent_distance_clamped:
			distance = clamp(listener_distance, reference_distance, maximum_distance)
			gain = power(distance / reference_distance,(-falloff_factor))
		break;
		
		case audio_falloff_exponent_distance_scaled:
			distance = clamp(listener_distance, reference_distance, maximum_distance)
			gain = (power(distance / reference_distance,(-falloff_factor))) * (power((maximum_distance - distance) / (maximum_distance - reference_distance),(distance / maximum_distance)))
		break;
		
		case audio_falloff_inverse_distance:
			gain = reference_distance / (reference_distance + falloff_factor * (listener_distance - reference_distance))
		break;
		
		case audio_falloff_inverse_distance_clamped:
			distance = clamp(listener_distance, reference_distance, maximum_distance)
			gain = reference_distance / (reference_distance + falloff_factor * (distance - reference_distance))
		break;
		
		case audio_falloff_inverse_distance_scaled:
			distance = clamp(listener_distance, reference_distance, maximum_distance)
			gain = (reference_distance / (reference_distance + falloff_factor * (distance - reference_distance))) * (power((maximum_distance - distance) / (maximum_distance - reference_distance),(distance / maximum_distance)))
		break;
		
		case audio_falloff_linear_distance:
			distance = min(distance, maximum_distance)
			gain = (1 - falloff_factor * (distance - reference_distance) / (maximum_distance - reference_distance))
		break;
		
		case audio_falloff_linear_distance_clamped:
			distance = clamp(listener_distance, reference_distance, maximum_distance)
			gain = (1 - falloff_factor * (distance - reference_distance) / (maximum_distance - reference_distance))
		break;
		
	}
	
	return gain;
}

playsound = function(dist) {
	
	var gain = get_gain(dist);

	audio_play_sound(snd_test,0,false,gain);
	
}


//debug gui
var vwid = 600;
var vhei = 600;
var vx = room_width-vwid-50;
var vy = 50;
dbg_view("settings",true,vx,vy,vwid,vhei);
var ref_model = ref_create(self,"falloff_model");
dbg_drop_down(ref_model,falloff_models,model_names);

dbg_slider(ref_create(self,"ref_dist"),0,500);
dbg_slider(ref_create(self,"max_dist"),0,500);
dbg_slider(ref_create(self,"factor"),0,2);
dbg_text_separator("graph:");
dbg_slider(ref_create(self,"max_shown_gain"),1,5);
dbg_slider(ref_create(self,"max_shown_dist"),1,500);




function mapnum(val,low1,up1,low2,up2) {
	return (val - low1) / (up1 - low1) * (up2 - low2) + low2; 
}






