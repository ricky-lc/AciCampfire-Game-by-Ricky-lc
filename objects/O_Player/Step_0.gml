/// STEP EVENT PLAYER

// -------------------------
// FUNZIONE DI RESET
// -------------------------
function reset_player_state() {

    x = 16;
    y = 128;

    // Evita spawn dentro muri
    while (place_meeting(x, y, O_Solid)) {
        y -= 1;
    }

    x_speed = 0;
    y_speed = 0;

    jumping = false;
    jump_time = 0;

    controllable = true;
}


// -------------------------
// MOVIMENTO ORIZZONTALE (solo se premi tasti)
// -------------------------
x_speed = 0;

if (controllable)
{
    if (keyboard_check(vk_right)) {
        x_speed = walk_speed;
        image_xscale = -1;
    }
    else if (keyboard_check(vk_left)) {
        x_speed = -walk_speed;
        image_xscale = 1;
    }
}


// -------------------------
// SALTO PARABOLICO
// -------------------------

// Inizio salto
if (controllable && !jumping && keyboard_check_pressed(vk_up))
{
    jumping = true;
    jump_time = 0;
    y_start = y;
}

// Aggiornamento salto
if (jumping)
{
    jump_time += 1;

    var t = jump_time / jump_duration;
    y = y_start + (4 * jump_height * t * (1 - t));

    if (jump_time >= jump_duration)
    {
        jumping = false;
    }
}


// -------------------------
// APPLICAZIONE MOVIMENTO ORIZZONTALE
// -------------------------
x += x_speed;


// -------------------------
// COLLISIONE CON SOLIDI (solo verticale)
// -------------------------
while (place_meeting(x, y, O_Solid)) {
    y -= 1;
}


// -------------------------
// RESET PER SPINE
// -------------------------
if (place_meeting(x, y, O_Spike))
{
    reset_player_state();
}


// -------------------------
// RESET SOLO SE COMPLETAMENTE FUORI SCHERMO
// -------------------------
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32)
{
    reset_player_state();
}