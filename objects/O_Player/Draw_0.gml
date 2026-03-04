/// DRAW EVENT

// ── Pseudo-3D: drop shadow beneath the player ─────────────────────────────────
var _sw = sprite_width * 0.55;
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - _sw * 0.5, y - 3, x + _sw * 0.5, y + 3, false);
draw_set_alpha(1);
draw_set_color(c_white);

// Draw the player sprite
draw_self();

if (variable_instance_exists(id, "vittoria") && vittoria == true) {

    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 2;

    draw_sprite(S_Win, 0, _cx, _cy);
}