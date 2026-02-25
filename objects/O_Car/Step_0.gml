if (controllable)
{

// --- CONTROLLO TERRENO ---
var on_ground = place_meeting(x, y + 1, O_Solid);

// --- BLOCCA LA GRAVITÀ PER 1 FRAME DOPO L'INGRESSO ---
// Blocca completamente la fisica per 1 frame dopo l'ingresso
if (just_entered) {
    y_speed = 0;
    x_speed = 0;
    just_entered = false;
    exit; // <-- IMPORTANTISSIMO
}
else
{
    // --- GRAVITÀ SOLO SE NON C'È TERRENO ---
    if (!on_ground) {
        y_speed += 0.5;
    } else {
        y_speed = 0;
    }
}

    // Controllo terreno
    var on_ground = place_meeting(x, y + 1, O_Solid);

    // Salto
    if (on_ground) {
        if (keyboard_check_pressed(vk_up)) {
            y_speed = -10;
        } else {
            y_speed = 0;
        }
    }

    // Movimento orizzontale
    if (keyboard_check(vk_right)) {
        x_speed = min(x_speed + acc, max_speed);
        image_xscale = -1;
    }
    else if (keyboard_check(vk_left)) {
        x_speed = max(x_speed - brake, 0);
        image_xscale = 1;
    }

    move_and_collide(x_speed, y_speed, O_Solid);
}