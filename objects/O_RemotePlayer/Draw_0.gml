/// @description Remote Player – Draw
// Draw the remote player as a slightly tinted ghost using the same sprite as O_Player.
// The semi-transparent tint distinguishes network players from the local player.

// Pseudo-3D: draw a drop shadow beneath the remote player
var _sw = sprite_width * 0.55;
draw_set_alpha(0.30);
draw_set_color(c_black);
draw_ellipse(x - _sw * 0.5, y - 3, x + _sw * 0.5, y + 3, false);
draw_set_alpha(1);
draw_set_color(c_white);

// Draw ghost with cyan tint to mark it as a remote (network) player
draw_sprite_ext(S_Player, image_index, x, y, image_xscale, image_yscale,
                image_angle, make_color_rgb(180, 255, 255), 0.75);
