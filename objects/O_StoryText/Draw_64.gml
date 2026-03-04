/// @description Story Text – Draw GUI
// Rendered in GUI/screen space so the panel always appears at the bottom of
// the screen regardless of camera position.

var _gw  = display_get_gui_width();
var _gh  = display_get_gui_height();
var _pad = 12;
var _bh  = 90;   // banner height in pixels

// Dark semi-transparent banner at bottom of screen
draw_set_alpha(alpha * 0.82);
draw_set_color(c_black);
draw_rectangle(0, _gh - _bh - _pad, _gw, _gh, false);

// Amber top border line
draw_set_alpha(alpha);
draw_set_color(make_color_rgb(255, 160, 0));
draw_rectangle(0, _gh - _bh - _pad, _gw, _gh - _bh - _pad + 2, false);

// Story text
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_ext(_pad + 4, _gh - _bh, story_text, 16, _gw - _pad * 2 - 8);

// Dismiss hint (blinking)
if ((display_timer mod 40) < 20)
{
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_set_halign(fa_right);
    draw_text(_gw - _pad, _gh - _pad - 10, "[ ENTER / Z / SPACE ]");
}

draw_set_halign(fa_left);
draw_set_alpha(1);
draw_set_color(c_white);
