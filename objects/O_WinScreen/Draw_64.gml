/// @description Win Screen – Draw GUI

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// Background
draw_set_alpha(0.90);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Main heading
draw_set_color(make_color_rgb(255, 200, 0));
draw_text(_cx, _cy - 80, "MISSION COMPLETE");

// Lore outro
draw_set_color(c_white);
draw_text(_cx, _cy - 40, "You reached the radio tower.");
draw_text(_cx, _cy - 22, "The signal is broadcasting.");
draw_text(_cx, _cy,      "Help is on the way.");
draw_set_color(make_color_rgb(180, 180, 180));
draw_text(_cx, _cy + 24, "AciCampfire will not be forgotten.");

// Blink prompt
if (blink_timer < 30)
{
    draw_set_color(c_yellow);
    draw_text(_cx, _cy + 70, "[ ENTER / Z  to return to menu ]");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
