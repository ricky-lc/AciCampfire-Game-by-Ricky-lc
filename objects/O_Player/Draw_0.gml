/// DRAW GUI EVENT

draw_self(); // se vuoi disegnare il player anche in GUI (opzionale)

if (variable_instance_exists(id, "vittoria") && vittoria == true) {

    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 2;

    draw_sprite(S_Win, 0, _cx, _cy);
}