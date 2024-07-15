

//box
var wid = 400;
var hei = 400;
var x1 = 200;
var y1 = 200;
var x2 = x1+wid;
var y2 = y1+hei;

draw_rectangle(x1,y1,x2,y2,true);


var gain = 1;
var step = 0.25;
var maxdist = max_shown_dist;
var mingain = 0;
var maxgain = max_shown_gain;

//show line for 1 gain
draw_set_alpha(0.33);
var basey = mapnum(1, mingain,maxgain, y2,y1);
draw_line(x1,basey,x2,basey);
draw_set_halign(fa_right);
draw_text(x1-10,basey,$"1");
draw_set_alpha(1);

//graph gain
var px = undefined;
var py = undefined;
var dx,dy;
for(var i=0; i<=maxdist; i+=step) {
	gain = get_gain(i);
	
	dx = mapnum(i, 0,maxdist, x1,x2 );
	dy = mapnum(gain, mingain,maxgain, y2,y1 );
	if px!=undefined {
		draw_line(px,py,dx,dy);
	}
	px = dx;
	py = dy;
}

//labels
draw_set_halign(fa_right);
draw_text(x1-10,y1,$"{maxgain}");
draw_text(x1-10,y2,$"{mingain}");
draw_text(x1-30,y1+hei/2,"Gain");
draw_set_halign(fa_center);
draw_text(x1,y2+10,"0");
draw_text(x2,y2+10,$"{maxdist}");
draw_text(x1+wid/2,y2+40,"Distance");
draw_set_halign(fa_left);

//mouse preview of gain
var brd = 30;
if mouse_x>=x1-brd && mouse_x<=x2+brd {
	
	var mx = clamp(mouse_x,x1,x2);
	var checkdist = (mx-x1) / wid * maxdist;
	var gain = get_gain(checkdist);
	
	draw_line(mx,y1,mx,y2);
	
	draw_text(mx,y1-30,$"gain: {gain}");
	draw_set_alpha(0.33);
	draw_text(mx,y2+10,$"{checkdist}");
	draw_set_alpha(1);
	
	var col = c_white;
	if gain>1 { col = c_yellow }
	if gain>2 { col = c_orange }
	if gain>4 { col = c_red; }
	draw_set_color(col);
	draw_text(y1,y2+70,"Left Click to play a sound");
	draw_set_color(c_white);
	
	if mouse_check_button_pressed(mb_left) {
		playsound(checkdist);
	}
	
}


