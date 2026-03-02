/// @description LAN Lobby – Draw GUI
// All coordinates are in GUI/screen space so the menu always sits
// correctly on screen regardless of the room view.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ── Semi-transparent background ───────────────────────────────────────────────
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// ── Title ─────────────────────────────────────────────────────────────────────
draw_set_color(make_color_rgb(255, 140, 0));
draw_text(_cx, _cy - 140, "ACICAMPFIRE");
draw_set_color(c_white);
draw_text(_cx, _cy - 118, "Dystopic City Walk-through");

// ── Phase 0: story intro ──────────────────────────────────────────────────────
if (phase == 0)
{
    draw_set_color(c_silver);
    var _ly = _cy - 70;
    for (var _i = 0; _i < array_length(intro_lines); _i++)
    {
        draw_text(_cx, _ly, intro_lines[_i]);
        _ly += 18;
    }

    if (cursor_blink < 30)
    {
        draw_set_color(c_yellow);
        draw_text(_cx, _cy + 120, "[ ENTER / Z / SPACE  to begin ]");
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// ── Phase 1 & 2: menu options ─────────────────────────────────────────────────
var _opts  = ["HOST GAME  (local WiFi)", "JOIN GAME  (local WiFi)", "SOLO PLAY"];
var _descs = [
    "Share your IP with friends on the same network",
    "Auto-discover a host on your local network",
    "Play alone – no network required",
];

for (var _i = 0; _i < 3; _i++)
{
    var _oy = _cy - 20 + _i * 34;

    if (_i == menu_option)
    {
        draw_set_color(cursor_blink < 30 ? c_yellow : c_orange);
        draw_text(_cx - 6, _oy, "> " + _opts[_i]);
        draw_set_color(c_gray);
        draw_text(_cx, _oy + 14, _descs[_i]);
    }
    else
    {
        draw_set_color(c_white);
        draw_text(_cx, _oy, _opts[_i]);
    }
}

// Status / searching message
if (status_msg != "")
{
    draw_set_color(c_lime);
    draw_text(_cx, _cy + 130, status_msg);
}

// Controls hint
draw_set_color(make_color_rgb(100, 100, 100));
draw_text(_cx, _gh - 24, "Arrow Keys = navigate   Enter/Z = select   ESC = back");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
